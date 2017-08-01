SELECT DB_NAME(st.dbid) DBName
      ,OBJECT_SCHEMA_NAME(st.objectid,dbid) SchemaName
      ,OBJECT_NAME(st.objectid,dbid) StoredProcedure
      ,max(cp.usecounts) Execution_count
 FROM sys.dm_exec_cached_plans cp
         CROSS APPLY sys.dm_exec_sql_text(cp.plan_handle) st
 where DB_NAME(st.dbid) is not null and cp.objtype = 'proc'
   group by cp.plan_handle, DB_NAME(st.dbid),
            OBJECT_SCHEMA_NAME(objectid,st.dbid), 
   OBJECT_NAME(objectid,st.dbid) 
 order by max(cp.usecounts) DESC
