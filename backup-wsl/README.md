---
external help file: backup-wsl-help.xml
Module Name: backup-wsl
online version:
schema: 2.0.0
---


# Backup-WSL

## SYNOPSIS
Backup `//wsl.localhost/DISTRO/USERNAME/SUBDIR` to `%USERPROFILE%/OneDrive/Documents/SUBDIR` with robocopy . 
set $ENV:BACKUP_WSL_SUBDIR to specify the subdir

## SYNTAX

```
Backup-WSL
```

## DESCRIPTION
Backup `//wsl.localhost/DISTRO/USERNAME/SUBDIR` to `%USERPROFILE%/OneDrive/Documents/SUBDIR` with robocopy . 
set $ENV:BACKUP_WSL_SUBDIR to specify the subdir

## EXAMPLES

### EXAMPLE 1
```
Backup-WSL
```

### EXAMPLE 2
```
# full command to trigger from .bat or Scheduled Task
pwsh -C "Import-Module $HOME\scripts\backup-wsl && Backup-WSL"
```

## PARAMETERS

## INPUTS

## OUTPUTS

### see %USERPROFILE%\backup-wsl.log.txt
## NOTES

## RELATED LINKS


# Install-BackupWSL

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

```
Install-BackupWSL
```

## DESCRIPTION
Install Scheduled Task for 2pm daily backup

## EXAMPLES

### Example 1
```powershell
Install-BackupWSL
```

## PARAMETERS

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS



# Get-BackupWSLEvent

## SYNOPSIS
Lists latest BackupWSL events from Windows Event Log

## SYNTAX

```
Get-BackupWSLEvent
```

## DESCRIPTION
Lists latest BackupWSL events from Windows Event Log

## EXAMPLES

### EXAMPLE 1
```
Get-BackupWSLEvent
```

## PARAMETERS

## INPUTS

## OUTPUTS

### System.Diagnostics.EventLogEntry
## NOTES

## RELATED LINKS