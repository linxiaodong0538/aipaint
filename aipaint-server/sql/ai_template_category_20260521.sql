insert into ai_template_category
  (category_name, category_code, sort, status, create_by, create_time, update_by, update_time, remark)
select '海报与营销', 'poster_marketing', 4, '0', 'admin', sysdate(), '', null, null
where not exists (select 1 from ai_template_category where category_code = 'poster_marketing');

insert into ai_template_category
  (category_name, category_code, sort, status, create_by, create_time, update_by, update_time, remark)
select '食物', 'food', 5, '0', 'admin', sysdate(), '', null, null
where not exists (select 1 from ai_template_category where category_code = 'food');

insert into ai_template_category
  (category_name, category_code, sort, status, create_by, create_time, update_by, update_time, remark)
select '动漫', 'anime', 6, '0', 'admin', sysdate(), '', null, null
where not exists (select 1 from ai_template_category where category_code = 'anime');

insert into ai_template_category
  (category_name, category_code, sort, status, create_by, create_time, update_by, update_time, remark)
select '产品与广告', 'product_advertising', 7, '0', 'admin', sysdate(), '', null, null
where not exists (select 1 from ai_template_category where category_code = 'product_advertising');
