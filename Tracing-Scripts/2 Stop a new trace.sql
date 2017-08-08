-- Stop the trace. Please manually delete the trace file on the disk
--Select * from sys.traces - to find the @trace_id
declare @TraceID int = 2
exec sp_trace_setstatus @TraceID,0 --First you need to Stop the specified trace.
--exec sp_trace_setstatus 2,0
exec sp_trace_setstatus @TraceID,2 --If needed the trace can be removed from the server.
go