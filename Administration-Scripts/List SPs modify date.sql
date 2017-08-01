
SELECT name, modify_date, create_date
FROM sys.objects
WHERE type = 'P' 
Order by modify_date desc