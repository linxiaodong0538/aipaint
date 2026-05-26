set @ai_generation_task_run_start_time_sql = (
  select if(
    count(*) = 0,
    'alter table ai_generation_task add column run_start_time datetime null comment ''开始运行时间'' after credit_cost',
    'select 1'
  )
  from information_schema.columns
  where table_schema = database()
    and table_name = 'ai_generation_task'
    and column_name = 'run_start_time'
);
prepare ai_generation_task_run_start_time_stmt from @ai_generation_task_run_start_time_sql;
execute ai_generation_task_run_start_time_stmt;
deallocate prepare ai_generation_task_run_start_time_stmt;
