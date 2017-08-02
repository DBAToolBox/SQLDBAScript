USE distribution 
go

SELECT time, comments, delivery_rate, delivery_latency
FROM dbo.MSdistribution_history
order by time desc

-- delivery_rate - The average delivered commands per second.
-- delivery_latency - The latency between the command entering the distribution database and being applied to the Subscriber. In milliseconds.
