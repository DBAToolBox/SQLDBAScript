
-- Create a new trace, make sure the @tracefile must NOT exist on the disk yet
-- The .trc extension will be appended to the filename automatically. 
declare @TraceID int
declare @maxfilesize bigint = 1024 -- in MB
declare @pathname nvarchar(50) = N'D:\SQLTraceEvents\SP_trace_'
SET @pathname = @pathname + CAST(CONVERT(date, getdate()) as nvarchar(10))
-- 4th parameter is a datetime to stop tracing automatically; DECLARE @TraceEndTime datetime = DATEADD(day, 1, GETDATE())
-- 5th parameter specified how many files will be created on the disk for a log rotation [by default number of files is unlimited, which can lead to a full disk]
exec sp_trace_create @TraceID output, 2, @pathname, @maxfilesize, NULL, 5

-- Set the events and columns
declare @on bit = 1
declare @EventID int = 43 -- Event 43 indicates completed stored procedure [https://technet.microsoft.com/en-us/library/ms186265(v=sql.105).aspx]

exec sp_trace_setevent @TraceID, 43, 8, @on --Name of the client computer that originated the request
exec sp_trace_setevent @TraceID, 43, 10, @on --ApplicationName
exec sp_trace_setevent @TraceID, 43, 11, @on --LoginName
--exec sp_trace_setevent @TraceID, 43, 12, @on --Process ID
exec sp_trace_setevent @TraceID, 43, 14, @on --StartTime
exec sp_trace_setevent @TraceID, 43, 15, @on --EndTime
--exec sp_trace_setevent @TraceID, 43, 22, @on --ObjectID
--exec sp_trace_setevent @TraceID, 43, 28, @on --ObjectType [Table,SP,Function]
exec sp_trace_setevent @TraceID, 43, 34, @on --Name of object accessed
--exec sp_trace_setevent @TraceID, 43, 35, @on --Name of the database

-- Set the Filters
-- Filter in the Database Name
exec sp_trace_setfilter @TraceID, 35, 0, 6, N'DB_Name' -- 6 means filter in

--Filtered out Application Name
exec sp_trace_setfilter @TraceID, 10, 0, 1, N'APP_Name' -- 1 means filter out

--Filtered out Stored Procedures
exec sp_trace_setfilter @TraceID, 34, 0, 1, N'PROC_Name' -- 1 means filter out

--Filtered out functions
exec sp_trace_setfilter @TraceID, 34, 0, 1, N'FUNC_Name' -- 1 means filter out

-- Start the trace
Select * from sys.traces
--exec sp_trace_setstatus 2, 1
exec sp_trace_setstatus @TraceID, 1

-- Display trace id for future references
Select * from sys.traces

--_____________________________________

-- Select events from the trace
select ObjectName,HostName as CallingHost,ApplicationName,
LoginName,StartTime,EndTime--,ObjectID,ObjectType,ServerName,DatabaseName
from ::fn_trace_gettable(N'D:\SQLTraceEvents\SP_trace.trc',default)
--Where ApplicationName <> 'Repl-LogReader-0-AlexisITSTest-7'
go

--Get current trace file path
SELECT value FROM sys.fn_trace_getinfo(2)
WHERE property = 2;

-- Stop the trace. Please manually delete the trace file on the disk
--Select * from sys.traces to find the @trace_id
declare @TraceID int = 2
exec sp_trace_setstatus @TraceID,0 --First you need to Stop the specified trace.
--exec sp_trace_setstatus 2,0
exec sp_trace_setstatus @TraceID,2 --If needed the trace can be removed from the server.
go