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
        [parameter(Mandatory)]$FontName
    )
    $shell = New-Object -ComObject "Shell.Application"
    $namespace = $shell.Namespace("C:\Windows\Fonts")
    $font = $namespace.ParseName($FontName)
    if(!$font){
        Write-Error "$FontName not found"
        return
    }

    [PSCustomObject]@{
        Name   = $font.Name
        ShellObject = $font
        Path   = $font.Path
        Hidden = $namespace.GetDetailsOf($font,2) -eq 'Hide'
    }
}

Function Set-FontStatus {
    <#
        .SYNOPSIS
            Set Font "Show" or "Hide" Status Font by Name

        .DESCRIPTION
            Hide/Show font in Windows Explorer making the font unavailable/available to use in Apps. Font remains installed

        .EXAMPLE
            Set-FontStatus -Status Hide -Name "Monotype Corsiva Italic"
            Set-FontStatus -Status Show -Name "Monotype Corsiva Italic"

        .OUTPUTS
            Use -Verbose for output
    #>
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSReviewUnusedParameter", "")]
    [CmdletBinding(SupportsShouldProcess)]
    Param(
        [parameter(Mandatory)]$Status,
        [parameter(Mandatory)]$Name
    )

    switch -regex ($Status){
         "Show" { Show-Font @args }
         "Hide" { Hide-Font @args}
         default { throw "$Status is not valid"}
    }
}
Function Hide-Font {
    Param(
        [parameter(Mandatory)]$FontName
    )

    $font = Get-Font $FontName
    if(!$font){
        Write-Error "$FontName not found"
        return
    }

    if($font.hidden){
        Write-Verbose "Font '$FontName' is already set to 'Hide'"
        return -1
    }
    Write-Verbose "Setting font '$FontName' to 'Hide'"
    $font.ShellObject.Verbs() | Where-Object Name -eq '&Hide' | ForEach-Object { $_.DoIt() }
    # reload font
    $font = Get-Font $FontName
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
    Param(
        [parameter(Mandatory)]$FontName
    )

    $font = Get-Font $FontName
    if(!$font){
        Write-Error "$FontName not found"
        return
    }

    if(!$font.hidden){
        Write-Error "Font '$FontName' is already set to 'Show'"
        return
    }

    Write-Verbose "Setting font '$FontName' to 'Show'"
    $font.ShellObject.Verbs() | Where-Object Name -eq '&Show'  | ForEach-Object { $_.DoIt() }
    # reload
    $font = Get-Font $FontName
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
    $n = $sh.Namespace("C:\Windows\Fonts")
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
    $n = $sh.Namespace("C:\Windows\Fonts")
    $n.Items() | Where-Object {$_.Name -eq $Name } | ForEach-Object {[PSCustomObject]@{ Name=$_.Name ; Path=$_.Path; Hidden= $n.GetDetailsOf($_,2); FontObject=$_} }
}
# SIG # Begin signature block
# MIIFuQYJKoZIhvcNAQcCoIIFqjCCBaYCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCBAxLhgQ5UFesOz
# PskfpvBqtqcJmduVctqwEz//11Hqn6CCAyIwggMeMIICBqADAgECAhA8Azq0Wr3+
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
# hvcNAQkEMSIEIPg35fmKE1DNoRPQoO0HGmRnm4fA3UCCG3ChWShDA64wMA0GCSqG
# SIb3DQEBAQUABIIBAL4llxVz0ELpdt4dE1PpyrjAymTmEmr6NIJ3nZxkew5BME9n
# CBX0T+jbdFYNyd63qaDqb9SpaKGgChgAwYYTYb8ntgsqeO8bvNrA0md7l+88H0bs
# /eq+lttq/RhdIh4F3JBWRnYxTWqU5H5earTZRVJJh7zB6OPtfVnE2so4QQ7EiJ1o
# WD74OXuZzrOJ/61QTwfJgFcIis7HyxhwUZbH8FQFeL7XRcC+NaNLSjl59Z8AN3Pu
# ncS+SQ0sSB5qnTXG3Ej1OcmIXpNkbO01MYmU8nERxG71nfZFH8K0Ft5BTaweW+U7
# 1FbHx+SKvkvajCWTZocNEtH6k2XDDQGxbGr8l/Q=
# SIG # End signature block
