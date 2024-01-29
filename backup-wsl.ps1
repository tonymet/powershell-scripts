# backup wsl contents on a schedule
$src="\\wsl.localhost\Debian\home\tonymet\sotion"
$dest="$HOME\OneDrive\Documents\sotion\"
#Get-ChildItem -Path $src -Recurse -Exclude node_modules | Copy-Item -Destination $dest
# Copy-Item -Recurse -Exclude node_modules -Path $src -Destination $dest
Write-EventLog  -LogName Application -Source "Backup-WSL" -EventID 3001 -Message "Starting Backup"
$logfile="$HOME\backup-wsl.log.txt"
$t0=(Get-Date)
robocopy $src $dest /W:1 /R:1 /E /xd node_modules  /NFL /NDL /LOG+:$logfile
$exitcoderobo=$LASTEXITCODE
$t1=(Get-Date)
$delta =($t1-$t0)
Write-EventLog  -LogName Application -Source "Backup-WSL" -EventID 3001 -Message "Finished Backup. Duration = $delta"
exit $exitcoderobo