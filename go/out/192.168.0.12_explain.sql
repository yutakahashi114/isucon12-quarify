UPDATE player SET is_disqualified = true, updated_at = 1659435539 WHERE id = '0000000000' -- UPDATE player SET is_disqualified = ?, updated_at = ? WHERE id = ?
SELECT * FROM player WHERE id = '0000000000' -- SELECT * FROM player WHERE id = ?
INSERT INTO competition (id, tenant_id, title, finished_at, created_at, updated_at) VALUES ('8619889b-124c-11ed-8110-0aa59cf41f83', 3572, 'びわシステム大会', <nil>, 1659435539, 1659435539) -- INSERT INTO competition (id, tenant_id, title, finished_at, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?)

SELECT * FROM competition WHERE id = '0000000000' -- SELECT * FROM competition WHERE id = ?
UPDATE competition SET finished_at = 1659435539, updated_at = 1659435539 WHERE id = '8619889b-124c-11ed-8110-0aa59cf41f83' -- UPDATE competition SET finished_at = ?, updated_at = ? WHERE id = ?
SELECT player_id, created_at AS min_created_at FROM visit_history_2 WHERE tenant_id = 3572 AND competition_id = '8619889b-124c-11ed-8110-0aa59cf41f83' -- SELECT player_id, created_at AS min_created_at FROM visit_history_2 WHERE tenant_id = ? AND competition_id = ?
no warning
SELECT DISTINCT(player_id) FROM player_score WHERE tenant_id = 3572 AND competition_id = '8619889b-124c-11ed-8110-0aa59cf41f83' -- SELECT DISTINCT(player_id) FROM player_score WHERE tenant_id = ? AND competition_id = ?
INSERT INTO billing (tenant_id, competition_id, player, visitor, yen) VALUES (3572, '8619889b-124c-11ed-8110-0aa59cf41f83', 0, 0, 0) -- INSERT INTO billing (tenant_id, competition_id, player, visitor, yen) VALUES (?, ?, ?, ?, ?)

SELECT * FROM player WHERE tenant_id=27 ORDER BY created_at DESC -- SELECT * FROM player WHERE tenant_id=? ORDER BY created_at DESC
DELETE FROM player_score WHERE tenant_id = 27 AND competition_id = '87f24f7e-124c-11ed-8110-0aa59cf41f83' -- DELETE FROM player_score WHERE tenant_id = ? AND competition_id = ?
INSERT INTO player_score (id, tenant_id, player_id, competition_id, score, row_num, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, 
too long query

SELECT * FROM tenant WHERE id = 27 -- SELECT * FROM tenant WHERE id = ?
no warning
SELECT player_score.*, display_name FROM player_score INNER JOIN (
			SELECT player_id, max(row_num) AS row_num FROM player_score WHERE tenant_id = 27 AND competition_id = '87f24f7e-124c-11ed-8110-0aa59cf41f83' GROUP BY player_id
		) AS c ON (
			player_score.player_id = c.player_id
			AND player_score.row_num = c.row_num
			AND player_score.tenant_id = 27 AND player_score.competition_id = '87f24f7e-124c-11ed-8110-0aa59cf41f83'
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
		
SELECT * FROM competition WHERE tenant_id=27 ORDER BY created_at DESC -- SELECT * FROM competition WHERE tenant_id=? ORDER BY created_at DESC
SELECT player_score.score, competition.title, competition.created_at, competition.id FROM player_score INNER JOIN (
				SELECT competition_id, max(row_num) AS row_num FROM player_score WHERE tenant_id = 27 AND player_id = '510489a57' GROUP BY competition_id
			) AS c ON (
				player_score.row_num = c.row_num
				AND player_score.competition_id = c.competition_id
				AND player_score.tenant_id = 27 AND player_score.player_id = '510489a57'
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
			
INSERT IGNORE INTO visit_history_2 (player_id, tenant_id, competition_id, created_at, updated_at) VALUES ('ddab48c3',27,'87f24f7e-124c-11ed-8110-0aa59cf41f83',1659435542,1659435542),('27aaa3698',27,'87f24f7e-124c-11ed-8110-0aa59cf41f83',1659435542,1659435542),('520a0690e',27,'87f24f7e-124c-11ed-8110-0aa59cf41f83',1659435542,1659435542),('2b319d877',27,'87f24f7e-124c-11ed-8110-0aa59cf41f83',1659435542,1659435542),('42f8144d3',27,'87f24f7e-124c-11ed-8110-0aa59cf41f83',1659435542,1659435542),('420ffe3d0',27,'87f24f7e-124c-11ed-8110-0aa59cf41f83',1659435542,1659435542) -- INSERT IGNORE INTO visit_history_2 (player_id, tenant_id, competition_id, created_at, updated_at) VALUES (?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?)

SELECT * FROM billing WHERE tenant_id=27 -- SELECT * FROM billing WHERE tenant_id=?
no warning
