INSERT INTO tenant (name, display_name, created_at, updated_at) VALUES ('vo-akwdkx-1659161944', 'ウィスキー会', 1659161944, 1659161944) -- INSERT INTO tenant (name, display_name, created_at, updated_at) VALUES (?, ?, ?, ?)

SELECT * FROM tenant WHERE name = 'vo-akwdkx-1659161944' -- SELECT * FROM tenant WHERE name = ?
no warning
SELECT * FROM tenant ORDER BY id DESC -- SELECT * FROM tenant ORDER BY id DESC
no warning
SELECT * FROM competition WHERE tenant_id=21 -- SELECT * FROM competition WHERE tenant_id=?
SELECT * FROM competition WHERE id = 'baadc3db' -- SELECT * FROM competition WHERE id = ?
REPLACE INTO id_generator (stub) VALUES ('a'); -- REPLACE INTO id_generator (stub) VALUES (?);

INSERT INTO player (id, tenant_id, display_name, is_disqualified, created_at, updated_at) VALUES ('9fa52401', 150, 'validate_player0', false, 1659161944, 1659161944) -- INSERT INTO player (id, tenant_id, display_name, is_disqualified, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?)

SELECT * FROM player WHERE id = '9fa52401' -- SELECT * FROM player WHERE id = ?
SELECT player_id, MIN(created_at) AS min_created_at FROM visit_history WHERE tenant_id = 21 AND competition_id = 'baadc3db' GROUP BY player_id -- SELECT player_id, MIN(created_at) AS min_created_at FROM visit_history WHERE tenant_id = ? AND competition_id = ? GROUP BY player_id
クエリの実行に一時テーブルを必要としています
+----+-------------+---------------+------------+------+---------------+---------------+---------+-------+-------+-----------+------------------------------+
| ID | SELECT TYPE |     TABLE     | PARTITIONS | TYPE | POSSIBLE KEYS |      KEY      | KEY LEN |  REF  | ROWS  | FILTERED  |            EXTRA             |
+----+-------------+---------------+------------+------+---------------+---------------+---------+-------+-------+-----------+------------------------------+
|  1 | SIMPLE      | visit_history | NULL       | ref  | tenant_id_idx | tenant_id_idx |       8 | const | 33284 | 10.000000 | Using where; Using temporary |
+----+-------------+---------------+------------+------+---------------+---------------+---------+-------+-------+-----------+------------------------------+

SELECT DISTINCT(player_id) FROM player_score WHERE tenant_id = 21 AND competition_id = 'baadc3db' -- SELECT DISTINCT(player_id) FROM player_score WHERE tenant_id = ? AND competition_id = ?
INSERT INTO competition (id, tenant_id, title, finished_at, created_at, updated_at) VALUES ('9fa52406', 152, '腹筋ガチ勢カップ', <nil>, 1659161944, 1659161944) -- INSERT INTO competition (id, tenant_id, title, finished_at, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?)

UPDATE player SET is_disqualified = true, updated_at = 1659161945 WHERE id = '0000000000' -- UPDATE player SET is_disqualified = ?, updated_at = ? WHERE id = ?
SELECT * FROM player WHERE tenant_id=150 ORDER BY created_at DESC -- SELECT * FROM player WHERE tenant_id=? ORDER BY created_at DESC
UPDATE competition SET finished_at = 1659161945, updated_at = 1659161945 WHERE id = '9fa5252f' -- UPDATE competition SET finished_at = ?, updated_at = ? WHERE id = ?
DELETE FROM player_score WHERE tenant_id = 150 AND competition_id = '9fa52531' -- DELETE FROM player_score WHERE tenant_id = ? AND competition_id = ?
INSERT INTO player_score (id, tenant_id, player_id, competition_id, score, row_num, created_at, updated_at) VALUES ('9fa52536', 150, '9fa52401', '9fa52531', 100, 1, 1659161945, 1659161945) -- INSERT INTO player_score (id, tenant_id, player_id, competition_id, score, row_num, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?)

SELECT * FROM tenant WHERE id = 152 -- SELECT * FROM tenant WHERE id = ?
no warning
INSERT INTO visit_history (player_id, tenant_id, competition_id, created_at, updated_at) VALUES ('9fa52409', 152, '9fa52406', 1659161946, 1659161946) -- INSERT INTO visit_history (player_id, tenant_id, competition_id, created_at, updated_at) VALUES (?, ?, ?, ?, ?)

SELECT * FROM player_score WHERE tenant_id = 152 AND competition_id = '9fa52406' ORDER BY row_num DESC -- SELECT * FROM player_score WHERE tenant_id = ? AND competition_id = ? ORDER BY row_num DESC
SELECT * FROM competition WHERE tenant_id = 152 ORDER BY created_at ASC -- SELECT * FROM competition WHERE tenant_id = ? ORDER BY created_at ASC
SELECT * FROM player_score WHERE tenant_id = 152 AND competition_id = '9fa52406' AND player_id = '9fa5245f' ORDER BY row_num DESC LIMIT 1 -- SELECT * FROM player_score WHERE tenant_id = ? AND competition_id = ? AND player_id = ? ORDER BY row_num DESC LIMIT 1
SELECT * FROM competition WHERE tenant_id=150 ORDER BY created_at DESC -- SELECT * FROM competition WHERE tenant_id=? ORDER BY created_at DESC
