alter table ai_generation_task
  add column preview_image_url varchar(1000) default null comment '预览图片地址' after result_image_url;
