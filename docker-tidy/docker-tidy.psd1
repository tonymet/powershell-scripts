@{
RootModule = 'docker-tidy.psm1'
ModuleVersion = '0.0.1'
CompatiblePSEditions  = @(
    'Core'
)
GUID = 'e49f2736-c30e-4faf-9d23-d66658970d5b'
Author = 'tonymet'
CompanyName = 'tonymet'
Copyright = '(c) tonymet. All rights reserved.'
Description = 'DockerTidy reclaims disk space with a scheduled task to run docker images prune & docker containers prune'
PowerShellVersion = '5.1'

# Modules that must be imported into the global environment prior to importing this module
RequiredModules = @()

# Assemblies that must be loaded prior to importing this module
RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
FormatsToProcess = @()

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
NestedModules = @()

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = @("Install-DockerTidy","Optimize-DockerTidy", "Get-DockerTidyEvent", "Register-DockerTidy", "Build-DockerTidyModuleSignature")

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
# CmdletsToExport = @("Install-DockerTidy","Optimize-DockerTidy", "Get-DockerTidyEvent", "Register-DockerTidy", "Build-DockerTidyModuleSignature")
VariablesToExport = @()
AliasesToExport = @()
DscResourcesToExport = @()
ModuleList = @()
FileList = @(
    'docker-tidy.psd1'
    'docker-tidy.psm1'
)

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData = @{

        PSData = @{
            Tags = @(
                'docker'
                'scheduled'
                'scheduler'
                'taskscheduler'
                'scheduledtasks'
                'tasks'
                'events'
            )
            LicenseUri = 'https://github.com/tonymet/powershell-scripts/blob/master/LICENSE'
            ProjectUri = 'https://github.com/tonymet/powershell-scripts/tree/docker-tidy'
            IconUri    = 'https://raw.githubusercontent.com/PSModule/Fonts/main/icon/icon.png'
        }
    }
}


# SIG # Begin signature block
# MIIFuQYJKoZIhvcNAQcCoIIFqjCCBaYCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCCEkp/nzp3LIptr
# TQLYt6+AZNEhG3YZgfzaHnmTopUeXaCCAyIwggMeMIICBqADAgECAhA8Azq0Wr3+
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
# hvcNAQkEMSIEIH0VNupDqWuNs7g4PY3JOVfgw7i98F5NKq3RA6+NSjMZMA0GCSqG
# SIb3DQEBAQUABIIBAGcczXvh0Bme0J6Q5hmyNE5AL4ZyCgwY+9ilebYYYfOWAh0m
# Bwh9CXBFFAApkAo9uYBt7olWPNOdbVSTPMpVnVdnWz3KtlW5Qvs/x/TwfYXSNffD
# Vri40op3yZvlMMbuSog+YTDJi36EQcCggukMgjykkbh2u87fV2JMBPgR2YChX+Jf
# G7r8IoibeWO310imi7p/imaxzF76JW8rA15qdEtn1+UOsRM1MIGZa6XPGzfbpaL4
# 1yOv0fkgS7nAg4JLB3DI7c9WUQ59CyL4uaBO/GHmZxJeq7baYQf2ekkkBSYvNAOo
# SK1qRIHYoMWDlHZHAQMsPCJO9zbPggOlodO7JB8=
# SIG # End signature block
