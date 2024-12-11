# Powershell Scripts

Assorted Powershell scripts for WSL backup, disabling fonts, wake on lan, managing services. 
* backup-wsl
* crlf
* services
* [win-fonts](./win-fonts/)
* wol
* [docker-tidy](./docker-tidy/)

## backup-wsl
Backup wsl directory to your windows home directory using robocopy. Includes
Windows Scheduler install script.  [Full docs found here](https://tonym.us/wsl2-backup-to-onedrive-cloud.html)

Usage:  `pwsh backup-wsl.ps1`

## crlf
functions for converting CRLF to LF , e.g. dos2unix, unix2dos

Install: `Import-Module -force .\scripts\crlf`

## win-fonts

Available on [PSGallery](https://www.powershellgallery.com/packages/win-fonts/0.0.4)

`Install-Module -Name win-fonts -RequiredVersion 0.0.4`

or install from repo

`Import-Module .\scripts\win-fonts`

## services

Module to list services with additional detail. 

Install : `Import-Module .\scripts\services`

Usage: 

```
# list running services that are not published by Microsoft Corporation
> Get-ServiceFileInfo | where-object {$_.Status -eq "Running"} `
    |where-object {$_.CompanyName -ne "Microsoft Corporation"}

Name            : AMD Crash Defender Service
Status          : Running
BinaryPath      : C:\WINDOWS\System32\DriverStore\FileRepository\amdfendr.inf_amd64_987f8cede005f427\amdfendrsr.exe
ProductName     : AMD Crash Defender Service
FileDescription : AMD Crash Defender Service
CompanyName     : Advanced Micro Devices, Inc.
```

## wol
credit: stack-exchange

install: `Import-Module .\scripts\wol`

Usage: 
```
> Invoke-WakeOnLan -verbose ff:ff:ff:ff:ff:ff
VERBOSE: sent magic packet to ff:ff:ff:ff:ff:ff...
```

## LICENSE
see (/LICENSE.md)