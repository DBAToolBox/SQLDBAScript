SELECT
  id                    AS [Table ID]
, OBJECT_NAME(id)       AS [Table Name]
, name                  AS [Index Name]
, STATS_DATE(id, indid) AS [LastUpdated]
, rowmodctr             AS [Rows Modified]
FROM sys.sysindexes 
WHERE STATS_DATE(id, indid)<=DATEADD(DAY,-1,GETDATE()) 
AND rowmodctr>0 AND (OBJECTPROPERTY(id,'IsUserTable'))=1
order by [Rows Modified] desc
GO
