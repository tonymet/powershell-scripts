$ModuleName = "Backup-WSL"
$env:WSL_UTF8 = 1
Function Backup-WSL() {
    <#
        .SYNOPSIS
            Orchestrates both file and repository backups.
        .DESCRIPTION
            Calls Backup-WSLFiles to sync files with OneDrive and Backup-Repos to push git repositories to gcloud.
    #>
    $fileExitCode = Backup-WSLFiles
    $repoExitCode = Backup-Repos
    
    # Prioritize file backup exit code if it's an error (Robocopy error codes >= 8)
    # But if it's 0-7 (success/minor issues), and repo fails (non-zero), use that.
    $finalExitCode = $fileExitCode
    if ($fileExitCode -lt 8 -and $repoExitCode -ne 0) {
        $finalExitCode = $repoExitCode
    }
    
    exit $finalExitCode
}

Function Backup-WSLFiles() {
    <#
        .SYNOPSIS
            Backup //wsl.localhost/DISTRO/USERNAME/SUBDIR to %USERPROFILE%/OneDrive/Documents/SUBDIR with robocopy .
            set $ENV:BACKUP_WSL_SUBDIR to specify the subdir

        .DESCRIPTION
            Backup //wsl.localhost/DISTRO/USERNAME/SUBDIR to %USERPROFILE%/OneDrive/Documents/SUBDIR with robocopy .
            set $ENV:BACKUP_WSL_SUBDIR to specify the subdir

        .EXAMPLE
            Backup-WSLFiles
        .EXAMPLE
            # full command to trigger from .bat or Scheduled Task
            pwsh -C "Import-Module $HOME\scripts\backup-wsl && Backup-WSLFiles"

        .OUTPUTS
            see %USERPROFILE%\backup-wsl.log.txt
    #>
    $logfile = "$HOME\backup-wsl.log.txt"
    if (Test-Path $logfile) {
        if ((Get-Item $logfile).length -gt 1280000) {
            Remove-Item $logfile
        }
    }
    $subDir = [string]($env:BACKUP_WSL_SUBDIR ?? "sotion")
    $wslUser = [string](wsl whoami)
    $wslDistro = [string](wsl --list -q | Select-Object -first 1)
    if ($LASTEXITCODE -ne 0) {
        $message = "wsl command missing"
        Write-EventLog  -LogName Application -Source "Backup-WSL" -EventID 3001 -Message $message
        return
    }
    $src = [string](Join-Path "\\wsl.localhost" $wslDistro "home" $wslUser $subDir)
    $dest = [string](Join-Path ${env:OneDrive} "Documents\${subDir}")
    Write-EventLog  -LogName Application -Source "Backup-WSL" -EventID 3001 -Message "Starting Backup"
    $t0 = (Get-Date)
    $roboOptions = @( '/W:1', '/R:0', '/E',
        '/xd', "node_modules", "venv", "test_venv", "bin", "dist" ,
        '/NFL', "/LOG+:${logfile}")
    robocopy $src $dest $roboOptions
    $exitcoderobo = $LASTEXITCODE
    $t1 = (Get-Date)
    $delta = ($t1 - $t0)
    $message = "Finished Backup. Duration = $delta"
    if ($exitcoderobo -ne 0) {
        $message = "ERROR: Finished Backup. Backup failed. Duration = $delta . Check $logfile for error"
    }
    Write-EventLog  -LogName Application -Source "Backup-WSL" -EventID 3001 -Message $message
    return $exitcoderobo
}

Function Backup-Repos() {
    <#
        .SYNOPSIS
            Pushes git repositories to "gcloud" remote.
        .DESCRIPTION
            Iterates over a list of git repositories and pushes to "gcloud" remote.
    #>
    $repos = @(
        "\\wsl.localhost\Debian\home\$env:USERNAME\sotion\sotion"
    )

    $allSuccess = $true
    foreach ($repo in $repos) {
        if (Test-Path $repo) {
            Write-EventLog -LogName Application -Source "Backup-WSL" -EventID 3001 -Message "Pushing git repo $repo to gcloud"
            Push-Location $repo
            try {
                # Pushing all branches to gcloud remote
                git push gcloud --all
                if ($LASTEXITCODE -eq 0) {
                    Write-EventLog -LogName Application -Source "Backup-WSL" -EventID 3001 -Message "Successfully pushed $repo to gcloud"
                }
                else {
                    Write-EventLog -LogName Application -Source "Backup-WSL" -EventID 3001 -Message "Failed to push $repo to gcloud. Exit code: $LASTEXITCODE"
                    $allSuccess = $false
                }
            }
            catch {
                Write-EventLog -LogName Application -Source "Backup-WSL" -EventID 3001 -Message "Exception during git push for $(repo) : $($_.Exception.Message)"
                $allSuccess = $false
            }
            finally {
                Pop-Location
            }
        }
        else {
            Write-EventLog -LogName Application -Source "Backup-WSL" -EventID 3001 -Message "Git repo path not found: $repo"
            $allSuccess = $false
        }
    }
    return $allSuccess ? 0 : 1
}

