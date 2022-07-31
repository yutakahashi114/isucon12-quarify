package isuports

import (
	"context"
	"database/sql"
	"encoding/csv"
	"errors"
	"fmt"
	"io"
	"net"
	"net/http"
	"net/http/httputil"
	"os"
	"os/exec"
	"path/filepath"
	"reflect"
	"regexp"
	"strconv"
	"strings"
	"time"

	"github.com/go-sql-driver/mysql"
	json "github.com/goccy/go-json"
	"github.com/google/uuid"
	"github.com/isucon/isucon12-qualify/webapp/go/cache"
	"github.com/isucon/isucon12-qualify/webapp/go/mutexmap"
	"github.com/isucon/isucon12-qualify/webapp/go/trace"
	"github.com/jmoiron/sqlx"
	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
	"github.com/labstack/gommon/log"
	"github.com/lestrrat-go/jwx/v2/jwa"
	"github.com/lestrrat-go/jwx/v2/jwk"
	"github.com/lestrrat-go/jwx/v2/jwt"
	"golang.org/x/exp/slices"
	"golang.org/x/sync/singleflight"
)

const (
	tenantDBSchemaFilePath = "../sql/tenant/10_schema.sql"
	initializeScript       = "../sql/init.sh"
	cookieName             = "isuports_session"

	RoleAdmin     = "admin"
	RoleOrganizer = "organizer"
	RolePlayer    = "player"
	RoleNone      = "none"
)

var (
	// 正しいテナント名の正規表現
	tenantNameRegexp = regexp.MustCompile(`^[a-z][a-z0-9-]{0,61}[a-z0-9]$`)

	adminDB *sqlx.DB

	sqliteDriverName = "sqlite3"
)

// 環境変数を取得する、なければデフォルト値を返す
func getEnv(key string, defaultValue string) string {
	if val, ok := os.LookupEnv(key); ok {
		return val
	}
	return defaultValue
}

func connectAdminDBDSN() string {
	config := mysql.NewConfig()
	config.Net = "tcp"
	config.Addr = getEnv("ISUCON_DB_HOST", "127.0.0.1") + ":" + getEnv("ISUCON_DB_PORT", "3306")
	config.User = getEnv("ISUCON_DB_USER", "isucon")
	config.Passwd = getEnv("ISUCON_DB_PASSWORD", "isucon")
	config.DBName = getEnv("ISUCON_DB_NAME", "isuports")
	config.ParseTime = true
	config.InterpolateParams = true
	return config.FormatDSN()
}

// 管理用DBに接続する
func connectAdminDB() (*sqlx.DB, error) {
	return sqlx.Open("mysql", connectAdminDBDSN())
}

// テナントDBのパスを返す
func tenantDBPath(id int64) string {
	tenantDBDir := getEnv("ISUCON_TENANT_DB_DIR", "../tenant_db")
	return filepath.Join(tenantDBDir, fmt.Sprintf("%d.db", id))
}

// テナントDBに接続する
func connectToTenantDB(id int64) (*sqlx.DB, error) {
	p := tenantDBPath(id)
	db, err := sqlx.Open(sqliteDriverName, fmt.Sprintf("file:%s?mode=rw", p))
	if err != nil {
		return nil, fmt.Errorf("failed to open tenant DB: %w", err)
	}
	db.DB = t.DB(fmt.Sprintf("file:%s?mode=rw", p), db.Driver())
	db.SetMaxOpenConns(10)
	db.SetMaxIdleConns(10)
	db.SetConnMaxLifetime(time.Second * 10)
	return db, nil
}

// テナントDBを新規に作成する
func createTenantDB(id int64) error {
	p := tenantDBPath(id)

	cmd := exec.Command("sh", "-c", fmt.Sprintf("sqlite3 %s < %s", p, tenantDBSchemaFilePath))
	if out, err := cmd.CombinedOutput(); err != nil {
		return fmt.Errorf("failed to exec sqlite3 %s < %s, out=%s: %w", p, tenantDBSchemaFilePath, string(out), err)
	}
	return nil
}

// システム全体で一意なIDを生成する
func dispenseID(ctx context.Context) (string, error) {
	var lastErr error
	for i := 0; i < 100; i++ {
		id, err := uuid.NewUUID()
		if err != nil {
			lastErr = err
			continue
		}
		return id.String(), nil
	}
	return "", lastErr
}

// // システム全体で一意なIDを生成する
// func dispenseID(ctx context.Context) (string, error) {
// 	var id int64
// 	var lastErr error
// 	for i := 0; i < 100; i++ {
// 		var ret sql.Result
// 		ret, err := adminDB.ExecContext(ctx, "REPLACE INTO id_generator (stub) VALUES (?);", "a")
// 		if err != nil {
// 			if merr, ok := err.(*mysql.MySQLError); ok && merr.Number == 1213 { // deadlock
// 				lastErr = fmt.Errorf("error REPLACE INTO id_generator: %w", err)
// 				continue
// 			}
// 			return "", fmt.Errorf("error REPLACE INTO id_generator: %w", err)
// 		}
// 		id, err = ret.LastInsertId()
// 		if err != nil {
// 			return "", fmt.Errorf("error ret.LastInsertId: %w", err)
// 		}
// 		break
// 	}
// 	if id != 0 {
// 		return fmt.Sprintf("%x", id), nil
// 	}
// 	return "", lastErr
// }

// 全APIにCache-Control: privateを設定する
func SetCacheControlPrivate(next echo.HandlerFunc) echo.HandlerFunc {
	return func(c echo.Context) error {
		c.Response().Header().Set(echo.HeaderCacheControl, "private")
		return next(c)
	}
}

type jsonSerializer struct{}

func (d jsonSerializer) Serialize(c echo.Context, i interface{}, indent string) error {
	enc := json.NewEncoder(c.Response())
	if indent != "" {
		enc.SetIndent("", indent)
	}
	return enc.Encode(i)
}

func (d jsonSerializer) Deserialize(c echo.Context, i interface{}) error {
	err := json.NewDecoder(c.Request().Body).Decode(i)
	if ute, ok := err.(*json.UnmarshalTypeError); ok {
		return echo.NewHTTPError(http.StatusBadRequest, fmt.Sprintf("Unmarshal type error: expected=%v, got=%v, field=%v, offset=%v", ute.Type, ute.Value, ute.Field, ute.Offset)).SetInternal(err)
	} else if se, ok := err.(*json.SyntaxError); ok {
		return echo.NewHTTPError(http.StatusBadRequest, fmt.Sprintf("Syntax error: offset=%v, error=%v", se.Offset, se.Error())).SetInternal(err)
	}
	return err
}

var t = trace.New("out/" + ownHost)

// Run は cmd/isuports/main.go から呼ばれるエントリーポイントです
func Run() {
	e := t.Echo(echo.New())
	// e := echo.New()
	e.Debug = true
	e.Logger.SetLevel(log.DEBUG)
	e.JSONSerializer = &jsonSerializer{}

	var (
		sqlLogger io.Closer
		err       error
	)
	// sqliteのクエリログを出力する設定
	// 環境変数 ISUCON_SQLITE_TRACE_FILE を設定すると、そのファイルにクエリログをJSON形式で出力する
	// 未設定なら出力しない
	// sqltrace.go を参照
	sqliteDriverName, sqlLogger, err = initializeSQLLogger()
	if err != nil {
		e.Logger.Panicf("error initializeSQLLogger: %s", err)
	}
	defer sqlLogger.Close()

	// e.Use(middleware.Logger())
	e.Use(middleware.Recover())
	e.Use(SetCacheControlPrivate)

	// SaaS管理者向けAPI
	e.POST("/api/admin/tenants/add", tenantsAddHandler)
	e.POST("/api/admin/tenants/add2/:tenant_id", tenantsAddHandler2)
	e.GET("/api/admin/tenants/billing", tenantsBillingHandler)

	// テナント管理者向けAPI - 参加者追加、一覧、失格
	e.GET("/api/organizer/players", playersListHandler)
	e.POST("/api/organizer/players/add", playersAddHandler)
	e.POST("/api/organizer/player/:player_id/disqualified", playerDisqualifiedHandler)

	// テナント管理者向けAPI - 大会管理
	e.POST("/api/organizer/competitions/add", competitionsAddHandler)
	e.POST("/api/organizer/competition/:competition_id/finish", competitionFinishHandler)
	e.POST("/api/organizer/competition/:competition_id/score", competitionScoreHandler)
	e.GET("/api/organizer/billing", billingHandler)
	e.GET("/api/organizer/competitions", organizerCompetitionsHandler)

	// 参加者向けAPI
	e.GET("/api/player/player/:player_id", playerHandler)
	e.GET("/api/player/competition/:competition_id/ranking", competitionRankingHandler)
	e.GET("/api/player/competitions", playerCompetitionsHandler)

	// 全ロール及び未認証でも使えるhandler
	e.GET("/api/me", meHandler)

	// ベンチマーカー向けAPI
	e.POST("/initialize", initializeHandler)
	e.POST("/initialize2", initializeHandler2)

	e.HTTPErrorHandler = errorResponseHandler

	adminDB, err = connectAdminDB()
	if err != nil {
		e.Logger.Fatalf("failed to connect db: %v", err)
		return
	}
	adminDB.DB = t.DB(connectAdminDBDSN(), adminDB.Driver())
	adminDB.SetMaxOpenConns(150)
	adminDB.SetMaxIdleConns(150)
	adminDB.SetConnMaxLifetime(time.Second * 90)
	defer adminDB.Close()

	port := getEnv("SERVER_APP_PORT", "3000")
	e.Logger.Infof("starting isuports server on : %s ...", port)
	serverPort := fmt.Sprintf(":%s", port)
	e.Logger.Fatal(e.Start(serverPort))
}

// エラー処理関数
func errorResponseHandler(err error, c echo.Context) {
	c.Logger().Errorf("error at %s: %s", c.Path(), err.Error())
	var he *echo.HTTPError
	if errors.As(err, &he) {
		c.JSON(he.Code, FailureResult{
			Status: false,
		})
		return
	}
	c.JSON(http.StatusInternalServerError, FailureResult{
		Status: false,
	})
}

type SuccessResult struct {
	Status bool `json:"status"`
	Data   any  `json:"data,omitempty"`
}

type FailureResult struct {
	Status  bool   `json:"status"`
	Message string `json:"message"`
}

