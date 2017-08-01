use master
go

select *
from sys.symmetric_keys

select name, is_master_key_encrypted_by_server
from sys.databases

select name, pvt_key_encryption_type_desc, issuer_name, pvt_key_last_backup_date
from sys.certificates




