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