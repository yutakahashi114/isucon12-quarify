SELECT * FROM competition WHERE tenant_id=20 -- SELECT * FROM competition WHERE tenant_id=?
SELECT * FROM competition WHERE id = '15f0c2a29' -- SELECT * FROM competition WHERE id = ?
SELECT player_id, created_at AS min_created_at FROM visit_history_2 WHERE tenant_id = 20 AND competition_id = '409facade' -- SELECT player_id, created_at AS min_created_at FROM visit_history_2 WHERE tenant_id = ? AND competition_id = ?
no warning
SELECT DISTINCT(player_id) FROM player_score WHERE tenant_id = 20 AND competition_id = '409facade' -- SELECT DISTINCT(player_id) FROM player_score WHERE tenant_id = ? AND competition_id = ?
