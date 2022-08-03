SELECT * FROM tenant ORDER BY id DESC -- SELECT * FROM tenant ORDER BY id DESC
no warning
SELECT * FROM competition WHERE tenant_id=100 -- SELECT * FROM competition WHERE tenant_id=?
SELECT player_id, created_at AS min_created_at FROM visit_history_2 WHERE tenant_id = 100 AND competition_id = '2ba330394' -- SELECT player_id, created_at AS min_created_at FROM visit_history_2 WHERE tenant_id = ? AND competition_id = ?
no warning
SELECT DISTINCT(player_id) FROM player_score WHERE tenant_id = 100 AND competition_id = '2ba330394' -- SELECT DISTINCT(player_id) FROM player_score WHERE tenant_id = ? AND competition_id = ?
INSERT INTO billing (tenant_id, competition_id, player, visitor, yen) VALUES (?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?
too long query

INSERT INTO tenant (name, display_name, created_at, updated_at) VALUES ('ucpz-tx-1659537924', '魔法のようなすもも組合', 1659537924, 1659537924) -- INSERT INTO tenant (name, display_name, created_at, updated_at) VALUES (?, ?, ?, ?)

SELECT * FROM tenant WHERE name = 'ucpz-tx-1659537924' -- SELECT * FROM tenant WHERE name = ?
no warning
SELECT tenant.id, tenant.name, tenant.display_name, y.yen
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
		WHERE id < 28 ORDER BY id DESC LIMIT 10 -- SELECT tenant.id, tenant.name, tenant.display_name, y.yen
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
		WHERE id < ? ORDER BY id DESC LIMIT 10
no warning
SELECT * FROM player WHERE tenant_id=5080 ORDER BY created_at DESC -- SELECT * FROM player WHERE tenant_id=? ORDER BY created_at DESC
INSERT INTO competition (id, tenant_id, title, finished_at, created_at, updated_at) VALUES ('e81ce7dd-133a-11ed-b2da-0ac90d535923', 5080, 'validate_competition', <nil>, 1659537924, 1659537924) -- INSERT INTO competition (id, tenant_id, title, finished_at, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?)

UPDATE player SET is_disqualified = true, updated_at = 1659537924 WHERE id = 'e81a2b2e-133a-11ed-b2da-0ac90d535923' -- UPDATE player SET is_disqualified = ?, updated_at = ? WHERE id = ?
DELETE FROM player_score WHERE tenant_id = 5080 AND competition_id = 'e81ce7dd-133a-11ed-b2da-0ac90d535923' -- DELETE FROM player_score WHERE tenant_id = ? AND competition_id = ?
INSERT INTO player_score (id, tenant_id, player_id, competition_id, score, row_num, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, 
too long query

SELECT * FROM player WHERE id = '0000000000' -- SELECT * FROM player WHERE id = ?
SELECT * FROM competition WHERE id = '0000000000' -- SELECT * FROM competition WHERE id = ?
INSERT IGNORE INTO visit_history_2 (player_id, tenant_id, competition_id, created_at, updated_at) VALUES ('e81a1425-133a-11ed-b2da-0ac90d535923',5080,'e81ce7dd-133a-11ed-b2da-0ac90d535923',1659537924,1659537924),('e81a1425-133a-11ed-b2da-0ac90d535923',5080,'e81ce7dd-133a-11ed-b2da-0ac90d535923',1659537924,1659537924),('e81a1425-133a-11ed-b2da-0ac90d535923',5080,'e81ce7dd-133a-11ed-b2da-0ac90d535923',1659537924,1659537924),('e81a1425-133a-11ed-b2da-0ac90d535923',5080,'e81ce7dd-133a-11ed-b2da-0ac90d535923',1659537924,1659537924),('e81a1425-133a-11ed-b2da-0ac90d535923',5080,'e81ce7dd-133a-11ed-b2da-0ac90d535923',1659537924,1659537924),('e81a1425-133a-11ed-b2da-0ac90d535923',5080,'e81ce7dd-133a-11ed-b2da-0ac90d535923',1659537924,1659537924),('e81a1425-133a-11ed-b2da-0ac90d535923',5080,'e81ce7dd-133a-11ed-b2da-0ac90d535923',1659537924,1659537924),('e81a1425-133a-11ed-b2da-0ac90d535923',5080,'e81ce7dd-133a-11ed-b2da-0ac90d535923',1659537924,1659537924),('e81a1425-133a-11ed-b2da-0ac90d535923',5080,'e81ce7dd-133a-11ed-b2da-0ac90d535923',1659537924,1659537924) -- INSERT IGNORE INTO visit_history_2 (player_id, tenant_id, competition_id, created_at, updated_at) VALUES (?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?)

UPDATE competition SET finished_at = 1659537924, updated_at = 1659537924 WHERE id = 'e8255873-133a-11ed-b2da-0ac90d535923' -- UPDATE competition SET finished_at = ?, updated_at = ? WHERE id = ?
INSERT INTO billing (tenant_id, competition_id, player, visitor, yen) VALUES (5082, 'e8255873-133a-11ed-b2da-0ac90d535923', 0, 0, 0) -- INSERT INTO billing (tenant_id, competition_id, player, visitor, yen) VALUES (?, ?, ?, ?, ?)

SELECT * FROM competition WHERE tenant_id=5080 ORDER BY created_at DESC -- SELECT * FROM competition WHERE tenant_id=? ORDER BY created_at DESC
SELECT * FROM billing WHERE tenant_id=5080 -- SELECT * FROM billing WHERE tenant_id=?
no warning
SELECT tenant.id, tenant.name, tenant.display_name, y.yen
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
		ORDER BY id DESC LIMIT 10 -- SELECT tenant.id, tenant.name, tenant.display_name, y.yen
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
		ORDER BY id DESC LIMIT 10
no warning
SELECT player_score.*, display_name FROM player_score INNER JOIN (
			SELECT player_id, max(row_num) AS row_num FROM player_score WHERE tenant_id = 25 AND competition_id = '410bf4665' GROUP BY player_id
		) AS c ON (
			player_score.player_id = c.player_id
			AND player_score.row_num = c.row_num
			AND player_score.tenant_id = 25 AND player_score.competition_id = '410bf4665'
		)
		INNER JOIN player ON (
			player.id = player_score.player_id
		)
		ORDER BY player_score.score DESC, player_score.row_num ASC
		 -- SELECT player_score.*, display_name FROM player_score INNER JOIN (
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
		
SELECT player_score.score, competition.title, competition.created_at, competition.id FROM player_score INNER JOIN (
				SELECT competition_id, max(row_num) AS row_num FROM player_score WHERE tenant_id = 25 AND player_id = '33c221b6c' GROUP BY competition_id
			) AS c ON (
				player_score.row_num = c.row_num
				AND player_score.competition_id = c.competition_id
				AND player_score.tenant_id = 25 AND player_score.player_id = '33c221b6c'
			)
			INNER JOIN competition ON (
				competition.id = player_score.competition_id
			)
			ORDER BY competition.created_at ASC
			 -- SELECT player_score.score, competition.title, competition.created_at, competition.id FROM player_score INNER JOIN (
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
			
