
# Check 7zip presence
if (-not (test-path "C:\Program Files (x86)\7-Zip\7z.exe")) {throw "C:\Program Files (x86)\7-Zip\7z.exe is needed"} 
 
$zipfile = "DB_Backup-Scripts_$(get-date -f yyyy-MM-dd_HH-mm).zip"
$FPath = "D:\Backup" 
$SQLFiles = Get-ChildItem -Path $FPath | Where-Object { $_.Extension -eq ".sql" } 

foreach ($file in $SQLFiles) { 
    $name = $file.name
    $directory = $file.DirectoryName 
               
    & "C:\Program Files (x86)\7-Zip\7z.exe" a -tzip "D:\Backup\$zipfile" "$directory\$name"                
} 
                
                
#Copy-Item -Path $ArchiveFile -Destination $destination -Force