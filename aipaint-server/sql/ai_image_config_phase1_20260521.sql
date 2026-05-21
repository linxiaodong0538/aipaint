alter table ai_generation_task
  add column if not exists provider_code varchar(32) not null default '' comment '提供方编码' after user_id;

insert into sys_config (config_name, config_key, config_value, config_type, create_by, create_time, remark)
select 'AI生图-当前生效通道', 'ai.image.activeProvider', 'backup', 'Y', 'admin', sysdate(), 'primary=主通道，backup=备用通道'
where not exists (select 1 from sys_config where config_key = 'ai.image.activeProvider');

insert into sys_config (config_name, config_key, config_value, config_type, create_by, create_time, remark)
select 'AI生图-强制尺寸开关', 'ai.image.forceSizeEnabled', 'false', 'Y', 'admin', sysdate(), 'true 开启固定尺寸，false 按比例自动推导'
where not exists (select 1 from sys_config where config_key = 'ai.image.forceSizeEnabled');

insert into sys_config (config_name, config_key, config_value, config_type, create_by, create_time, remark)
select 'AI生图-强制尺寸', 'ai.image.forceSize', '1024x1024', 'Y', 'admin', sysdate(), '可选值：1024x1024、1536x1024、1024x1536'
where not exists (select 1 from sys_config where config_key = 'ai.image.forceSize');

insert into sys_config (config_name, config_key, config_value, config_type, create_by, create_time, remark)
select 'AI生图-主通道-名称', 'ai.image.primary.name', '主通道', 'Y', 'admin', sysdate(), '通道展示名称'
where not exists (select 1 from sys_config where config_key = 'ai.image.primary.name');

insert into sys_config (config_name, config_key, config_value, config_type, create_by, create_time, remark)
select 'AI生图-主通道-启用', 'ai.image.primary.enabled', 'false', 'Y', 'admin', sysdate(), 'true 启用，false 停用'
where not exists (select 1 from sys_config where config_key = 'ai.image.primary.enabled');

insert into sys_config (config_name, config_key, config_value, config_type, create_by, create_time, remark)
select 'AI生图-主通道-类型', 'ai.image.primary.type', 'openai-compatible', 'Y', 'admin', sysdate(), '当前支持 openai-compatible'
where not exists (select 1 from sys_config where config_key = 'ai.image.primary.type');

insert into sys_config (config_name, config_key, config_value, config_type, create_by, create_time, remark)
select 'AI生图-主通道-BaseURL', 'ai.image.primary.baseUrl', '', 'Y', 'admin', sysdate(), '图片生成接口基础地址'
where not exists (select 1 from sys_config where config_key = 'ai.image.primary.baseUrl');

insert into sys_config (config_name, config_key, config_value, config_type, create_by, create_time, remark)
select 'AI生图-主通道-APIKey', 'ai.image.primary.apiKey', '', 'Y', 'admin', sysdate(), '图片生成接口密钥'
where not exists (select 1 from sys_config where config_key = 'ai.image.primary.apiKey');

insert into sys_config (config_name, config_key, config_value, config_type, create_by, create_time, remark)
select 'AI生图-主通道-模型', 'ai.image.primary.model', 'gpt-image-2', 'Y', 'admin', sysdate(), '例如 gpt-image-2'
where not exists (select 1 from sys_config where config_key = 'ai.image.primary.model');

insert into sys_config (config_name, config_key, config_value, config_type, create_by, create_time, remark)
select 'AI生图-备用通道-名称', 'ai.image.backup.name', '备用通道', 'Y', 'admin', sysdate(), '通道展示名称'
where not exists (select 1 from sys_config where config_key = 'ai.image.backup.name');

insert into sys_config (config_name, config_key, config_value, config_type, create_by, create_time, remark)
select 'AI生图-备用通道-启用', 'ai.image.backup.enabled', 'true', 'Y', 'admin', sysdate(), 'true 启用，false 停用'
where not exists (select 1 from sys_config where config_key = 'ai.image.backup.enabled');

insert into sys_config (config_name, config_key, config_value, config_type, create_by, create_time, remark)
select 'AI生图-备用通道-类型', 'ai.image.backup.type', 'openai-compatible', 'Y', 'admin', sysdate(), '当前支持 openai-compatible'
where not exists (select 1 from sys_config where config_key = 'ai.image.backup.type');

insert into sys_config (config_name, config_key, config_value, config_type, create_by, create_time, remark)
select 'AI生图-备用通道-BaseURL', 'ai.image.backup.baseUrl', 'https://dm-fox.rjj.cc/codex/v1', 'Y', 'admin', sysdate(), '图片生成接口基础地址'
where not exists (select 1 from sys_config where config_key = 'ai.image.backup.baseUrl');

insert into sys_config (config_name, config_key, config_value, config_type, create_by, create_time, remark)
select 'AI生图-备用通道-APIKey', 'ai.image.backup.apiKey', '', 'Y', 'admin', sysdate(), '图片生成接口密钥'
where not exists (select 1 from sys_config where config_key = 'ai.image.backup.apiKey');

insert into sys_config (config_name, config_key, config_value, config_type, create_by, create_time, remark)
select 'AI生图-备用通道-模型', 'ai.image.backup.model', 'gpt-image-2', 'Y', 'admin', sysdate(), '例如 gpt-image-2'
where not exists (select 1 from sys_config where config_key = 'ai.image.backup.model');

insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 2008, '生图配置', 2000, 3, 'image-config', 'system/aiImageConfig/index', '', '', 1, 0, 'C', '0', '0', 'system:aiImageConfig:query', 'edit', 'admin', sysdate(), '', null, 'AI生图配置菜单'
where not exists (select 1 from sys_menu where menu_id = 2008);

insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 2009, '生图配置查询', 2008, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:aiImageConfig:query', '#', 'admin', sysdate(), '', null, ''
where not exists (select 1 from sys_menu where menu_id = 2009);

insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 2010, '生图配置修改', 2008, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:aiImageConfig:edit', '#', 'admin', sysdate(), '', null, ''
where not exists (select 1 from sys_menu where menu_id = 2010);

insert into sys_role_menu (role_id, menu_id)
select 2, 2008 where not exists (select 1 from sys_role_menu where role_id = 2 and menu_id = 2008);

insert into sys_role_menu (role_id, menu_id)
select 2, 2009 where not exists (select 1 from sys_role_menu where role_id = 2 and menu_id = 2009);

insert into sys_role_menu (role_id, menu_id)
select 2, 2010 where not exists (select 1 from sys_role_menu where role_id = 2 and menu_id = 2010);
