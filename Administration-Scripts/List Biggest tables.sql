CREATE TABLE #temp (name varchar(100), rows int,reserved varchar(100), data varchar(100),index_size  varchar(100),unused  varchar(100))
 
CREATE TABLE #loop (id int identity, name varchar(1000))
INSERT #loop
SELECT SCHEMA_NAME(schema_id) +'.' + name 
FROM sys.tables
WHERE type = 'U'
 
 
SET NOCOUNT ON
DECLARE @LoopId int
DECLARE @MaxID int
DECLARE @cmd varchar(1100)
DECLARE @TableName varchar(1000)
 
 
SELECT @LoopId= 1
SELECT @MaxID = max(id) from #loop
 
WHILE @LoopId <= @MaxID
BEGIN
    SELECT @cmd = 'insert #temp exec sp_spaceused '''
    SELECT @TableName = name from #loop where id = @LoopId
    SELECT @cmd = @cmd + @TableName + ''''
 
    EXEC( @cmd )
 
 
    SET @LoopId = @LoopId + 1
END
 
 
SELECT TOP 20 * 
FROM #temp
ORDER BY CONVERT(bigint,REPLACE(reserved,' KB','')) DESC
 
DROP TABLE #temp, #loop
