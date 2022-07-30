INSERT INTO tenant (name, display_name, created_at, updated_at) VALUES ('k-t-1659163327', 'かぼちゃテクノロジーズ', 1659163327, 1659163327) -- INSERT INTO tenant (name, display_name, created_at, updated_at) VALUES (?, ?, ?, ?)

SELECT * FROM tenant WHERE name = 'k-t-1659163327' -- SELECT * FROM tenant WHERE name = ?
no warning
REPLACE INTO id_generator (stub) VALUES ('a'); -- REPLACE INTO id_generator (stub) VALUES (?);

SELECT * FROM tenant ORDER BY id DESC -- SELECT * FROM tenant ORDER BY id DESC
no warning
SELECT * FROM competition WHERE tenant_id=19 -- SELECT * FROM competition WHERE tenant_id=?
SELECT * FROM competition WHERE id = '13f6ceb68' -- SELECT * FROM competition WHERE id = ?
INSERT INTO player (id, tenant_id, display_name, is_disqualified, created_at, updated_at) VALUES ('9fa52401', 172, 'validate_player0', false, 1659163327, 1659163327) -- INSERT INTO player (id, tenant_id, display_name, is_disqualified, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?)

SELECT * FROM player WHERE id = '9fa52401' -- SELECT * FROM player WHERE id = ?
INSERT INTO competition (id, tenant_id, title, finished_at, created_at, updated_at) VALUES ('9fa52408', 174, 'だいたい太麺.py杯', <nil>, 1659163327, 1659163327) -- INSERT INTO competition (id, tenant_id, title, finished_at, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?)

SELECT player_id, MIN(created_at) AS min_created_at FROM visit_history WHERE tenant_id = 19 AND competition_id = '13f6ceb68' GROUP BY player_id -- SELECT player_id, MIN(created_at) AS min_created_at FROM visit_history WHERE tenant_id = ? AND competition_id = ? GROUP BY player_id
クエリの実行に一時テーブルを必要としています
+----+-------------+---------------+------------+------+---------------+---------------+---------+-------+-------+-----------+------------------------------+
| ID | SELECT TYPE |     TABLE     | PARTITIONS | TYPE | POSSIBLE KEYS |      KEY      | KEY LEN |  REF  | ROWS  | FILTERED  |            EXTRA             |
+----+-------------+---------------+------------+------+---------------+---------------+---------+-------+-------+-----------+------------------------------+
|  1 | SIMPLE      | visit_history | NULL       | ref  | tenant_id_idx | tenant_id_idx |       8 | const | 91712 | 10.000000 | Using where; Using temporary |
+----+-------------+---------------+------------+------+---------------+---------------+---------+-------+-------+-----------+------------------------------+

SELECT DISTINCT(player_id) FROM player_score WHERE tenant_id = 19 AND competition_id = '13f6ceb68' -- SELECT DISTINCT(player_id) FROM player_score WHERE tenant_id = ? AND competition_id = ?
SELECT * FROM player WHERE tenant_id=172 ORDER BY created_at DESC -- SELECT * FROM player WHERE tenant_id=? ORDER BY created_at DESC
UPDATE player SET is_disqualified = true, updated_at = 1659163328 WHERE id = '9fa5251b' -- UPDATE player SET is_disqualified = ?, updated_at = ? WHERE id = ?
UPDATE competition SET finished_at = 1659163328, updated_at = 1659163328 WHERE id = '9fa52535' -- UPDATE competition SET finished_at = ?, updated_at = ? WHERE id = ?
DELETE FROM player_score WHERE tenant_id = 172 AND competition_id = '9fa52523' -- DELETE FROM player_score WHERE tenant_id = ? AND competition_id = ?
INSERT INTO player_score (id, tenant_id, player_id, competition_id, score, row_num, created_at, updated_at) VALUES ('9fa5252b', 172, '9fa52401', '9fa52523', 100, 1, 1659163328, 1659163328) -- INSERT INTO player_score (id, tenant_id, player_id, competition_id, score, row_num, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?)

SELECT * FROM tenant WHERE id = 172 -- SELECT * FROM tenant WHERE id = ?
no warning
INSERT INTO visit_history (player_id, tenant_id, competition_id, created_at, updated_at) VALUES ('9fa52401', 172, '9fa52523', 1659163329, 1659163329) -- INSERT INTO visit_history (player_id, tenant_id, competition_id, created_at, updated_at) VALUES (?, ?, ?, ?, ?)

SELECT player_score.*, display_name FROM player_score INNER JOIN (
			SELECT player_id, max(row_num) AS row_num FROM player_score WHERE tenant_id = 174 AND competition_id = '9fa52408' GROUP BY player_id
		) AS c ON (
			player_score.player_id = c.player_id
			AND player_score.row_num = c.row_num
			AND player_score.tenant_id = 174 AND player_score.competition_id = '9fa52408'
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
		
SELECT * FROM competition WHERE tenant_id = 174 ORDER BY created_at ASC -- SELECT * FROM competition WHERE tenant_id = ? ORDER BY created_at ASC
SELECT * FROM player_score WHERE tenant_id = 174 AND competition_id = '9fa52408' AND player_id = '9fa52469' ORDER BY row_num DESC LIMIT 1 -- SELECT * FROM player_score WHERE tenant_id = ? AND competition_id = ? AND player_id = ? ORDER BY row_num DESC LIMIT 1
SELECT * FROM competition WHERE tenant_id=172 ORDER BY created_at DESC -- SELECT * FROM competition WHERE tenant_id=? ORDER BY created_at DESC
