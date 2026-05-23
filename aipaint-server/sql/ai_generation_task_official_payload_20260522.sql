alter table ai_generation_task
  add column resolution varchar(16) not null default '2k' comment '分辨率档位' after size,
  add column image_urls text null comment '参考图URL，逗号分隔' after resolution,
  add column image_count int(11) not null default 1 comment '生成张数' after image_urls,
  add column progress int(11) not null default 0 comment '任务进度' after status;
