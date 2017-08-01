SELECT DISTINCT 
       o.name
       ,o.type_desc
       --,ps.last_execution_time
FROM sys.sql_modules m 
INNER JOIN sys.objects o ON m.object_id = o.object_id
--INNER JOIN sys.dm_exec_procedure_stats ps ON ps.object_id = o.object_id 
WHERE m.definition Like '%INSERT INTO \[TRANSACTION\]%' ESCAPE '\';
