DECLARE @SearchText varchar(1000) = ' Account ';

SELECT DISTINCT SPName 
FROM (
    (SELECT ROUTINE_NAME SPName
        FROM INFORMATION_SCHEMA.ROUTINES 
        WHERE ROUTINE_DEFINITION LIKE '%' + @SearchText + '%' 
        AND ROUTINE_TYPE='PROCEDURE')
    UNION ALL
    (SELECT OBJECT_NAME(id) SPName
        FROM SYSCOMMENTS 
        WHERE [text] LIKE '%' + @SearchText + '%' 
        AND OBJECTPROPERTY(id, 'IsProcedure') = 1 
        GROUP BY OBJECT_NAME(id))
    UNION ALL
    (SELECT OBJECT_NAME(object_id) SPName
        FROM sys.sql_modules
        WHERE OBJECTPROPERTY(object_id, 'IsProcedure') = 1
        AND definition LIKE '%' + @SearchText + '%')
) AS T
ORDER BY T.SPName
