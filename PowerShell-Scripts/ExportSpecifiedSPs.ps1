# Usage:  powershell ExportSchema.ps1 "SERVERNAME" "DATABASE" "C:\<YourOutputPath>"

# Start Script
#Set-ExecutionPolicy RemoteSigned

# Scripter class options
# https://msdn.microsoft.com/en-us/subscriptions/index/microsoft.sqlserver.management.smo.scriptingoptions

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
  $options.IncludeDatabaseContext = $false
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

  # Collect all existing SP objects
  $StoredProcedures = $db.StoredProcedures | where {$_.IsSystemObject -eq $false}
  #$StoredProcedures[1].Urn
  #$StoredProcedures[1].DateLastModified.ToShortDateString()
  
  # Add the names of the SPs you would like to script
  $SPs = 'AccBalReport_XMLFormat',
  'Ws_GiftCard_Phone_Activation_old',
  'Ws_Regenerate'
  
  $options.FileName = $scriptpath + "\$($dbname)_specified_stored_procs_$(get-date -f yyyy-MM-dd).sql"
  New-Item $options.FileName -type file -force | Out-Null
  Foreach ($StoredProcedure in $StoredProcedures)
  {
    if ($StoredProcedures -ne $null)
    {   
      $SPName = $StoredProcedure.Urn.Value -replace [regex]::Escape("Server[@Name='GPS-4040\GPS4040']/Database[@Name='Alexis_Backup']/StoredProcedure[@Name='"), ""
      #$StoredProcedure.DateLastModified.ToShortDateString()
      $SPName = $SPName -replace "\' and @Schema=\'dbo\']",""
      
      # Only script SPs that are in the predefined list
      if ($SPs -contains $SPName)
      {
        $SPName
        $scr.Script($StoredProcedure)
      }
    }
  } 
}

#=============
# Execute
#=============
GenerateDBScript "GPS-4040\GPS4040" "Alexis_Backup" "D:\Alexis_Schema_Export_For_ITS"
#GenerateDBScript $args[0] $args[1] $args[2]