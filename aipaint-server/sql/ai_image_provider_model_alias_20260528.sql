set @ai_image_provider_model_alias_sql = (
  select if(
    count(*) = 0,
    'alter table ai_image_provider_model add column provider_model varchar(100) null comment ''供应商实际模型'' after model',
    'select 1'
  )
  from information_schema.columns
  where table_schema = database()
    and table_name = 'ai_image_provider_model'
    and column_name = 'provider_model'
);
prepare ai_image_provider_model_alias_stmt from @ai_image_provider_model_alias_sql;
execute ai_image_provider_model_alias_stmt;
deallocate prepare ai_image_provider_model_alias_stmt;

update ai_image_provider_model
set provider_model = model
where provider_model is null or provider_model = '';
