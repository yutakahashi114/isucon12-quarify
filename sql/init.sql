DELETE FROM tenant WHERE id > 100;
DELETE FROM visit_history WHERE created_at >= '1654041600';
DELETE FROM visit_history_2 WHERE created_at >= '1654041600';
UPDATE id_generator SET id=2678400000 WHERE stub='a';
ALTER TABLE id_generator AUTO_INCREMENT=2678400000;

-- DROP TABLE IF EXISTS `visit_history_2`;

-- CREATE TABLE `visit_history_2` (
--   `player_id` VARCHAR(255) NOT NULL,
--   `tenant_id` BIGINT UNSIGNED NOT NULL,
--   `competition_id` VARCHAR(255) NOT NULL,
--   `created_at` BIGINT NOT NULL,
--   `updated_at` BIGINT NOT NULL,
--   PRIMARY KEY (`tenant_id`, `competition_id`, `player_id`)
-- ) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8mb4;

-- INSERT INTO visit_history_2 SELECT player_id, tenant_id, competition_id, min(created_at) AS created_at, min(created_at) AS updated_at FROM visit_history GROUP BY `tenant_id`, `competition_id`, `player_id`

DROP TABLE IF EXISTS `billing`;

CREATE TABLE `billing` (
  `tenant_id` BIGINT UNSIGNED NOT NULL,
  `competition_id` VARCHAR(255) NOT NULL,
  `player` BIGINT NOT NULL,
  `visitor` BIGINT NOT NULL,
  `yen` BIGINT NOT NULL,
  PRIMARY KEY (`tenant_id`, `competition_id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8mb4;
