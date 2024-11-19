# Get BIOS version information
function Get-BIOS
{
    Get-CimInstance -ClassName win32_bios
}