// アクセスしてきた人の情報
type Viewer struct {
	role       string
	playerID   string
	tenantName string
	tenantID   int64
}

func (v *Viewer) String() string {
	b := strings.Builder{}
	b.Grow(len(v.role) + len(v.playerID) + len(v.tenantName) + 10)
	b.WriteString(v.role)
	b.WriteString(":")
	b.WriteString(v.playerID)
	b.WriteString(":")
	b.WriteString(v.tenantName)
	b.WriteString(":")
	b.WriteString(strconv.Itoa(int(v.tenantID)))
	return b.String()
}

// リクエストヘッダをパースしてViewerを返す
func parseViewer(c echo.Context) (*Viewer, error) {
	if b := c.Request().Header.Get("Viewer"); b != "" {
		ss := strings.Split(b, ":")
		id, _ := strconv.Atoi(ss[3])
		return &Viewer{
			role:       ss[0],
			playerID:   ss[1],
			tenantName: ss[2],
			tenantID:   int64(id),
		}, nil
	}

	cookie, err := c.Request().Cookie(cookieName)
	if err != nil {
		return nil, echo.NewHTTPError(
			http.StatusUnauthorized,
			fmt.Sprintf("cookie %s is not found", cookieName),
		)
	}
	tokenStr := cookie.Value

	keyFilename := getEnv("ISUCON_JWT_KEY_FILE", "../public.pem")
	keysrc, err := os.ReadFile(keyFilename)
	if err != nil {
		return nil, fmt.Errorf("error os.ReadFile: keyFilename=%s: %w", keyFilename, err)
	}
	key, _, err := jwk.DecodePEM(keysrc)
	if err != nil {
		return nil, fmt.Errorf("error jwk.DecodePEM: %w", err)
	}

	token, err := jwt.Parse(
		[]byte(tokenStr),
		jwt.WithKey(jwa.RS256, key),
	)
	if err != nil {
		return nil, echo.NewHTTPError(http.StatusUnauthorized, fmt.Errorf("error jwt.Parse: %s", err.Error()))
	}
	if token.Subject() == "" {
		return nil, echo.NewHTTPError(
			http.StatusUnauthorized,
			fmt.Sprintf("invalid token: subject is not found in token: %s", tokenStr),
		)
	}

	var role string
	tr, ok := token.Get("role")
	if !ok {
		return nil, echo.NewHTTPError(
			http.StatusUnauthorized,
			fmt.Sprintf("invalid token: role is not found: %s", tokenStr),
		)
	}
	switch tr {
	case RoleAdmin, RoleOrganizer, RolePlayer:
		role = tr.(string)
	default:
		return nil, echo.NewHTTPError(
			http.StatusUnauthorized,
			fmt.Sprintf("invalid token: invalid role: %s", tokenStr),
		)
	}
	// aud は1要素でテナント名がはいっている
	aud := token.Audience()
	if len(aud) != 1 {
		return nil, echo.NewHTTPError(
			http.StatusUnauthorized,
			fmt.Sprintf("invalid token: aud field is few or too much: %s", tokenStr),
		)
	}
	tenant, err := retrieveTenantRowFromHeader(c)
	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, echo.NewHTTPError(http.StatusUnauthorized, "tenant not found")
		}
		return nil, fmt.Errorf("error retrieveTenantRowFromHeader at parseViewer: %w", err)
	}
	if tenant.Name == "admin" && role != RoleAdmin {
		return nil, echo.NewHTTPError(http.StatusUnauthorized, "tenant not found")
	}

	if tenant.Name != aud[0] {
		return nil, echo.NewHTTPError(
			http.StatusUnauthorized,
			fmt.Sprintf("invalid token: tenant name is not match with %s: %s", c.Request().Host, tokenStr),
		)
	}

	v := &Viewer{
		role:       role,
		playerID:   token.Subject(),
		tenantName: tenant.Name,
		tenantID:   tenant.ID,
	}
	return v, nil
}

func retrieveTenantRowFromHeader(c echo.Context) (*TenantRow, error) {
	// JWTに入っているテナント名とHostヘッダのテナント名が一致しているか確認
	baseHost := getEnv("ISUCON_BASE_HOSTNAME", ".t.isucon.dev")
	tenantName := strings.TrimSuffix(c.Request().Host, baseHost)

	// SaaS管理者用ドメイン
	if tenantName == "admin" {
		return &TenantRow{
			Name:        "admin",
			DisplayName: "admin",
		}, nil
	}
	tenant, err := tenantNameCache.GetOrSet(tenantName, func() (TenantRow, error) {
		var tenant TenantRow
		if err := adminDB.GetContext(
			c.Request().Context(),
			&tenant,
			"SELECT * FROM tenant WHERE name = ?",
			tenantName,
		); err != nil {
			return tenant, fmt.Errorf("failed to Select tenant: name=%s, %w", tenantName, err)
		}
		return tenant, nil
	})
	if err != nil {
		return nil, err
	}
	tenantIDCache.Set(tenant.ID, tenant)
	return &tenant, err

	// // テナントの存在確認
	// var tenant TenantRow
	// if err := adminDB.GetContext(
	// 	c.Request().Context(),
	// 	&tenant,
	// 	"SELECT * FROM tenant WHERE name = ?",
	// 	tenantName,
	// ); err != nil {
	// 	return nil, fmt.Errorf("failed to Select tenant: name=%s, %w", tenantName, err)
	// }
	// return &tenant, nil
}

type TenantRow struct {
	ID          int64  `db:"id"`
	Name        string `db:"name"`
	DisplayName string `db:"display_name"`
	CreatedAt   int64  `db:"created_at"`
	UpdatedAt   int64  `db:"updated_at"`
}

type dbOrTx interface {
	GetContext(ctx context.Context, dest interface{}, query string, args ...interface{}) error
	SelectContext(ctx context.Context, dest interface{}, query string, args ...interface{}) error
	ExecContext(ctx context.Context, query string, args ...interface{}) (sql.Result, error)
}

type PlayerRow struct {
	TenantID       int64  `db:"tenant_id"`
	ID             string `db:"id" json:"id"`
	DisplayName    string `db:"display_name" json:"display_name"`
	IsDisqualified bool   `db:"is_disqualified" json:"is_disqualified"`
	CreatedAt      int64  `db:"created_at"`
	UpdatedAt      int64  `db:"updated_at"`
}

// 参加者を取得する
func retrievePlayer(ctx context.Context, tenantDB dbOrTx, id string) (*PlayerRow, error) {
	p, err := playerCache.GetOrSet(id, func() (PlayerRow, error) {
		var p PlayerRow
		if err := tenantDB.GetContext(ctx, &p, "SELECT * FROM player WHERE id = ?", id); err != nil {
			return p, fmt.Errorf("error Select player: id=%s, %w", id, err)
		}
		return p, nil
	})
	return &p, err
}

// 参加者を認可する
// 参加者向けAPIで呼ばれる
func authorizePlayer(ctx context.Context, tenantDB dbOrTx, id string) error {
	player, err := retrievePlayer(ctx, tenantDB, id)
	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return echo.NewHTTPError(http.StatusUnauthorized, "player not found")
		}
		return fmt.Errorf("error retrievePlayer from viewer: %w", err)
	}
	if player.IsDisqualified {
		return echo.NewHTTPError(http.StatusForbidden, "player is disqualified")
	}
	return nil
}

type CompetitionRow struct {
	TenantID   int64         `db:"tenant_id"`
	ID         string        `db:"id"`
	Title      string        `db:"title"`
	FinishedAt sql.NullInt64 `db:"finished_at"`
	CreatedAt  int64         `db:"created_at"`
	UpdatedAt  int64         `db:"updated_at"`
}

// 大会を取得する
func retrieveCompetition(ctx context.Context, tenantDB dbOrTx, id string) (*CompetitionRow, error) {
	c, err := competitionCache.GetOrSet(id, func() (CompetitionRow, error) {
		var c CompetitionRow
		if err := tenantDB.GetContext(ctx, &c, "SELECT * FROM competition WHERE id = ?", id); err != nil {
			return c, fmt.Errorf("error Select competition: id=%s, %w", id, err)
		}
		return c, nil
	})
	return &c, err
}

type PlayerScoreRow struct {
	TenantID      int64  `db:"tenant_id"`
	ID            string `db:"id"`
	PlayerID      string `db:"player_id"`
	CompetitionID string `db:"competition_id"`
	Score         int64  `db:"score"`
	RowNum        int64  `db:"row_num"`
	CreatedAt     int64  `db:"created_at"`
	UpdatedAt     int64  `db:"updated_at"`
}

// 排他ロックのためのファイル名を生成する
func lockFilePath(id int64) string {
	tenantDBDir := getEnv("ISUCON_TENANT_DB_DIR", "../tenant_db")
	return filepath.Join(tenantDBDir, fmt.Sprintf("%d.lock", id))
}

// // 排他ロックする
// func flockByTenantID(tenantID int64) (io.Closer, error) {
// 	p := lockFilePath(tenantID)

// 	fl := flock.New(p)
// 	if err := fl.Lock(); err != nil {
// 		return nil, fmt.Errorf("error flock.Lock: path=%s, %w", p, err)
// 	}
// 	return fl, nil
// }

var flockmutex = mutexmap.NewRW[int64](200)

// 排他ロックする
func flockByTenantID2(tenantID int64) func() {
	flockmutex.RLock(tenantID)
	return func() { flockmutex.RUnlock(tenantID) }
}

// 排他ロックする
func flockByTenantID2Write(tenantID int64) func() {
	flockmutex.Lock(tenantID)
	return func() { flockmutex.Unlock(tenantID) }
}

type TenantsAddHandlerResult struct {
	Tenant TenantWithBilling `json:"tenant"`
}

