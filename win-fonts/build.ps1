$files = "win-fonts.psd1","win-fonts.psm1"
$files | ForEach-Object {
    Invoke-ScriptAnalyzer $_
    Get-AuthenticodeSignature $_
}
Test-ModuleManifest win-fonts.psd1
Copy-Item $files win-fonts/