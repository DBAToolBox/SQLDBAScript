# Usage:  powershell ExportSchema.ps1 "SERVERNAME" "DATABASE" "C:\<YourOutputPath>"


# Start Script
Set-ExecutionPolicy RemoteSigned

# Set-ExecutionPolicy -ExecutionPolicy:Unrestricted -Scope:LocalMachine
function GenerateDBScript([string]$serverName, [string]$dbname, [string]$scriptpath)
{
  [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SMO") | Out-Null
  [System.Reflection.Assembly]::LoadWithPartialName("System.Data") | Out-Null
  $srv = new-object "Microsoft.SqlServer.Management.SMO.Server" $serverName
  $srv.SetDefaultInitFields([Microsoft.SqlServer.Management.SMO.View], "IsSystemObject")
  $db = New-Object "Microsoft.SqlServer.Management.SMO.Database"
  $db = $srv.Databases[$dbname]
  $scr = New-Object "Microsoft.SqlServer.Management.Smo.Scripter"
  $deptype = New-Object "Microsoft.SqlServer.Management.Smo.DependencyType"
  $scr.Server = $srv
  $options = New-Object "Microsoft.SqlServer.Management.SMO.ScriptingOptions"
  $options.AllowSystemObjects = $false
  $options.IncludeDatabaseContext = $true
  $options.IncludeIfNotExists = $false
  $options.ClusteredIndexes = $true
  $options.Default = $true
  $options.DriAll = $true
  $options.Indexes = $true
  $options.NonClusteredIndexes = $true
  $options.IncludeHeaders = $false
  $options.ToFileOnly = $true
  $options.AppendToFile = $true
  $options.ScriptDrops = $false 

  # Set options for SMO.Scripter
  $scr.Options = $options

  #=============
  # Tables
  #=============
  $options.FileName = $scriptpath + "\$($dbname)_tables_$(get-date -f yyyy-MM-dd).sql"
  New-Item $options.FileName -type file -force | Out-Null
  Foreach ($tb in $db.Tables)
  {
   If ($tb.IsSystemObject -eq $FALSE)
   {
    $smoObjects = New-Object Microsoft.SqlServer.Management.Smo.UrnCollection
    $smoObjects.Add($tb.Urn)
    $scr.Script($smoObjects)
   }
  }

  #=============
  # Views
  #=============
  $options.FileName = $scriptpath + "\$($dbname)_views_$(get-date -f yyyy-MM-dd).sql"
  New-Item $options.FileName -type file -force | Out-Null
  $views = $db.Views | where {$_.IsSystemObject -eq $false}
  #$views
  Foreach ($view in $views)
  { 
    if ($views -ne $null)
    {
        if ($view.name -NotLike "syncobj*")
        {
            #'' + $view.name
            $scr.Script($view)
        }
    }
  }

  #=============
  # StoredProcedures
  #=============
  $StoredProcedures = $db.StoredProcedures | where {$_.IsSystemObject -eq $false}
  $options.FileName = $scriptpath + "\$($dbname)_stored_procs_$(get-date -f yyyy-MM-dd).sql"
  New-Item $options.FileName -type file -force | Out-Null
  Foreach ($StoredProcedure in $StoredProcedures)
  {
    if ($StoredProcedures -ne $null)
    {   
     $scr.Script($StoredProcedure)
   }
  } 

  #=============
  # Functions
  #=============
  $UserDefinedFunctions = $db.UserDefinedFunctions | where {$_.IsSystemObject -eq $false}
  $options.FileName = $scriptpath + "\$($dbname)_functions_$(get-date -f yyyy-MM-dd).sql"
  New-Item $options.FileName -type file -force | Out-Null
  Foreach ($function in $UserDefinedFunctions)
  {
    if ($UserDefinedFunctions -ne $null)
    {
     $scr.Script($function)
   }
  } 

  #=============
  # DBTriggers
  #=============
  #$DBTriggers = $db.Triggers
  #$options.FileName = $scriptpath + "\$($dbname)_db_triggers_$(get-date -f yyyy-MM-dd).sql"
  #New-Item $options.FileName -type file -force | Out-Null
  #foreach ($trigger in $db.triggers)
  #{
  #  if ($DBTriggers -ne $null)
  #  {
  #    $scr.Script($DBTriggers)
  #  }
  #}

  #=============
  # Table Triggers
  #=============
  $options.FileName = $scriptpath + "\$($dbname)_table_triggers_$(get-date -f yyyy-MM-dd).sql"
  New-Item $options.FileName -type file -force | Out-Null
  Foreach ($tb in $db.Tables)
  {     
    if($tb.triggers -ne $null)
    {
      foreach ($trigger in $tb.triggers)
      {
        $scr.Script($trigger)
      }
    }
  } 
}

#=============
# Execute
#=============
GenerateDBScript "SERVERNAME" "DBNAME" "C:\Backup" 
#GenerateDBScript $args[0] $args[1] $args[2]