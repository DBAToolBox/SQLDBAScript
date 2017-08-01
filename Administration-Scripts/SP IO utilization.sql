SELECT DB_NAME(st.dbid) DBName
      ,OBJECT_SCHEMA_NAME(objectid,st.dbid) SchemaName
      ,OBJECT_NAME(objectid,st.dbid) StoredProcedure
      ,max(cp.usecounts) execution_count
      ,sum(qs.total_physical_reads + qs.total_logical_reads + qs.total_logical_writes) total_IO
      ,sum(qs.total_physical_reads + qs.total_logical_reads + qs.total_logical_writes) / (max(cp.usecounts)) avg_total_IO
      ,sum(qs.total_physical_reads) total_physical_reads
      ,sum(qs.total_physical_reads) / (max(cp.usecounts) * 1.0) avg_physical_read    
      ,sum(qs.total_logical_reads) total_logical_reads
      ,sum(qs.total_logical_reads) / (max(cp.usecounts) * 1.0) avg_logical_read  
      ,sum(qs.total_logical_writes) total_logical_writes
      ,sum(qs.total_logical_writes) / (max(cp.usecounts) * 1.0) avg_logical_writes  
 FROM sys.dm_exec_query_stats qs CROSS APPLY sys.dm_exec_sql_text(qs.plan_handle) st
   join sys.dm_exec_cached_plans cp on qs.plan_handle = cp.plan_handle
  where DB_NAME(st.dbid) is not null and cp.objtype = 'proc'
 group by DB_NAME(st.dbid),OBJECT_SCHEMA_NAME(objectid,st.dbid), OBJECT_NAME(objectid,st.dbid) 
 order by sum(qs.total_physical_reads + qs.total_logical_reads + qs.total_logical_writes) desc
