select * from sys.dm_os_performance_counters
where object_name like '%Replica%'
and counter_name like '%Dist%latency%'