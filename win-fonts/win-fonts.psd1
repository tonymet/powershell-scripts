@{
    RootModule            = 'win-fonts.psm1'
    ModuleVersion         = '0.0.1'
    CompatiblePSEditions  = @(
        'Core'
    )
    GUID                  = ''
    Author                = 'tonymet'
    CompanyName           = 'tonymet'
    Copyright             = '(c) 2024 tonyme. All rights reserved.'
    Description           = 'Powershell Module for Managing Windows Fonts using Shell.Application / Windows Explorer'
    PowerShellVersion     = '5.1'
    ProcessorArchitecture = 'None'
    RequiredAssemblies    = @()
    ScriptsToProcess      = @()
    TypesToProcess        = @()
    FormatsToProcess      = @()
    NestedModules         = @()
    FunctionsToExport     = @(
        'Set-FontStatus'
        'Search-FontName'
        'Search-FontStatus'
    )
    CmdletsToExport       = @()
    VariablesToExport     = @()
    AliasesToExport       = '*'
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
            LicenseUri = 'https://github.com/tonymet/powershell-scripts/LICENSE'
            ProjectUri = 'https://github.com/tonymet/powershell-scripts'
            IconUri    = 'https://raw.githubusercontent.com/PSModule/Fonts/main/icon/icon.png'
        }
    }
}