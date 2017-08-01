SELECT [name]
       ,create_date
       ,modify_date
FROM   sys.views
WHERE name NOT LIKE 'syncobj%'
ORDER BY modify_date DESC