create table if not exists ai_template_tag (
  tag_id bigint not null auto_increment comment '标签ID',
  tag_name varchar(50) not null comment '标签名称',
  group_code varchar(30) not null comment '分组编码(style/use/subject/element/scene/medium/composition/color/technique)',
  sort int default 0 comment '排序',
  status char(1) default '0' comment '状态（0正常 1停用）',
  create_by varchar(64) default '' comment '创建者',
  create_time datetime default null comment '创建时间',
  update_by varchar(64) default '' comment '更新者',
  update_time datetime default null comment '更新时间',
  remark varchar(500) default null comment '备注',
  primary key (tag_id),
  unique key uk_ai_template_tag_name_group (tag_name, group_code),
  key idx_ai_template_tag_group_status_sort (group_code, status, sort)
) engine=InnoDB default charset=utf8mb4 comment='生图模板标签表';

create table if not exists ai_template_tag_relation (
  template_id bigint not null comment '模板ID',
  tag_id bigint not null comment '标签ID',
  primary key (template_id, tag_id),
  key idx_ai_template_tag_relation_tag (tag_id)
) engine=InnoDB default charset=utf8mb4 comment='生图模板标签关联表';

insert into sys_menu
  (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select '模板标签', 2000, 4, 'template-tag', 'system/template/tag/index', '', '', 1, 0, 'C', '0', '0', 'system:template:list', 'skill', 'admin', sysdate(), '', null, '模板标签菜单'
where not exists (select 1 from sys_menu where parent_id = 2000 and path = 'template-tag');

insert into sys_role_menu (role_id, menu_id)
select distinct rm.role_id, m.menu_id
from sys_role_menu rm
inner join sys_menu m on m.parent_id = 2000 and m.path = 'template-tag'
where rm.menu_id in (2000, 2001, 2002, 2008)
  and not exists (
    select 1 from sys_role_menu exists_rm
    where exists_rm.role_id = rm.role_id and exists_rm.menu_id = m.menu_id
  );

insert into ai_template_tag
  (tag_name, group_code, sort, status, create_by, create_time, update_by, update_time, remark)
select '极简', 'style', 1, '0', 'admin', sysdate(), '', null, null
where not exists (select 1 from ai_template_tag where tag_name = '极简' and group_code = 'style');

insert into ai_template_tag
  (tag_name, group_code, sort, status, create_by, create_time, update_by, update_time, remark)
select '水墨', 'style', 2, '0', 'admin', sysdate(), '', null, null
where not exists (select 1 from ai_template_tag where tag_name = '水墨' and group_code = 'style');

insert into ai_template_tag
  (tag_name, group_code, sort, status, create_by, create_time, update_by, update_time, remark)
select '超现实', 'style', 3, '0', 'admin', sysdate(), '', null, null
where not exists (select 1 from ai_template_tag where tag_name = '超现实' and group_code = 'style');

insert into ai_template_tag
  (tag_name, group_code, sort, status, create_by, create_time, update_by, update_time, remark)
select '海报营销', 'use', 1, '0', 'admin', sysdate(), '', null, null
where not exists (select 1 from ai_template_tag where tag_name = '海报营销' and group_code = 'use');

insert into ai_template_tag
  (tag_name, group_code, sort, status, create_by, create_time, update_by, update_time, remark)
select '电商主图', 'use', 2, '0', 'admin', sysdate(), '', null, null
where not exists (select 1 from ai_template_tag where tag_name = '电商主图' and group_code = 'use');

insert into ai_template_tag
  (tag_name, group_code, sort, status, create_by, create_time, update_by, update_time, remark)
select '球鞋', 'subject', 1, '0', 'admin', sysdate(), '', null, null
where not exists (select 1 from ai_template_tag where tag_name = '球鞋' and group_code = 'subject');

insert into ai_template_tag
  (tag_name, group_code, sort, status, create_by, create_time, update_by, update_time, remark)
select '火焰', 'element', 1, '0', 'admin', sysdate(), '', null, null
where not exists (select 1 from ai_template_tag where tag_name = '火焰' and group_code = 'element');

insert into ai_template_tag
  (tag_name, group_code, sort, status, create_by, create_time, update_by, update_time, remark)
select '餐饮', 'scene', 1, '0', 'admin', sysdate(), '', null, null
where not exists (select 1 from ai_template_tag where tag_name = '餐饮' and group_code = 'scene');

insert into ai_template_tag
  (tag_name, group_code, sort, status, create_by, create_time, update_by, update_time, remark)
select '服饰', 'scene', 2, '0', 'admin', sysdate(), '', null, null
where not exists (select 1 from ai_template_tag where tag_name = '服饰' and group_code = 'scene');

insert into ai_template_tag
  (tag_name, group_code, sort, status, create_by, create_time, update_by, update_time, remark)
select '美妆', 'scene', 3, '0', 'admin', sysdate(), '', null, null
where not exists (select 1 from ai_template_tag where tag_name = '美妆' and group_code = 'scene');

insert into ai_template_tag
  (tag_name, group_code, sort, status, create_by, create_time, update_by, update_time, remark)
select '摄影', 'medium', 1, '0', 'admin', sysdate(), '', null, null
where not exists (select 1 from ai_template_tag where tag_name = '摄影' and group_code = 'medium');

insert into ai_template_tag
  (tag_name, group_code, sort, status, create_by, create_time, update_by, update_time, remark)
select '插画', 'medium', 2, '0', 'admin', sysdate(), '', null, null
where not exists (select 1 from ai_template_tag where tag_name = '插画' and group_code = 'medium');

insert into ai_template_tag
  (tag_name, group_code, sort, status, create_by, create_time, update_by, update_time, remark)
select '3D', 'medium', 3, '0', 'admin', sysdate(), '', null, null
where not exists (select 1 from ai_template_tag where tag_name = '3D' and group_code = 'medium');

insert into ai_template_tag
  (tag_name, group_code, sort, status, create_by, create_time, update_by, update_time, remark)
select '俯拍', 'composition', 1, '0', 'admin', sysdate(), '', null, null
where not exists (select 1 from ai_template_tag where tag_name = '俯拍' and group_code = 'composition');

insert into ai_template_tag
  (tag_name, group_code, sort, status, create_by, create_time, update_by, update_time, remark)
select '特写', 'composition', 2, '0', 'admin', sysdate(), '', null, null
where not exists (select 1 from ai_template_tag where tag_name = '特写' and group_code = 'composition');

insert into ai_template_tag
  (tag_name, group_code, sort, status, create_by, create_time, update_by, update_time, remark)
select '留白', 'composition', 3, '0', 'admin', sysdate(), '', null, null
where not exists (select 1 from ai_template_tag where tag_name = '留白' and group_code = 'composition');

insert into ai_template_tag
  (tag_name, group_code, sort, status, create_by, create_time, update_by, update_time, remark)
select '黑金', 'color', 1, '0', 'admin', sysdate(), '', null, null
where not exists (select 1 from ai_template_tag where tag_name = '黑金' and group_code = 'color');

insert into ai_template_tag
  (tag_name, group_code, sort, status, create_by, create_time, update_by, update_time, remark)
select '霓虹蓝', 'color', 2, '0', 'admin', sysdate(), '', null, null
where not exists (select 1 from ai_template_tag where tag_name = '霓虹蓝' and group_code = 'color');

insert into ai_template_tag
  (tag_name, group_code, sort, status, create_by, create_time, update_by, update_time, remark)
select '暗调', 'color', 3, '0', 'admin', sysdate(), '', null, null
where not exists (select 1 from ai_template_tag where tag_name = '暗调' and group_code = 'color');

insert into ai_template_tag
  (tag_name, group_code, sort, status, create_by, create_time, update_by, update_time, remark)
select '写实', 'technique', 1, '0', 'admin', sysdate(), '', null, null
where not exists (select 1 from ai_template_tag where tag_name = '写实' and group_code = 'technique');

insert into ai_template_tag
  (tag_name, group_code, sort, status, create_by, create_time, update_by, update_time, remark)
select '产品摄影', 'technique', 2, '0', 'admin', sysdate(), '', null, null
where not exists (select 1 from ai_template_tag where tag_name = '产品摄影' and group_code = 'technique');

insert into ai_template_tag
  (tag_name, group_code, sort, status, create_by, create_time, update_by, update_time, remark)
select '概念设计', 'technique', 3, '0', 'admin', sysdate(), '', null, null
where not exists (select 1 from ai_template_tag where tag_name = '概念设计' and group_code = 'technique');
