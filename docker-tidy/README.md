## docker-tidy
Windows scheduler task to prune docker images & containers weekly.

## Install
```
# create event log
Import-Module -force ${HOME}\scripts\docker-tidy
Install-DockerTidy
# test run
Start-ScheduledTask -TaskName Docker-Tidy
# Show Events
Get-DockerTidyEvent
```

## Example Results
```
Get-DockerTidyEvent

   Index Time          EntryType   Source                 InstanceID Message
   ----- ----          ---------   ------                 ---------- -------
   46250 Nov 29 16:09  Information Docker-Tidy                  3002 Docker-Tidy success. image=Total reclaimed space: 0B, container=Total reclaimed space: 0B
```


## Help Docs

# Get-DockerTidyEvent

## SYNOPSIS
Lists latest DockerTidy events from Windows Event Log

## SYNTAX

```
Get-DockerTidyEvent
```

## DESCRIPTION
Lists latest DockerTidy events from Windows Event Log

## EXAMPLES

### EXAMPLE 1
```
Get-DockerTidyEvent
```

## OUTPUTS

### System.Diagnostics.EventLogEntry

# Build-DockerTidyModuleSignature

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

```
Build-DockerTidyModuleSignature
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS

# Install-DockerTidy

## SYNOPSIS
(MUST BE RUN AS ADMINISTRATOR) Installs DockerTidy by creating event log & scheduled task

## SYNTAX

```
Install-DockerTidy
```

## DESCRIPTION
Installs DockerTidy by creating event log & scheduled task

## EXAMPLES

### EXAMPLE 1
```
Install-DockerTidy
```

### No Output
### must be run as administrator
## NOTES

## RELATED LINKSo

# Optimize-DockerTidy

## SYNOPSIS
Run DockerTidy cleanup (docker image prune & docker container prune)

## SYNTAX

```
Optimize-DockerTidy
```

## DESCRIPTION
Run DockerTidy cleanup (docker image prune & docker container prune)

## EXAMPLES

### EXAMPLE 1
```
Optimize-DockerTidy
```


# Register-DockerTidy

## SYNOPSIS
Registers scheduled task.
Docker-Tidy will run weekly

## SYNTAX

```
Register-DockerTidy
```

## DESCRIPTION
Registers scheduled task.
Docker-Tidy will run weekly

## EXAMPLES

### EXAMPLE 1
```
Register-DockerTidy
```