SELECT TOP 10 T.entry_time,
T.publisher_database_id,
T.xact_id,
T.xact_seqno,
C.type,
C.article_id,
C.command_id
FROM [distribution].[dbo].[MSrepl_transactions](nolock) T
JOIN [MSrepl_commands](nolock) C 
 ON T.[xact_seqno] = C.[xact_seqno]
where T.publisher_database_id = 115
order by entry_time
