SELECT --ps.database_id, 
DB_NAME() AS DBname,
--ps.OBJECT_ID,
--ps.index_id, 
b.name as IndexName,
ps.avg_fragmentation_in_percent,
ps.avg_page_space_used_in_percent,
ps.page_count,
b.fill_factor
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, 'SAMPLED') AS ps
INNER JOIN sys.indexes AS b ON ps.OBJECT_ID = b.OBJECT_ID AND ps.index_id = b.index_id
--INNER JOIN sys.objects AS o ON ps.OBJECT_ID = b.OBJECT_ID
WHERE 
ps.database_id = DB_ID() 
AND ps.avg_fragmentation_in_percent > 30 
--AND name is not null
ORDER BY ps.page_count DESC, ps.OBJECT_ID DESC
GO

