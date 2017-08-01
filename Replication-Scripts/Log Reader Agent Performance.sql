USE distribution 
GO 

SELECT time, 
CAST(comments AS XML) AS comments, 
runstatus, 
duration, 
xact_seqno, 
delivered_transactions, 
delivered_commands, 
average_commands, 
delivery_time, 
delivery_rate, 
delivery_latency / ( 1000 * 60 ) AS delivery_latency_Min 
FROM mslogreader_history WITH (nolock) 
WHERE time > '2015-09-08 16:30:00.130' 
ORDER BY time DESC 