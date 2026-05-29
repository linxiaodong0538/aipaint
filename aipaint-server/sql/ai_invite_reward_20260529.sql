CREATE TABLE IF NOT EXISTS `ai_invite_record` (
  `record_id` bigint NOT NULL AUTO_INCREMENT COMMENT '邀请记录ID',
  `inviter_user_id` bigint NOT NULL COMMENT '邀请人用户ID',
  `invited_user_id` bigint NOT NULL COMMENT '被邀请人用户ID',
  `reward_amount` int NOT NULL COMMENT '奖励积分',
  `reward_status` varchar(20) NOT NULL DEFAULT 'GRANTED' COMMENT '奖励状态',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`record_id`),
  UNIQUE KEY `uk_ai_invite_invited` (`invited_user_id`),
  KEY `idx_ai_invite_inviter_time` (`inviter_user_id`, `create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='邀请奖励记录';

insert into sys_menu
  (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select '邀请记录', 2000, 5, 'invite-record', 'system/invite/index', '', '', 1, 0, 'C', '0', '0', 'system:invite:list', 'peoples', 'admin', sysdate(), '', null, '邀请记录菜单'
where not exists (select 1 from sys_menu where parent_id = 2000 and path = 'invite-record');

insert into sys_menu
  (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select '邀请记录查询', m.menu_id, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:invite:list', '#', 'admin', sysdate(), '', null, ''
from sys_menu m
where m.parent_id = 2000 and m.path = 'invite-record'
  and not exists (select 1 from sys_menu where parent_id = m.menu_id and perms = 'system:invite:list');

insert into sys_menu
  (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select '邀请记录导出', m.menu_id, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:invite:export', '#', 'admin', sysdate(), '', null, ''
from sys_menu m
where m.parent_id = 2000 and m.path = 'invite-record'
  and not exists (select 1 from sys_menu where parent_id = m.menu_id and perms = 'system:invite:export');

insert into sys_role_menu (role_id, menu_id)
select distinct rm.role_id, m.menu_id
from sys_role_menu rm
inner join sys_menu m on m.parent_id = 2000 and m.path = 'invite-record'
where rm.menu_id in (2000, 2001, 2002, 2008)
  and not exists (
    select 1 from sys_role_menu exists_rm
    where exists_rm.role_id = rm.role_id and exists_rm.menu_id = m.menu_id
  );

insert into sys_role_menu (role_id, menu_id)
select distinct rm.role_id, child.menu_id
from sys_role_menu rm
inner join sys_menu invite_menu on invite_menu.parent_id = 2000 and invite_menu.path = 'invite-record'
inner join sys_menu child on child.parent_id = invite_menu.menu_id and child.menu_type = 'F'
where rm.menu_id = invite_menu.menu_id
  and not exists (
    select 1 from sys_role_menu exists_rm
    where exists_rm.role_id = rm.role_id and exists_rm.menu_id = child.menu_id
  );
