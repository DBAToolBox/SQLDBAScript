USE distribution 
go 
SELECT time, 
Cast(comments AS XML) AS comments, 
runstatus, 
duration, 
xact_seqno, 
delivered_commands, 
average_commands, 
current_delivery_rate, 
delivered_transactions, 
error_id, 
delivery_latency 
FROM msdistribution_history WITH (nolock) 
WHERE time > '2015-09-08 17:10:00' 
ORDER BY time DESC 