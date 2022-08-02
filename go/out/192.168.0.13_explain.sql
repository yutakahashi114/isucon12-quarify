SELECT * FROM player WHERE tenant_id=3570 ORDER BY created_at DESC -- SELECT * FROM player WHERE tenant_id=? ORDER BY created_at DESC
INSERT INTO competition (id, tenant_id, title, finished_at, created_at, updated_at) VALUES ('8613f81d-124c-11ed-831a-0aca4c9b93b3', 3570, 'validate_competition', <nil>, 1659435539, 1659435539) -- INSERT INTO competition (id, tenant_id, title, finished_at, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?)

UPDATE player SET is_disqualified = true, updated_at = 1659435539 WHERE id = '86120fea-124c-11ed-831a-0aca4c9b93b3' -- UPDATE player SET is_disqualified = ?, updated_at = ? WHERE id = ?
DELETE FROM player_score WHERE tenant_id = 3570 AND competition_id = '8613f81d-124c-11ed-831a-0aca4c9b93b3' -- DELETE FROM player_score WHERE tenant_id = ? AND competition_id = ?
INSERT INTO player_score (id, tenant_id, player_id, competition_id, score, row_num, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, ?, ?, ?, ?, ?),(?, ?, ?, 
too long query

SELECT * FROM tenant WHERE id = 3570 -- SELECT * FROM tenant WHERE id = ?
no warning
SELECT player_score.score, competition.title, competition.created_at, competition.id FROM player_score INNER JOIN (
				SELECT competition_id, max(row_num) AS row_num FROM player_score WHERE tenant_id = 3570 AND player_id = '8612033a-124c-11ed-831a-0aca4c9b93b3' GROUP BY competition_id
			) AS c ON (
				player_score.row_num = c.row_num
				AND player_score.competition_id = c.competition_id
				AND player_score.tenant_id = 3570 AND player_score.player_id = '8612033a-124c-11ed-831a-0aca4c9b93b3'
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
			
INSERT IGNORE INTO visit_history_2 (player_id, tenant_id, competition_id, created_at, updated_at) VALUES ('8611fe25-124c-11ed-831a-0aca4c9b93b3',3570,'8613f81d-124c-11ed-831a-0aca4c9b93b3',1659435539,1659435539),('8611fe25-124c-11ed-831a-0aca4c9b93b3',3570,'8613f81d-124c-11ed-831a-0aca4c9b93b3',1659435539,1659435539),('8611fe25-124c-11ed-831a-0aca4c9b93b3',3570,'8613f81d-124c-11ed-831a-0aca4c9b93b3',1659435539,1659435539),('8611fe25-124c-11ed-831a-0aca4c9b93b3',3570,'8613f81d-124c-11ed-831a-0aca4c9b93b3',1659435539,1659435539),('8611fe25-124c-11ed-831a-0aca4c9b93b3',3570,'8613f81d-124c-11ed-831a-0aca4c9b93b3',1659435539,1659435539),('8611fe25-124c-11ed-831a-0aca4c9b93b3',3570,'8613f81d-124c-11ed-831a-0aca4c9b93b3',1659435539,1659435539),('8611fe25-124c-11ed-831a-0aca4c9b93b3',3570,'8613f81d-124c-11ed-831a-0aca4c9b93b3',1659435539,1659435539),('8611fe25-124c-11ed-831a-0aca4c9b93b3',3570,'8613f81d-124c-11ed-831a-0aca4c9b93b3',1659435539,1659435539),('8611fe25-124c-11ed-831a-0aca4c9b93b3',3570,'8613f81d-124c-11ed-831a-0aca4c9b93b3',1659435539,1659435539),('8612100a-124c-11ed-831a-0aca4c9b93b3',3570,'8613f81d-124c-11ed-831a-0aca4c9b93b3',1659435539,1659435539) -- INSERT IGNORE INTO visit_history_2 (player_id, tenant_id, competition_id, created_at, updated_at) VALUES (?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?),(?,?,?,?,?)

UPDATE competition SET finished_at = 1659435542, updated_at = 1659435542 WHERE id = '8613f81d-124c-11ed-831a-0aca4c9b93b3' -- UPDATE competition SET finished_at = ?, updated_at = ? WHERE id = ?
SELECT player_id, created_at AS min_created_at FROM visit_history_2 WHERE tenant_id = 3570 AND competition_id = '8613f81d-124c-11ed-831a-0aca4c9b93b3' -- SELECT player_id, created_at AS min_created_at FROM visit_history_2 WHERE tenant_id = ? AND competition_id = ?
no warning
SELECT DISTINCT(player_id) FROM player_score WHERE tenant_id = 3570 AND competition_id = '8613f81d-124c-11ed-831a-0aca4c9b93b3' -- SELECT DISTINCT(player_id) FROM player_score WHERE tenant_id = ? AND competition_id = ?
INSERT INTO billing (tenant_id, competition_id, player, visitor, yen) VALUES (3570, '8613f81d-124c-11ed-831a-0aca4c9b93b3', 99, 1, 9910) -- INSERT INTO billing (tenant_id, competition_id, player, visitor, yen) VALUES (?, ?, ?, ?, ?)

SELECT * FROM competition WHERE tenant_id=3570 ORDER BY created_at DESC -- SELECT * FROM competition WHERE tenant_id=? ORDER BY created_at DESC
SELECT * FROM billing WHERE tenant_id=3570 -- SELECT * FROM billing WHERE tenant_id=?
no warning
SELECT * FROM player WHERE id = '54455a574' -- SELECT * FROM player WHERE id = ?
SELECT player_score.*, display_name FROM player_score INNER JOIN (
			SELECT player_id, max(row_num) AS row_num FROM player_score WHERE tenant_id = 45 AND competition_id = '87f505f6-124c-11ed-831a-0aca4c9b93b3' GROUP BY player_id
		) AS c ON (
			player_score.player_id = c.player_id
			AND player_score.row_num = c.row_num
			AND player_score.tenant_id = 45 AND player_score.competition_id = '87f505f6-124c-11ed-831a-0aca4c9b93b3'
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
		
SELECT * FROM competition WHERE id = '319af22fe' -- SELECT * FROM competition WHERE id = ?
