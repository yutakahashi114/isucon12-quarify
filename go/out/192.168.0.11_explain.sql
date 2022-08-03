SELECT * FROM tenant ORDER BY id DESC -- SELECT * FROM tenant ORDER BY id DESC
no warning
SELECT * FROM competition WHERE tenant_id=100 -- SELECT * FROM competition WHERE tenant_id=?
SELECT player_id, created_at AS min_created_at FROM visit_history_2 WHERE tenant_id = 100 AND competition_id = '2ba330394' -- SELECT player_id, created_at AS min_created_at FROM visit_history_2 WHERE tenant_id = ? AND competition_id = ?
no warning
SELECT DISTINCT(player_id) FROM player_score WHERE tenant_id = 100 AND competition_id = '2ba330394' -- SELECT DISTINCT(player_id) FROM player_score WHERE tenant_id = ? AND competition_id = ?
INSERT INTO billing (tenant_id, competition_id, player, visitor, yen) VALUES (?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?, ?),(?, ?, ?, ?
too long query

INSERT INTO tenant (name, display_name, created_at, updated_at) VALUES ('m-gnhk-1659534320', 'ビールバトル', 1659534320, 1659534320) -- INSERT INTO tenant (name, display_name, created_at, updated_at) VALUES (?, ?, ?, ?)

SELECT * FROM tenant WHERE name = 'm-gnhk-1659534320' -- SELECT * FROM tenant WHERE name = ?
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
		WHERE id < 21 ORDER BY id DESC LIMIT 10 -- SELECT tenant.id, tenant.name, tenant.display_name, y.yen
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
SELECT * FROM player WHERE tenant_id=1 ORDER BY created_at DESC -- SELECT * FROM player WHERE tenant_id=? ORDER BY created_at DESC
INSERT INTO competition (id, tenant_id, title, finished_at, created_at, updated_at) VALUES ('864a5885-1332-11ed-8e72-0ac90d535923', 4606, 'やわやわアワビ.dev #7', <nil>, 1659534324, 1659534324) -- INSERT INTO competition (id, tenant_id, title, finished_at, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?)

DELETE FROM player_score WHERE tenant_id = 4606 AND competition_id = '864a5885-1332-11ed-8e72-0ac90d535923' -- DELETE FROM player_score WHERE tenant_id = ? AND competition_id = ?
INSERT INTO player_score (id, tenant_id, player_id, competition_id, score, row_num, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, 
too long query

SELECT player_score.*, display_name FROM player_score INNER JOIN (
			SELECT player_id, max(row_num) AS row_num FROM player_score WHERE tenant_id = 4606 AND competition_id = '864a5885-1332-11ed-8e72-0ac90d535923' GROUP BY player_id
		) AS c ON (
			player_score.player_id = c.player_id
			AND player_score.row_num = c.row_num
			AND player_score.tenant_id = 4606 AND player_score.competition_id = '864a5885-1332-11ed-8e72-0ac90d535923'
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
		
SELECT * FROM competition WHERE tenant_id=4606 ORDER BY created_at DESC -- SELECT * FROM competition WHERE tenant_id=? ORDER BY created_at DESC
SELECT player_score.score, competition.title, competition.created_at, competition.id FROM player_score INNER JOIN (
				SELECT competition_id, max(row_num) AS row_num FROM player_score WHERE tenant_id = 4606 AND player_id = '864863a5-1332-11ed-8e72-0ac90d535923' GROUP BY competition_id
			) AS c ON (
				player_score.row_num = c.row_num
				AND player_score.competition_id = c.competition_id
				AND player_score.tenant_id = 4606 AND player_score.player_id = '864863a5-1332-11ed-8e72-0ac90d535923'
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
			
INSERT IGNORE INTO visit_history_2 (player_id, tenant_id, competition_id, created_at, updated_at) VALUES ('864864f2-1332-11ed-8e72-0ac90d535923',4606,'864a5885-1332-11ed-8e72-0ac90d535923',1659534324,1659534324),('864863ad-1332-11ed-8e72-0ac90d535923',4606,'864a5885-1332-11ed-8e72-0ac90d535923',1659534324,1659534324),('864863b1-1332-11ed-8e72-0ac90d535923',4606,'864a5885-1332-11ed-8e72-0ac90d535923',1659534324,1659534324),('86486295-1332-11ed-8e72-0ac90d535923',4606,'864a5885-1332-11ed-8e72-0ac90d535923',1659534324,1659534324),('864864a7-1332-11ed-8e72-0ac90d535923',4606,'864a5885-1332-11ed-8e72-0ac90d535923',1659534324,1659534324),('86486253-1332-11ed-8e72-0ac90d535923',4606,'864a5885-1332-11ed-8e72-0ac90d535923',1659534324,1659534324),('8648624b-1332-11ed-8e72-0ac90d535923',4606,'864a5885-1332-11ed-8e72-0ac90d535923',1659534324,1659534324),('86486258-1332-11ed-8e72-0ac90d535923',4606,'864a5885-1332-11ed-8e72-0ac90d535923',1659534324,1659534324),('86486247-1332-11ed-8e72-0ac90d535923',4606,'864a5885-1332-11ed-8e72-0ac90d535923',1659534324,1659534324),('86486250-1332-11ed-8e72-0ac90d535923',4606,'864a5885-1332-11ed-8e72-0ac90d535923',1659534324,1659534324),('86486250-1332-11ed-8e72-0ac90d535923',4606,'864a5885-1332-11ed-8e72-0ac90d535923',1659534324,1659534324),('86486238-1332-11ed-8e72-0ac90d535923',4606,'864a5885-1332-11ed-8e72-0ac90d535923',1659534324,1659534324) -- INSERT IGNORE INTO visit_history_2 (player_id, tenant_id, competition_id, created_at, updated_at) VALUES (?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?)

UPDATE competition SET finished_at = 1659534325, updated_at = 1659534325 WHERE id = '864a5885-1332-11ed-8e72-0ac90d535923' -- UPDATE competition SET finished_at = ?, updated_at = ? WHERE id = ?
INSERT INTO billing (tenant_id, competition_id, player, visitor, yen) VALUES (4606, '864a5885-1332-11ed-8e72-0ac90d535923', 200, 0, 20000) -- INSERT INTO billing (tenant_id, competition_id, player, visitor, yen) VALUES (?, ?, ?, ?, ?)

SELECT * FROM billing WHERE tenant_id=4606 -- SELECT * FROM billing WHERE tenant_id=?
no warning
UPDATE player SET is_disqualified = true, updated_at = 1659534339 WHERE id = '5c9c7c90b' -- UPDATE player SET is_disqualified = ?, updated_at = ? WHERE id = ?
