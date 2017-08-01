USE distribution 
go 
EXEC Sp_browsereplcmds 
@xact_seqno_start = '0x0010AC4E00013E170019', 
@xact_seqno_end = '0x0010AC4E00013E170019', 
@publisher_database_id = 103
