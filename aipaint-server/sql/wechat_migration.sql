alter table sys_user add column openid varchar(64) default null comment '微信小程序openid';
create unique index idx_sys_user_openid on sys_user(openid);
