EXEC sp_configure 'show advanced options',1
GO
RECONFIGURE WITH OVERRIDE
GO

DECLARE @DefaultFillFactor INT 
DECLARE @Fillfactor TABLE(Name VARCHAR(100),Minimum INT ,Maximum INT,config_value INT ,run_value INT)
INSERT INTO @Fillfactor EXEC sp_configure 'fill factor (%)'     
SELECT @DefaultFillFactor  = CASE WHEN run_value=0 THEN 100 ELSE  run_value  END  FROM @Fillfactor 

SELECT
	DB_NAME() AS DBname,
	QUOTENAME(o.name) AS TableName,
	i.name AS IndexName,
	stats.Index_type_desc AS IndexType,
	CASE WHEN i.fill_factor>0 THEN i.fill_factor ELSE @DefaultFillFactor END  AS [Fill Factor],
	stats.page_count AS [PageCount],
	stats.avg_fragmentation_in_percent,
	stats.avg_page_space_used_in_percent
	--stats.partition_number AS PartitionNumber,
	--QUOTENAME(s.name) AS CchemaName,
	--CASE WHEN stats.index_level =0 THEN 'Leaf Level' ELSE 'Nonleaf Level' END AS IndexLevel
FROM 
    sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL , NULL, 'SAMPLED') AS stats,
    sys.objects AS o,
    --sys.schemas AS s,
    sys.indexes AS i
WHERE 
	o.OBJECT_ID = stats.OBJECT_ID 
	--AND s.schema_id = o.schema_id       
    AND i.OBJECT_ID = stats.OBJECT_ID 
    AND i.index_id = stats.index_id
    AND stats.avg_page_space_used_in_percent<= 85 
    AND stats.page_count >= 100
    AND stats.index_id > 0 
    AND stats.avg_fragmentation_in_percent > 30
ORDER BY  
	stats.page_count DESC, 
	stats.avg_fragmentation_in_percent DESC