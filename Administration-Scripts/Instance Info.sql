SELECT    SERVERPROPERTY('ServerName') AS [SQLServer],
    --@@microsoftversion/0x01000000 AS [MajorVersion],
    SERVERPROPERTY('ProductVersion') AS [VersionBuild],
    SERVERPROPERTY('ProductLevel') AS [Product],
    SERVERPROPERTY ('Edition') AS [Edition],
    --SERVERPROPERTY('IsIntegratedSecurityOnly') AS [IsWindowsAuthOnly],
    SERVERPROPERTY('IsClustered') AS [IsClustered],
    [cpu_count] AS [CPUs]--,
    --[physical_memory_kb]/1048576 AS [RAM (MB)]
FROM    [sys].[dm_os_sys_info]
