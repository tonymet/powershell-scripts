. ".\win-fonts\secrets.ps1"
$parameters = @{
    Path        = Get-Item "backup-wsl"
    NuGetApiKey = $secrets.NuGetApiKey
    #LicenseUri  = "https://github.com/tonymet/powershell-scripts/blob/master/LICENSE"
    #Tag         = "docker","Windows", "PSEdition_Core", "powershell", "powershell-module", "scheduled","scheduler","taskscheduler","scheduledtasks","tasks","events"
}

Publish-Module @parameters