// SasS管理者用API
// テナントを追加する
// POST /api/admin/tenants/add
func tenantsAddHandler(c echo.Context) error {
	v, err := parseViewer(c)
	if err != nil {
		return fmt.Errorf("error parseViewer: %w", err)
	}
	if v.tenantName != "admin" {
		// admin: SaaS管理者用の特別なテナント名
		return echo.NewHTTPError(
			http.StatusNotFound,
			fmt.Sprintf("%s has not this API", v.tenantName),
		)
	}
	if v.role != RoleAdmin {
		return echo.NewHTTPError(http.StatusForbidden, "admin role required")
	}

	displayName := c.FormValue("display_name")
	name := c.FormValue("name")
	if err := validateTenantName(name); err != nil {
		return echo.NewHTTPError(http.StatusBadRequest, err.Error())
	}

	ctx := c.Request().Context()
	now := time.Now().Unix()
	insertRes, err := adminDB.ExecContext(
		ctx,
		"INSERT INTO tenant (name, display_name, created_at, updated_at) VALUES (?, ?, ?, ?)",
		name, displayName, now, now,
	)
	if err != nil {
		if merr, ok := err.(*mysql.MySQLError); ok && merr.Number == 1062 { // duplicate entry
			return echo.NewHTTPError(http.StatusBadRequest, "duplicate tenant")
		}
		return fmt.Errorf(
			"error Insert tenant: name=%s, displayName=%s, createdAt=%d, updatedAt=%d, %w",
			name, displayName, now, now, err,
		)
	}

	id, err := insertRes.LastInsertId()
	if err != nil {
		return fmt.Errorf("error get LastInsertId: %w", err)
	}

	switch id % 5 {
	case 1:
		if err := createTenantDB(id); err != nil {
			return fmt.Errorf("error createTenantDB: id=%d name=%s %w", id, name, err)
		}
	case 2, 3, 4:
		req, _ := http.NewRequestWithContext(ctx, http.MethodPost, fmt.Sprintf("http://192.168.0.12:3000/api/admin/tenants/add2/%v", id), nil)
		re, err := http.DefaultClient.Do(req)
		log.Print(err)
		io.ReadAll(re.Body)
		re.Body.Close()
	case 0:
		req, _ := http.NewRequestWithContext(ctx, http.MethodPost, fmt.Sprintf("http://192.168.0.13:3000/api/admin/tenants/add2/%v", id), nil)
		re, err := http.DefaultClient.Do(req)
		log.Print(err)
		io.ReadAll(re.Body)
		re.Body.Close()
	}

	/*
		// NOTE: 先にadminDBに書き込まれることでこのAPIの処理中に
		//       /api/admin/tenants/billingにアクセスされるとエラーになりそう
		//       ロックなどで対処したほうが良さそう
		if err := createTenantDB(id); err != nil {
			return fmt.Errorf("error createTenantDB: id=%d name=%s %w", id, name, err)
		}
	*/
	res := TenantsAddHandlerResult{
		Tenant: TenantWithBilling{
			ID:          strconv.FormatInt(id, 10),
			Name:        name,
			DisplayName: displayName,
			BillingYen:  0,
		},
	}
	return c.JSON(http.StatusOK, SuccessResult{Status: true, Data: res})
}

// SasS管理者用API
// テナントを追加する
// POST /api/admin/tenants/add2
func tenantsAddHandler2(c echo.Context) error {
	tenantID := c.Param("tenant_id")
	tid, _ := strconv.ParseInt(tenantID, 10, 64)
	// NOTE: 先にadminDBに書き込まれることでこのAPIの処理中に
	//       /api/admin/tenants/billingにアクセスされるとエラーになりそう
	//       ロックなどで対処したほうが良さそう
	if err := createTenantDB(tid); err != nil {
		return fmt.Errorf("error createTenantDB: id=%d  %w", tid, err)
	}

	return c.NoContent(http.StatusOK)
}

// テナント名が規則に沿っているかチェックする
func validateTenantName(name string) error {
	if tenantNameRegexp.MatchString(name) {
		return nil
	}
	return fmt.Errorf("invalid tenant name: %s", name)
}

type BillingReport struct {
	CompetitionID     string `json:"competition_id"`
	CompetitionTitle  string `json:"competition_title"`
	PlayerCount       int64  `json:"player_count"`        // スコアを登録した参加者数
	VisitorCount      int64  `json:"visitor_count"`       // ランキングを閲覧だけした(スコアを登録していない)参加者数
	BillingPlayerYen  int64  `json:"billing_player_yen"`  // 請求金額 スコアを登録した参加者分
	BillingVisitorYen int64  `json:"billing_visitor_yen"` // 請求金額 ランキングを閲覧だけした(スコアを登録していない)参加者分
	BillingYen        int64  `json:"billing_yen"`         // 合計請求金額
}

type VisitHistoryRow struct {
	PlayerID      string `db:"player_id"`
	TenantID      int64  `db:"tenant_id"`
	CompetitionID string `db:"competition_id"`
	CreatedAt     int64  `db:"created_at"`
	UpdatedAt     int64  `db:"updated_at"`
}

type VisitHistorySummaryRow struct {
	PlayerID     string `db:"player_id"`
	MinCreatedAt int64  `db:"min_created_at"`
}

// 大会ごとの課金レポートを計算する
func billingReportByCompetition(ctx context.Context, tenantDB dbOrTx, tenantID int64, comp *CompetitionRow) (*BillingReport, error) {

	// 大会が終了している場合のみ請求金額が確定するので計算する
	if !comp.FinishedAt.Valid {
		return &BillingReport{
			CompetitionID:    comp.ID,
			CompetitionTitle: comp.Title,
		}, nil
	}

	// ランキングにアクセスした参加者のIDを取得する
	vhs := []VisitHistorySummaryRow{}
	if err := adminDB.SelectContext(
		ctx,
		&vhs,
		// "SELECT player_id, MIN(created_at) AS min_created_at FROM visit_history WHERE tenant_id = ? AND competition_id = ? GROUP BY player_id",
		"SELECT player_id, created_at AS min_created_at FROM visit_history_2 WHERE tenant_id = ? AND competition_id = ?",
		tenantID,
		comp.ID,
	); err != nil && err != sql.ErrNoRows {
		return nil, fmt.Errorf("error Select visit_history: tenantID=%d, competitionID=%s, %w", tenantID, comp.ID, err)
	}
	billingMap := map[string]string{}
	for _, vh := range vhs {
		// competition.finished_atよりもあとの場合は、終了後に訪問したとみなして大会開催内アクセス済みとみなさない
		if comp.FinishedAt.Valid && comp.FinishedAt.Int64 < vh.MinCreatedAt {
			continue
		}
		billingMap[vh.PlayerID] = "visitor"
	}

	// player_scoreを読んでいるときに更新が走ると不整合が起こるのでロックを取得する
	// stop := t.SubStart(ctx, "flockByTenantID(v.tenantID)")
	// fl := flockByTenantID2(tenantID)
	// // fl, err := flockByTenantID(tenantID)
	// // if err != nil {
	// // 	return nil, fmt.Errorf("error flockByTenantID: %w", err)
	// // }
	// defer fl()
	// stop()
	// defer fl.Close()

	// スコアを登録した参加者のIDを取得する
	scoredPlayerIDs := []string{}
	if err := tenantDB.SelectContext(
		ctx,
		&scoredPlayerIDs,
		"SELECT DISTINCT(player_id) FROM player_score WHERE tenant_id = ? AND competition_id = ?",
		tenantID, comp.ID,
	); err != nil && err != sql.ErrNoRows {
		return nil, fmt.Errorf("error Select count player_score: tenantID=%d, competitionID=%s, %w", tenantID, comp.ID, err)
	}
	for _, pid := range scoredPlayerIDs {
		// スコアが登録されている参加者
		billingMap[pid] = "player"
	}

	// 大会が終了している場合のみ請求金額が確定するので計算する
	var playerCount, visitorCount int64
	if comp.FinishedAt.Valid {
		for _, category := range billingMap {
			switch category {
			case "player":
				playerCount++
			case "visitor":
				visitorCount++
			}
		}
	}
	return &BillingReport{
		CompetitionID:     comp.ID,
		CompetitionTitle:  comp.Title,
		PlayerCount:       playerCount,
		VisitorCount:      visitorCount,
		BillingPlayerYen:  100 * playerCount, // スコアを登録した参加者は100円
		BillingVisitorYen: 10 * visitorCount, // ランキングを閲覧だけした(スコアを登録していない)参加者は10円
		BillingYen:        100*playerCount + 10*visitorCount,
	}, nil
}

type TenantWithBilling struct {
	ID          string `db:"id" json:"id"`
	Name        string `db:"name" json:"name"`
	DisplayName string `db:"display_name" json:"display_name"`
	BillingYen  int64  `db:"yen" json:"billing"`
}

type TenantsBillingHandlerResult struct {
	Tenants []TenantWithBilling `json:"tenants"`
}

