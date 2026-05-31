CREATE TABLE IF NOT EXISTS `ai_template_favorite` (
  `favorite_id` bigint NOT NULL AUTO_INCREMENT COMMENT '收藏ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `template_id` bigint NOT NULL COMMENT '模板ID',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`favorite_id`),
  UNIQUE KEY `uk_ai_template_favorite_user_template` (`user_id`, `template_id`),
  KEY `idx_ai_template_favorite_template_id` (`template_id`),
  KEY `idx_ai_template_favorite_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='模板收藏';
