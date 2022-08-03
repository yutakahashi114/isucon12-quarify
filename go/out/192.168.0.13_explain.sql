UPDATE player SET is_disqualified = true, updated_at = 1659535596 WHERE id = '0000000000' -- UPDATE player SET is_disqualified = ?, updated_at = ? WHERE id = ?
SELECT * FROM player WHERE id = '0000000000' -- SELECT * FROM player WHERE id = ?
INSERT INTO competition (id, tenant_id, title, finished_at, created_at, updated_at) VALUES ('7c85d363-1335-11ed-80cd-0aca4c9b93b3', 4765, '太麺クラッシャー #9', <nil>, 1659535596, 1659535596) -- INSERT INTO competition (id, tenant_id, title, finished_at, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?)

SELECT * FROM competition WHERE id = '0000000000' -- SELECT * FROM competition WHERE id = ?
UPDATE competition SET finished_at = 1659535596, updated_at = 1659535596 WHERE id = '7c85d363-1335-11ed-80cd-0aca4c9b93b3' -- UPDATE competition SET finished_at = ?, updated_at = ? WHERE id = ?
SELECT player_id, created_at AS min_created_at FROM visit_history_2 WHERE tenant_id = 4765 AND competition_id = '7c85d363-1335-11ed-80cd-0aca4c9b93b3' -- SELECT player_id, created_at AS min_created_at FROM visit_history_2 WHERE tenant_id = ? AND competition_id = ?
no warning
SELECT DISTINCT(player_id) FROM player_score WHERE tenant_id = 4765 AND competition_id = '7c85d363-1335-11ed-80cd-0aca4c9b93b3' -- SELECT DISTINCT(player_id) FROM player_score WHERE tenant_id = ? AND competition_id = ?
INSERT INTO billing (tenant_id, competition_id, player, visitor, yen) VALUES (4765, '7c85d363-1335-11ed-80cd-0aca4c9b93b3', 0, 0, 0) -- INSERT INTO billing (tenant_id, competition_id, player, visitor, yen) VALUES (?, ?, ?, ?, ?)

SELECT * FROM player WHERE tenant_id=4770 ORDER BY created_at DESC -- SELECT * FROM player WHERE tenant_id=? ORDER BY created_at DESC
DELETE FROM player_score WHERE tenant_id = 4770 AND competition_id = '7e6fefe9-1335-11ed-80cd-0aca4c9b93b3' -- DELETE FROM player_score WHERE tenant_id = ? AND competition_id = ?
INSERT INTO player_score (id, tenant_id, player_id, competition_id, score, row_num, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, 
too long query

SELECT * FROM tenant WHERE id = 4770 -- SELECT * FROM tenant WHERE id = ?
no warning
SELECT * FROM competition WHERE tenant_id=4770 ORDER BY created_at DESC -- SELECT * FROM competition WHERE tenant_id=? ORDER BY created_at DESC
INSERT IGNORE INTO visit_history_2 (player_id, tenant_id, competition_id, created_at, updated_at) VALUES ('7e6dc658-1335-11ed-80cd-0aca4c9b93b3',4770,'7e6fefe9-1335-11ed-80cd-0aca4c9b93b3',1659535599,1659535599),('7e6dc5ce-1335-11ed-80cd-0aca4c9b93b3',4770,'7e6fefe9-1335-11ed-80cd-0aca4c9b93b3',1659535599,1659535599),('7e6dba21-1335-11ed-80cd-0aca4c9b93b3',4770,'7e6fefe9-1335-11ed-80cd-0aca4c9b93b3',1659535599,1659535599),('7e6db55a-1335-11ed-80cd-0aca4c9b93b3',4770,'7e6fefe9-1335-11ed-80cd-0aca4c9b93b3',1659535599,1659535599),('7e6dbf0f-1335-11ed-80cd-0aca4c9b93b3',4770,'7e6fefe9-1335-11ed-80cd-0aca4c9b93b3',1659535599,1659535599),('7e6db55a-1335-11ed-80cd-0aca4c9b93b3',4770,'7e6fefe9-1335-11ed-80cd-0aca4c9b93b3',1659535599,1659535599),('7e6db62a-1335-11ed-80cd-0aca4c9b93b3',4770,'7e6fefe9-1335-11ed-80cd-0aca4c9b93b3',1659535599,1659535599),('7e6db5cb-1335-11ed-80cd-0aca4c9b93b3',4770,'7e6fefe9-1335-11ed-80cd-0aca4c9b93b3',1659535599,1659535599),('7e6db5fe-1335-11ed-80cd-0aca4c9b93b3',4770,'7e6fefe9-1335-11ed-80cd-0aca4c9b93b3',1659535599,1659535599),('7e6db5b6-1335-11ed-80cd-0aca4c9b93b3',4770,'7e6fefe9-1335-11ed-80cd-0aca4c9b93b3',1659535599,1659535599),('7e6db59c-1335-11ed-80cd-0aca4c9b93b3',4770,'7e6fefe9-1335-11ed-80cd-0aca4c9b93b3',1659535599,1659535599) -- INSERT IGNORE INTO visit_history_2 (player_id, tenant_id, competition_id, created_at, updated_at) VALUES (?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?)

SELECT * FROM billing WHERE tenant_id=4770 -- SELECT * FROM billing WHERE tenant_id=?
no warning
SELECT player_score.*, display_name FROM player_score INNER JOIN (
			SELECT player_id, max(row_num) AS row_num FROM player_score WHERE tenant_id = 60 AND competition_id = '54e12eea8' GROUP BY player_id
		) AS c ON (
			player_score.player_id = c.player_id
			AND player_score.row_num = c.row_num
			AND player_score.tenant_id = 60 AND player_score.competition_id = '54e12eea8'
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
				SELECT competition_id, max(row_num) AS row_num FROM player_score WHERE tenant_id = 60 AND player_id = '1963e90ed' GROUP BY competition_id
			) AS c ON (
				player_score.row_num = c.row_num
				AND player_score.competition_id = c.competition_id
				AND player_score.tenant_id = 60 AND player_score.player_id = '1963e90ed'
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
			
