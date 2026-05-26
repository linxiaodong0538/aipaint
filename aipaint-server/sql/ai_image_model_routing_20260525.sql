create table if not exists ai_image_provider (
  provider_code varchar(32) not null comment '通道编码',
  provider_name varchar(100) not null comment '通道名称',
  adapter_type varchar(64) not null comment '接口协议/适配器类型',
  response_mode varchar(32) not null default 'json' comment 'OpenAI兼容响应模式：json/stream',
  base_url varchar(500) not null default '' comment 'Base URL',
  api_key varchar(500) not null default '' comment 'API Key',
  enabled tinyint(1) not null default 0 comment '是否启用',
  sort_order int not null default 0 comment '排序',
  remark varchar(500) default null comment '备注',
  create_time datetime default null,
  update_time datetime default null,
  primary key (provider_code)
) comment='AI图片通道配置';

create table if not exists ai_image_provider_model (
  provider_code varchar(32) not null comment '通道编码',
  model varchar(100) not null comment '模型',
  enabled tinyint(1) not null default 1 comment '是否启用',
  create_time datetime default null,
  update_time datetime default null,
  primary key (provider_code, model),
  constraint fk_ai_image_provider_model_provider foreign key (provider_code) references ai_image_provider(provider_code)
) comment='AI图片通道支持模型';

create table if not exists ai_image_model_route (
  model varchar(100) not null comment '模型',
  enabled tinyint(1) not null default 1 comment '是否启用',
  primary_provider_code varchar(32) not null comment '主通道编码',
  backup_provider_code varchar(32) default null comment '备用通道编码',
  fallback_enabled tinyint(1) not null default 1 comment '是否失败切备用',
  sort_order int not null default 0 comment '排序',
  remark varchar(500) default null comment '备注',
  create_time datetime default null,
  update_time datetime default null,
  primary key (model),
  constraint fk_ai_image_route_primary foreign key (primary_provider_code) references ai_image_provider(provider_code),
  constraint fk_ai_image_route_backup foreign key (backup_provider_code) references ai_image_provider(provider_code)
) comment='AI图片模型路由';

set @ai_image_provider_response_mode_sql = (
  select if(
    count(*) = 0,
    'alter table ai_image_provider add column response_mode varchar(32) not null default ''json'' comment ''OpenAI兼容响应模式：json/stream'' after adapter_type',
    'select 1'
  )
  from information_schema.columns
  where table_schema = database()
    and table_name = 'ai_image_provider'
    and column_name = 'response_mode'
);
prepare ai_image_provider_response_mode_stmt from @ai_image_provider_response_mode_sql;
execute ai_image_provider_response_mode_stmt;
deallocate prepare ai_image_provider_response_mode_stmt;

insert into ai_image_provider(provider_code, provider_name, adapter_type, response_mode, base_url, api_key, enabled, sort_order, remark, create_time, update_time)
select 'superapi',
       'SuperAPI 中转站',
       'openai-compatible',
       'stream',
       coalesce((select config_value from sys_config where config_key = 'ai.image.primary.baseUrl' limit 1), ''),
       coalesce((select config_value from sys_config where config_key = 'ai.image.primary.apiKey' limit 1), ''),
       coalesce((select config_value from sys_config where config_key = 'ai.image.primary.enabled' limit 1), 'false') = 'true',
       1,
       '默认 GPT 主通道',
       sysdate(),
       sysdate()
where not exists (select 1 from ai_image_provider where provider_code = 'superapi');

insert into ai_image_provider(provider_code, provider_name, adapter_type, response_mode, base_url, api_key, enabled, sort_order, remark, create_time, update_time)
select 'grsai',
       'Grsai 中转站',
       'grsai-async',
       'json',
       '',
       '',
       false,
       2,
       '支持 GPT 与 nano-banana 的中转站',
       sysdate(),
       sysdate()
where not exists (select 1 from ai_image_provider where provider_code = 'grsai');

insert into ai_image_provider_model(provider_code, model, enabled, create_time, update_time)
select 'superapi', 'gpt-image-2', true, sysdate(), sysdate()
where not exists (select 1 from ai_image_provider_model where provider_code = 'superapi' and model = 'gpt-image-2');

insert into ai_image_provider_model(provider_code, model, enabled, create_time, update_time)
select 'grsai', 'gpt-image-2', true, sysdate(), sysdate()
where not exists (select 1 from ai_image_provider_model where provider_code = 'grsai' and model = 'gpt-image-2');

insert into ai_image_provider_model(provider_code, model, enabled, create_time, update_time)
select 'grsai', 'nano-banana-2', true, sysdate(), sysdate()
where not exists (select 1 from ai_image_provider_model where provider_code = 'grsai' and model = 'nano-banana-2');

insert into ai_image_provider_model(provider_code, model, enabled, create_time, update_time)
select 'grsai', 'gpt-image-2-vip', true, sysdate(), sysdate()
where not exists (select 1 from ai_image_provider_model where provider_code = 'grsai' and model = 'gpt-image-2-vip');

insert into ai_image_provider_model(provider_code, model, enabled, create_time, update_time)
select 'grsai', 'nano-banana-pro', true, sysdate(), sysdate()
where not exists (select 1 from ai_image_provider_model where provider_code = 'grsai' and model = 'nano-banana-pro');

insert into ai_image_provider_model(provider_code, model, enabled, create_time, update_time)
select 'grsai', 'nano-banana', true, sysdate(), sysdate()
where not exists (select 1 from ai_image_provider_model where provider_code = 'grsai' and model = 'nano-banana');

insert into ai_image_model_route(model, enabled, primary_provider_code, backup_provider_code, fallback_enabled, sort_order, remark, create_time, update_time)
select 'gpt-image-2', true, 'superapi', 'grsai', true, 1, 'GPT 主用 SuperAPI，失败切 Grsai', sysdate(), sysdate()
where not exists (select 1 from ai_image_model_route where model = 'gpt-image-2');

insert into ai_image_model_route(model, enabled, primary_provider_code, backup_provider_code, fallback_enabled, sort_order, remark, create_time, update_time)
select 'gpt-image-2-vip', true, 'grsai', null, false, 2, 'GPT VIP 固定走 Grsai', sysdate(), sysdate()
where not exists (select 1 from ai_image_model_route where model = 'gpt-image-2-vip');

insert into ai_image_model_route(model, enabled, primary_provider_code, backup_provider_code, fallback_enabled, sort_order, remark, create_time, update_time)
select 'nano-banana-2', true, 'grsai', null, false, 3, 'nano-banana-2 固定走 Grsai', sysdate(), sysdate()
where not exists (select 1 from ai_image_model_route where model = 'nano-banana-2');

insert into ai_image_model_route(model, enabled, primary_provider_code, backup_provider_code, fallback_enabled, sort_order, remark, create_time, update_time)
select 'nano-banana-pro', true, 'grsai', null, false, 4, 'nano-banana-pro 固定走 Grsai', sysdate(), sysdate()
where not exists (select 1 from ai_image_model_route where model = 'nano-banana-pro');

insert into ai_image_model_route(model, enabled, primary_provider_code, backup_provider_code, fallback_enabled, sort_order, remark, create_time, update_time)
select 'nano-banana', true, 'grsai', null, false, 5, 'nano-banana 固定走 Grsai', sysdate(), sysdate()
where not exists (select 1 from ai_image_model_route where model = 'nano-banana');
