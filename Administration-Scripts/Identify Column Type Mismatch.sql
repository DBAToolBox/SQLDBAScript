WITH UniqueColumnDefinitions AS (
SELECT
    o.[name] AS [Table], 
    c.[name] AS [Column],
    t.[name] AS [Data Type],
    c.[prec] AS [Precision],
    c.[scale] AS [Scale], 
    c.[isnullable] AS [Nullable],
    [check_sum] = binary_checksum(c.[name], t.[name], c.[prec], c.[scale], c.[isnullable])
FROM    [dbo].[sysobjects] o 
JOIN    [dbo].[syscolumns] c     ON c.[id] = o.[id] 
JOIN    [dbo].[systypes] t    ON c.[xtype] = t.[xtype] AND t.[name] <> 'sysname'
WHERE    o.[type] = 'U'
)
SELECT    MIN([column]) AS [Column],
    MIN([data type]) AS [Data Type],
    MIN([precision]) AS [Precision],
    MIN([Scale]) AS [Scale],
    MIN(nullable) AS [Nullable],
    COUNT(*) AS [Usage Count]
FROM UniqueColumnDefinitions
GROUP BY check_sum
ORDER BY [Column]