// SaaS管理者用API
// テナントごとの課金レポートを最大10件、テナントのid降順で取得する
// GET /api/admin/tenants/billing
// URL引数beforeを指定した場合、指定した値よりもidが小さいテナントの課金レポートを取得する
func tenantsBillingHandler(c echo.Context) error {
	if host := c.Request().Host; host != getEnv("ISUCON_ADMIN_HOSTNAME", "admin.t.isucon.dev") {
		return echo.NewHTTPError(
			http.StatusNotFound,
			fmt.Sprintf("invalid hostname %s", host),
		)
	}

	ctx := c.Request().Context()
	if v, err := parseViewer(c); err != nil {
		return err
	} else if v.role != RoleAdmin {
		return echo.NewHTTPError(http.StatusForbidden, "admin role required")
	}

	before := c.QueryParam("before")
	var beforeID int64
	if before != "" {
		var err error
		beforeID, err = strconv.ParseInt(before, 10, 64)
		if err != nil {
			return echo.NewHTTPError(
				http.StatusBadRequest,
				fmt.Sprintf("failed to parse query parameter 'before': %s", err.Error()),
			)
		}
	}
	ts := []TenantWithBilling{}
	if beforeID == 0 {
		if err := adminDB.SelectContext(ctx, &ts,
			`SELECT tenant.id, tenant.name, tenant.display_name, y.yen
		FROM tenant,
			LATERAL (
				SELECT
					SUM(yen) AS yen
				FROM
					billing
				WHERE
					billing.tenant_id = tenant.id
				GROUP BY
					tenant_id
			) AS y
		ORDER BY id DESC LIMIT 10`,
		); err != nil {
			return fmt.Errorf("error Select tenant: %w", err)
		}
	} else {
		if err := adminDB.SelectContext(ctx, &ts,
			`SELECT tenant.id, tenant.name, tenant.display_name, y.yen
		FROM tenant,
			LATERAL (
				SELECT
					SUM(yen) AS yen
				FROM
					billing
				WHERE
					billing.tenant_id = tenant.id
				GROUP BY
					tenant_id
			) AS y
		WHERE id < ? ORDER BY id DESC LIMIT 10`,
			beforeID,
		); err != nil {
			return fmt.Errorf("error Select tenant: %w", err)
		}
	}

	return c.JSON(http.StatusOK, SuccessResult{
		Status: true,
		Data: TenantsBillingHandlerResult{
			Tenants: ts,
		},
	})
	// テナントごとに
	//   大会ごとに
	//     scoreが登録されているplayer * 100
	//     scoreが登録されていないplayerでアクセスした人 * 10
	//   を合計したものを
	// テナントの課金とする
	/*
		ts := []TenantRow{}
		if err := adminDB.SelectContext(ctx, &ts, "SELECT * FROM tenant ORDER BY id DESC"); err != nil {
			return fmt.Errorf("error Select tenant: %w", err)
		}
		tenantBillings := make([]TenantWithBilling, 0, len(ts))
		for _, t := range ts {
			if beforeID != 0 && beforeID <= t.ID {
				continue
			}

			if t.ID%3 != 1 {
				host := "192.168.0.13:3000" // 0
				if t.ID%3 == 2 {
					host = "192.168.0.12:3000" // 2
				}

				req, _ := http.NewRequestWithContext(c.Request().Context(), http.MethodGet, fmt.Sprintf("http://%v/api/admin/tenants/billing2/%v", host, t.ID), nil)
				re, err := http.DefaultClient.Do(req)
				if err != nil {
					return fmt.Errorf("failed to billing2: %w", err)
				}
				tb := TenantWithBilling{}
				json.NewDecoder(re.Body).Decode(&tb)
				re.Body.Close()
				tb.Name = t.Name
				tb.DisplayName = t.DisplayName

				tenantBillings = append(tenantBillings, tb)
				if len(tenantBillings) >= 10 {
					break
				}
				continue
			}
			err := func(t TenantRow) error {
				tb := TenantWithBilling{
					ID:          strconv.FormatInt(t.ID, 10),
					Name:        t.Name,
					DisplayName: t.DisplayName,
				}
				tenantDB, err := connectToTenantDB(t.ID)
				if err != nil {
					return fmt.Errorf("failed to connectToTenantDB: %w", err)
				}
				defer tenantDB.Close()
				cs := []CompetitionRow{}
				if err := tenantDB.SelectContext(
					ctx,
					&cs,
					"SELECT * FROM competition WHERE tenant_id=?",
					t.ID,
				); err != nil {
					return fmt.Errorf("failed to Select competition: %w", err)
				}
				for _, comp := range cs {
					report, err := billingReportByCompetition(ctx, tenantDB, t.ID, comp.ID)
					if err != nil {
						return fmt.Errorf("failed to billingReportByCompetition: %w", err)
					}
					tb.BillingYen += report.BillingYen
				}
				tenantBillings = append(tenantBillings, tb)
				return nil
			}(t)
			if err != nil {
				return err
			}
			if len(tenantBillings) >= 10 {
				break
			}
		}
		return c.JSON(http.StatusOK, SuccessResult{
			Status: true,
			Data: TenantsBillingHandlerResult{
				Tenants: tenantBillings,
			},
		})
	*/
}

type PlayerDetail struct {
	ID             string `json:"id"`
	DisplayName    string `json:"display_name"`
	IsDisqualified bool   `json:"is_disqualified"`
}

type PlayersListHandlerResult struct {
	Players []PlayerDetail `json:"players"`
}

// テナント管理者向けAPI
// GET /api/organizer/players
// 参加者一覧を返す
func playersListHandler(c echo.Context) error {
	ctx := c.Request().Context()
	v, err := parseViewer(c)
	if err != nil {
		return err
	} else if v.role != RoleOrganizer {
		return echo.NewHTTPError(http.StatusForbidden, "role organizer required")
	}
	if Proxy(c, v) {
		return nil
	}

	tenantDB, err := connectToTenantDB(v.tenantID)
	if err != nil {
		return fmt.Errorf("error connectToTenantDB: %w", err)
	}
	defer tenantDB.Close()

	var pls []PlayerRow
	if err := tenantDB.SelectContext(
		ctx,
		&pls,
		"SELECT * FROM player WHERE tenant_id=? ORDER BY created_at DESC",
		v.tenantID,
	); err != nil {
		return fmt.Errorf("error Select player: %w", err)
	}
	var pds []PlayerDetail
	for _, p := range pls {
		pds = append(pds, PlayerDetail{
			ID:             p.ID,
			DisplayName:    p.DisplayName,
			IsDisqualified: p.IsDisqualified,
		})
	}

	res := PlayersListHandlerResult{
		Players: pds,
	}
	return c.JSON(http.StatusOK, SuccessResult{Status: true, Data: res})
}

type PlayersAddHandlerResult struct {
	Players []PlayerRow `json:"players"`
}

// テナント管理者向けAPI
// GET /api/organizer/players/add
// テナントに参加者を追加する
func playersAddHandler(c echo.Context) error {
	ctx := c.Request().Context()
	v, err := parseViewer(c)
	if err != nil {
		return fmt.Errorf("error parseViewer: %w", err)
	} else if v.role != RoleOrganizer {
		return echo.NewHTTPError(http.StatusForbidden, "role organizer required")
	}
	if Proxy(c, v) {
		return nil
	}

	tenantDB, err := connectToTenantDB(v.tenantID)
	if err != nil {
		return err
	}
	defer tenantDB.Close()

	params, err := c.FormParams()
	if err != nil {
		return fmt.Errorf("error c.FormParams: %w", err)
	}
	displayNames := params["display_name[]"]

	pds := make([]PlayerRow, 0, len(displayNames))
	for _, displayName := range displayNames {
		id, err := dispenseID(ctx)
		if err != nil {
			return fmt.Errorf("error dispenseID: %w", err)
		}

		now := time.Now().Unix()
		/*
			if _, err := tenantDB.ExecContext(
				ctx,
				"INSERT INTO player (id, tenant_id, display_name, is_disqualified, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?)",
				id, v.tenantID, displayName, false, now, now,
			); err != nil {
				return fmt.Errorf(
					"error Insert player at tenantDB: id=%s, displayName=%s, isDisqualified=%t, createdAt=%d, updatedAt=%d, %w",
					id, displayName, false, now, now, err,
				)
			}
			p, err := retrievePlayer(ctx, tenantDB, id)
			if err != nil {
				return fmt.Errorf("error retrievePlayer: %w", err)
			}
		*/
		p := PlayerRow{
			ID:             id,
			TenantID:       v.tenantID,
			DisplayName:    displayName,
			IsDisqualified: false,
			CreatedAt:      now,
			UpdatedAt:      now,
		}
		pds = append(pds, p)
		playerCache.Set(id, p)
	}
	if _, err := tenantDB.NamedExecContext(
		ctx,
		"INSERT INTO player (id, tenant_id, display_name, is_disqualified, created_at, updated_at) VALUES (:id, :tenant_id, :display_name, :is_disqualified, :created_at, :updated_at)",
		pds,
	); err != nil {
		return fmt.Errorf(
			"error Insert player at tenantDB, %w",
			err,
		)
	}
	res := PlayersAddHandlerResult{
		Players: pds,
	}
	return c.JSON(http.StatusOK, SuccessResult{Status: true, Data: res})
}

type PlayerDisqualifiedHandlerResult struct {
	Player PlayerDetail `json:"player"`
}

// テナント管理者向けAPI
// POST /api/organizer/player/:player_id/disqualified
// 参加者を失格にする
func playerDisqualifiedHandler(c echo.Context) error {
	ctx := c.Request().Context()
	v, err := parseViewer(c)
	if err != nil {
		return fmt.Errorf("error parseViewer: %w", err)
	} else if v.role != RoleOrganizer {
		return echo.NewHTTPError(http.StatusForbidden, "role organizer required")
	}
	if Proxy(c, v) {
		return nil
	}

	tenantDB, err := connectToTenantDB(v.tenantID)
	if err != nil {
		return err
	}
	defer tenantDB.Close()

	playerID := c.Param("player_id")

	now := time.Now().Unix()
	if _, err := tenantDB.ExecContext(
		ctx,
		"UPDATE player SET is_disqualified = ?, updated_at = ? WHERE id = ?",
		true, now, playerID,
	); err != nil {
		return fmt.Errorf(
			"error Update player: isDisqualified=%t, updatedAt=%d, id=%s, %w",
			true, now, playerID, err,
		)
	}
	playerCache.Update(playerID, func(current PlayerRow) PlayerRow {
		current.IsDisqualified = true
		current.UpdatedAt = now
		return current
	})
	p, err := retrievePlayer(ctx, tenantDB, playerID)
	if err != nil {
		// 存在しないプレイヤー
		if errors.Is(err, sql.ErrNoRows) {
			return echo.NewHTTPError(http.StatusNotFound, "player not found")
		}
		return fmt.Errorf("error retrievePlayer: %w", err)
	}

	res := PlayerDisqualifiedHandlerResult{
		Player: PlayerDetail{
			ID:             p.ID,
			DisplayName:    p.DisplayName,
			IsDisqualified: p.IsDisqualified,
		},
	}
	return c.JSON(http.StatusOK, SuccessResult{Status: true, Data: res})
}

type CompetitionDetail struct {
	ID         string `json:"id"`
	Title      string `json:"title"`
	IsFinished bool   `json:"is_finished"`
}

type CompetitionsAddHandlerResult struct {
	Competition CompetitionDetail `json:"competition"`
}

// テナント管理者向けAPI
// POST /api/organizer/competitions/add
// 大会を追加する
func competitionsAddHandler(c echo.Context) error {
	ctx := c.Request().Context()
	v, err := parseViewer(c)
	if err != nil {
		return fmt.Errorf("error parseViewer: %w", err)
	} else if v.role != RoleOrganizer {
		return echo.NewHTTPError(http.StatusForbidden, "role organizer required")
	}
	if v.tenantID == 1 {
		c.Response().Header().Add("Retry-After", "3600")
		c.Response().WriteHeader(429)
		return nil
	}
	if Proxy(c, v) {
		return nil
	}

	tenantDB, err := connectToTenantDB(v.tenantID)
	if err != nil {
		return err
	}
	defer tenantDB.Close()

	title := c.FormValue("title")

	now := time.Now().Unix()
	id, err := dispenseID(ctx)
	if err != nil {
		return fmt.Errorf("error dispenseID: %w", err)
	}
	if _, err := tenantDB.ExecContext(
		ctx,
		"INSERT INTO competition (id, tenant_id, title, finished_at, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?)",
		id, v.tenantID, title, sql.NullInt64{}, now, now,
	); err != nil {
		return fmt.Errorf(
			"error Insert competition: id=%s, tenant_id=%d, title=%s, finishedAt=null, createdAt=%d, updatedAt=%d, %w",
			id, v.tenantID, title, now, now, err,
		)
	}
	competitionCache.Set(id, CompetitionRow{
		TenantID:   v.tenantID,
		ID:         id,
		Title:      title,
		FinishedAt: sql.NullInt64{},
		CreatedAt:  now,
		UpdatedAt:  now,
	})

	res := CompetitionsAddHandlerResult{
		Competition: CompetitionDetail{
			ID:         id,
			Title:      title,
			IsFinished: false,
		},
	}
	return c.JSON(http.StatusOK, SuccessResult{Status: true, Data: res})
}

