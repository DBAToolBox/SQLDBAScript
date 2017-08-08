-- Select events from the trace, you need to specify the file name
select ObjectName,HostName as CallingHost,ApplicationName,
LoginName,StartTime,EndTime,DATEDIFF(second, StartTime, EndTime) as sec, 
DATEDIFF(millisecond, StartTime, EndTime) as msec--,ObjectID,ObjectType,ServerName,DatabaseName
from ::fn_trace_gettable(N'D:\SQLTraceEvents\SP_trace_2015-09-30.trc',default)
where DATEDIFF(second, StartTime, EndTime) > 5
go

--Get current trace file path
--SELECT value FROM sys.fn_trace_getinfo(2)
--WHERE property = 2;


-- Most frequently used queries
select ObjectName, COUNT(*) as CountNr
from ::fn_trace_gettable(N'D:\SQLTraceEvents\SP_trace_2015-09-30.trc',default)
group by ObjectName
order by CountNr desc
go


-- longest queries
select ObjectName,HostName as CallingHost,ApplicationName,
LoginName,StartTime,EndTime,DATEDIFF(second, StartTime, EndTime) as sec, 
DATEDIFF(millisecond, StartTime, EndTime) as msec--,ObjectID,ObjectType,ServerName,DatabaseName
from ::fn_trace_gettable(N'D:\SQLTraceEvents\SP_trace_2015-09-30.trc',default)
where DATEDIFF(second, StartTime, EndTime) > 5
order by sec desc
go