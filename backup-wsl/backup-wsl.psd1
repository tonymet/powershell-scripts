#
# Module manifest for module 'backup-wsl'
#
# Generated by: tonymet
#
# Generated on: 12/11/2024
#

@{

# Script module or binary module file associated with this manifest.
RootModule = '.\backup-wsl'

# Version number of this module.
ModuleVersion = '0.0.3'

# Supported PSEditions
# CompatiblePSEditions = @()

# ID used to uniquely identify this module
GUID = '448315ca-510a-4236-b480-d698154a36cb'

# Author of this module
Author = 'tonymet'

# Company or vendor of this module
CompanyName = 'tonymet'

# Copyright statement for this module
Copyright = '(c) tonymet. All rights reserved.'

# Description of the functionality provided by this module
Description = 'Backup WSL to Onedrive using Robocopy, Daily Scheduled Task'

# Minimum version of the PowerShell engine required by this module
PowerShellVersion = '5.1'

#FunctionsToExport = @()
FunctionsToExport = @('Backup-WSL', 'Install-BackupWSL', 'Get-BackupWSLEvent', 'Build-BackupWSLSignature')
#CmdletsToExport = @('Backup-WSL', 'Install-BackupWSL', 'Build-BackupWSLSignature')
VariablesToExport = @()
AliasesToExport = @()
DscResourcesToExport = @()
ModuleList = @()
FileList = @('backup-wsl.psd1', 'backup-wsl.psm1')

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.

PrivateData = @{

    PSData = @{
        Tags = @(
            'wsl'
            'linux'
            'robocopy'
            'scheduled'
            'scheduler'
            'taskscheduler'
            'scheduledtasks'
            'tasks'
            'events'
        )
        LicenseUri = 'https://github.com/tonymet/powershell-scripts/blob/master/LICENSE'
        ProjectUri = 'https://github.com/tonymet/powershell-scripts/tree/master/backup-wsl'
        IconUri    = 'https://raw.githubusercontent.com/PSModule/Fonts/main/icon/icon.png'
    }
}
# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}


# SIG # Begin signature block
# MIIFuQYJKoZIhvcNAQcCoIIFqjCCBaYCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCBGmuXqENW0/RIE
# lMNmGcnUC/xdOsUmxb6KekA9Uzj+VKCCAyIwggMeMIICBqADAgECAhA8Azq0Wr3+
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
# hvcNAQkEMSIEIKHbPwHFGfLfr6ScqynZX6WO6agpIPdeXqiyco6A5O/SMA0GCSqG
# SIb3DQEBAQUABIIBAIVJ0LpwtDr57FrqmJHz4UyFTMX13Dyt0MK6Rm6j8W7O6CST
# eIod6K4rrCnMrnGGaGNmtLwIV/ANvohhACEPdXPo4YRWKYtWo5eY/lStTMnAzkIc
# n0CNI6o0rCVGY28GKNxhhryx+Y3nGaxurCpOXl87A4td3PzCzUgbD9L4v3ximb2u
# LctFRxhVVbDm2qf8harc1+/uxrDd16cZf0CwpfD4pMGKpukAZJ1IjQEM143P6rA4
# HqJBVq0xxHSsdkQ4v/w+wN3GQEleranVrtZ3IbRitEU3S7NEGHm8lExB8Qdlk+4s
# bN98a8rwGWcP57ESU5V9eY8JNC2lA4YB+iqiCAc=
# SIG # End signature block
