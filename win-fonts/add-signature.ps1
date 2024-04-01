[cmdletbinding()]

$cert = Get-ChildItem Cert:\CurrentUser\My -CodeSigningCert |
    Select-Object -First 1

"win-fonts.psd1","win-fonts.psm1" | Foreach-Object {
    Set-AuthenticodeSignature -File $_ -Certificate $cert
}