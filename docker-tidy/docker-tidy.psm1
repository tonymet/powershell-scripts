$ModuleName="Docker-Tidy"
Function Optimize-DockerTidy{
     <#
        .SYNOPSIS
            Run DockerTidy cleanup (docker image prune & docker container prune)

        .DESCRIPTION
            Run DockerTidy cleanup (docker image prune & docker container prune)

        .EXAMPLE
            Optimize-DockerTidy

        .OUTPUTS
            No Output
    #>
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
     <#
        .SYNOPSIS
            (MUST BE RUN AS ADMINISTRATOR) Installs DockerTidy by creating event log & scheduled task

        .DESCRIPTION
            Installs DockerTidy by creating event log & scheduled task

        .EXAMPLE
            Install-DockerTidy

        .OUTPUTS
            No Output
    #>
    # must be run as administrator
    New-EventLog -LogName Application -Source $ModuleName
    Register-DockerTidy
}

Function Register-DockerTidy{
     <#
        .SYNOPSIS
            Registers scheduled task. Docker-Tidy will run weekly

        .DESCRIPTION
            Registers scheduled task. Docker-Tidy will run weekly

        .EXAMPLE
            Register-DockerTidy

        .OUTPUTS
            No Output
    #>
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
     <#
        .SYNOPSIS
            Lists latest DockerTidy events from Windows Event Log

        .DESCRIPTION
            Lists latest DockerTidy events from Windows Event Log

        .EXAMPLE
            Get-DockerTidyEvent

        .OUTPUTS
            System.Diagnostics.EventLogEntry
    #>
    Get-EventLog -LogName Application -Source $ModuleName

}

Function Build-DockerTidyModuleSignature {
    $cert = Get-ChildItem Cert:\CurrentUser\My -CodeSigningCert |
        Select-Object -First 1

    "docker-tidy.psd1","docker-tidy.psm1" | Foreach-Object {
        Set-AuthenticodeSignature -File $_ -Certificate $cert
    }
}

# SIG # Begin signature block
# MIIFuQYJKoZIhvcNAQcCoIIFqjCCBaYCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCBM2oCbTHM/nff6
# wA0gTRVT9ginSQFNXUPmhxFN5FenKqCCAyIwggMeMIICBqADAgECAhA8Azq0Wr3+
# pEKieGfMmIkiMA0GCSqGSIb3DQEBCwUAMCcxJTAjBgNVBAMMHFBvd2VyU2hlbGwg
# Q29kZSBTaWduaW5nIENlcnQwHhcNMjQwMzI5MjE1NTI0WhcNMjUwMzI5MjIxNTI0
# WjAnMSUwIwYDVQQDDBxQb3dlclNoZWxsIENvZGUgU2lnbmluZyBDZXJ0MIIBIjAN
# BgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA22r/jGspQfAjlNK1WG+vzr08YI7J
# oyY22hYZcgsmKvktxaoY8AARwQK1dTy9lRB3RPG9LARN3D8c/77dJwQV+U7fHQVc
# Wqi8YMsrXYbr/uYWYRiZXdWjYgOaY+jeCcvytvmPGpkVklp5wf8a6wfaUTJuaRe9
# MaJR84KoY4LmyMFpuKf1yX/T3W2H2rjCufha/RqR+I2PdV6onB6+1s+coaEJRt/A
# 4wmzeOBg8xbpIcHRFVwz4JjKPNd62ZdClnGsYepJ1YS+EDmX8nL2Xb1JZ0V+QzTd
# k5PZLgMLq88A1VAkJrvUOWT8cNddxiKJ9Ca0J+tUgafYpwC52YQaEaAlNQIDAQAB
# o0YwRDAOBgNVHQ8BAf8EBAMCB4AwEwYDVR0lBAwwCgYIKwYBBQUHAwMwHQYDVR0O
# BBYEFN/W6W2WQ86WApKXJzjgsw14OgpbMA0GCSqGSIb3DQEBCwUAA4IBAQByATpz
# KPYyk+NSoOesHIX0oD3RYRBpth0A/ASej+R/aY649DeB6/6LvPGY5O2ap0+niA5w
# lB3HViXCVcDiDSzdzwnqWOeRXBqCRo4vqhspXp/sv1tCKtfN4MMVGGdOOG2NO5Pn
# MY93j9yX5zwIzXTF17QL01fpVECf5tDCtKZ6iomWzEqlz9Kbh1f1bSNnqzDlEZyp
# H62dtstbbv/r1qu4+G+Z4NSSs2YtHDWXDTAlg2VC0T3aAo+0f50Chf9zDTC/OUFd
# 4F7VXvyBow9QJKa5F/aTQW6a7/rJaYDLaB2eKJfN8ML+TtIjI2x4kzPyBaSnnIFz
# 9hrzdvgl+EGGjcKiMYIB7TCCAekCAQEwOzAnMSUwIwYDVQQDDBxQb3dlclNoZWxs
# IENvZGUgU2lnbmluZyBDZXJ0AhA8Azq0Wr3+pEKieGfMmIkiMA0GCWCGSAFlAwQC
# AQUAoIGEMBgGCisGAQQBgjcCAQwxCjAIoAKAAKECgAAwGQYJKoZIhvcNAQkDMQwG
# CisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwLwYJKoZI
# hvcNAQkEMSIEILJVTPOoihaaoF5GsysSwVEnvmHsbS5SckIji2MyXuZLMA0GCSqG
# SIb3DQEBAQUABIIBAH3U0YJB8GmFPsyj3ldM9aDzzlXhRcVxapcDj/yv/yJroGt9
# O9ons9WO2RWe3fBiTKuz/tk2VG0OJi+gfn2MdjU3/V5Acf+Uxu9fvr8rjXjHxhZn
# kTIHTSNkAJBSPXSyc+qStXA0Rr/h+b42RUVASrkcKOcNuB2SqQxg6VX/Z3u5JaCU
# 7MqQSU/kzJst1MFXbh+LYGIDNYZr4RqMmomfcoBcIX34U7nXFj7sU78yd2wNsxnl
# dPEVwrH0Ysou/74zBqqhzlgaBOzdUUf1rkSo/zX+S9WPNBb2rfCRrmx06MXhYuTx
# W94xRgbxXdSkFUrs9dnmq1f0tdB02HbQNtX91So=
# SIG # End signature block
