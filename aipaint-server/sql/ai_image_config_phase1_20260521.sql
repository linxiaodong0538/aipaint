-- 1) 如果 provider_code 还没加，就手动加一次
ALTER TABLE ai_generation_task
ADD COLUMN provider_code varchar(32) NOT NULL DEFAULT '' COMMENT '提供方编码' AFTER user_id;

-- 2) 初始化 sys_config
INSERT INTO sys_config (config_name, config_key, config_value, config_type, create_by, create_time, remark)
SELECT 'AI生图-当前生效通道', 'ai.image.activeProvider', 'backup', 'Y', 'admin', SYSDATE(), 'primary=主通道，backup=备用通道'
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_config WHERE config_key = 'ai.image.activeProvider');

INSERT INTO sys_config (config_name, config_key, config_value, config_type, create_by, create_time, remark)
SELECT 'AI生图-强制尺寸开关', 'ai.image.forceSizeEnabled', 'false', 'Y', 'admin', SYSDATE(), 'true 开启固定尺寸，false 按比例自动推导'
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_config WHERE config_key = 'ai.image.forceSizeEnabled');

INSERT INTO sys_config (config_name, config_key, config_value, config_type, create_by, create_time, remark)
SELECT 'AI生图-强制尺寸', 'ai.image.forceSize', '1024x1024', 'Y', 'admin', SYSDATE(), '可选值：1024x1024、1536x1024、1024x1536'
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_config WHERE config_key = 'ai.image.forceSize');

INSERT INTO sys_config (config_name, config_key, config_value, config_type, create_by, create_time, remark)
SELECT 'AI生图-主通道-名称', 'ai.image.primary.name', '主通道', 'Y', 'admin', SYSDATE(), '通道展示名称'
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_config WHERE config_key = 'ai.image.primary.name');

INSERT INTO sys_config (config_name, config_key, config_value, config_type, create_by, create_time, remark)
SELECT 'AI生图-主通道-启用', 'ai.image.primary.enabled', 'false', 'Y', 'admin', SYSDATE(), 'true 启用，false 停用'
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_config WHERE config_key = 'ai.image.primary.enabled');

INSERT INTO sys_config (config_name, config_key, config_value, config_type, create_by, create_time, remark)
SELECT 'AI生图-主通道-类型', 'ai.image.primary.type', 'openai-compatible', 'Y', 'admin', SYSDATE(), '当前支持 openai-compatible'
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_config WHERE config_key = 'ai.image.primary.type');

INSERT INTO sys_config (config_name, config_key, config_value, config_type, create_by, create_time, remark)
SELECT 'AI生图-主通道-BaseURL', 'ai.image.primary.baseUrl', '', 'Y', 'admin', SYSDATE(), '图片生成接口基础地址'
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_config WHERE config_key = 'ai.image.primary.baseUrl');

INSERT INTO sys_config (config_name, config_key, config_value, config_type, create_by, create_time, remark)
SELECT 'AI生图-主通道-APIKey', 'ai.image.primary.apiKey', '', 'Y', 'admin', SYSDATE(), '图片生成接口密钥'
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_config WHERE config_key = 'ai.image.primary.apiKey');

INSERT INTO sys_config (config_name, config_key, config_value, config_type, create_by, create_time, remark)
SELECT 'AI生图-主通道-模型', 'ai.image.primary.model', 'gpt-image-2', 'Y', 'admin', SYSDATE(), '例如 gpt-image-2'
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_config WHERE config_key = 'ai.image.primary.model');

INSERT INTO sys_config (config_name, config_key, config_value, config_type, create_by, create_time, remark)
SELECT 'AI生图-备用通道-名称', 'ai.image.backup.name', '备用通道', 'Y', 'admin', SYSDATE(), '通道展示名称'
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_config WHERE config_key = 'ai.image.backup.name');

INSERT INTO sys_config (config_name, config_key, config_value, config_type, create_by, create_time, remark)
SELECT 'AI生图-备用通道-启用', 'ai.image.backup.enabled', 'true', 'Y', 'admin', SYSDATE(), 'true 启用，false 停用'
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_config WHERE config_key = 'ai.image.backup.enabled');

INSERT INTO sys_config (config_name, config_key, config_value, config_type, create_by, create_time, remark)
SELECT 'AI生图-备用通道-类型', 'ai.image.backup.type', 'openai-compatible', 'Y', 'admin', SYSDATE(), '当前支持 openai-compatible'
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_config WHERE config_key = 'ai.image.backup.type');

INSERT INTO sys_config (config_name, config_key, config_value, config_type, create_by, create_time, remark)
SELECT 'AI生图-备用通道-BaseURL', 'ai.image.backup.baseUrl', 'https://dm-fox.rjj.cc/codex/v1', 'Y', 'admin', SYSDATE(), '图片生成接口基础地址'
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_config WHERE config_key = 'ai.image.backup.baseUrl');

INSERT INTO sys_config (config_name, config_key, config_value, config_type, create_by, create_time, remark)
SELECT 'AI生图-备用通道-APIKey', 'ai.image.backup.apiKey', '', 'Y', 'admin', SYSDATE(), '图片生成接口密钥'
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_config WHERE config_key = 'ai.image.backup.apiKey');

INSERT INTO sys_config (config_name, config_key, config_value, config_type, create_by, create_time, remark)
SELECT 'AI生图-备用通道-模型', 'ai.image.backup.model', 'gpt-image-2', 'Y', 'admin', SYSDATE(), '例如 gpt-image-2'
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_config WHERE config_key = 'ai.image.backup.model');

-- 3) 菜单
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
SELECT 2008, '生图配置', 2000, 3, 'image-config', 'system/aiImageConfig/index', '', '', 1, 0, 'C', '0', '0', 'system:aiImageConfig:query', 'edit', 'admin', SYSDATE(), '', NULL, 'AI生图配置菜单'
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE menu_id = 2008);

INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
SELECT 2009, '生图配置查询', 2008, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:aiImageConfig:query', '#', 'admin', SYSDATE(), '', NULL, ''
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE menu_id = 2009);

INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
SELECT 2010, '生图配置修改', 2008, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:aiImageConfig:edit', '#', 'admin', SYSDATE(), '', NULL, ''
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE menu_id = 2010);

INSERT INTO sys_role_menu (role_id, menu_id)
SELECT 2, 2008
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_role_menu WHERE role_id = 2 AND menu_id = 2008);

INSERT INTO sys_role_menu (role_id, menu_id)
SELECT 2, 2009
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_role_menu WHERE role_id = 2 AND menu_id = 2009);

INSERT INTO sys_role_menu (role_id, menu_id)
SELECT 2, 2010
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_role_menu WHERE role_id = 2 AND menu_id = 2010);