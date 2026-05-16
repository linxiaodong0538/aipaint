alter table sys_user add column if not exists openid varchar(64) default '' comment '微信小程序openid';
create unique index if not exists idx_sys_user_openid on sys_user(openid);
