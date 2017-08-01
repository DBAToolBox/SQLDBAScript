SELECT name, modify_date, create_date
FROM sys.objects
WHERE type IN ('FN', 'IF', 'TF')
order by modify_date desc