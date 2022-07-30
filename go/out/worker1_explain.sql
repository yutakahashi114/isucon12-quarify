INSERT INTO tenant (name, display_name, created_at, updated_at) VALUES ('q-srlisi-1659164325', '中目黒探偵', 1659164325, 1659164325) -- INSERT INTO tenant (name, display_name, created_at, updated_at) VALUES (?, ?, ?, ?)

SELECT * FROM tenant ORDER BY id DESC -- SELECT * FROM tenant ORDER BY id DESC
no warning
SELECT * FROM competition WHERE tenant_id=17 -- SELECT * FROM competition WHERE tenant_id=?
SELECT * FROM competition WHERE id = '19f4163d4' -- SELECT * FROM competition WHERE id = ?
SELECT * FROM tenant WHERE name = 'q-srlisi-1659164325' -- SELECT * FROM tenant WHERE name = ?
no warning
REPLACE INTO id_generator (stub) VALUES ('a'); -- REPLACE INTO id_generator (stub) VALUES (?);

SELECT player_id, MIN(created_at) AS min_created_at FROM visit_history WHERE tenant_id = 17 AND competition_id = '19f4163d4' GROUP BY player_id -- SELECT player_id, MIN(created_at) AS min_created_at FROM visit_history WHERE tenant_id = ? AND competition_id = ? GROUP BY player_id
no warning
SELECT DISTINCT(player_id) FROM player_score WHERE tenant_id = 17 AND competition_id = '19f4163d4' -- SELECT DISTINCT(player_id) FROM player_score WHERE tenant_id = ? AND competition_id = ?
INSERT INTO player (id, tenant_id, display_name, is_disqualified, created_at, updated_at) VALUES ('9fa52401', 193, 'validate_player0', false, 1659164325, 1659164325) -- INSERT INTO player (id, tenant_id, display_name, is_disqualified, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?)

SELECT * FROM player WHERE id = '9fa52401' -- SELECT * FROM player WHERE id = ?
INSERT INTO competition (id, tenant_id, title, finished_at, created_at, updated_at) VALUES ('9fa52403', 194, 'こだわりフカヒレ基地カップ', <nil>, 1659164325, 1659164325) -- INSERT INTO competition (id, tenant_id, title, finished_at, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?)

SELECT * FROM player WHERE tenant_id=193 ORDER BY created_at DESC -- SELECT * FROM player WHERE tenant_id=? ORDER BY created_at DESC
UPDATE player SET is_disqualified = true, updated_at = 1659164326 WHERE id = '0000000000' -- UPDATE player SET is_disqualified = ?, updated_at = ? WHERE id = ?
UPDATE competition SET finished_at = 1659164326, updated_at = 1659164326 WHERE id = '9fa5252e' -- UPDATE competition SET finished_at = ?, updated_at = ? WHERE id = ?
DELETE FROM player_score WHERE tenant_id = 193 AND competition_id = '9fa5252b' -- DELETE FROM player_score WHERE tenant_id = ? AND competition_id = ?
INSERT INTO player_score (id, tenant_id, player_id, competition_id, score, row_num, created_at, updated_at) VALUES ('9fa52530', 193, '9fa52401', '9fa5252b', 100, 1, 1659164326, 1659164326) -- INSERT INTO player_score (id, tenant_id, player_id, competition_id, score, row_num, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?)

SELECT * FROM tenant WHERE id = 193 -- SELECT * FROM tenant WHERE id = ?
no warning
INSERT INTO visit_history (player_id, tenant_id, competition_id, created_at, updated_at) VALUES ('9fa52401', 193, '9fa5252b', 1659164327, 1659164327) -- INSERT INTO visit_history (player_id, tenant_id, competition_id, created_at, updated_at) VALUES (?, ?, ?, ?, ?)

SELECT player_score.*, display_name FROM player_score INNER JOIN (
			SELECT player_id, max(row_num) AS row_num FROM player_score WHERE tenant_id = 194 AND competition_id = '9fa52403' GROUP BY player_id
		) AS c ON (
			player_score.player_id = c.player_id
			AND player_score.row_num = c.row_num
			AND player_score.tenant_id = 194 AND player_score.competition_id = '9fa52403'
		)
		INNER JOIN player ON (
			player.id = player_score.player_id
		)
		ORDER BY player_score.score DESC, player_score.row_num ASC
		LIMIT 100 OFFSET 0
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
		LIMIT ? OFFSET ?
		
SELECT * FROM competition WHERE tenant_id = 194 ORDER BY created_at ASC -- SELECT * FROM competition WHERE tenant_id = ? ORDER BY created_at ASC
SELECT * FROM player_score WHERE tenant_id = 194 AND competition_id = '9fa52403' AND player_id = '9fa52462' ORDER BY row_num DESC LIMIT 1 -- SELECT * FROM player_score WHERE tenant_id = ? AND competition_id = ? AND player_id = ? ORDER BY row_num DESC LIMIT 1
SELECT * FROM competition WHERE tenant_id=193 ORDER BY created_at DESC -- SELECT * FROM competition WHERE tenant_id=? ORDER BY created_at DESC
