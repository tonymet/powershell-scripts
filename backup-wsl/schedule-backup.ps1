$time = New-ScheduledTaskTrigger -Daily -At 2pm 
$user = (whoami)
$action = New-ScheduledTaskAction -Execute "${env:ProgramFiles}\PowerShell\7\pwsh.exe" -Argument "-noninteractive -nologo -noprofile $HOME\scripts\backup-wsl\backup-wsl.ps1"
Register-ScheduledTask -TaskName "Backup-WSL" -Trigger $Time -User $User -Action $action