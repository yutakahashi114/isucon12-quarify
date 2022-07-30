INSERT INTO tenant (name, display_name, created_at, updated_at) VALUES ('gel-ae-1659163580', '空から和光市でごめん', 1659163580, 1659163580) -- INSERT INTO tenant (name, display_name, created_at, updated_at) VALUES (?, ?, ?, ?)

SELECT * FROM tenant WHERE name = 'gel-ae-1659163580' -- SELECT * FROM tenant WHERE name = ?
no warning
REPLACE INTO id_generator (stub) VALUES ('a'); -- REPLACE INTO id_generator (stub) VALUES (?);

SELECT * FROM tenant ORDER BY id DESC -- SELECT * FROM tenant ORDER BY id DESC
no warning
SELECT * FROM competition WHERE tenant_id=25 -- SELECT * FROM competition WHERE tenant_id=?
SELECT * FROM competition WHERE id = '14fc7ee53' -- SELECT * FROM competition WHERE id = ?
INSERT INTO player (id, tenant_id, display_name, is_disqualified, created_at, updated_at) VALUES ('9fa52401', 179, 'validate_player0', false, 1659163580, 1659163580) -- INSERT INTO player (id, tenant_id, display_name, is_disqualified, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?)

SELECT * FROM player WHERE id = '9fa52401' -- SELECT * FROM player WHERE id = ?
SELECT player_id, MIN(created_at) AS min_created_at FROM visit_history WHERE tenant_id = 25 AND competition_id = '14fc7ee53' GROUP BY player_id -- SELECT player_id, MIN(created_at) AS min_created_at FROM visit_history WHERE tenant_id = ? AND competition_id = ? GROUP BY player_id
クエリの実行に一時テーブルを必要としています
+----+-------------+---------------+------------+------+---------------+---------------+---------+-------+-------+-----------+------------------------------+
| ID | SELECT TYPE |     TABLE     | PARTITIONS | TYPE | POSSIBLE KEYS |      KEY      | KEY LEN |  REF  | ROWS  | FILTERED  |            EXTRA             |
+----+-------------+---------------+------------+------+---------------+---------------+---------+-------+-------+-----------+------------------------------+
|  1 | SIMPLE      | visit_history | NULL       | ref  | tenant_id_idx | tenant_id_idx |       8 | const | 34200 | 10.000000 | Using where; Using temporary |
+----+-------------+---------------+------------+------+---------------+---------------+---------+-------+-------+-----------+------------------------------+

SELECT DISTINCT(player_id) FROM player_score WHERE tenant_id = 25 AND competition_id = '14fc7ee53' -- SELECT DISTINCT(player_id) FROM player_score WHERE tenant_id = ? AND competition_id = ?
INSERT INTO competition (id, tenant_id, title, finished_at, created_at, updated_at) VALUES ('9fa52406', 181, '第2回 ウルトラ舞浜効果', <nil>, 1659163580, 1659163580) -- INSERT INTO competition (id, tenant_id, title, finished_at, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?)

SELECT * FROM player WHERE tenant_id=179 ORDER BY created_at DESC -- SELECT * FROM player WHERE tenant_id=? ORDER BY created_at DESC
UPDATE player SET is_disqualified = true, updated_at = 1659163581 WHERE id = '9fa52522' -- UPDATE player SET is_disqualified = ?, updated_at = ? WHERE id = ?
UPDATE competition SET finished_at = 1659163581, updated_at = 1659163581 WHERE id = '9fa52531' -- UPDATE competition SET finished_at = ?, updated_at = ? WHERE id = ?
DELETE FROM player_score WHERE tenant_id = 179 AND competition_id = '9fa52529' -- DELETE FROM player_score WHERE tenant_id = ? AND competition_id = ?
INSERT INTO player_score (id, tenant_id, player_id, competition_id, score, row_num, created_at, updated_at) VALUES ('9fa5252d', 179, '9fa52401', '9fa52529', 100, 1, 1659163581, 1659163581) -- INSERT INTO player_score (id, tenant_id, player_id, competition_id, score, row_num, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?)

SELECT * FROM tenant WHERE id = 179 -- SELECT * FROM tenant WHERE id = ?
no warning
INSERT INTO visit_history (player_id, tenant_id, competition_id, created_at, updated_at) VALUES ('9fa52401', 179, '9fa52529', 1659163582, 1659163582) -- INSERT INTO visit_history (player_id, tenant_id, competition_id, created_at, updated_at) VALUES (?, ?, ?, ?, ?)

SELECT player_score.*, display_name FROM player_score INNER JOIN (
			SELECT player_id, max(row_num) AS row_num FROM player_score WHERE tenant_id = 181 AND competition_id = '9fa52406' GROUP BY player_id
		) AS c ON (
			player_score.player_id = c.player_id
			AND player_score.row_num = c.row_num
			AND player_score.tenant_id = 181 AND player_score.competition_id = '9fa52406'
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
		
SELECT * FROM player_score WHERE tenant_id = 181 AND competition_id = '9fa52406' AND player_id = '9fa52463' ORDER BY row_num DESC LIMIT 1 -- SELECT * FROM player_score WHERE tenant_id = ? AND competition_id = ? AND player_id = ? ORDER BY row_num DESC LIMIT 1
SELECT * FROM competition WHERE tenant_id = 181 ORDER BY created_at ASC -- SELECT * FROM competition WHERE tenant_id = ? ORDER BY created_at ASC
SELECT * FROM competition WHERE tenant_id=179 ORDER BY created_at DESC -- SELECT * FROM competition WHERE tenant_id=? ORDER BY created_at DESC