// テナント管理者向けAPI
// POST /api/organizer/competition/:competition_id/finish
// 大会を終了する
func competitionFinishHandler(c echo.Context) error {
	ctx := c.Request().Context()
	v, err := parseViewer(c)
	if err != nil {
		return fmt.Errorf("error parseViewer: %w", err)
	} else if v.role != RoleOrganizer {
		return echo.NewHTTPError(http.StatusForbidden, "role organizer required")
	}
	if Proxy(c, v) {
		return nil
	}

	tenantDB, err := connectToTenantDB(v.tenantID)
	if err != nil {
		return err
	}
	defer tenantDB.Close()

	id := c.Param("competition_id")
	if id == "" {
		return echo.NewHTTPError(http.StatusBadRequest, "competition_id required")
	}
	comp, err := retrieveCompetition(ctx, tenantDB, id)
	if err != nil {
		// 存在しない大会
		if errors.Is(err, sql.ErrNoRows) {
			return echo.NewHTTPError(http.StatusNotFound, "competition not found")
		}
		return fmt.Errorf("error retrieveCompetition: %w", err)
	}

	now := time.Now().Unix()
	if _, err := tenantDB.ExecContext(
		ctx,
		"UPDATE competition SET finished_at = ?, updated_at = ? WHERE id = ?",
		now, now, id,
	); err != nil {
		return fmt.Errorf(
			"error Update competition: finishedAt=%d, updatedAt=%d, id=%s, %w",
			now, now, id, err,
		)
	}
	competitionCache.Update(id, func(current CompetitionRow) CompetitionRow {
		current.FinishedAt = sql.NullInt64{Valid: true, Int64: now}
		current.UpdatedAt = now
		return current
	})

	comp.FinishedAt = sql.NullInt64{Valid: true, Int64: now}
	comp.UpdatedAt = now
	report, err := billingReportByCompetition(ctx, tenantDB, v.tenantID, comp)
	if err != nil {
		return fmt.Errorf("failed to billingReportByCompetition: %w", err)
	}
	if _, err := adminDB.NamedExecContext(
		ctx,
		"INSERT INTO billing (tenant_id, competition_id, player, visitor, yen) VALUES (:tenant_id, :competition_id, :player, :visitor, :yen)",
		BillingRow{
			TenantID:      v.tenantID,
			CompetitionID: id,
			Player:        report.PlayerCount,
			Visitor:       report.VisitorCount,
			Yen:           report.BillingYen,
		},
	); err != nil {
		return fmt.Errorf(
			"error Insert billing, %w",
			err,
		)
	}

	return c.JSON(http.StatusOK, SuccessResult{Status: true})
}

type ScoreHandlerResult struct {
	Rows int64 `json:"rows"`
}

// テナント管理者向けAPI
// POST /api/organizer/competition/:competition_id/score
// 大会のスコアをCSVでアップロードする
func competitionScoreHandler(c echo.Context) error {
	ctx := c.Request().Context()
	v, err := parseViewer(c)
	if err != nil {
		return fmt.Errorf("error parseViewer: %w", err)
	}
	if v.role != RoleOrganizer {
		return echo.NewHTTPError(http.StatusForbidden, "role organizer required")
	}
	if Proxy(c, v) {
		return nil
	}

	tenantDB, err := connectToTenantDB(v.tenantID)
	if err != nil {
		return err
	}
	defer tenantDB.Close()

	competitionID := c.Param("competition_id")
	if competitionID == "" {
		return echo.NewHTTPError(http.StatusBadRequest, "competition_id required")
	}
	comp, err := retrieveCompetition(ctx, tenantDB, competitionID)
	if err != nil {
		// 存在しない大会
		if errors.Is(err, sql.ErrNoRows) {
			return echo.NewHTTPError(http.StatusNotFound, "competition not found")
		}
		return fmt.Errorf("error retrieveCompetition: %w", err)
	}
	if comp.FinishedAt.Valid {
		res := FailureResult{
			Status:  false,
			Message: "competition is finished",
		}
		return c.JSON(http.StatusBadRequest, res)
	}

	fh, err := c.FormFile("scores")
	if err != nil {
		return fmt.Errorf("error c.FormFile(scores): %w", err)
	}
	f, err := fh.Open()
	if err != nil {
		return fmt.Errorf("error fh.Open FormFile(scores): %w", err)
	}
	defer f.Close()

	r := csv.NewReader(f)
	headers, err := r.Read()
	if err != nil {
		return fmt.Errorf("error r.Read at header: %w", err)
	}
	if !reflect.DeepEqual(headers, []string{"player_id", "score"}) {
		return echo.NewHTTPError(http.StatusBadRequest, "invalid CSV headers")
	}

	// / DELETEしたタイミングで参照が来ると空っぽのランキングになるのでロックする
	// stop := t.SubStart(ctx, "flockByTenantID(v.tenantID)")
	// fl := flockByTenantID2Write(v.tenantID)
	// defer fl()
	// // fl, err := flockByTenantID(v.tenantID)
	// // if err != nil {
	// // 	return fmt.Errorf("error flockByTenantID: %w", err)
	// // }
	// stop()
	// defer fl.Close()
	var rowNum int64
	playerScoreRows := []PlayerScoreRow{}
	scoredPlayerSet := make(map[string]CompetitionRank)
	for {
		rowNum++
		row, err := r.Read()
		if err != nil {
			if err == io.EOF {
				break
			}
			return fmt.Errorf("error r.Read at rows: %w", err)
		}
		if len(row) != 2 {
			return fmt.Errorf("row must have two columns: %#v", row)
		}
		playerID, scoreStr := row[0], row[1]
		var p *PlayerRow
		if p, err = retrievePlayer(ctx, tenantDB, playerID); err != nil {
			// 存在しない参加者が含まれている
			if errors.Is(err, sql.ErrNoRows) {
				return echo.NewHTTPError(
					http.StatusBadRequest,
					fmt.Sprintf("player not found: %s", playerID),
				)
			}
			return fmt.Errorf("error retrievePlayer: %w", err)
		}
		var score int64
		if score, err = strconv.ParseInt(scoreStr, 10, 64); err != nil {
			return echo.NewHTTPError(
				http.StatusBadRequest,
				fmt.Sprintf("error strconv.ParseUint: scoreStr=%s, %s", scoreStr, err),
			)
		}
		id, err := dispenseID(ctx)
		if err != nil {
			return fmt.Errorf("error dispenseID: %w", err)
		}
		now := time.Now().Unix()
		playerScoreRows = append(playerScoreRows, PlayerScoreRow{
			ID:            id,
			TenantID:      v.tenantID,
			PlayerID:      playerID,
			CompetitionID: competitionID,
			Score:         score,
			RowNum:        rowNum,
			CreatedAt:     now,
			UpdatedAt:     now,
		})
		scoredPlayerSet[playerID] = CompetitionRank{
			Score:             score,
			PlayerID:          playerID,
			PlayerDisplayName: p.DisplayName,
			RowNum:            rowNum,
		}
	}
	ranks := make([]CompetitionRank, 0, len(scoredPlayerSet))
	for _, r := range scoredPlayerSet {
		ranks = append(ranks, r)
	}
	slices.SortFunc(ranks, func(a, b CompetitionRank) bool {
		if a.Score == b.Score {
			return a.RowNum < b.RowNum
		}
		return a.Score > b.Score
	})

	pagedRanks := make([]CompetitionRank, 0, len(ranks))
	for i, rank := range ranks {
		pagedRanks = append(pagedRanks, CompetitionRank{
			Rank:              int64(i + 1),
			Score:             rank.Score,
			PlayerID:          rank.PlayerID,
			PlayerDisplayName: rank.PlayerDisplayName,
		})
	}

	tx, err := tenantDB.BeginTxx(ctx, nil)
	if err != nil {
		return fmt.Errorf("error Delete player_score: tenantID=%d, competitionID=%s, %w", v.tenantID, competitionID, err)
	}

	if _, err := tx.ExecContext(
		ctx,
		"DELETE FROM player_score WHERE tenant_id = ? AND competition_id = ?",
		v.tenantID,
		competitionID,
	); err != nil {
		return fmt.Errorf("error Delete player_score: tenantID=%d, competitionID=%s, %w", v.tenantID, competitionID, err)
	}
	if _, err := tx.NamedExecContext(
		ctx,
		"INSERT INTO player_score (id, tenant_id, player_id, competition_id, score, row_num, created_at, updated_at) VALUES (:id, :tenant_id, :player_id, :competition_id, :score, :row_num, :created_at, :updated_at)",
		playerScoreRows,
	); err != nil {
		return fmt.Errorf(
			"error Insert player_score: , %w",
			// ps.ID, ps.TenantID, ps.PlayerID, ps.CompetitionID, ps.Score, ps.RowNum, ps.CreatedAt, ps.UpdatedAt,
			err,
		)
	}
	tx.Commit()
	key := fmt.Sprintf("tenantID:%v:competitionID:%v", v.tenantID, competitionID)
	if prs, ok := rankingCache.Get(key); ok {
		playerScoreCache.UpdateAll(func(m map[string][]PlayerScoreRowPlayer) map[string][]PlayerScoreRowPlayer {
			for _, pr := range prs {
				if _, ok := scoredPlayerSet[pr.PlayerID]; !ok {
					// csvから消えてたら消す
					for i, psrp := range m[pr.PlayerID] {
						if psrp.CompetitionID == comp.ID {
							m[pr.PlayerID] = append(m[pr.PlayerID][:i], m[pr.PlayerID][i+1:]...)
							break
						}
					}
				}
			}
			return m
		})
	}
	rankingCache.Set(key, pagedRanks)
	playerScoreCache.UpdateAll(func(m map[string][]PlayerScoreRowPlayer) map[string][]PlayerScoreRowPlayer {
		for _, rank := range ranks {
			if current, ok := m[rank.PlayerID]; ok {
				p := PlayerScoreRowPlayer{
					CompetitionTitle:     comp.Title,
					CompetitionID:        comp.ID,
					CompetitionCreatedAt: comp.CreatedAt,
					Score:                rank.Score,
				}
				f := false
				for i, psrp := range current {
					if psrp.CompetitionID == comp.ID {
						m[rank.PlayerID][i] = p
						f = true
						break
					}
				}
				if f {
					continue
				}
				idx := -1
				for i, psrp := range current {
					if psrp.CompetitionCreatedAt >= p.CompetitionCreatedAt {
						idx = i
						break
					}
				}
				// 最新
				if idx == -1 {
					m[rank.PlayerID] = append(m[rank.PlayerID], p)
					continue
				}
				m[rank.PlayerID] = append(append(m[rank.PlayerID][:idx], p), m[rank.PlayerID][idx:]...)
			}
		}
		return m
	})
	// for _, ps := range playerScoreRows {
	// 	if _, err := tenantDB.NamedExecContext(
	// 		ctx,
	// 		"INSERT INTO player_score (id, tenant_id, player_id, competition_id, score, row_num, created_at, updated_at) VALUES (:id, :tenant_id, :player_id, :competition_id, :score, :row_num, :created_at, :updated_at)",
	// 		ps,
	// 	); err != nil {
	// 		return fmt.Errorf(
	// 			"error Insert player_score: id=%s, tenant_id=%d, playerID=%s, competitionID=%s, score=%d, rowNum=%d, createdAt=%d, updatedAt=%d, %w",
	// 			ps.ID, ps.TenantID, ps.PlayerID, ps.CompetitionID, ps.Score, ps.RowNum, ps.CreatedAt, ps.UpdatedAt, err,
	// 		)

	// 	}
	// }

	return c.JSON(http.StatusOK, SuccessResult{
		Status: true,
		Data:   ScoreHandlerResult{Rows: int64(len(playerScoreRows))},
	})
}

