
DECLARE @startdatetime smalldatetime = '2015-09-18 09:24';
DECLARE @enddatetime smalldatetime = DATEADD(minute,5,@startdatetime)

EXEC master..xp_readerrorlog 0, 1, NULL, NULL, @startdatetime, @enddatetime, 'asc'


--------------------------
-- To find the table involved in the deadllock [if not visible] you can use the hotbitid value from the log
SELECT o.name
FROM sys.partitions p
INNER JOIN sys.objects o ON p.object_id = o.object_id
WHERE p.hobt_id = 72057627103395840