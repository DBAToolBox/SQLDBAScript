SELECT 
 O.name,
 PS.last_execution_time
FROM sys.dm_exec_procedure_stats PS 
INNER JOIN sys.objects O ON O.[object_id] = PS.[object_id]
--where O.name LIKE 'Inse%' 
Order by PS.last_execution_time DESC
GO