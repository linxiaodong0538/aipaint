insert into sys_menu
  (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select '充值订单', 2000, 6, 'payment-order', 'system/payment/index', '', '', 1, 0, 'C', '0', '0', 'system:payment:list', 'money', 'admin', sysdate(), '', null, '充值订单菜单'
where not exists (select 1 from sys_menu where parent_id = 2000 and path = 'payment-order');

insert into sys_menu
  (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select '充值订单查询', m.menu_id, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:payment:list', '#', 'admin', sysdate(), '', null, ''
from sys_menu m
where m.parent_id = 2000 and m.path = 'payment-order'
  and not exists (select 1 from sys_menu where parent_id = m.menu_id and perms = 'system:payment:list');

insert into sys_menu
  (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select '充值订单导出', m.menu_id, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:payment:export', '#', 'admin', sysdate(), '', null, ''
from sys_menu m
where m.parent_id = 2000 and m.path = 'payment-order'
  and not exists (select 1 from sys_menu where parent_id = m.menu_id and perms = 'system:payment:export');

insert into sys_menu
  (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select '充值订单同步', m.menu_id, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:payment:sync', '#', 'admin', sysdate(), '', null, ''
from sys_menu m
where m.parent_id = 2000 and m.path = 'payment-order'
  and not exists (select 1 from sys_menu where parent_id = m.menu_id and perms = 'system:payment:sync');

insert into sys_role_menu (role_id, menu_id)
select distinct rm.role_id, m.menu_id
from sys_role_menu rm
inner join sys_menu m on m.parent_id = 2000 and m.path = 'payment-order'
where rm.menu_id in (2000, 2001, 2002, 2008)
  and not exists (
    select 1 from sys_role_menu exists_rm
    where exists_rm.role_id = rm.role_id and exists_rm.menu_id = m.menu_id
  );

insert into sys_role_menu (role_id, menu_id)
select distinct rm.role_id, child.menu_id
from sys_role_menu rm
inner join sys_menu payment_menu on payment_menu.parent_id = 2000 and payment_menu.path = 'payment-order'
inner join sys_menu child on child.parent_id = payment_menu.menu_id and child.menu_type = 'F'
where rm.menu_id = payment_menu.menu_id
  and not exists (
    select 1 from sys_role_menu exists_rm
    where exists_rm.role_id = rm.role_id and exists_rm.menu_id = child.menu_id
  );
