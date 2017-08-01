select top 200
 j.name as 'JobName',
 msdb.dbo.agent_datetime(run_date, run_time) as 'RunDateTime',
 run_duration as 'Execution duration, s',
 h.step_id,
 step_name
From msdb.dbo.sysjobs j 
INNER JOIN msdb.dbo.sysjobhistory h 
 ON j.job_id = h.job_id 
where j.enabled = 1   AND run_duration > 5 --Only Enabled Jobs with duration more than 5s
order by RunDateTime desc