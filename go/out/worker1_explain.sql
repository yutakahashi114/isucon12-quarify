INSERT INTO tenant (name, display_name, created_at, updated_at) VALUES ('j-un-1659163978', 'チーム無職ビーチ', 1659163978, 1659163978) -- INSERT INTO tenant (name, display_name, created_at, updated_at) VALUES (?, ?, ?, ?)

SELECT * FROM tenant WHERE name = 'j-un-1659163978' -- SELECT * FROM tenant WHERE name = ?
no warning
SELECT * FROM tenant ORDER BY id DESC -- SELECT * FROM tenant ORDER BY id DESC
no warning
SELECT * FROM competition WHERE tenant_id=24 -- SELECT * FROM competition WHERE tenant_id=?
SELECT * FROM competition WHERE id = '21a27cad0' -- SELECT * FROM competition WHERE id = ?
REPLACE INTO id_generator (stub) VALUES ('a'); -- REPLACE INTO id_generator (stub) VALUES (?);

SELECT player_id, MIN(created_at) AS min_created_at FROM visit_history WHERE tenant_id = 24 AND competition_id = '21a27cad0' GROUP BY player_id -- SELECT player_id, MIN(created_at) AS min_created_at FROM visit_history WHERE tenant_id = ? AND competition_id = ? GROUP BY player_id
クエリの実行に一時テーブルを必要としています
+----+-------------+---------------+------------+------+---------------+---------------+---------+-------+------+-----------+------------------------------+
| ID | SELECT TYPE |     TABLE     | PARTITIONS | TYPE | POSSIBLE KEYS |      KEY      | KEY LEN |  REF  | ROWS | FILTERED  |            EXTRA             |
+----+-------------+---------------+------------+------+---------------+---------------+---------+-------+------+-----------+------------------------------+
|  1 | SIMPLE      | visit_history | NULL       | ref  | tenant_id_idx | tenant_id_idx |       8 | const | 5480 | 10.000000 | Using where; Using temporary |
+----+-------------+---------------+------------+------+---------------+---------------+---------+-------+------+-----------+------------------------------+

SELECT DISTINCT(player_id) FROM player_score WHERE tenant_id = 24 AND competition_id = '21a27cad0' -- SELECT DISTINCT(player_id) FROM player_score WHERE tenant_id = ? AND competition_id = ?
INSERT INTO player (id, tenant_id, display_name, is_disqualified, created_at, updated_at) VALUES ('9fa52401', 186, 'validate_player0', false, 1659163978, 1659163978) -- INSERT INTO player (id, tenant_id, display_name, is_disqualified, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?)

SELECT * FROM player WHERE id = '9fa52401' -- SELECT * FROM player WHERE id = ?
INSERT INTO competition (id, tenant_id, title, finished_at, created_at, updated_at) VALUES ('9fa52406', 188, '聖なるfailします', <nil>, 1659163978, 1659163978) -- INSERT INTO competition (id, tenant_id, title, finished_at, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?)

SELECT * FROM player WHERE tenant_id=186 ORDER BY created_at DESC -- SELECT * FROM player WHERE tenant_id=? ORDER BY created_at DESC
UPDATE player SET is_disqualified = true, updated_at = 1659163979 WHERE id = '9fa5251a' -- UPDATE player SET is_disqualified = ?, updated_at = ? WHERE id = ?
UPDATE competition SET finished_at = 1659163979, updated_at = 1659163979 WHERE id = '9fa52544' -- UPDATE competition SET finished_at = ?, updated_at = ? WHERE id = ?
DELETE FROM player_score WHERE tenant_id = 186 AND competition_id = '9fa52521' -- DELETE FROM player_score WHERE tenant_id = ? AND competition_id = ?
INSERT INTO player_score (id, tenant_id, player_id, competition_id, score, row_num, created_at, updated_at) VALUES ('9fa52526', 186, '9fa52401', '9fa52521', 100, 1, 1659163979, 1659163979) -- INSERT INTO player_score (id, tenant_id, player_id, competition_id, score, row_num, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?)

SELECT * FROM tenant WHERE id = 186 -- SELECT * FROM tenant WHERE id = ?
no warning
INSERT INTO visit_history (player_id, tenant_id, competition_id, created_at, updated_at) VALUES ('9fa52401', 186, '9fa52521', 1659163980, 1659163980) -- INSERT INTO visit_history (player_id, tenant_id, competition_id, created_at, updated_at) VALUES (?, ?, ?, ?, ?)

SELECT player_score.*, display_name FROM player_score INNER JOIN (
			SELECT player_id, max(row_num) AS row_num FROM player_score WHERE tenant_id = 188 AND competition_id = '9fa52406' GROUP BY player_id
		) AS c ON (
			player_score.player_id = c.player_id
			AND player_score.row_num = c.row_num
			AND player_score.tenant_id = 188 AND player_score.competition_id = '9fa52406'
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
		
SELECT * FROM competition WHERE tenant_id = 188 ORDER BY created_at ASC -- SELECT * FROM competition WHERE tenant_id = ? ORDER BY created_at ASC
SELECT * FROM player_score WHERE tenant_id = 188 AND competition_id = '9fa52406' AND player_id = '9fa52465' ORDER BY row_num DESC LIMIT 1 -- SELECT * FROM player_score WHERE tenant_id = ? AND competition_id = ? AND player_id = ? ORDER BY row_num DESC LIMIT 1
SELECT * FROM competition WHERE tenant_id=186 ORDER BY created_at DESC -- SELECT * FROM competition WHERE tenant_id=? ORDER BY created_at DESC
