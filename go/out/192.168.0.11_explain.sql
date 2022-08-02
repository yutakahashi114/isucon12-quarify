SELECT * FROM tenant ORDER BY id DESC -- SELECT * FROM tenant ORDER BY id DESC
no warning
SELECT * FROM competition WHERE tenant_id=100 -- SELECT * FROM competition WHERE tenant_id=?
SELECT player_id, created_at AS min_created_at FROM visit_history_2 WHERE tenant_id = 100 AND competition_id = '2ba330394' -- SELECT player_id, created_at AS min_created_at FROM visit_history_2 WHERE tenant_id = ? AND competition_id = ?
no warning
SELECT DISTINCT(player_id) FROM player_score WHERE tenant_id = 100 AND competition_id = '2ba330394' -- SELECT DISTINCT(player_id) FROM player_score WHERE tenant_id = ? AND competition_id = ?
INSERT INTO billing (tenant_id, competition_id, player, visitor, yen) VALUES (?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?
too long query

INSERT INTO tenant (name, display_name, created_at, updated_at) VALUES ('rbcue-t-1659442320', 'よくわかるサッカー株式会社', 1659442320, 1659442320) -- INSERT INTO tenant (name, display_name, created_at, updated_at) VALUES (?, ?, ?, ?)

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
		WHERE id < 20 ORDER BY id DESC LIMIT 10 -- SELECT tenant.id, tenant.name, tenant.display_name, y.yen
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
SELECT * FROM tenant WHERE name = 'rbcue-t-1659442320' -- SELECT * FROM tenant WHERE name = ?
no warning
SELECT * FROM player WHERE id = '0000000000' -- SELECT * FROM player WHERE id = ?
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
SELECT * FROM player WHERE tenant_id=81 ORDER BY created_at DESC -- SELECT * FROM player WHERE tenant_id=? ORDER BY created_at DESC
INSERT INTO competition (id, tenant_id, title, finished_at, created_at, updated_at) VALUES ('52427b93-125c-11ed-9c58-0ac90d535923', 81, 'ラーメンエンジニア #4', <nil>, 1659442324, 1659442324) -- INSERT INTO competition (id, tenant_id, title, finished_at, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?)

DELETE FROM player_score WHERE tenant_id = 81 AND competition_id = '52427b93-125c-11ed-9c58-0ac90d535923' -- DELETE FROM player_score WHERE tenant_id = ? AND competition_id = ?
INSERT INTO player_score (id, tenant_id, player_id, competition_id, score, row_num, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, 
too long query

SELECT player_score.score, competition.title, competition.created_at, competition.id FROM player_score INNER JOIN (
				SELECT competition_id, max(row_num) AS row_num FROM player_score WHERE tenant_id = 81 AND player_id = '62f67de45' GROUP BY competition_id
			) AS c ON (
				player_score.row_num = c.row_num
				AND player_score.competition_id = c.competition_id
				AND player_score.tenant_id = 81 AND player_score.player_id = '62f67de45'
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
			
SELECT * FROM competition WHERE tenant_id=81 ORDER BY created_at DESC -- SELECT * FROM competition WHERE tenant_id=? ORDER BY created_at DESC
UPDATE player SET is_disqualified = true, updated_at = 1659442324 WHERE id = '62855defe' -- UPDATE player SET is_disqualified = ?, updated_at = ? WHERE id = ?
UPDATE competition SET finished_at = 1659442324, updated_at = 1659442324 WHERE id = '52427b93-125c-11ed-9c58-0ac90d535923' -- UPDATE competition SET finished_at = ?, updated_at = ? WHERE id = ?
SELECT player_score.*, display_name FROM player_score INNER JOIN (
			SELECT player_id, max(row_num) AS row_num FROM player_score WHERE tenant_id = 4041 AND competition_id = '529f0534-125c-11ed-9c58-0ac90d535923' GROUP BY player_id
		) AS c ON (
			player_score.player_id = c.player_id
			AND player_score.row_num = c.row_num
			AND player_score.tenant_id = 4041 AND player_score.competition_id = '529f0534-125c-11ed-9c58-0ac90d535923'
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
		
INSERT IGNORE INTO visit_history_2 (player_id, tenant_id, competition_id, created_at, updated_at) VALUES ('62f67de45',81,'52427b93-125c-11ed-9c58-0ac90d535923',1659442324,1659442324),('62855defe',81,'52427b93-125c-11ed-9c58-0ac90d535923',1659442324,1659442324),('62f67de45',81,'52427b93-125c-11ed-9c58-0ac90d535923',1659442324,1659442324),('5273a7c3-125c-11ed-9c58-0ac90d535923',4036,'5275f601-125c-11ed-9c58-0ac90d535923',1659442324,1659442324),('5273b55e-125c-11ed-9c58-0ac90d535923',4036,'5275f601-125c-11ed-9c58-0ac90d535923',1659442324,1659442324),('5273ba1c-125c-11ed-9c58-0ac90d535923',4036,'5275f601-125c-11ed-9c58-0ac90d535923',1659442324,1659442324),('5273b22e-125c-11ed-9c58-0ac90d535923',4036,'5275f601-125c-11ed-9c58-0ac90d535923',1659442324,1659442324),('5273b777-125c-11ed-9c58-0ac90d535923',4036,'5275f601-125c-11ed-9c58-0ac90d535923',1659442324,1659442324),('5273bd3c-125c-11ed-9c58-0ac90d535923',4036,'5275f601-125c-11ed-9c58-0ac90d535923',1659442324,1659442324),('5273a860-125c-11ed-9c58-0ac90d535923',4036,'5275f601-125c-11ed-9c58-0ac90d535923',1659442324,1659442324),('5273a82f-125c-11ed-9c58-0ac90d535923',4036,'5275f601-125c-11ed-9c58-0ac90d535923',1659442324,1659442324),('5273a774-125c-11ed-9c58-0ac90d535923',4036,'5275f601-125c-11ed-9c58-0ac90d535923',1659442324,1659442324),('5273a7fb-125c-11ed-9c58-0ac90d535923',4036,'5275f601-125c-11ed-9c58-0ac90d535923',1659442324,1659442324),('5273a70d-125c-11ed-9c58-0ac90d535923',4036,'5275f601-125c-11ed-9c58-0ac90d535923',1659442324,1659442324),('5273a774-125c-11ed-9c58-0ac90d535923',4036,'5275f601-125c-11ed-9c58-0ac90d535923',1659442324,1659442324),('529d2bc3-125c-11ed-9c58-0ac90d535923',4041,'529f0534-125c-11ed-9c58-0ac90d535923',1659442325,1659442325),('529d2a25-125c-11ed-9c58-0ac90d535923',4041,'529f0534-125c-11ed-9c58-0ac90d535923',1659442325,1659442325),('529d3336-125c-11ed-9c58-0ac90d535923',4041,'529f0534-125c-11ed-9c58-0ac90d535923',1659442325,1659442325),('529d2b9c-125c-11ed-9c58-0ac90d535923',4041,'529f0534-125c-11ed-9c58-0ac90d535923',1659442325,1659442325),('529d28a4-125c-11ed-9c58-0ac90d535923',4041,'529f0534-125c-11ed-9c58-0ac90d535923',1659442325,1659442325),('529d2e2f-125c-11ed-9c58-0ac90d535923',4041,'529f0534-125c-11ed-9c58-0ac90d535923',1659442325,1659442325),('529d28e1-125c-11ed-9c58-0ac90d535923',4041,'529f0534-125c-11ed-9c58-0ac90d535923',1659442325,1659442325),('529d2935-125c-11ed-9c58-0ac90d535923',4041,'529f0534-125c-11ed-9c58-0ac90d535923',1659442325,1659442325),('529d28ff-125c-11ed-9c58-0ac90d535923',4041,'529f0534-125c-11ed-9c58-0ac90d535923',1659442325,1659442325),('529d2918-125c-11ed-9c58-0ac90d535923',4041,'529f0534-125c-11ed-9c58-0ac90d535923',1659442325,1659442325),('529d291c-125c-11ed-9c58-0ac90d535923',4041,'529f0534-125c-11ed-9c58-0ac90d535923',1659442325,1659442325) -- INSERT IGNORE INTO visit_history_2 (player_id, tenant_id, competition_id, created_at, updated_at) VALUES (?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?)

INSERT INTO billing (tenant_id, competition_id, player, visitor, yen) VALUES (81, '52427b93-125c-11ed-9c58-0ac90d535923', 100, 0, 10000) -- INSERT INTO billing (tenant_id, competition_id, player, visitor, yen) VALUES (?, ?, ?, ?, ?)

SELECT * FROM billing WHERE tenant_id=4041 -- SELECT * FROM billing WHERE tenant_id=?
no warning
