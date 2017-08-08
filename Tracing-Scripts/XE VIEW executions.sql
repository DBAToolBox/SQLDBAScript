
--SELECT DB_ID('DB_Name')
--SELECT * FROM sys.server_event_sessions
--DROP EVENT SESSION [VIEWS_EXEC_HISTORY] ON SERVER

CREATE EVENT SESSION [VIEWS_EXEC_HISTORY] ON SERVER 
ADD EVENT sqlserver.sp_statement_completed(
	ACTION(sqlserver.client_app_name, 
		sqlserver.client_hostname,
		sqlserver.database_id,
		--sqlserver.database_name,
		sqlserver.username,
		sqlserver.sql_text,
		sqlos.task_time)
    WHERE (([object_type]=(8278)) AND ([source_database_id]=(5)))
	--WHERE ([sqlserver].[like_i_sql_unicode_string]([sqlserver].[sql_text], N'%Unable to retrieve SQL text%'))
)
ADD TARGET package0.asynchronous_file_target (
	SET FILENAME = N'E:\SQLExtendedEvents\VIEWSExecutionHistory.xel',
	--max_file_size = (10),
	METADATAFILE = N'E:\SQLExtendedEvents\VIEWSExecutionHistory.xem'
)
WITH (MAX_MEMORY = 4096KB, 
	EVENT_RETENTION_MODE = ALLOW_SINGLE_EVENT_LOSS, 
	MAX_DISPATCH_LATENCY = 10 SECONDS, 
	MAX_EVENT_SIZE = 0KB, 
	MEMORY_PARTITION_MODE = NONE, 
	TRACK_CAUSALITY = OFF, 
	STARTUP_STATE = OFF
);
GO

ALTER EVENT SESSION [VIEWS_EXEC_HISTORY] ON SERVER
  STATE = START;
GO
ALTER EVENT SESSION [VIEWS_EXEC_HISTORY] ON SERVER
STATE = STOP;
GO


;WITH ee_data AS 
(  SELECT data = CONVERT(XML, event_data)
   FROM sys.fn_xe_file_target_read_file(
   'E:\SQLExtendedEvents\VIEWSExecutionHistory*.xel', 
   'E:\SQLExtendedEvents\VIEWSExecutionHistory*.xem', 
   NULL, NULL )
),
tab AS (  SELECT data,
  [client_host] = data.value('(event/action[@name="client_hostname"]/value)[1]','nvarchar(400)'),
  [app_name] = data.value('(event/action[@name="client_app_name"]/value)[1]','nvarchar(100)'),
  [username] = data.value('(event/action[@name="username"]/value)[1]','nvarchar(400)'),
  [timestamp] = DATEADD(hh, 1, data.value('(event/@timestamp)[1]','datetime2')),
  [SQL] = data.value('(event/action[@name="sql_text"]/value)[1]', 'nvarchar(max)'),
  [task_time] = data.value('(event/action[@name="task_time"]/value)[1]','bigint')/@@TIMETICKS
 FROM ee_data )
 
SELECT [data]
, [client_host]
, [app_name]
, [username]
, [timestamp] as last_executed
, [task_time] as task_duration
--, COUNT([object_name]) as number_of_executions
--, [object_name]
, SQL
FROM tab 
--GROUP BY [host], app_name, username, [object_name] ;
--order by [timestamp] desc

