# function New-TemporaryFile {
#     $parent = [System.IO.Path]::GetTempPath()
#     $name = [System.IO.Path]::GetRandomFileName()
#     New-Item -ItemType Directory -Path (Join-Path $parent $name)
# }
function unix2dos2($infile, $outfile){
    if ( ! (Test-Path $infile) ) {
        throw "ERROR: File not found $infile"
    }
    (Get-Content -raw $infile) -replace "`n","`r`n" |
        Set-Content -nonewline $outfile
}
function unix2dos($infile){
    if ( ! (Test-Path $infile) ) {
        throw "ERROR: File not found $infile"
    }
    $outfile = New-TemporaryFile
    (Get-Content -raw $infile) -replace "`n","`r`n" |
        Set-Content -nonewline $outfile
    Move-Item -Force $outfile $infile
}
function dos2unix2 ($infile) {
    if ( ! (Test-Path $infile) ) {
        throw "ERROR: File not found $infile"
    }
    (Get-Content -raw $outfile) -replace "`r`n","`n" |
    Set-Content -nonewline $outfile
}
function dos2unix ($infile) {
    if ( ! (Test-Path $infile) ) {
        throw "ERROR: File not found $infile"
    }
    $outfile = New-TemporaryFile
    (Get-Content -raw $outfile) -replace "`r`n","`n" |
    Set-Content -nonewline $outfile
    Move-Item -Force $outfile $infile
}