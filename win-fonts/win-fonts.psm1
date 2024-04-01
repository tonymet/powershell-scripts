$FontDir = Join-Path $ENV:WINDIR "Fonts"
if(! (Test-Path $FontDir) ){
    throw "$FontDir does not exist"
}
Function Get-Font {
     <#
        .SYNOPSIS
            Get Font Object by Name

        .DESCRIPTION
            Get Font Object by Name

        .EXAMPLE
            Get-Font


        .EXAMPLE
            Get-Font -Name 'Arial'

        .OUTPUTS
            [System.Collections.Generic.List[PSCustomObject]]
    #>
    Param(
        [parameter(Mandatory)]$Name
    )
    $shell = New-Object -ComObject "Shell.Application"
    $namespace = $shell.Namespace($FontDir)
    $font = $namespace.ParseName($Name)
    if(!$font){
        Write-Error "$Name not found"
        return
    }

    [PSCustomObject]@{
        Name   = $font.Name
        ShellObject = $font
        Path   = $font.Path
        Hidden = $namespace.GetDetailsOf($font,2) -eq 'Hide'
    }
}

Function Hide-Font {
    <#
        .SYNOPSIS
            Hide Font in Fonts control panel.  Hidden from application font lists

        .DESCRIPTION
            Hide font in Windows Explorer making the font unavailable to use in Apps. Font remains installed

        .EXAMPLE
            Hide-Font -Name "Monotype Corsiva Italic"

        .OUTPUTS
            Use -Verbose for output
    #>
    Param(
        [parameter(Mandatory)]$Name
    )

    $font = Get-Font $Name
    if(!$font){
        Write-Error "$Name not found"
        return
    }

    if($font.hidden){
        Write-Verbose "Font '$Name' is already set to 'Hide'"
        return -1
    }
    Write-Verbose "Setting font '$Name' to 'Hide'"
    $font.ShellObject.Verbs() | Where-Object Name -eq '&Hide' | ForEach-Object { $_.DoIt() }
    # reload font
    $font = Get-Font $Name
    if(!$font.hidden){
        throw "Error Hiding Font"
    }
    return
}

Function Remove-Font {
    <#
        .SYNOPSIS
            Remove (delete) a font from C:\Windows\Fonts via the shell.

        .DESCRIPTION
            Remove (delete) a font from c:\Windows\Fonts via the shell (windows explorer). Font will
            be placed in the trash.


        .EXAMPLE
            Remove-Font -Name "Monotype Corsiva Italic"

        .OUTPUTS
            Use -Verbose for output
    #>
    [CmdletBinding(SupportsShouldProcess)]
    Param(
        [parameter(Mandatory)]$Name
    )

    $font = Get-Font $Name
    if(!$font){
        Write-Error "$Name not found"
        return
    }

    Write-Verbose "Deleting font '$Name'"
    if($PSCmdlet.ShouldProcess($Name)){
        $font.ShellObject.Verbs() | Where-Object Name -eq '&Delete'  | ForEach-Object { $_.DoIt() }
    }
}

Function Show-Font {
    <#
        .SYNOPSIS
            Show font in Windows control panel and apps

        .DESCRIPTION
            Show font in Windows Explorer making the font available to use in Apps. Font remains installed

        .EXAMPLE
            Show-Font -Name "Monotype Corsiva Italic"

        .OUTPUTS
            Use -Verbose for output
    #>
    Param(
        [parameter(Mandatory)]$Name
    )

    $font = Get-Font $Name
    if(!$font){
        Write-Error "$Name not found"
        return
    }

    if(!$font.hidden){
        Write-Error "Font '$Name' is already set to 'Show'"
        return
    }

    Write-Verbose "Setting font '$Name' to 'Show'"
    $font.ShellObject.Verbs() | Where-Object Name -eq '&Show'  | ForEach-Object { $_.DoIt() }
    # reload
    $font = Get-Font $Name
    if($font.hidden){
        throw "Error Showing Font"
    }
}

Function Search-FontStatus {
     <#
        .SYNOPSIS
            Search font by status : "Hide" or "Show"

        .DESCRIPTION
            Search font by status : "Hide" or "Show"

        .EXAMPLE
            Search-FontStatus -Status "Hide"
        .EXAMPLE
            Show All fonts:
            Search-FontStatus
        .EXAMPLE
            Search-FontStatus -Status "Show"
        .OUTPUTS
            Use -Verbose for output
    #>
    Param(
        [string]$Status
    )
    $sh = New-Object -ComObject "Shell.Application"
    $n = $sh.Namespace($FontDir)
    switch -regex ($Status) {
        "Show|Hide" {
            $n.Items() | ForEach-Object {[PSCustomObject]@{ Name=$_.Name ; Path=$_.Path; Hidden= $n.GetDetailsOf($_,2); FontObject=$_ } } | Where-Object {$_.Hidden -eq $Status}
        }
        Default {
            $n.Items() | ForEach-Object {[PSCustomObject]@{ Name=$_.Name ; Path=$_.Path; Hidden= $n.GetDetailsOf($_,2); FontObject=$_} }
        }
    }
}
Function Search-FontName {
     <#
        .SYNOPSIS
            Search font by Name : "Hide" or "Show"

        .DESCRIPTION
            Search font by status : "Hide" or "Show"

        .EXAMPLE
            Search-FontStatus -Status "Hide"
        .EXAMPLE
            Show All fonts:
            Search-FontStatus
        .EXAMPLE
            Search-FontStatus -Status "Show"
        .OUTPUTS
            Use -Verbose for output
    #>
    Param(
        [string]$Name
    )
    $sh = New-Object -ComObject "Shell.Application"
    $n = $sh.Namespace($FontDir)
    $n.Items() | Where-Object {$_.Name -eq $Name } | ForEach-Object {[PSCustomObject]@{ Name=$_.Name ; Path=$_.Path; Hidden= $n.GetDetailsOf($_,2); FontObject=$_} }
}
# SIG # Begin signature block
# MIIFuQYJKoZIhvcNAQcCoIIFqjCCBaYCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCCw5gefkdAzT0pL
# LSELdtDLldrItKn0ejq9khHT/9ipaKCCAyIwggMeMIICBqADAgECAhA8Azq0Wr3+
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
# hvcNAQkEMSIEIBZIU7mKuFUh3bK+TUTA2XWRPE9QpPs/6fhvJbtrUZc9MA0GCSqG
# SIb3DQEBAQUABIIBAKrhEPVdf3iLwPGG4NxqS9ztokGyr0PUo1/7BdcZI2O0hZ8t
# NTypp2HrRHINTNDDAJqMi/wXNBz9hUDcwhk+xiCYox63gXCHZKZU7k3VmD0zxDnh
# L0fyut7Py0dJ0veTYRyDihtPEHAWvVoDQfUik5Xig+Gse/6oNm0Ct6vH5e871uFD
# O2WyfSKH4byjNKIdq8PwxHth/8PR6/EIpebuV3qVSBjqcfBbGRyqR96/cxGJlHJF
# I7OflIrW0/NPw4OYm2J5NPjJooLmOFtcqwP/tAvxeHFsyc5yNr/5F/JqDkXNs6rw
# Z6Ewsntamzy4U+zY/Os1lq72BGxTDaAplLJAk1o=
# SIG # End signature block
