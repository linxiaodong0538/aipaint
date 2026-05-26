set @ai_image_provider_supports_batch_sql = (
  select if(
    count(*) = 0,
    'alter table ai_image_provider add column supports_batch tinyint(1) not null default 1 comment ''是否支持单次批量生成'' after response_mode',
    'select 1'
  )
  from information_schema.columns
  where table_schema = database()
    and table_name = 'ai_image_provider'
    and column_name = 'supports_batch'
);
prepare ai_image_provider_supports_batch_stmt from @ai_image_provider_supports_batch_sql;
execute ai_image_provider_supports_batch_stmt;
deallocate prepare ai_image_provider_supports_batch_stmt;

update ai_image_provider
set supports_batch = 1
where supports_batch is null;
