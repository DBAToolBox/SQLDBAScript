EXECUTE msdb.dbo.sysmail_help_profile_sp;

sp_configure 'Database Mail XPs'

USE msdb
GO
EXEC sp_send_dbmail @profile_name='S1',
@recipients='jzilcov@gmail.com',
@subject='Test message from S1',
@body='This is the body of the test message 2'

USE msdb
GO
SELECT * FROM sysmail_allitems
SELECT * FROM sysmail_mailitems
SELECT * FROM sysmail_log
SELECT * FROM sysmail_sentitems
SELECT * FROM sysmail_event_log
SELECT * FROM sysmail_unsentitems

