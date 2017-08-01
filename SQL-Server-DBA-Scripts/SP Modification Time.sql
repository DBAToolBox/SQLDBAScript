SELECT name, create_date, modify_date 
FROM sys.objects 
WHERE type = 'P' and modify_date > '2015-08-01'
ORDER BY modify_date DESC
--ORDER BY name DESC