Function Backup-WSL(){
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
}

Function Install-BackupWSL{
    $time = New-ScheduledTaskTrigger -Daily -At 2pm
    $user = (whoami)
    $action = New-ScheduledTaskAction -Execute "${env:ProgramFiles}\PowerShell\7\pwsh.exe"`
        -Argument "-noninteractive -nologo -noprofile`
        -C `"Import-Module $HOME\scripts\backup-wsl && Backup-WSL`""
    Register-ScheduledTask -TaskName "Backup-WSL" -Trigger $Time -User $User -Action $action
}

Function Build-BackupWSLSignature {
    $cert = Get-ChildItem Cert:\CurrentUser\My -CodeSigningCert |
        Select-Object -First 1

    "backup-wsl.psd1","backup-wsl.psm1" | Foreach-Object {
        Set-AuthenticodeSignature -File $_ -Certificate $cert
    }
}
# SIG # Begin signature block
# MIIFuQYJKoZIhvcNAQcCoIIFqjCCBaYCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCD+bbImfAb8N2p1
# 9YQI2dKMMUdGH09tc9BQwV8ogg33PaCCAyIwggMeMIICBqADAgECAhA8Azq0Wr3+
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
# hvcNAQkEMSIEIHf2i7JaUZXitfksLBOcCEqrR2dOsgHhaEFM0GN/9S+hMA0GCSqG
# SIb3DQEBAQUABIIBAJbOmR1wTwOuqgdB6rc2BztW7GymVtenWsQ7lwBaiqr/AR9X
# SJEE0uKOUzSk1AitvDz7+DV6WkcPUf9CmMNx1DNbQVWzZ1eqQoneRExhW1QzHYSS
# sxllkYE+9sjQ6dUlfJAwz2iH2YH4IElq48pDgEgax5x1FDgTY+J/oqEecdBord2U
# Uut5Fvgwjf0t+32YbeohnUgFzXZZquZvOdJioukl27o5yIZOOON2xeWNiu5dcbWl
# 0jMPQLnzwCF8oXpGwvm9ATz913Rm6YvN2CICPh8itSO3NN30ZlXxIaMfAreI3Qfs
# pXe9DhsUEXA3SjIzRnbg8c0YRoKZAJfga231lFc=
# SIG # End signature block
