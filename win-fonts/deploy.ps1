. ".\secrets.ps1"
$parameters = @{
    Path        = Get-Item "win-fonts"
    NuGetApiKey = $secrets.NuGetApiKey
    LicenseUri  = "https://github.com/tonymet/powershell-scripts/blob/master/LICENSE"
    Tag         = "fonts","powershell","powershell-module","PSEdition_Core","Windows"
    ReleaseNote = "Updated the ActiveDirectory DSC Resources to support adding users."
    Repository  = "PSGallery"
}

Publish-Module @parameters  