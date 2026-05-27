insert into ai_image_provider_model(provider_code, model, enabled, create_time, update_time)
select 'grsai', 'gpt-image-2-vip', true, sysdate(), sysdate()
where exists (select 1 from ai_image_provider where provider_code = 'grsai')
  and not exists (select 1 from ai_image_provider_model where provider_code = 'grsai' and model = 'gpt-image-2-vip');

insert into ai_image_provider_model(provider_code, model, enabled, create_time, update_time)
select 'grsai', 'nano-banana', true, sysdate(), sysdate()
where exists (select 1 from ai_image_provider where provider_code = 'grsai')
  and not exists (select 1 from ai_image_provider_model where provider_code = 'grsai' and model = 'nano-banana');

insert into ai_image_provider_model(provider_code, model, enabled, create_time, update_time)
select 'grsai', 'nano-banana-2', true, sysdate(), sysdate()
where exists (select 1 from ai_image_provider where provider_code = 'grsai')
  and not exists (select 1 from ai_image_provider_model where provider_code = 'grsai' and model = 'nano-banana-2');

insert into ai_image_provider_model(provider_code, model, enabled, create_time, update_time)
select 'grsai', 'nano-banana-pro', true, sysdate(), sysdate()
where exists (select 1 from ai_image_provider where provider_code = 'grsai')
  and not exists (select 1 from ai_image_provider_model where provider_code = 'grsai' and model = 'nano-banana-pro');

insert into ai_image_model_route(model, enabled, primary_provider_code, backup_provider_code, fallback_enabled, sort_order, remark, create_time, update_time)
select 'gpt-image-2-vip', true, 'grsai', null, false, 2, 'GPT VIP 暂时走 Grsai', sysdate(), sysdate()
where exists (select 1 from ai_image_provider_model where provider_code = 'grsai' and model = 'gpt-image-2-vip')
  and not exists (select 1 from ai_image_model_route where model = 'gpt-image-2-vip');

insert into ai_image_model_route(model, enabled, primary_provider_code, backup_provider_code, fallback_enabled, sort_order, remark, create_time, update_time)
select 'nano-banana', true, 'grsai', null, false, 3, 'nano-banana 暂时走 Grsai', sysdate(), sysdate()
where exists (select 1 from ai_image_provider_model where provider_code = 'grsai' and model = 'nano-banana')
  and not exists (select 1 from ai_image_model_route where model = 'nano-banana');

insert into ai_image_model_route(model, enabled, primary_provider_code, backup_provider_code, fallback_enabled, sort_order, remark, create_time, update_time)
select 'nano-banana-2', true, 'grsai', null, false, 4, 'nano-banana-2 暂时走 Grsai', sysdate(), sysdate()
where exists (select 1 from ai_image_provider_model where provider_code = 'grsai' and model = 'nano-banana-2')
  and not exists (select 1 from ai_image_model_route where model = 'nano-banana-2');

insert into ai_image_model_route(model, enabled, primary_provider_code, backup_provider_code, fallback_enabled, sort_order, remark, create_time, update_time)
select 'nano-banana-pro', true, 'grsai', null, false, 5, 'nano-banana-pro 暂时走 Grsai', sysdate(), sysdate()
where exists (select 1 from ai_image_provider_model where provider_code = 'grsai' and model = 'nano-banana-pro')
  and not exists (select 1 from ai_image_model_route where model = 'nano-banana-pro');
