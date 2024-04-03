@{
    RootModule            = 'win-fonts.psm1'
    ModuleVersion         = '0.0.5'
    CompatiblePSEditions  = @(
        'Core'
    )
    GUID = '7a557357-e256-4873-8e0e-5c3f531aa4bf'
    Author                = 'tonymet'
    CompanyName           = 'tonymet'
    Copyright             = '(c) 2024 tonymet. All rights reserved.'
    Description           = 'Powershell Module for Managing Windows Fonts using Shell.Application / Windows Explorer. No files or registry keys are edited directly'
    PowerShellVersion     = '5.1'
    ProcessorArchitecture = 'None'
    RequiredAssemblies    = @()
    ScriptsToProcess      = @()
    TypesToProcess        = @()
    FormatsToProcess      = @()
    NestedModules         = @()
    FunctionsToExport     = @(
        'Hide-Font'
        'Show-Font'
        'Remove-Font'
        'Search-FontName'
        'Search-FontStatus'
    )
    CmdletsToExport       = @()
    VariablesToExport     = @()
    AliasesToExport       = @()
    ModuleList            = @()
    FileList              = @(
        'win-fonts.psd1'
        'win-fonts.psm1'
    )
    PrivateData           = @{
        PSData = @{
            Tags       = @(
                'fonts'
                'powershell'
                'powershell-module'
                'PSEdition_Core'
                'Windows'
            )
            LicenseUri = 'https://github.com/tonymet/powershell-scripts/blob/master/LICENSE'
            ProjectUri = 'https://github.com/tonymet/powershell-scripts/tree/master/win-fonts'
            IconUri    = 'https://raw.githubusercontent.com/PSModule/Fonts/main/icon/icon.png'
        }
    }
}
# SIG # Begin signature block
# MIIFuQYJKoZIhvcNAQcCoIIFqjCCBaYCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCBc4BVgYbpdk469
# jx2gMGXTXMrhh6lVzTPHiMd08A6CRqCCAyIwggMeMIICBqADAgECAhA8Azq0Wr3+
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
# hvcNAQkEMSIEIPkVC95gh4H5PG9GwxQHX9mnDcig6b4Ou7VEAJNtjdNtMA0GCSqG
# SIb3DQEBAQUABIIBAIsHPvvB/q7DmxCbZt9IVvcY9Rrrt6ZdyLuca8OAJ3K4YTAi
# 4fTkIGPvDemi1r5U54LF34xwKJViA09/7YtWPI3Wp0fADWD4EvUUhRYOaohHvpY7
# 19AjgABDt7SBgg5HkbI0ZYPhc9hijY86WEus/F63U+PaLnFdMM3OzkqomZrfEILH
# 5twpmxV3c6pPR1VH9+XAQN6T7qAR/Eem5VW07oN5KNceBceh2Sim32cMl+h1bcbj
# 7eS2+EQPxcHttfwtjNO+FWs8+WvnWtf8daVse1bvRsglWanhkj3j/lRNVE5jnprl
# tEJU2h3BzY4TSecKFK3zTeQMKRjkJ9B8hpPRmPk=
# SIG # End signature block