Function Measure-Folders() {
    $excludedFolders = @("node_modules", "venv", "test_venv", "bin", "dist")
    $results = foreach ($folderName in $excludedFolders) {
        Get-ChildItem -Path "." -Recurse -Directory -Filter $folderName | ForEach-Object {
            $size = (Get-ChildItem $_.FullName -Recurse -File | Measure-Object -Property Length -Sum).Sum
            [PSCustomObject]@{
                FolderName = $_.FullName
                SizeMB     = [Math]::Round($size / 1MB, 2)
            }
        }
    }

    $results | Format-Table -AutoSize
    $totalGB = [Math]::Round(($results.SizeMB | Measure-Object -Sum).Sum / 1KB, 2)
    Write-Host "Total space to be reclaimed: $totalGB GB" -ForegroundColor Cyan
}

Function Get-WSLDiskInfo() {
    # 1. Define the explicit Docker VHDX path
    $dockerPath = "$env:LOCALAPPDATA\Docker\wsl\disk\docker_data.vhdx"

    # 2. Retrieve WSL base directories from the Registry
    # The 'BasePath' value in the registry points to the folder containing the vhdx
    $wslBaseDirs = Get-ChildItem "HKCU:\Software\Microsoft\Windows\CurrentVersion\Lxss" | 
    Get-ItemProperty | 
    ForEach-Object { $_.BasePath -replace '^\\\\\?\\', '' }

    # 3. Combine both sources into a single array of search paths
    $searchPaths = @($dockerPath) + $wslBaseDirs

    # 4. Locate all .vhdx files and calculate sizes
    $results = $searchPaths | ForEach-Object {
        if (Test-Path $_) {
            # Search recursively if the path is a directory; get item if it is a file
            Get-ChildItem -Path $_ -Filter "*.vhdx" -Recurse -ErrorAction SilentlyContinue
        }
    } | Select-Object `
        FullName, 
    @{Name = "Size_GB"; Expression = { [math]::Round($_.Length / 1GB, 2) } },
    @{Name = "Size_MB"; Expression = { [math]::Round($_.Length / 1MB, 2) } }

    # 5. Output the results to the console
    $results | Sort-Object Size_GB -Descending | Format-Table -AutoSize

}

Function Install-BackupWSL {
    <#
        .SYNOPSIS
            Install scheduled task 2pm daily

        .DESCRIPTION
            Install scheduled task 2pm daily

        .EXAMPLE
            Install-BackupWSL

        .OUTPUTS
            None
    #>
    $time = New-ScheduledTaskTrigger -Daily -At 2pm
    $user = (whoami)
    $action = New-ScheduledTaskAction -Execute "${env:ProgramFiles}\PowerShell\7\pwsh.exe"`
        -Argument "-noninteractive -nologo -noprofile`
        -C `"Import-Module $HOME\scripts\backup-wsl && Backup-WSL`""
    Register-ScheduledTask -TaskName "Backup-WSL" -Trigger $Time -User $User -Action $action
}
Function Get-BackupWSLEvent {
    <#
        .SYNOPSIS
            Lists latest BackupWSL events from Windows Event Log

        .DESCRIPTION
            Lists latest BackupWSL events from Windows Event Log

        .EXAMPLE
            Get-BackupWSLEvent

        .OUTPUTS
            System.Diagnostics.EventLogEntry
    #>
    Get-EventLog -LogName Application -Source $ModuleName

}

Function Build-BackupWSLSignature {
    $cert = Get-ChildItem Cert:\CurrentUser\My -CodeSigningCert |
    Select-Object -First 1

    "backup-wsl.psd1", "backup-wsl.psm1" | Foreach-Object {
        Set-AuthenticodeSignature -File $_ -Certificate $cert
    }
}





# SIG # Begin signature block
# MIIFuQYJKoZIhvcNAQcCoIIFqjCCBaYCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCAnMiyx629woI7x
# 1mLSDXmREtFkTRIkunVWlVN2jc68wqCCAyIwggMeMIICBqADAgECAhA8Azq0Wr3+
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
# hvcNAQkEMSIEIKAvWlDTRN5AG0fpsixLZT9adi3yYYlsWpeQbraKPaRdMA0GCSqG
# SIb3DQEBAQUABIIBAGUMGo8IFGbhKUvOFkuv2vmGRyTlQngmhxsvgEH2jCLJqMTU
# OF92OBNrSKN3GZrEpkXFN5MtP2vJJw8acRkQh81hvjJysV8DCYI00idJxh2zIlcN
# /MoqVawUsmAQSSPpEef7LquQl2wx76JQfMni185VINQIPkPCsmG+ErFljU7KTMZ6
# uSOZuYEdNNBjB98C77Rod+rXY8JM1Oihbo3FbEM6UYDGOXLqqKphnkt9LVHOPj3a
# ZtEj3Upxf+bURrVq8TUOot/d6zwsgDBZtubnIjE0tDnstBwwXpVEkiY3f8BG2bKo
# Uh5KKAmMe6COKgxNg8ZJBDJYZqpZv/bfoMuVUtM=
# SIG # End signature block
