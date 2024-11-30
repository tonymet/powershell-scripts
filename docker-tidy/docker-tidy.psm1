$ModuleName="Docker-Tidy"
Function Optimize-DockerTidy{
    $savingsImage=$(docker image prune -f | Select-String -Pattern reclaimed )
    $savingsContainer=$(docker container prune -f | Select-String -Pattern reclaimed)
    $LogSource = $ModuleName

    if($LASTEXITCODE -ne 0){
        $message="ERROR: Docker-Tidy failed. Run this script manually to obtain the error message"
        Write-EventLog  -LogName Application -Source $LogSource -EventID 3001 -Message $message
    } else {
        $message="Docker-Tidy success. image=${savingsImage}, container=${savingsContainer}"
        Write-EventLog  -LogName Application -Source $LogSource -EventID 3002 -Message $message
    }
}

Function Install-DockerTidy{
    # must be run as administrator
    New-EventLog -LogName Application -Source $ModuleName
    Register-DockerTidy
}

Function Register-DockerTidy{
    if (Get-ScheduledTask -TaskName $ModuleName -WarningAction silentlyContinue){
        Write-Error "Already Installed: ${ModuleName}"
        exit 1
    }
    $time = New-ScheduledTaskTrigger -Weekly -At 3pm -DaysOfWeek Sunday
    $user = (whoami)
    $action = New-ScheduledTaskAction -Execute "${env:ProgramFiles}\PowerShell\7\pwsh.exe"`
        -Argument "-noninteractive -nologo -noprofile`
        -C `"Import-Module $HOME\scripts\docker-tidy && Optimize-DockerTidy`""
    Register-ScheduledTask -TaskName  $taskName -Trigger $Time -User $User -Action $action
}

Function Get-DockerTidyEvent {
    Get-EventLog -LogName Application -Source $ModuleName

}