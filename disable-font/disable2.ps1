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
    }
    else{
        Write-Verbose "Setting font '$FontName' to 'Hide'"
        $shell = New-Object -ComObject "Shell.Application"
        $namespace = $shell.Namespace("C:\Windows\Fonts")
        $font = $namespace.ParseName($FontName)
        $hideverb = $font.Verbs() | Where-Object Name -like '*hide*'
        $hideverb.DoIt()
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

    if($font.hidden){
        Write-Verbose "Setting font '$FontName' to 'Show'"
        $shell = New-Object -ComObject "Shell.Application"
        $namespace = $shell.Namespace("C:\Windows\Fonts")
        $font = $namespace.ParseName($FontName)
        $showverb = $font.Verbs() | Where-Object Name -like '*show*'
        $showverb.DoIt()
    }
    else{
        Write-Verbose "Font '$FontName' is already set to 'Show'"
    }
}