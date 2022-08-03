INSERT INTO competition (id, tenant_id, title, finished_at, created_at, updated_at) VALUES ('ac08bc96-1333-11ed-a952-0aa59cf41f83', 4687, '渋谷.go杯', <nil>, 1659534816, 1659534816) -- INSERT INTO competition (id, tenant_id, title, finished_at, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?)

DELETE FROM player_score WHERE tenant_id = 4687 AND competition_id = 'ac08bc96-1333-11ed-a952-0aa59cf41f83' -- DELETE FROM player_score WHERE tenant_id = ? AND competition_id = ?
INSERT INTO player_score (id, tenant_id, player_id, competition_id, score, row_num, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, 
too long query

SELECT * FROM tenant WHERE id = 4687 -- SELECT * FROM tenant WHERE id = ?
no warning
SELECT
				GROUP_CONCAT(player_score.score) AS scores,
				GROUP_CONCAT(competition.title) AS titles,
				GROUP_CONCAT(competition.created_at) AS created_ats,
				GROUP_CONCAT(competition.id) AS ids
			FROM player_score INNER JOIN (
				SELECT competition_id, max(row_num) AS row_num FROM player_score WHERE tenant_id = 4687 AND player_id = 'ac09d9d0-1333-11ed-a952-0aa59cf41f83' GROUP BY competition_id
			) AS c ON (
				player_score.row_num = c.row_num
				AND player_score.competition_id = c.competition_id
				AND player_score.tenant_id = 4687 AND player_score.player_id = 'ac09d9d0-1333-11ed-a952-0aa59cf41f83'
			)
			INNER JOIN competition ON (
				competition.id = player_score.competition_id
			)
			GROUP BY player_score.player_id
			 -- SELECT
				GROUP_CONCAT(player_score.score) AS scores,
				GROUP_CONCAT(competition.title) AS titles,
				GROUP_CONCAT(competition.created_at) AS created_ats,
				GROUP_CONCAT(competition.id) AS ids
			FROM player_score INNER JOIN (
				SELECT competition_id, max(row_num) AS row_num FROM player_score WHERE tenant_id = ? AND player_id = ? GROUP BY competition_id
			) AS c ON (
				player_score.row_num = c.row_num
				AND player_score.competition_id = c.competition_id
				AND player_score.tenant_id = ? AND player_score.player_id = ?
			)
			INNER JOIN competition ON (
				competition.id = player_score.competition_id
			)
			GROUP BY player_score.player_id
			
INSERT IGNORE INTO visit_history_2 (player_id, tenant_id, competition_id, created_at, updated_at) VALUES ('ac09d3df-1333-11ed-a952-0aa59cf41f83',4687,'ac08bc96-1333-11ed-a952-0aa59cf41f83',1659534816,1659534816),('ac09d3df-1333-11ed-a952-0aa59cf41f83',4687,'ac08bc96-1333-11ed-a952-0aa59cf41f83',1659534816,1659534816),('ac09d3df-1333-11ed-a952-0aa59cf41f83',4687,'ac08bc96-1333-11ed-a952-0aa59cf41f83',1659534816,1659534816),('ac09d3df-1333-11ed-a952-0aa59cf41f83',4687,'ac08bc96-1333-11ed-a952-0aa59cf41f83',1659534816,1659534816) -- INSERT IGNORE INTO visit_history_2 (player_id, tenant_id, competition_id, created_at, updated_at) VALUES (?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?)

SELECT * FROM player WHERE id = '0000000000' -- SELECT * FROM player WHERE id = ?
SELECT * FROM player WHERE tenant_id=72 ORDER BY created_at DESC -- SELECT * FROM player WHERE tenant_id=? ORDER BY created_at DESC
SELECT * FROM competition WHERE tenant_id=24 ORDER BY created_at DESC -- SELECT * FROM competition WHERE tenant_id=? ORDER BY created_at DESC
SELECT * FROM competition WHERE id = '2ebdf1447' -- SELECT * FROM competition WHERE id = ?
SELECT player_score.*, display_name FROM player_score INNER JOIN (
			SELECT player_id, max(row_num) AS row_num FROM player_score WHERE tenant_id = 24 AND competition_id = '2ebdf1447' GROUP BY player_id
		) AS c ON (
			player_score.player_id = c.player_id
			AND player_score.row_num = c.row_num
			AND player_score.tenant_id = 24 AND player_score.competition_id = '2ebdf1447'
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
		
UPDATE player SET is_disqualified = true, updated_at = 1659534820 WHERE id = '614491e6c' -- UPDATE player SET is_disqualified = ?, updated_at = ? WHERE id = ?
UPDATE competition SET finished_at = 1659534820, updated_at = 1659534820 WHERE id = 'ade16157-1333-11ed-a952-0aa59cf41f83' -- UPDATE competition SET finished_at = ?, updated_at = ? WHERE id = ?
SELECT player_id, created_at AS min_created_at FROM visit_history_2 WHERE tenant_id = 72 AND competition_id = 'ade16157-1333-11ed-a952-0aa59cf41f83' -- SELECT player_id, created_at AS min_created_at FROM visit_history_2 WHERE tenant_id = ? AND competition_id = ?
no warning
SELECT DISTINCT(player_id) FROM player_score WHERE tenant_id = 72 AND competition_id = 'ade16157-1333-11ed-a952-0aa59cf41f83' -- SELECT DISTINCT(player_id) FROM player_score WHERE tenant_id = ? AND competition_id = ?
INSERT INTO billing (tenant_id, competition_id, player, visitor, yen) VALUES (72, 'ade16157-1333-11ed-a952-0aa59cf41f83', 61, 0, 6100) -- INSERT INTO billing (tenant_id, competition_id, player, visitor, yen) VALUES (?, ?, ?, ?, ?)

SELECT * FROM billing WHERE tenant_id=24 -- SELECT * FROM billing WHERE tenant_id=?
no warning
