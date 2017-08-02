-- Mke sure nothing is blocking Distribution Agent. Stop CleanUp jobs.

SELECT r.session_id, 
Db_name(r.database_id) AS DatabaseName,
s.program_name, 
s.login_name, 
r.start_time, 
r.status, 
r.wait_time, 
r.wait_type, 
r.wait_resource,
r.command, 
Object_name(sqltxt.objectid, sqltxt.dbid) AS ObjectName, 
Substring(sqltxt.text, ( r.statement_start_offset / 2 ) + 1, ( ( 
CASE r.statement_end_offset 
WHEN -1 THEN 
datalength(sqltxt.text) 
ELSE r.statement_end_offset 
END 
- r.statement_start_offset ) / 2 ) + 1) AS active_statement,
r.percent_complete,  
r.blocking_session_id,  
r.open_transaction_count, 
r.cpu_time,-- in milli sec 
r.reads, 
r.writes, 
r.logical_reads, 
r.row_count, 
r.prev_error, 
r.granted_query_memory, 
Cast(sqlplan.query_plan AS XML) AS QueryPlan, 
CASE r.transaction_isolation_level 
WHEN 0 THEN 'Unspecified' 
WHEN 1 THEN 'ReadUncomitted' 
WHEN 2 THEN 'ReadCommitted' 
WHEN 3 THEN 'Repeatable' 
WHEN 4 THEN 'Serializable' 
WHEN 5 THEN 'Snapshot' 
END AS Issolation_Level, 
r.sql_handle, 
r.plan_handle 
FROM sys.dm_exec_requests r WITH (nolock) 
INNER JOIN sys.dm_exec_sessions s WITH (nolock) 
ON r.session_id = s.session_id 
CROSS apply sys.Dm_exec_sql_text(r.sql_handle) sqltxt 
CROSS apply 
sys.Dm_exec_text_query_plan(r.plan_handle, r.statement_start_offset, r.statement_end_offset) sqlplan
WHERE r.status <> 'background' 
ORDER BY r.session_id 
go 