SELECT * FROM competition WHERE tenant_id=80 ORDER BY created_at DESC -- SELECT * FROM competition WHERE tenant_id=? ORDER BY created_at DESC
SELECT * FROM billing WHERE tenant_id=80 -- SELECT * FROM billing WHERE tenant_id=?
no warning
SELECT * FROM player WHERE tenant_id=4035 ORDER BY created_at DESC -- SELECT * FROM player WHERE tenant_id=? ORDER BY created_at DESC
INSERT INTO competition (id, tenant_id, title, finished_at, created_at, updated_at) VALUES ('526dfb53-125c-11ed-a704-0aca4c9b93b3', 4035, '第3回 アイドル柿〜♪', <nil>, 1659442324, 1659442324) -- INSERT INTO competition (id, tenant_id, title, finished_at, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?)

DELETE FROM player_score WHERE tenant_id = 4035 AND competition_id = '526dfb53-125c-11ed-a704-0aca4c9b93b3' -- DELETE FROM player_score WHERE tenant_id = ? AND competition_id = ?
SELECT * FROM tenant WHERE id = 4035 -- SELECT * FROM tenant WHERE id = ?
no warning
SELECT player_score.*, display_name FROM player_score INNER JOIN (
			SELECT player_id, max(row_num) AS row_num FROM player_score WHERE tenant_id = 4035 AND competition_id = '526dfb53-125c-11ed-a704-0aca4c9b93b3' GROUP BY player_id
		) AS c ON (
			player_score.player_id = c.player_id
			AND player_score.row_num = c.row_num
			AND player_score.tenant_id = 4035 AND player_score.competition_id = '526dfb53-125c-11ed-a704-0aca4c9b93b3'
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
		
INSERT INTO player_score (id, tenant_id, player_id, competition_id, score, row_num, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, 
too long query

SELECT player_score.score, competition.title, competition.created_at, competition.id FROM player_score INNER JOIN (
				SELECT competition_id, max(row_num) AS row_num FROM player_score WHERE tenant_id = 4035 AND player_id = '526b1830-125c-11ed-a704-0aca4c9b93b3' GROUP BY competition_id
			) AS c ON (
				player_score.row_num = c.row_num
				AND player_score.competition_id = c.competition_id
				AND player_score.tenant_id = 4035 AND player_score.player_id = '526b1830-125c-11ed-a704-0aca4c9b93b3'
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
			
INSERT IGNORE INTO visit_history_2 (player_id, tenant_id, competition_id, created_at, updated_at) VALUES ('526b2228-125c-11ed-a704-0aca4c9b93b3',4035,'526dfb53-125c-11ed-a704-0aca4c9b93b3',1659442324,1659442324),('526b1440-125c-11ed-a704-0aca4c9b93b3',4035,'526dfb53-125c-11ed-a704-0aca4c9b93b3',1659442324,1659442324),('526b1ce2-125c-11ed-a704-0aca4c9b93b3',4035,'526dfb53-125c-11ed-a704-0aca4c9b93b3',1659442324,1659442324),('526b1d0d-125c-11ed-a704-0aca4c9b93b3',4035,'526dfb53-125c-11ed-a704-0aca4c9b93b3',1659442324,1659442324),('526b227c-125c-11ed-a704-0aca4c9b93b3',4035,'526dfb53-125c-11ed-a704-0aca4c9b93b3',1659442324,1659442324),('526b07bf-125c-11ed-a704-0aca4c9b93b3',4035,'526dfb53-125c-11ed-a704-0aca4c9b93b3',1659442324,1659442324),('526b0486-125c-11ed-a704-0aca4c9b93b3',4035,'526dfb53-125c-11ed-a704-0aca4c9b93b3',1659442324,1659442324),('526b0857-125c-11ed-a704-0aca4c9b93b3',4035,'526dfb53-125c-11ed-a704-0aca4c9b93b3',1659442324,1659442324),('526b07bf-125c-11ed-a704-0aca4c9b93b3',4035,'526dfb53-125c-11ed-a704-0aca4c9b93b3',1659442324,1659442324),('526b0486-125c-11ed-a704-0aca4c9b93b3',4035,'526dfb53-125c-11ed-a704-0aca4c9b93b3',1659442324,1659442324),('526b07e6-125c-11ed-a704-0aca4c9b93b3',4035,'526dfb53-125c-11ed-a704-0aca4c9b93b3',1659442324,1659442324),('526b080d-125c-11ed-a704-0aca4c9b93b3',4035,'526dfb53-125c-11ed-a704-0aca4c9b93b3',1659442324,1659442324),('526b0857-125c-11ed-a704-0aca4c9b93b3',4035,'526dfb53-125c-11ed-a704-0aca4c9b93b3',1659442324,1659442324),('526b07bf-125c-11ed-a704-0aca4c9b93b3',4035,'526dfb53-125c-11ed-a704-0aca4c9b93b3',1659442324,1659442324),('526b07e6-125c-11ed-a704-0aca4c9b93b3',4035,'526dfb53-125c-11ed-a704-0aca4c9b93b3',1659442324,1659442324),('526b0486-125c-11ed-a704-0aca4c9b93b3',4035,'526dfb53-125c-11ed-a704-0aca4c9b93b3',1659442324,1659442324),('526b080d-125c-11ed-a704-0aca4c9b93b3',4035,'526dfb53-125c-11ed-a704-0aca4c9b93b3',1659442324,1659442324),('526b07e6-125c-11ed-a704-0aca4c9b93b3',4035,'526dfb53-125c-11ed-a704-0aca4c9b93b3',1659442324,1659442324),('526b0486-125c-11ed-a704-0aca4c9b93b3',4035,'526dfb53-125c-11ed-a704-0aca4c9b93b3',1659442324,1659442324),('526b0857-125c-11ed-a704-0aca4c9b93b3',4035,'526dfb53-125c-11ed-a704-0aca4c9b93b3',1659442324,1659442324),('526b07bf-125c-11ed-a704-0aca4c9b93b3',4035,'526dfb53-125c-11ed-a704-0aca4c9b93b3',1659442324,1659442324),('526b080d-125c-11ed-a704-0aca4c9b93b3',4035,'526dfb53-125c-11ed-a704-0aca4c9b93b3',1659442324,1659442324),('526b07e6-125c-11ed-a704-0aca4c9b93b3',4035,'526dfb53-125c-11ed-a704-0aca4c9b93b3',1659442324,1659442324),('526b0486-125c-11ed-a704-0aca4c9b93b3',4035,'526dfb53-125c-11ed-a704-0aca4c9b93b3',1659442324,1659442324),('526b07bf-125c-11ed-a704-0aca4c9b93b3',4035,'526dfb53-125c-11ed-a704-0aca4c9b93b3',1659442324,1659442324),('526b080d-125c-11ed-a704-0aca4c9b93b3',4035,'526dfb53-125c-11ed-a704-0aca4c9b93b3',1659442324,1659442324),('526b0486-125c-11ed-a704-0aca4c9b93b3',4035,'526dfb53-125c-11ed-a704-0aca4c9b93b3',1659442324,1659442324),('526b0857-125c-11ed-a704-0aca4c9b93b3',4035,'526dfb53-125c-11ed-a704-0aca4c9b93b3',1659442324,1659442324),('526b07e6-125c-11ed-a704-0aca4c9b93b3',4035,'526dfb53-125c-11ed-a704-0aca4c9b93b3',1659442324,1659442324),('526b07bf-125c-11ed-a704-0aca4c9b93b3',4035,'526dfb53-125c-11ed-a704-0aca4c9b93b3',1659442324,1659442324),('526b0857-125c-11ed-a704-0aca4c9b93b3',4035,'526dfb53-125c-11ed-a704-0aca4c9b93b3',1659442324,1659442324),('526b080d-125c-11ed-a704-0aca4c9b93b3',4035,'526dfb53-125c-11ed-a704-0aca4c9b93b3',1659442324,1659442324),('526b0486-125c-11ed-a704-0aca4c9b93b3',4035,'526dfb53-125c-11ed-a704-0aca4c9b93b3',1659442324,1659442324),('526b07e6-125c-11ed-a704-0aca4c9b93b3',4035,'526dfb53-125c-11ed-a704-0aca4c9b93b3',1659442324,1659442324),('526b0832-125c-11ed-a704-0aca4c9b93b3',4035,'526dfb53-125c-11ed-a704-0aca4c9b93b3',1659442324,1659442324),('526b0857-125c-11ed-a704-0aca4c9b93b3',4035,'526dfb53-125c-11ed-a704-0aca4c9b93b3',1659442324,1659442324),('5294fcd7-125c-11ed-a704-0aca4c9b93b3',4040,'5297829a-125c-11ed-a704-0aca4c9b93b3',1659442325,1659442325),('5294f551-125c-11ed-a704-0aca4c9b93b3',4040,'5297829a-125c-11ed-a704-0aca4c9b93b3',1659442325,1659442325),('5294f80f-125c-11ed-a704-0aca4c9b93b3',4040,'5297829a-125c-11ed-a704-0aca4c9b93b3',1659442325,1659442325),('5294fc8b-125c-11ed-a704-0aca4c9b93b3',4040,'5297829a-125c-11ed-a704-0aca4c9b93b3',1659442325,1659442325),('5294f8bd-125c-11ed-a704-0aca4c9b93b3',4040,'5297829a-125c-11ed-a704-0aca4c9b93b3',1659442325,1659442325),('5294f53a-125c-11ed-a704-0aca4c9b93b3',4040,'5297829a-125c-11ed-a704-0aca4c9b93b3',1659442325,1659442325),('5294f53f-125c-11ed-a704-0aca4c9b93b3',4040,'5297829a-125c-11ed-a704-0aca4c9b93b3',1659442325,1659442325),('5294f4d8-125c-11ed-a704-0aca4c9b93b3',4040,'5297829a-125c-11ed-a704-0aca4c9b93b3',1659442325,1659442325),('5294f511-125c-11ed-a704-0aca4c9b93b3',4040,'5297829a-125c-11ed-a704-0aca4c9b93b3',1659442325,1659442325),('5294f53a-125c-11ed-a704-0aca4c9b93b3',4040,'5297829a-125c-11ed-a704-0aca4c9b93b3',1659442325,1659442325),('5294f50c-125c-11ed-a704-0aca4c9b93b3',4040,'5297829a-125c-11ed-a704-0aca4c9b93b3',1659442325,1659442325),('5294f516-125c-11ed-a704-0aca4c9b93b3',4040,'5297829a-125c-11ed-a704-0aca4c9b93b3',1659442325,1659442325) -- INSERT IGNORE INTO visit_history_2 (player_id, tenant_id, competition_id, created_at, updated_at) VALUES (?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?)

UPDATE competition SET finished_at = 1659442326, updated_at = 1659442326 WHERE id = '526dfb53-125c-11ed-a704-0aca4c9b93b3' -- UPDATE competition SET finished_at = ?, updated_at = ? WHERE id = ?
SELECT player_id, created_at AS min_created_at FROM visit_history_2 WHERE tenant_id = 4040 AND competition_id = '5297829a-125c-11ed-a704-0aca4c9b93b3' -- SELECT player_id, created_at AS min_created_at FROM visit_history_2 WHERE tenant_id = ? AND competition_id = ?
no warning
SELECT DISTINCT(player_id) FROM player_score WHERE tenant_id = 4035 AND competition_id = '526dfb53-125c-11ed-a704-0aca4c9b93b3' -- SELECT DISTINCT(player_id) FROM player_score WHERE tenant_id = ? AND competition_id = ?
INSERT INTO billing (tenant_id, competition_id, player, visitor, yen) VALUES (4035, '526dfb53-125c-11ed-a704-0aca4c9b93b3', 218, 0, 21800) -- INSERT INTO billing (tenant_id, competition_id, player, visitor, yen) VALUES (?, ?, ?, ?, ?)

SELECT * FROM player WHERE id = '632ebade8' -- SELECT * FROM player WHERE id = ?
UPDATE player SET is_disqualified = true, updated_at = 1659442340 WHERE id = '630e46c47' -- UPDATE player SET is_disqualified = ?, updated_at = ? WHERE id = ?
SELECT * FROM competition WHERE id = '37e4a4b7c' -- SELECT * FROM competition WHERE id = ?
