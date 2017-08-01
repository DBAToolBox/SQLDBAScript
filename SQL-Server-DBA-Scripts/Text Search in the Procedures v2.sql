

--select SPECIFIC_NAME, ROUTINE_NAME
--from information_schema.routines 
--where routine_type = 'PROCEDURE' --and Left(Routine_Name, 3) NOT IN ('sp_', 'xp_', 'ms_')
--ORDER BY SPECIFIC_NAME


DECLARE @FullList TABLE (referencing_entity_name NVARCHAR(100), referenced_entity_name NVARCHAR(100));
DECLARE @spName NVARCHAR(100);
DECLARE cur_SP CURSOR FOR
SELECT SPECIFIC_NAME FROM information_schema.routines WHERE routine_type = 'PROCEDURE' Order by SPECIFIC_NAME
OPEN cur_SP;
FETCH NEXT FROM cur_SP INTO @spName;
WHILE (@@FETCH_STATUS = 0)
BEGIN
    INSERT INTO @FullList
    SELECT OBJECT_NAME(referencing_id) AS referencing_entity_name, referenced_entity_name
    FROM sys.sql_expression_dependencies AS sed
    INNER JOIN sys.objects AS o ON sed.referencing_id = o.object_id
    WHERE referencing_id = OBJECT_ID(@spName)
    
    FETCH NEXT FROM cur_SP INTO @spName;
END;
CLOSE cur_SP;
DEALLOCATE cur_SP;
SELECT * FROM @FullList WHERE referenced_entity_name = 'Account'