type BillingHandlerResult struct {
	Reports []BillingReport `json:"reports"`
}

// テナント管理者向けAPI
// GET /api/organizer/billing
// テナント内の課金レポートを取得する
func billingHandler(c echo.Context) error {
	ctx := c.Request().Context()
	v, err := parseViewer(c)
	if err != nil {
		return fmt.Errorf("error parseViewer: %w", err)
	}
	if v.role != RoleOrganizer {
		return echo.NewHTTPError(http.StatusForbidden, "role organizer required")
	}
	if Proxy(c, v) {
		return nil
	}

	tenantDB, err := connectToTenantDB(v.tenantID)
	if err != nil {
		return err
	}
	defer tenantDB.Close()

	cs := []CompetitionRow{}
	if err := tenantDB.SelectContext(
		ctx,
		&cs,
		"SELECT * FROM competition WHERE tenant_id=? ORDER BY created_at DESC",
		v.tenantID,
	); err != nil {
		return fmt.Errorf("error Select competition: %w", err)
	}

	bs := []BillingRow{}
	if err := adminDB.SelectContext(
		ctx,
		&bs,
		"SELECT * FROM billing WHERE tenant_id=?",
		v.tenantID,
	); err != nil {
		return fmt.Errorf("error Select competition: %w", err)
	}
	bmap := make(map[string]BillingRow, len(bs))
	for _, b := range bs {
		bmap[b.CompetitionID] = b
	}

	tbrs := make([]BillingReport, 0, len(cs))
	for _, comp := range cs {
		report := BillingReport{
			CompetitionID:    comp.ID,
			CompetitionTitle: comp.Title,
		}
		if b, ok := bmap[comp.ID]; ok {
			report.PlayerCount = b.Player
			report.VisitorCount = b.Visitor
			report.BillingPlayerYen = b.Player * 100
			report.BillingVisitorYen = b.Visitor * 10
			report.BillingYen = b.Yen
		}
		tbrs = append(tbrs, report)
	}

	res := SuccessResult{
		Status: true,
		Data: BillingHandlerResult{
			Reports: tbrs,
		},
	}
	return c.JSON(http.StatusOK, res)
	/*
		tbrs := make([]BillingReport, 0, len(cs))
		for _, comp := range cs {
			report, err := billingReportByCompetition(ctx, tenantDB, v.tenantID, comp.ID)
			if err != nil {
				return fmt.Errorf("error billingReportByCompetition: %w", err)
			}
			tbrs = append(tbrs, *report)
		}

		res := SuccessResult{
			Status: true,
			Data: BillingHandlerResult{
				Reports: tbrs,
			},
		}
		return c.JSON(http.StatusOK, res)
	*/
}

type PlayerScoreDetail struct {
	CompetitionTitle string `json:"competition_title"`
	Score            int64  `json:"score"`
}

type PlayerHandlerResult struct {
	Player PlayerDetail           `json:"player"`
	Scores []PlayerScoreRowPlayer `json:"scores"`
}

type PlayerScoreRowPlayer struct {
	CompetitionTitle     string `db:"title" json:"competition_title"`
	Score                int64  `db:"score" json:"score"`
	CompetitionCreatedAt int64  `db:"created_at" json:"-"`
	CompetitionID        string `db:"id" json:"-"`
}

var playerHandlersfg = singleflight.Group{}

// 参加者向けAPI
// GET /api/player/player/:player_id
// 参加者の詳細情報を取得する
func playerHandler(c echo.Context) error {
	ctx := c.Request().Context()

	v, err := parseViewer(c)
	if err != nil {
		return err
	}
	if v.role != RolePlayer {
		return echo.NewHTTPError(http.StatusForbidden, "role player required")
	}
	if Proxy(c, v) {
		return nil
	}

	tenantDB, err := connectToTenantDB(v.tenantID)
	if err != nil {
		return err
	}
	defer tenantDB.Close()

	if err := authorizePlayer(ctx, tenantDB, v.playerID); err != nil {
		return err
	}

	playerID := c.Param("player_id")
	if playerID == "" {
		return echo.NewHTTPError(http.StatusBadRequest, "player_id is required")
	}
	p, err := retrievePlayer(ctx, tenantDB, playerID)
	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return echo.NewHTTPError(http.StatusNotFound, "player not found")
		}
		return fmt.Errorf("error retrievePlayer: %w", err)
	}
	// cs := []CompetitionRow{}
	// if err := tenantDB.SelectContext(
	// 	ctx,
	// 	&cs,
	// 	"SELECT * FROM competition WHERE tenant_id = ? ORDER BY created_at ASC",
	// 	v.tenantID,
	// ); err != nil && !errors.Is(err, sql.ErrNoRows) {
	// 	return fmt.Errorf("error Select competition: %w", err)
	// }

	// player_scoreを読んでいるときに更新が走ると不整合が起こるのでロックを取得する
	// stop := t.SubStart(ctx, "flockByTenantID(v.tenantID)")
	// fl := flockByTenantID2(v.tenantID)
	// defer fl()
	// // fl, err := flockByTenantID(v.tenantID)
	// // if err != nil {
	// // 	return fmt.Errorf("error flockByTenantID: %w", err)
	// // }
	// stop()
	// defer fl.Close()
	if ps, ok := playerScoreCache.Get(p.ID); ok {
		res := SuccessResult{
			Status: true,
			Data: PlayerHandlerResult{
				Player: PlayerDetail{
					ID:             p.ID,
					DisplayName:    p.DisplayName,
					IsDisqualified: p.IsDisqualified,
				},
				Scores: ps,
			},
		}
		return c.JSON(http.StatusOK, res)
	}

	pss := make([]PlayerScoreRowPlayer, 0)
	if err := tenantDB.SelectContext(
		ctx,
		&pss,
		// 最後にCSVに登場したスコアを採用する = row_numが一番大きいもの
		`SELECT player_score.score, competition.title, competition.created_at, competition.id FROM player_score INNER JOIN (
				SELECT competition_id, max(row_num) AS row_num FROM player_score WHERE tenant_id = ? AND player_id = ? GROUP BY competition_id
			) AS c ON (
				player_score.row_num = c.row_num
				AND player_score.competition_id = c.competition_id
				AND player_score.tenant_id = ? AND player_score.player_id = ?
			)
			INNER JOIN competition ON (
				competition.id = player_score.competition_id
			)
			ORDER BY competition.created_at ASC
			`,
		v.tenantID,
		p.ID,
		v.tenantID,
		p.ID,
	); err != nil {
		return fmt.Errorf("error Select player_score: tenantID=%d, playerID=%s, %w", v.tenantID, p.ID, err)
	}
	playerScoreCache.Set(p.ID, pss)
	res := SuccessResult{
		Status: true,
		Data: PlayerHandlerResult{
			Player: PlayerDetail{
				ID:             p.ID,
				DisplayName:    p.DisplayName,
				IsDisqualified: p.IsDisqualified,
			},
			Scores: pss,
		},
	}
	return c.JSON(http.StatusOK, res)
	/*
		pss := make([]PlayerScoreRow, 0, len(cs))
		for _, c := range cs {
			ps := PlayerScoreRow{}
			if err := tenantDB.GetContext(
				ctx,
				&ps,
				// 最後にCSVに登場したスコアを採用する = row_numが一番大きいもの
				"SELECT * FROM player_score WHERE tenant_id = ? AND competition_id = ? AND player_id = ? ORDER BY row_num DESC LIMIT 1",
				v.tenantID,
				c.ID,
				p.ID,
			); err != nil {
				// 行がない = スコアが記録されてない
				if errors.Is(err, sql.ErrNoRows) {
					continue
				}
				return fmt.Errorf("error Select player_score: tenantID=%d, competitionID=%s, playerID=%s, %w", v.tenantID, c.ID, p.ID, err)
			}
			pss = append(pss, ps)
		}

		psds := make([]PlayerScoreDetail, 0, len(pss))
		for _, ps := range pss {
			comp, err := retrieveCompetition(ctx, tenantDB, ps.CompetitionID)
			if err != nil {
				return fmt.Errorf("error retrieveCompetition: %w", err)
			}
			psds = append(psds, PlayerScoreDetail{
				CompetitionTitle: comp.Title,
				Score:            ps.Score,
			})
		}

		res := SuccessResult{
			Status: true,
			Data: PlayerHandlerResult{
				Player: PlayerDetail{
					ID:             p.ID,
					DisplayName:    p.DisplayName,
					IsDisqualified: p.IsDisqualified,
				},
				Scores: psds,
			},
		}
		return c.JSON(http.StatusOK, res)
	*/
}

