set names utf8mb4;

create table if not exists ai_image_global_config (
  config_id bigint not null default 1 comment '配置ID，固定为1',
  circuit_breaker_failure_threshold int not null default 3 comment '熔断失败阈值',
  circuit_breaker_cooldown_minutes int not null default 10 comment '熔断冷却分钟',
  output_format varchar(20) not null default 'jpeg' comment '输出格式：jpeg/png',
  output_compression int not null default 90 comment 'JPEG压缩强度，0-100',
  model_pricings json not null comment '模型基础积分价格JSON',
  resolution_multipliers json not null comment '清晰度倍率JSON',
  remark varchar(500) default null comment '备注',
  create_by varchar(64) default '' comment '创建者',
  create_time datetime default null comment '创建时间',
  update_by varchar(64) default '' comment '更新者',
  update_time datetime default null comment '更新时间',
  primary key (config_id)
) comment='AI图片全局配置';

insert into ai_image_global_config (
  config_id,
  circuit_breaker_failure_threshold,
  circuit_breaker_cooldown_minutes,
  output_format,
  output_compression,
  model_pricings,
  resolution_multipliers,
  remark,
  create_by,
  create_time,
  update_by,
  update_time
)
select 1,
       cast(coalesce((select config_value from sys_config where config_key = 'ai.image.circuitBreaker.failureThreshold' limit 1), '3') as unsigned),
       cast(coalesce((select config_value from sys_config where config_key = 'ai.image.circuitBreaker.cooldownMinutes' limit 1), '10') as unsigned),
       coalesce((select config_value from sys_config where config_key = 'ai.image.outputFormat' limit 1), 'jpeg'),
       cast(coalesce((select config_value from sys_config where config_key = 'ai.image.outputCompression' limit 1), '90') as unsigned),
       coalesce(
         (select if(json_valid(config_value), config_value, null) from sys_config where config_key = 'ai.image.pricing.models' limit 1),
         '[{"model":"gpt-image-2","baseCredits":6,"enabled":true,"sortOrder":1,"remark":"default"},{"model":"gpt-image-2-vip","baseCredits":15,"enabled":true,"sortOrder":2,"remark":"vip"},{"model":"nano-banana","baseCredits":5,"enabled":true,"sortOrder":3,"remark":"fast"},{"model":"nano-banana-2","baseCredits":12,"enabled":true,"sortOrder":4,"remark":"photo"},{"model":"nano-banana-pro","baseCredits":20,"enabled":true,"sortOrder":5,"remark":"pro"}]'
       ),
       coalesce(
         (select if(json_valid(config_value), config_value, null) from sys_config where config_key = 'ai.image.pricing.resolutionMultipliers' limit 1),
         '{"1K":1.0,"2K":1.2,"4K":1.5}'
       ),
       'AI image global config',
       'admin',
       sysdate(),
       'admin',
       sysdate()
where not exists (select 1 from ai_image_global_config where config_id = 1);

delete from sys_config
where config_key in (
  'ai.image.activeProvider',
  'ai.image.forceSizeEnabled',
  'ai.image.forceSize',
  'ai.image.primary.name',
  'ai.image.primary.enabled',
  'ai.image.primary.type',
  'ai.image.primary.baseUrl',
  'ai.image.primary.apiKey',
  'ai.image.primary.model',
  'ai.image.backup.name',
  'ai.image.backup.enabled',
  'ai.image.backup.type',
  'ai.image.backup.baseUrl',
  'ai.image.backup.apiKey',
  'ai.image.backup.model',
  'ai.image.fallbackEnabled',
  'ai.image.fallbackStrategy',
  'ai.image.circuitBreaker.failureThreshold',
  'ai.image.circuitBreaker.cooldownMinutes',
  'ai.image.outputFormat',
  'ai.image.outputCompression',
  'ai.image.pricing.models',
  'ai.image.pricing.resolutionMultipliers'
);
