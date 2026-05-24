CREATE TABLE IF NOT EXISTS `ai_credit_batch` (
  `batch_id` bigint NOT NULL AUTO_INCREMENT COMMENT '积分批次ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `source_type` varchar(32) NOT NULL COMMENT '来源类型',
  `source_id` varchar(64) NOT NULL DEFAULT '' COMMENT '来源ID',
  `total_amount` int NOT NULL COMMENT '发放积分',
  `remaining_amount` int NOT NULL COMMENT '剩余积分',
  `expire_time` datetime NULL DEFAULT NULL COMMENT '过期时间，空表示长期有效',
  `remark` varchar(255) NULL DEFAULT NULL COMMENT '备注',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`batch_id`),
  UNIQUE KEY `uk_ai_credit_batch_source` (`user_id`, `source_type`, `source_id`),
  KEY `idx_ai_credit_batch_user_expire` (`user_id`, `expire_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户积分批次表';

CREATE TABLE IF NOT EXISTS `ai_credit_record` (
  `record_id` bigint NOT NULL AUTO_INCREMENT COMMENT '积分流水ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `change_type` varchar(32) NOT NULL COMMENT '变动类型',
  `amount` int NOT NULL COMMENT '变动积分，正数增加负数扣减',
  `balance_after` int NOT NULL COMMENT '变动后可用余额',
  `related_type` varchar(32) NULL DEFAULT NULL COMMENT '关联类型',
  `related_id` varchar(64) NULL DEFAULT NULL COMMENT '关联ID',
  `remark` varchar(255) NULL DEFAULT NULL COMMENT '备注',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`record_id`),
  KEY `idx_ai_credit_record_user_time` (`user_id`, `create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户积分流水表';