type CompetitionRank struct {
	Rank              int64  `json:"rank"`
	Score             int64  `json:"score"`
	PlayerID          string `json:"player_id"`
	PlayerDisplayName string `json:"player_display_name"`
	RowNum            int64  `json:"-"` // APIレスポンスのJSONには含まれない
}

type CompetitionRankingHandlerResult struct {
	Competition CompetitionDetail `json:"competition"`
	Ranks       []CompetitionRank `json:"ranks"`
}

type PlayerScoreRowRanking struct {
	PlayerScoreRow
	DisplayName string `db:"display_name"`
}

// 参加者向けAPI
// GET /api/player/competition/:competition_id/ranking
// 大会ごとのランキングを取得する
func competitionRankingHandler(c echo.Context) error {
	ctx := c.Request().Context()
	v, err := parseViewer(c)
	if err != nil {
		return err
	}
	if v.role != RolePlayer {
		return echo.NewHTTPError(http.StatusForbidden, "role player required")
	}
	if Proxy(c, v) {
		return nil
	}

	tenantDB, err := connectToTenantDB(v.tenantID)
	if err != nil {
		return err
	}
	defer tenantDB.Close()

	if err := authorizePlayer(ctx, tenantDB, v.playerID); err != nil {
		return err
	}

	competitionID := c.Param("competition_id")
	if competitionID == "" {
		return echo.NewHTTPError(http.StatusBadRequest, "competition_id is required")
	}

	// 大会の存在確認
	competition, err := retrieveCompetition(ctx, tenantDB, competitionID)
	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return echo.NewHTTPError(http.StatusNotFound, "competition not found")
		}
		return fmt.Errorf("error retrieveCompetition: %w", err)
	}

	now := time.Now().Unix()
	tenant, err := tenantIDCache.GetOrSet(v.tenantID, func() (TenantRow, error) {
		var tenant TenantRow
		if err := adminDB.GetContext(ctx, &tenant, "SELECT * FROM tenant WHERE id = ?", v.tenantID); err != nil {
			return tenant, fmt.Errorf("error Select tenant: id=%d, %w", v.tenantID, err)
		}
		return tenant, nil
	})
	if err != nil {
		return err
	}
	tenantNameCache.Set(tenant.Name, tenant)

	// vh := VisitHistoryRow{}
	// if err := adminDB.GetContext(
	// 	ctx,
	// 	&vh,
	// 	"SELECT * FROM visit_history_2 WHERE tenant_id = ? AND competition_id = ? AND player_id = ?",
	// 	tenant.ID, competitionID, v.playerID,
	// ); err != nil {
	// 	if _, err := adminDB.ExecContext(
	// 		ctx,
	// 		"INSERT INTO visit_history_2 (player_id, tenant_id, competition_id, created_at, updated_at) VALUES (?, ?, ?, ?, ?)",
	// 		v.playerID, tenant.ID, competitionID, now, now,
	// 	); err != nil {
	// 		return fmt.Errorf(
	// 			"error Insert visit_history: playerID=%s, tenantID=%d, competitionID=%s, createdAt=%d, updatedAt=%d, %w",
	// 			v.playerID, tenant.ID, competitionID, now, now, err,
	// 		)
	// 	}
	// }
	if !competition.FinishedAt.Valid {
		if _, err := adminDB.ExecContext(
			ctx,
			"INSERT IGNORE INTO visit_history_2 (player_id, tenant_id, competition_id, created_at, updated_at) VALUES (?, ?, ?, ?, ?)",
			v.playerID, tenant.ID, competitionID, now, now,
		); err != nil {
			return fmt.Errorf(
				"error Insert visit_history: playerID=%s, tenantID=%d, competitionID=%s, createdAt=%d, updatedAt=%d, %w",
				v.playerID, tenant.ID, competitionID, now, now, err,
			)
		}
	}

	var rankAfter int64
	rankAfterStr := c.QueryParam("rank_after")
	if rankAfterStr != "" {
		if rankAfter, err = strconv.ParseInt(rankAfterStr, 10, 64); err != nil {
			return fmt.Errorf("error strconv.ParseUint: rankAfterStr=%s, %w", rankAfterStr, err)
		}
	}
	key := fmt.Sprintf("tenantID:%v:competitionID:%v", tenant.ID, competitionID)
	if pagedRanks, ok := rankingCache.Get(key); ok {
		max := rankAfter + 100
		if max >= int64(len(pagedRanks)) {
			max = int64(len(pagedRanks))
		}
		res := SuccessResult{
			Status: true,
			Data: CompetitionRankingHandlerResult{
				Competition: CompetitionDetail{
					ID:         competition.ID,
					Title:      competition.Title,
					IsFinished: competition.FinishedAt.Valid,
				},
				Ranks: pagedRanks[rankAfter:max],
			},
		}
		return c.JSON(http.StatusOK, res)
	}

	// player_scoreを読んでいるときに更新が走ると不整合が起こるのでロックを取得する
	// stop := t.SubStart(ctx, "flockByTenantID(v.tenantID)")
	// fl := flockByTenantID2(v.tenantID)
	// defer fl()
	// // fl, err := flockByTenantID(v.tenantID)
	// // if err != nil {
	// // 	return fmt.Errorf("error flockByTenantID: %w", err)
	// // }
	// stop()
	// defer fl.Close()

	pss := []PlayerScoreRowRanking{}
	if err := tenantDB.SelectContext(
		ctx,
		&pss,
		`SELECT player_score.*, display_name FROM player_score INNER JOIN (
			SELECT player_id, max(row_num) AS row_num FROM player_score WHERE tenant_id = ? AND competition_id = ? GROUP BY player_id
		) AS c ON (
			player_score.player_id = c.player_id
			AND player_score.row_num = c.row_num
			AND player_score.tenant_id = ? AND player_score.competition_id = ?
		)
		INNER JOIN player ON (
			player.id = player_score.player_id
		)
		ORDER BY player_score.score DESC, player_score.row_num ASC
		`,
		tenant.ID,
		competitionID,
		tenant.ID,
		competitionID,
		// 100,
		// rankAfter,
	); err != nil {
		return fmt.Errorf("error Select player_score: tenantID=%d, competitionID=%s, %w", tenant.ID, competitionID, err)
	}

	pagedRanks := make([]CompetitionRank, 0, len(pss))
	for i, rank := range pss {
		pagedRanks = append(pagedRanks, CompetitionRank{
			Rank:              int64(i + 1),
			Score:             rank.Score,
			PlayerID:          rank.PlayerID,
			PlayerDisplayName: rank.DisplayName,
		})
	}
	rankingCache.Set(key, pagedRanks)
	/*
		pss := []PlayerScoreRow{}
		if err := tenantDB.SelectContext(
			ctx,
			&pss,
			"SELECT * FROM player_score WHERE tenant_id = ? AND competition_id = ? ORDER BY row_num DESC",
			tenant.ID,
			competitionID,
		); err != nil {
			return fmt.Errorf("error Select player_score: tenantID=%d, competitionID=%s, %w", tenant.ID, competitionID, err)
		}
		ranks := make([]CompetitionRank, 0, len(pss))
		scoredPlayerSet := make(map[string]struct{}, len(pss))
		for _, ps := range pss {
			// player_scoreが同一player_id内ではrow_numの降順でソートされているので
			// 現れたのが2回目以降のplayer_idはより大きいrow_numでスコアが出ているとみなせる
			if _, ok := scoredPlayerSet[ps.PlayerID]; ok {
				continue
			}
			scoredPlayerSet[ps.PlayerID] = struct{}{}
			p, err := retrievePlayer(ctx, tenantDB, ps.PlayerID)
			if err != nil {
				return fmt.Errorf("error retrievePlayer: %w", err)
			}
			ranks = append(ranks, CompetitionRank{
				Score:             ps.Score,
				PlayerID:          p.ID,
				PlayerDisplayName: p.DisplayName,
				RowNum:            ps.RowNum,
			})
		}
		sort.Slice(ranks, func(i, j int) bool {
			if ranks[i].Score == ranks[j].Score {
				return ranks[i].RowNum < ranks[j].RowNum
			}
			return ranks[i].Score > ranks[j].Score
		})
		pagedRanks := make([]CompetitionRank, 0, 100)
		for i, rank := range ranks {
			if int64(i) < rankAfter {
				continue
			}
			pagedRanks = append(pagedRanks, CompetitionRank{
				Rank:              int64(i + 1),
				Score:             rank.Score,
				PlayerID:          rank.PlayerID,
				PlayerDisplayName: rank.PlayerDisplayName,
			})
			if len(pagedRanks) >= 100 {
				break
			}
		}
	*/
	max := rankAfter + 100
	if max >= int64(len(pagedRanks)) {
		max = int64(len(pagedRanks))
	}
	res := SuccessResult{
		Status: true,
		Data: CompetitionRankingHandlerResult{
			Competition: CompetitionDetail{
				ID:         competition.ID,
				Title:      competition.Title,
				IsFinished: competition.FinishedAt.Valid,
			},
			Ranks: pagedRanks[rankAfter:max],
		},
	}
	return c.JSON(http.StatusOK, res)
}

type CompetitionsHandlerResult struct {
	Competitions []CompetitionDetail `json:"competitions"`
}

// 参加者向けAPI
// GET /api/player/competitions
// 大会の一覧を取得する
func playerCompetitionsHandler(c echo.Context) error {
	ctx := c.Request().Context()

	v, err := parseViewer(c)
	if err != nil {
		return err
	}
	if v.role != RolePlayer {
		return echo.NewHTTPError(http.StatusForbidden, "role player required")
	}
	if Proxy(c, v) {
		return nil
	}

	tenantDB, err := connectToTenantDB(v.tenantID)
	if err != nil {
		return err
	}
	defer tenantDB.Close()

	if err := authorizePlayer(ctx, tenantDB, v.playerID); err != nil {
		return err
	}
	return competitionsHandler(c, v, tenantDB)
}

