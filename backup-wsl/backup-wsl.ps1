# backup wsl contents on a schedule
# set & truncate $logfile
$logfile="$HOME\backup-wsl.log.txt"
if ((Get-Item $logfile).length -gt 128000){
    Remove-Item $logfile
}
$src="\\wsl.localhost\Debian\home\${env:Username}\sotion"
$dest=$(Join-Path ${env:OneDrive} "Documents\Sotion")
Write-EventLog  -LogName Application -Source "Backup-WSL" -EventID 3001 -Message "Starting Backup"
$t0=(Get-Date)
#robocopy $src $dest /W:1 /R:0 /E /xd node_modules  /NFL /NDL /LOG+:$logfile
robocopy $src $dest /W:1 /R:0 /E /xd node_modules  /NFL /LOG+:$logfile
$exitcoderobo=$LASTEXITCODE
$t1=(Get-Date)
$delta =($t1-$t0)
$message="Finished Backup. Duration = $delta"
if($exitcoderobo -ne 0){
    $message="ERROR: Finished Backup. Backup failed. Duration = $delta . Check $logfile for error"
}
Write-EventLog  -LogName Application -Source "Backup-WSL" -EventID 3001 -Message $message
exit $exitcoderobo