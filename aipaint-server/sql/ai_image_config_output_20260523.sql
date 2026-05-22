-- AI 生图配置补充：输出格式与 JPEG 压缩强度

insert into sys_config (config_name, config_key, config_value, config_type, create_by, create_time, remark)
select 'AI生图-输出格式', 'ai.image.outputFormat', 'jpeg', 'Y', 'admin', sysdate(), '输出格式，支持 jpeg / png'
where not exists (select 1 from sys_config where config_key = 'ai.image.outputFormat');

insert into sys_config (config_name, config_key, config_value, config_type, create_by, create_time, remark)
select 'AI生图-JPEG压缩强度', 'ai.image.outputCompression', '90', 'Y', 'admin', sysdate(), 'JPEG 压缩强度，范围 0-100，仅 outputFormat=jpeg 时生效'
where not exists (select 1 from sys_config where config_key = 'ai.image.outputCompression');