// テナント管理者向けAPI
// GET /api/organizer/competitions
// 大会の一覧を取得する
func organizerCompetitionsHandler(c echo.Context) error {
	v, err := parseViewer(c)
	if err != nil {
		return err
	}
	if v.role != RoleOrganizer {
		return echo.NewHTTPError(http.StatusForbidden, "role organizer required")
	}
	if Proxy(c, v) {
		return nil
	}

	tenantDB, err := connectToTenantDB(v.tenantID)
	if err != nil {
		return err
	}
	defer tenantDB.Close()

	return competitionsHandler(c, v, tenantDB)
}

func competitionsHandler(c echo.Context, v *Viewer, tenantDB dbOrTx) error {
	ctx := c.Request().Context()

	cs := []CompetitionRow{}
	if err := tenantDB.SelectContext(
		ctx,
		&cs,
		"SELECT * FROM competition WHERE tenant_id=? ORDER BY created_at DESC",
		v.tenantID,
	); err != nil {
		return fmt.Errorf("error Select competition: %w", err)
	}
	cds := make([]CompetitionDetail, 0, len(cs))
	for _, comp := range cs {
		cds = append(cds, CompetitionDetail{
			ID:         comp.ID,
			Title:      comp.Title,
			IsFinished: comp.FinishedAt.Valid,
		})
	}

	res := SuccessResult{
		Status: true,
		Data: CompetitionsHandlerResult{
			Competitions: cds,
		},
	}
	return c.JSON(http.StatusOK, res)
}

type TenantDetail struct {
	Name        string `json:"name"`
	DisplayName string `json:"display_name"`
}

type MeHandlerResult struct {
	Tenant   *TenantDetail `json:"tenant"`
	Me       *PlayerDetail `json:"me"`
	Role     string        `json:"role"`
	LoggedIn bool          `json:"logged_in"`
}

// 共通API
// GET /api/me
// JWTで認証した結果、テナントやユーザ情報を返す
func meHandler(c echo.Context) error {
	tenant, err := retrieveTenantRowFromHeader(c)
	if err != nil {
		return fmt.Errorf("error retrieveTenantRowFromHeader: %w", err)
	}
	td := &TenantDetail{
		Name:        tenant.Name,
		DisplayName: tenant.DisplayName,
	}
	v, err := parseViewer(c)
	if err != nil {
		var he *echo.HTTPError
		if ok := errors.As(err, &he); ok && he.Code == http.StatusUnauthorized {
			return c.JSON(http.StatusOK, SuccessResult{
				Status: true,
				Data: MeHandlerResult{
					Tenant:   td,
					Me:       nil,
					Role:     RoleNone,
					LoggedIn: false,
				},
			})
		}
		return fmt.Errorf("error parseViewer: %w", err)
	}
	if v.role == RoleAdmin || v.role == RoleOrganizer {
		return c.JSON(http.StatusOK, SuccessResult{
			Status: true,
			Data: MeHandlerResult{
				Tenant:   td,
				Me:       nil,
				Role:     v.role,
				LoggedIn: true,
			},
		})
	}
	if Proxy(c, v) {
		return nil
	}

	tenantDB, err := connectToTenantDB(v.tenantID)
	if err != nil {
		return fmt.Errorf("error connectToTenantDB: %w", err)
	}
	ctx := c.Request().Context()
	p, err := retrievePlayer(ctx, tenantDB, v.playerID)
	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return c.JSON(http.StatusOK, SuccessResult{
				Status: true,
				Data: MeHandlerResult{
					Tenant:   td,
					Me:       nil,
					Role:     RoleNone,
					LoggedIn: false,
				},
			})
		}
		return fmt.Errorf("error retrievePlayer: %w", err)
	}

	return c.JSON(http.StatusOK, SuccessResult{
		Status: true,
		Data: MeHandlerResult{
			Tenant: td,
			Me: &PlayerDetail{
				ID:             p.ID,
				DisplayName:    p.DisplayName,
				IsDisqualified: p.IsDisqualified,
			},
			Role:     v.role,
			LoggedIn: true,
		},
	})
}

type InitializeHandlerResult struct {
	Lang string `json:"lang"`
}

// ベンチマーカー向けAPI
// POST /initialize
// ベンチマーカーが起動したときに最初に呼ぶ
// データベースの初期化などが実行されるため、スキーマを変更した場合などは適宜改変すること
func initializeHandler(c echo.Context) error {
	t.Start(time.Second*85, adminDB)
	out, err := exec.Command(initializeScript).CombinedOutput()
	if err != nil {
		return fmt.Errorf("error exec.Command: %s %e", string(out), err)
	}
	tenantIDCache = cache.New[int64, TenantRow](200)
	tenantNameCache = cache.New[string, TenantRow](200)

	rankingCache = cache.New[string, []CompetitionRank](1000)

	competitionCache = cache.New[string, CompetitionRow](1000)

	playerCache = cache.New[string, PlayerRow](10000)

	playerScoreCache = cache.New[string, []PlayerScoreRowPlayer](10000)

	{
		req, _ := http.NewRequestWithContext(c.Request().Context(), http.MethodPost, "http://192.168.0.12:3000/initialize2", nil)
		re, err := http.DefaultClient.Do(req)
		log.Print(err)
		io.ReadAll(re.Body)
		re.Body.Close()
	}
	{
		req, _ := http.NewRequestWithContext(c.Request().Context(), http.MethodPost, "http://192.168.0.13:3000/initialize2", nil)
		re, err := http.DefaultClient.Do(req)
		log.Print(err)
		io.ReadAll(re.Body)
		re.Body.Close()
	}
	ctx := c.Request().Context()
	ts := []TenantRow{}
	if err := adminDB.SelectContext(ctx, &ts, "SELECT * FROM tenant ORDER BY id DESC"); err != nil {
		return fmt.Errorf("error Select tenant: %w", err)
	}
	billings := make([]BillingRow, 0, len(ts)*10)
	for _, t := range ts {
		err := func(t TenantRow) error {
			tenantDB, err := connectToTenantDB(t.ID)
			if err != nil {
				return fmt.Errorf("failed to connectToTenantDB: %w", err)
			}
			defer tenantDB.Close()
			cs := []CompetitionRow{}
			if err := tenantDB.SelectContext(
				ctx,
				&cs,
				"SELECT * FROM competition WHERE tenant_id=?",
				t.ID,
			); err != nil {
				return fmt.Errorf("failed to Select competition: %w", err)
			}
			for _, comp := range cs {
				report, err := billingReportByCompetition(ctx, tenantDB, t.ID, &comp)
				if err != nil {
					return fmt.Errorf("failed to billingReportByCompetition: %w", err)
				}
				billings = append(billings, BillingRow{
					TenantID:      t.ID,
					CompetitionID: comp.ID,
					Player:        report.PlayerCount,
					Visitor:       report.VisitorCount,
					Yen:           report.BillingYen,
				})
			}
			return nil
		}(t)
		if err != nil {
			return err
		}
	}
	if _, err := adminDB.NamedExecContext(
		ctx,
		"INSERT INTO billing (tenant_id, competition_id, player, visitor, yen) VALUES (:tenant_id, :competition_id, :player, :visitor, :yen)",
		billings,
	); err != nil {
		return fmt.Errorf(
			"error Insert billing, %w",
			err,
		)
	}

	res := InitializeHandlerResult{
		Lang: "go",
	}
	return c.JSON(http.StatusOK, SuccessResult{Status: true, Data: res})
}

type BillingRow struct {
	TenantID      int64  `db:"tenant_id"`
	CompetitionID string `db:"competition_id"`
	Player        int64  `db:"player"`
	Visitor       int64  `db:"visitor"`
	Yen           int64  `db:"yen"`
}

func initializeHandler2(c echo.Context) error {
	t.Start(time.Second*85, adminDB)
	out, err := exec.Command(initializeScript).CombinedOutput()
	if err != nil {
		return fmt.Errorf("error exec.Command: %s %e", string(out), err)
	}
	tenantIDCache = cache.New[int64, TenantRow](200)
	tenantNameCache = cache.New[string, TenantRow](200)

	rankingCache = cache.New[string, []CompetitionRank](1000)

	competitionCache = cache.New[string, CompetitionRow](1000)

	playerCache = cache.New[string, PlayerRow](10000)

	playerScoreCache = cache.New[string, []PlayerScoreRowPlayer](10000)
	res := InitializeHandlerResult{
		Lang: "go",
	}
	return c.JSON(http.StatusOK, SuccessResult{Status: true, Data: res})
}

var tenantIDCache = cache.New[int64, TenantRow](200)
var tenantNameCache = cache.New[string, TenantRow](200)

var rankingCache = cache.New[string, []CompetitionRank](1000)

var competitionCache = cache.New[string, CompetitionRow](1000)

var playerCache = cache.New[string, PlayerRow](10000)

var playerScoreCache = cache.New[string, []PlayerScoreRowPlayer](10000)

var ownHost = getEnv("WOEKER_ADDR", "")

var tr = &http.Transport{
	DialContext: (&net.Dialer{
		Timeout:   60 * time.Second,
		KeepAlive: 60 * time.Second,
		DualStack: true,
	}).DialContext,
	ForceAttemptHTTP2:     true,
	TLSHandshakeTimeout:   10 * time.Second,
	ResponseHeaderTimeout: 10 * time.Second,
	ExpectContinueTimeout: 1 * time.Second,
	MaxIdleConns:          100,
	MaxIdleConnsPerHost:   100,
	IdleConnTimeout:       120 * time.Second,
}

func Proxy(c echo.Context, v *Viewer) bool {
	// 最初に 192.168.0.11 にリゥエストする
	// それ以外はプロキシ先なのでそのまま処理する
	if ownHost != "192.168.0.11" {
		return false
	}

	host := ""
	switch v.tenantID % 5 {
	case 1:
		return false
	case 2, 3, 4:
		host = "192.168.0.12:3000"
	case 0:
		host = "192.168.0.13:3000"
	}
	rp := &httputil.ReverseProxy{
		Director: func(req *http.Request) {
			req.URL.Scheme = "http"
			req.URL.Host = host

			if _, ok := req.Header["User-Agent"]; !ok {
				// explicitly disable User-Agent so it's not set to default value
				req.Header.Set("User-Agent", "")
			}

			req.Header.Set("Viewer", v.String())
		},
		Transport: tr,
		ModifyResponse: func(res *http.Response) error {
			res.Header.Del("Viewer")
			return nil
		},
	}
	rp.ServeHTTP(c.Response(), c.Request())
	return true
}
