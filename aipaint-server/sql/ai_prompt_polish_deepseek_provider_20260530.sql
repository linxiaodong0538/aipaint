insert into ai_image_provider(
  provider_code,
  provider_name,
  adapter_type,
  response_mode,
  supports_batch,
  base_url,
  api_key,
  enabled,
  sort_order,
  remark,
  create_time,
  update_time
)
select 'deepseek',
       'DeepSeek 提示词润色',
       'openai-compatible',
       'json',
       false,
       'https://api.deepseek.com',
       '',
       false,
       3,
       '仅用于提示词润色，不参与生图路由',
       sysdate(),
       sysdate()
where not exists (select 1 from ai_image_provider where provider_code = 'deepseek');

insert into ai_image_provider_model(provider_code, model, provider_model, enabled, create_time, update_time)
select 'deepseek', 'deepseek-v4-flash', 'deepseek-v4-flash', true, sysdate(), sysdate()
where exists (select 1 from ai_image_provider where provider_code = 'deepseek')
  and not exists (
    select 1
    from ai_image_provider_model
    where provider_code = 'deepseek'
      and model = 'deepseek-v4-flash'
  );
