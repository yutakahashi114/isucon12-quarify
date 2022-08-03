SELECT * FROM player WHERE tenant_id=4763 ORDER BY created_at DESC -- SELECT * FROM player WHERE tenant_id=? ORDER BY created_at DESC
INSERT INTO competition (id, tenant_id, title, finished_at, created_at, updated_at) VALUES ('7c7fc20e-1335-11ed-97a1-0aa59cf41f83', 4763, 'validate_competition', <nil>, 1659535596, 1659535596) -- INSERT INTO competition (id, tenant_id, title, finished_at, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?)

UPDATE player SET is_disqualified = true, updated_at = 1659535596 WHERE id = '7c7d7a85-1335-11ed-97a1-0aa59cf41f83' -- UPDATE player SET is_disqualified = ?, updated_at = ? WHERE id = ?
DELETE FROM player_score WHERE tenant_id = 4763 AND competition_id = '7c7fc20e-1335-11ed-97a1-0aa59cf41f83' -- DELETE FROM player_score WHERE tenant_id = ? AND competition_id = ?
INSERT INTO player_score (id, tenant_id, player_id, competition_id, score, row_num, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, 
too long query

SELECT * FROM tenant WHERE id = 4763 -- SELECT * FROM tenant WHERE id = ?
no warning
INSERT IGNORE INTO visit_history_2 (player_id, tenant_id, competition_id, created_at, updated_at) VALUES ('7c7d5e45-1335-11ed-97a1-0aa59cf41f83',4763,'7c7fc20e-1335-11ed-97a1-0aa59cf41f83',1659535596,1659535596),('7c7d5e45-1335-11ed-97a1-0aa59cf41f83',4763,'7c7fc20e-1335-11ed-97a1-0aa59cf41f83',1659535596,1659535596),('7c7d5e45-1335-11ed-97a1-0aa59cf41f83',4763,'7c7fc20e-1335-11ed-97a1-0aa59cf41f83',1659535596,1659535596),('7c7d5e45-1335-11ed-97a1-0aa59cf41f83',4763,'7c7fc20e-1335-11ed-97a1-0aa59cf41f83',1659535596,1659535596),('7c7d5e45-1335-11ed-97a1-0aa59cf41f83',4763,'7c7fc20e-1335-11ed-97a1-0aa59cf41f83',1659535596,1659535596),('7c7d5e45-1335-11ed-97a1-0aa59cf41f83',4763,'7c7fc20e-1335-11ed-97a1-0aa59cf41f83',1659535596,1659535596),('7c7d5e45-1335-11ed-97a1-0aa59cf41f83',4763,'7c7fc20e-1335-11ed-97a1-0aa59cf41f83',1659535596,1659535596),('7c7d5e45-1335-11ed-97a1-0aa59cf41f83',4763,'7c7fc20e-1335-11ed-97a1-0aa59cf41f83',1659535596,1659535596),('7c7d5e45-1335-11ed-97a1-0aa59cf41f83',4763,'7c7fc20e-1335-11ed-97a1-0aa59cf41f83',1659535596,1659535596),('7c7d7ad3-1335-11ed-97a1-0aa59cf41f83',4763,'7c7fc20e-1335-11ed-97a1-0aa59cf41f83',1659535596,1659535596),('7c85cdd3-1335-11ed-97a1-0aa59cf41f83',4764,'7c84970b-1335-11ed-97a1-0aa59cf41f83',1659535596,1659535596),('7c85cdd3-1335-11ed-97a1-0aa59cf41f83',4764,'7c84970b-1335-11ed-97a1-0aa59cf41f83',1659535596,1659535596) -- INSERT IGNORE INTO visit_history_2 (player_id, tenant_id, competition_id, created_at, updated_at) VALUES (?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?)

SELECT * FROM player WHERE id = '0000000000' -- SELECT * FROM player WHERE id = ?
UPDATE competition SET finished_at = 1659535599, updated_at = 1659535599 WHERE id = '7c7fc20e-1335-11ed-97a1-0aa59cf41f83' -- UPDATE competition SET finished_at = ?, updated_at = ? WHERE id = ?
SELECT player_id, created_at AS min_created_at FROM visit_history_2 WHERE tenant_id = 4763 AND competition_id = '7c7fc20e-1335-11ed-97a1-0aa59cf41f83' -- SELECT player_id, created_at AS min_created_at FROM visit_history_2 WHERE tenant_id = ? AND competition_id = ?
no warning
SELECT DISTINCT(player_id) FROM player_score WHERE tenant_id = 4763 AND competition_id = '7c7fc20e-1335-11ed-97a1-0aa59cf41f83' -- SELECT DISTINCT(player_id) FROM player_score WHERE tenant_id = ? AND competition_id = ?
INSERT INTO billing (tenant_id, competition_id, player, visitor, yen) VALUES (4763, '7c7fc20e-1335-11ed-97a1-0aa59cf41f83', 99, 1, 9910) -- INSERT INTO billing (tenant_id, competition_id, player, visitor, yen) VALUES (?, ?, ?, ?, ?)

SELECT * FROM competition WHERE tenant_id=4763 ORDER BY created_at DESC -- SELECT * FROM competition WHERE tenant_id=? ORDER BY created_at DESC
SELECT * FROM billing WHERE tenant_id=4763 -- SELECT * FROM billing WHERE tenant_id=?
no warning
SELECT player_score.score, competition.title, competition.created_at, competition.id FROM player_score INNER JOIN (
				SELECT competition_id, max(row_num) AS row_num FROM player_score WHERE tenant_id = 13 AND player_id = '3f60e639f' GROUP BY competition_id
			) AS c ON (
				player_score.row_num = c.row_num
				AND player_score.competition_id = c.competition_id
				AND player_score.tenant_id = 13 AND player_score.player_id = '3f60e639f'
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
			
SELECT * FROM competition WHERE id = 'ca59c23b' -- SELECT * FROM competition WHERE id = ?
SELECT player_score.*, display_name FROM player_score INNER JOIN (
			SELECT player_id, max(row_num) AS row_num FROM player_score WHERE tenant_id = 13 AND competition_id = 'ca59c23b' GROUP BY player_id
		) AS c ON (
			player_score.player_id = c.player_id
			AND player_score.row_num = c.row_num
			AND player_score.tenant_id = 13 AND player_score.competition_id = 'ca59c23b'
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
		
