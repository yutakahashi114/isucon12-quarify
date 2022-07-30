INSERT INTO tenant (name, display_name, created_at, updated_at) VALUES ('lok-oc-1659161414', '日本のブロッコリーから始めるXSUCON', 1659161414, 1659161414) -- INSERT INTO tenant (name, display_name, created_at, updated_at) VALUES (?, ?, ?, ?)

SELECT * FROM tenant ORDER BY id DESC -- SELECT * FROM tenant ORDER BY id DESC
no warning
SELECT * FROM competition WHERE tenant_id=23 -- SELECT * FROM competition WHERE tenant_id=?
SELECT * FROM competition WHERE id = '25dc1da4b' -- SELECT * FROM competition WHERE id = ?
SELECT * FROM tenant WHERE name = 'lok-oc-1659161414' -- SELECT * FROM tenant WHERE name = ?
no warning
REPLACE INTO id_generator (stub) VALUES ('a'); -- REPLACE INTO id_generator (stub) VALUES (?);

INSERT INTO player (id, tenant_id, display_name, is_disqualified, created_at, updated_at) VALUES ('9fa52401', 143, 'validate_player0', false, 1659161414, 1659161414) -- INSERT INTO player (id, tenant_id, display_name, is_disqualified, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?)

SELECT * FROM player WHERE id = '9fa52401' -- SELECT * FROM player WHERE id = ?
SELECT player_id, MIN(created_at) AS min_created_at FROM visit_history WHERE tenant_id = 23 AND competition_id = '25dc1da4b' GROUP BY player_id -- SELECT player_id, MIN(created_at) AS min_created_at FROM visit_history WHERE tenant_id = ? AND competition_id = ? GROUP BY player_id
クエリの実行に一時テーブルを必要としています
+----+-------------+---------------+------------+------+---------------+---------------+---------+-------+-------+-----------+------------------------------+
| ID | SELECT TYPE |     TABLE     | PARTITIONS | TYPE | POSSIBLE KEYS |      KEY      | KEY LEN |  REF  | ROWS  | FILTERED  |            EXTRA             |
+----+-------------+---------------+------------+------+---------------+---------------+---------+-------+-------+-----------+------------------------------+
|  1 | SIMPLE      | visit_history | NULL       | ref  | tenant_id_idx | tenant_id_idx |       8 | const | 21168 | 10.000000 | Using where; Using temporary |
+----+-------------+---------------+------------+------+---------------+---------------+---------+-------+-------+-----------+------------------------------+

SELECT DISTINCT(player_id) FROM player_score WHERE tenant_id = 23 AND competition_id = '25dc1da4b' -- SELECT DISTINCT(player_id) FROM player_score WHERE tenant_id = ? AND competition_id = ?
INSERT INTO competition (id, tenant_id, title, finished_at, created_at, updated_at) VALUES ('9fa52407', 145, 'たまねぎ屋さん', <nil>, 1659161414, 1659161414) -- INSERT INTO competition (id, tenant_id, title, finished_at, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?)

SELECT * FROM player WHERE tenant_id=143 ORDER BY created_at DESC -- SELECT * FROM player WHERE tenant_id=? ORDER BY created_at DESC
UPDATE player SET is_disqualified = true, updated_at = 1659161416 WHERE id = '9fa52524' -- UPDATE player SET is_disqualified = ?, updated_at = ? WHERE id = ?
UPDATE competition SET finished_at = 1659161416, updated_at = 1659161416 WHERE id = '9fa52534' -- UPDATE competition SET finished_at = ?, updated_at = ? WHERE id = ?
DELETE FROM player_score WHERE tenant_id = 143 AND competition_id = '9fa5252a' -- DELETE FROM player_score WHERE tenant_id = ? AND competition_id = ?
INSERT INTO player_score (id, tenant_id, player_id, competition_id, score, row_num, created_at, updated_at) VALUES ('9fa5252f', 143, '9fa52401', '9fa5252a', 100, 1, 1659161416, 1659161416) -- INSERT INTO player_score (id, tenant_id, player_id, competition_id, score, row_num, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?)

SELECT * FROM tenant WHERE id = 143 -- SELECT * FROM tenant WHERE id = ?
no warning
INSERT INTO visit_history (player_id, tenant_id, competition_id, created_at, updated_at) VALUES ('9fa52401', 143, '9fa5252a', 1659161417, 1659161417) -- INSERT INTO visit_history (player_id, tenant_id, competition_id, created_at, updated_at) VALUES (?, ?, ?, ?, ?)

SELECT * FROM player_score WHERE tenant_id = 145 AND competition_id = '9fa52407' ORDER BY row_num DESC -- SELECT * FROM player_score WHERE tenant_id = ? AND competition_id = ? ORDER BY row_num DESC
SELECT * FROM competition WHERE tenant_id = 145 ORDER BY created_at ASC -- SELECT * FROM competition WHERE tenant_id = ? ORDER BY created_at ASC
SELECT * FROM player_score WHERE tenant_id = 145 AND competition_id = '9fa52407' AND player_id = '9fa52465' ORDER BY row_num DESC LIMIT 1 -- SELECT * FROM player_score WHERE tenant_id = ? AND competition_id = ? AND player_id = ? ORDER BY row_num DESC LIMIT 1
SELECT * FROM competition WHERE tenant_id=143 ORDER BY created_at DESC -- SELECT * FROM competition WHERE tenant_id=? ORDER BY created_at DESC
