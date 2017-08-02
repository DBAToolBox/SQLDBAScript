USE distribution 
GO 
SELECT Getdate() AS CaptureTime, 
Object_name(t.object_id) AS TableName, 
st.row_count, 
s.NAME 
FROM sys.dm_db_partition_stats st WITH (nolock) 
INNER JOIN sys.tables t WITH (nolock) 
ON st.object_id = t.object_id 
INNER JOIN sys.schemas s WITH (nolock) 
ON t.schema_id = s.schema_id 
WHERE index_id < 2 
AND Object_name(t.object_id) 
IN ('MSsubscriptions', 
'MSdistribution_history', 
'MSrepl_commands', 
'MSrepl_transactions'
) 
ORDER BY st.row_count DESC 

--MSsubscriptions - contains one row for each published article in a subscription 
--MSdistribution_history - contains history rows for the Distribution Agents associated with the local Distributor 
--MSrepl_commands - contains rows of replicated commands 
--MSrepl_transactions - contains one row for each replicated transaction 
