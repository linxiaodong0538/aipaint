CREATE TABLE IF NOT EXISTS `ai_payment_order` (
  `order_id` bigint NOT NULL AUTO_INCREMENT COMMENT '支付订单ID',
  `out_trade_no` varchar(32) NOT NULL COMMENT '商户订单号',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `product_id` varchar(32) NOT NULL COMMENT '商品ID',
  `product_type` varchar(16) NOT NULL COMMENT '商品类型 MEMBERSHIP/ADDON',
  `product_name` varchar(64) NOT NULL COMMENT '商品名称',
  `amount_cent` int NOT NULL COMMENT '支付金额，单位分',
  `credits` int NOT NULL COMMENT '到账积分',
  `member_tier` varchar(16) NULL DEFAULT NULL COMMENT '会员等级',
  `member_days` int NULL DEFAULT NULL COMMENT '会员天数',
  `status` varchar(16) NOT NULL DEFAULT 'CREATED' COMMENT '订单状态 CREATED/PAID/CLOSED',
  `transaction_id` varchar(64) NULL DEFAULT NULL COMMENT '微信支付订单号',
  `prepay_id` varchar(128) NULL DEFAULT NULL COMMENT '预支付交易会话ID',
  `paid_time` datetime NULL DEFAULT NULL COMMENT '支付成功时间',
  `expire_time` datetime NULL DEFAULT NULL COMMENT '订单过期时间',
  `notify_time` datetime NULL DEFAULT NULL COMMENT '回调时间',
  `raw_notify` text NULL COMMENT '回调解密报文',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`order_id`),
  UNIQUE KEY `uk_ai_payment_order_trade_no` (`out_trade_no`),
  KEY `idx_ai_payment_order_user_time` (`user_id`, `create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='支付订单表';

CREATE TABLE IF NOT EXISTS `ai_user_membership` (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `member_tier` varchar(16) NOT NULL COMMENT '会员等级 monthly/pro/studio',
  `addon_bonus` int NOT NULL DEFAULT 0 COMMENT '积分加量包加赠百分比',
  `expire_time` datetime NOT NULL COMMENT '会员到期时间',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户会员表';
