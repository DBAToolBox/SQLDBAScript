EXEC master.dbo.sp_WhoIsActive
  @show_own_spid = 1,
  @get_plans = 1,
  @get_outer_command = 1,
  @get_transaction_info = 1,
  @get_locks = 1,
  @get_additional_info = 1

--sp_who2

---------
EXEC sp_WhoIsActive 
    @filter = '', 
    @filter_type = 'session', 
    @not_filter = '', 
    @not_filter_type = 'session', 
    @show_own_spid = 0, 
    @show_system_spids = 0, 
    @show_sleeping_spids = 1, 
    @get_full_inner_text = 0, 
    @get_plans = 0, 
    @get_outer_command = 0, 
    @get_transaction_info = 0, 
    @get_task_info = 1, 
    @get_locks = 0, 
    @get_avg_time = 0, 
    @get_additional_info = 0, 
    @find_block_leaders = 0, 
    @delta_interval = 0, 
    --@output_column_list = '[dd%][session_id][sql_text][sql_command][login_name][wait_info][tasks][tran_log%][cpu%][temp%][block%][reads%][writes%][context%][physical%][query_plan][locks][%]', 
    @sort_order = '[start_time] ASC', 
    @format_output = 1, 
    @destination_table = '', 
    @return_schema = 0, 
    @schema = NULL, 
    @help = 0


