use Distribution
go

SELECT      da.name, da.publisher_db, da.subscription_type,
            dh.runstatus, dh.delivery_rate, dh.start_time, dh.duration
FROM        dbo.MSdistribution_history dh WITH (NOLOCK)
INNER JOIN  dbo.msdistribution_agents da WITH (NOLOCK)
ON          dh.agent_id = da.id
WHERE       --dh.runstatus = 3 AND -- 3 means 'in progress', table explanation here:
            -- http://msdn.microsoft.com/en-us/library/ms179878.aspx
            dh.start_time BETWEEN DATEADD(dd,-1,GETDATE()) AND GETDATE()
ORDER BY    dh.start_time DESC

SELECT * FROM dbo.MSdistribution_history
order by time desc

SELECT * FROM dbo.msdistribution_agents