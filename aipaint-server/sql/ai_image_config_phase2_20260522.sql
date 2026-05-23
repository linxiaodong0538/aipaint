-- AI 生图配置二期：主备自动容灾 + 通道调用日志

insert into sys_config (config_name, config_key, config_value, config_type, create_by, create_time, remark)
select 'AI生图-失败自动切备用', 'ai.image.fallbackEnabled', 'true', 'Y', 'admin', sysdate(), 'true 开启主通道失败自动尝试备用通道，false 关闭'
where not exists (select 1 from sys_config where config_key = 'ai.image.fallbackEnabled');

insert into sys_config (config_name, config_key, config_value, config_type, create_by, create_time, remark)
select 'AI生图-切换策略', 'ai.image.fallbackStrategy', 'fallback', 'Y', 'admin', sysdate(), 'manual=仅手动切换，fallback=失败自动切备用，circuit-breaker=连续失败熔断主通道'
where not exists (select 1 from sys_config where config_key = 'ai.image.fallbackStrategy');

insert into sys_config (config_name, config_key, config_value, config_type, create_by, create_time, remark)
select 'AI生图-熔断失败阈值', 'ai.image.circuitBreaker.failureThreshold', '3', 'Y', 'admin', sysdate(), '连续失败达到该次数后临时熔断主通道'
where not exists (select 1 from sys_config where config_key = 'ai.image.circuitBreaker.failureThreshold');

insert into sys_config (config_name, config_key, config_value, config_type, create_by, create_time, remark)
select 'AI生图-熔断冷却分钟', 'ai.image.circuitBreaker.cooldownMinutes', '10', 'Y', 'admin', sysdate(), '只统计冷却窗口内的连续失败'
where not exists (select 1 from sys_config where config_key = 'ai.image.circuitBreaker.cooldownMinutes');

create table if not exists ai_image_provider_call_log (
  log_id bigint(20) not null auto_increment comment '日志ID',
  task_id bigint(20) not null comment '任务ID',
  provider_code varchar(32) not null comment '通道编码：primary/backup',
  provider_name varchar(64) default null comment '通道名称',
  model varchar(64) default null comment '模型',
  quality varchar(32) default null comment '质量',
  size varchar(32) default null comment '尺寸',
  status varchar(20) not null comment '调用状态：success/failed',
  fallback_used tinyint(1) not null default 0 comment '是否备用通道兜底调用',
  duration_ms bigint(20) default null comment '调用耗时毫秒',
  error_message varchar(1000) default null comment '错误信息',
  create_time datetime default null comment '创建时间',
  primary key (log_id),
  key idx_ai_image_call_task (task_id),
  key idx_ai_image_call_provider_time (provider_code, create_time),
  key idx_ai_image_call_status_time (status, create_time)
) engine=innodb auto_increment=1 default charset=utf8mb4 comment='AI图片通道调用日志';
