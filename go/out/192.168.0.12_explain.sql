SELECT * FROM player WHERE tenant_id=4122 ORDER BY created_at DESC -- SELECT * FROM player WHERE tenant_id=? ORDER BY created_at DESC
INSERT INTO competition (id, tenant_id, title, finished_at, created_at, updated_at) VALUES ('eaf982aa-125c-11ed-8c17-0aa59cf41f83', 4122, 'validate_competition', <nil>, 1659442580, 1659442580) -- INSERT INTO competition (id, tenant_id, title, finished_at, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?)

UPDATE player SET is_disqualified = true, updated_at = 1659442580 WHERE id = 'eaf7a3ed-125c-11ed-8c17-0aa59cf41f83' -- UPDATE player SET is_disqualified = ?, updated_at = ? WHERE id = ?
DELETE FROM player_score WHERE tenant_id = 4122 AND competition_id = 'eaf982aa-125c-11ed-8c17-0aa59cf41f83' -- DELETE FROM player_score WHERE tenant_id = ? AND competition_id = ?
INSERT INTO player_score (id, tenant_id, player_id, competition_id, score, row_num, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, 
too long query

SELECT * FROM player WHERE id = '0000000000' -- SELECT * FROM player WHERE id = ?
SELECT * FROM tenant WHERE id = 4122 -- SELECT * FROM tenant WHERE id = ?
no warning
SELECT * FROM competition WHERE id = '0000000000' -- SELECT * FROM competition WHERE id = ?
SELECT player_score.score, competition.title, competition.created_at, competition.id FROM player_score INNER JOIN (
				SELECT competition_id, max(row_num) AS row_num FROM player_score WHERE tenant_id = 4122 AND player_id = 'eaf7967b-125c-11ed-8c17-0aa59cf41f83' GROUP BY competition_id
			) AS c ON (
				player_score.row_num = c.row_num
				AND player_score.competition_id = c.competition_id
				AND player_score.tenant_id = 4122 AND player_score.player_id = 'eaf7967b-125c-11ed-8c17-0aa59cf41f83'
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
			
INSERT IGNORE INTO visit_history_2 (player_id, tenant_id, competition_id, created_at, updated_at) VALUES ('eaf79102-125c-11ed-8c17-0aa59cf41f83',4122,'eaf982aa-125c-11ed-8c17-0aa59cf41f83',1659442580,1659442580),('eaf79102-125c-11ed-8c17-0aa59cf41f83',4122,'eaf982aa-125c-11ed-8c17-0aa59cf41f83',1659442580,1659442580),('eaf79102-125c-11ed-8c17-0aa59cf41f83',4122,'eaf982aa-125c-11ed-8c17-0aa59cf41f83',1659442580,1659442580),('eaf79102-125c-11ed-8c17-0aa59cf41f83',4122,'eaf982aa-125c-11ed-8c17-0aa59cf41f83',1659442580,1659442580),('eaf79102-125c-11ed-8c17-0aa59cf41f83',4122,'eaf982aa-125c-11ed-8c17-0aa59cf41f83',1659442580,1659442580),('eaf79102-125c-11ed-8c17-0aa59cf41f83',4122,'eaf982aa-125c-11ed-8c17-0aa59cf41f83',1659442580,1659442580),('eaf79102-125c-11ed-8c17-0aa59cf41f83',4122,'eaf982aa-125c-11ed-8c17-0aa59cf41f83',1659442580,1659442580),('eaf79102-125c-11ed-8c17-0aa59cf41f83',4122,'eaf982aa-125c-11ed-8c17-0aa59cf41f83',1659442580,1659442580) -- INSERT IGNORE INTO visit_history_2 (player_id, tenant_id, competition_id, created_at, updated_at) VALUES (?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?)

UPDATE competition SET finished_at = 1659442580, updated_at = 1659442580 WHERE id = 'eaff83d3-125c-11ed-8c17-0aa59cf41f83' -- UPDATE competition SET finished_at = ?, updated_at = ? WHERE id = ?
SELECT player_id, created_at AS min_created_at FROM visit_history_2 WHERE tenant_id = 4123 AND competition_id = 'eaff83d3-125c-11ed-8c17-0aa59cf41f83' -- SELECT player_id, created_at AS min_created_at FROM visit_history_2 WHERE tenant_id = ? AND competition_id = ?
no warning
SELECT DISTINCT(player_id) FROM player_score WHERE tenant_id = 4123 AND competition_id = 'eaff83d3-125c-11ed-8c17-0aa59cf41f83' -- SELECT DISTINCT(player_id) FROM player_score WHERE tenant_id = ? AND competition_id = ?
INSERT INTO billing (tenant_id, competition_id, player, visitor, yen) VALUES (4123, 'eaff83d3-125c-11ed-8c17-0aa59cf41f83', 0, 0, 0) -- INSERT INTO billing (tenant_id, competition_id, player, visitor, yen) VALUES (?, ?, ?, ?, ?)

SELECT * FROM competition WHERE tenant_id=4122 ORDER BY created_at DESC -- SELECT * FROM competition WHERE tenant_id=? ORDER BY created_at DESC
SELECT * FROM billing WHERE tenant_id=4122 -- SELECT * FROM billing WHERE tenant_id=?
no warning
SELECT player_score.*, display_name FROM player_score INNER JOIN (
			SELECT player_id, max(row_num) AS row_num FROM player_score WHERE tenant_id = 4128 AND competition_id = 'ecea0f43-125c-11ed-8c17-0aa59cf41f83' GROUP BY player_id
		) AS c ON (
			player_score.player_id = c.player_id
			AND player_score.row_num = c.row_num
			AND player_score.tenant_id = 4128 AND player_score.competition_id = 'ecea0f43-125c-11ed-8c17-0aa59cf41f83'
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
		
