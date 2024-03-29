#  $FontVerbs = @{
#     Preview = 'Pre&view'
#     Print =   '&Print'
#     Show =    '&Show'
#     #      'Edit with &Notepad++'
#     AddToFavorites =   'Add to &Favorites'
#     Copy =             '&Copy'
#     Delete =           '&Delete'
#     Properties =       'P&roperties'
# }
Function Get-Font {
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

Function Search-Font-Status {
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

Function Search-Font-Name {
    Param(
        [string]$Name
    )
    $sh = New-Object -ComObject "Shell.Application"
    $n = $sh.Namespace("C:\Windows\Fonts")
    $n.Items() | Where-Object {$_.Name -eq $Name } | ForEach-Object {[PSCustomObject]@{ Name=$_.Name ; Path=$_.Path; Hidden= $n.GetDetailsOf($_,2); FontObject=$_} }
}