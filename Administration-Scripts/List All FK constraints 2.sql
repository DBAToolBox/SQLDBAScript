SELECT
OBJECT_NAME(parent_object_id) 'Parent table',
c.NAME 'Parent column name',
OBJECT_NAME(referenced_object_id) 'Referenced table',
cref.NAME 'Referenced column name'
FROM 
sys.foreign_key_columns fkc 
INNER JOIN 
sys.columns c 
   ON fkc.parent_column_id = c.column_id 
      AND fkc.parent_object_id = c.object_id
INNER JOIN 
sys.columns cref 
   ON fkc.referenced_column_id = cref.column_id 
      AND fkc.referenced_object_id = cref.object_id  --where   OBJECT_NAME(parent_object_id) = 'tablename'