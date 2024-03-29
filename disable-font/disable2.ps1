
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
        return -1 
    }

    Write-Verbose "Setting font '$FontName' to 'Show'"
    $font.ShellObject.Verbs() | Where-Object Name -eq '&Show'  | ForEach-Object { $_.DoIt() }
    #$showverb.DoIt()
    # reload
    $font = Get-Font $FontName
    if($font.hidden){
        throw "Error Showing Font"
    }
}