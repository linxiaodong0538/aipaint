drop table if exists ai_template;
create table ai_template (
  template_id    bigint(20)      not null auto_increment    comment '模板ID',
  title          varchar(80)     not null                   comment '模板标题',
  category       varchar(50)     not null                   comment '分类',
  description    varchar(200)    default ''                 comment '描述',
  cover_url      varchar(1000)   not null                   comment '封面图URL',
  prompt         text            not null                   comment '提示词',
  ai_engine      varchar(50)     default ''                 comment 'AI引擎',
  ratio          varchar(20)     default ''                 comment '画幅比例',
  sort           int(4)          default 0                  comment '排序',
  status         char(1)         default '0'                comment '状态（0正常 1停用）',
  create_by      varchar(64)     default ''                 comment '创建者',
  create_time    datetime                                   comment '创建时间',
  update_by      varchar(64)     default ''                 comment '更新者',
  update_time    datetime                                   comment '更新时间',
  remark         varchar(500)    default null               comment '备注',
  primary key (template_id)
) engine=innodb auto_increment=100 comment = '生图模板表';

insert into ai_template values
(1, '构图几何', '极简主义', '几何建筑风格', 'https://lh3.googleusercontent.com/aida-public/AB6AXuD3axI89PCaiyYvOKhN1Y0L8rUP_5dYHguX_E2SQedMqDNMqel_SuhSzcPMEirrfdFSNyFYpOFGNpPrcK8f-ok_5iZKhv5iZ0Pk0oK1JW0wFuLphL6F9FlzalGmvDLVyVshEGX3dGfxiVKI0Uj-IbHycZS82hs6rCIOUcLyqlAAYaoJi0S6B6Rm3iFGGxI-1b1Q5oBbJ0hHjROU53UyBOlWdKCQvH2j685HqF4oKl_42lyyxHBDbxzTs7T95AWoeBLiQW0KBe-CzJ6Q', 'Minimal geometric architecture composition, clean concrete forms, precise shadows, balanced negative space, muted palette, editorial photography, ultra sharp details.', 'V2.4 模型', '1:1', 1, '0', 'admin', sysdate(), '', null, null),
(2, '深墨之妙', '水墨艺术', '有机水墨质感', 'https://lh3.googleusercontent.com/aida-public/AB6AXuBy4Q9qzhm5vU8r8SAi7IiqgHBba2f1v9frjXOycyfWXX6vCQc4OZgvCJVa8uRoqk_wBWQB1jEe-TP7w1qna1bo_nmz51GR9DyemGINyF8YWag-aKtwur1m5QjuojukeXFL3yKVD_bSs9Gw9WURfyY2WQ3pgIp2u0NHtFZc7bBpG22O-KUhWxhvapU72CV4OlqbFLilBazCO3u0ZoJC0cCD09ggyxU1QgMn2rFE8QvDS_dPMgawbYdKGa7Cyt9RSyvOpC4KNcQpKj4_', 'Organic black ink textures blooming on handmade paper, layered washes, abstract natural forms, elegant Chinese ink painting mood, high contrast, refined composition.', 'V2.4 模型', '1:1', 2, '0', 'admin', sysdate(), '', null, null),
(3, '孤寂雪原', '极简主义', '极简自然景观', 'https://lh3.googleusercontent.com/aida-public/AB6AXuC-9Tqzn7ZcHRvuGnjFaB3GnIBcWMOm0fn-qWTnBR3BAUAp6McsCn7asVqoYbbE-joxK64KiFVQccmXVRnzSY0sGxOpDu6hHjzrxmdo-wcKQkZu2esDg80MEAbyOUXo3wMbzI6sdwVnbRtgXkR6KHsxCHlO-FtxK5kIxU9tWmQUSh1XBTZ1ZmO5Vb27SAYcxvNe874iFiMBreUTW0nmTwoJo8YyCtJqWRPJhAfNKcdmnn_hHdwXT8NmZEOTZt-Po2auaCMKvhrf3P9p', 'A lonely minimal snowfield landscape, soft horizon, quiet atmosphere, pale winter light, sparse composition, cinematic stillness, fine detail, natural realism.', 'V2.4 模型', '16:9', 3, '0', 'admin', sysdate(), '', null, null),
(4, '未来结构', '超现实', '3D 超现实主义', 'https://lh3.googleusercontent.com/aida-public/AB6AXuDg1wfvmjr27Z35iMy0xuxdbO88ziI23TJdPT0cf-4dN0__IH1OurtM4pHdBJbYSeACOYz_YzyVxKCFixJIbhkbHkUntzOzu_dglucTVxnTideDIwlzDCRqptOf9i1AIWhQ2mJ2DkEjIc53u_3j7CREdvyLtnfzgm5u9F7UBS_QEK_6dPIULaOBMeG53jLzNU2B-SvWUniKhxBrB2b1_eQuYpRIA75Sx2BC0enE66CXtergZNJwS0BIWhczTRqOoCpCexFlPywMIkKN', 'Futuristic surreal 3D structure, impossible architectural forms, polished surfaces, dramatic studio lighting, abstract spatial depth, high-end concept art.', 'V2.4 模型', '4:3', 4, '0', 'admin', sysdate(), '', null, null);

insert into sys_menu values('2000', 'AI内容管理', '0', '5', 'ai', null, '', '', 1, 0, 'M', '0', '0', '', 'magic-stick', 'admin', sysdate(), '', null, 'AI内容管理目录');
insert into sys_menu values('2001', '模板管理', '2000', '1', 'template', 'system/template/index', '', '', 1, 0, 'C', '0', '0', 'system:template:list', 'picture', 'admin', sysdate(), '', null, '模板管理菜单');
insert into sys_menu values('2002', '模板查询', '2001', '1', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:template:query', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2003', '模板新增', '2001', '2', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:template:add', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2004', '模板修改', '2001', '3', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:template:edit', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2005', '模板删除', '2001', '4', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:template:remove', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2006', '模板导出', '2001', '5', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:template:export', '#', 'admin', sysdate(), '', null, '');
