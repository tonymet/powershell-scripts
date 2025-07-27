# | `ls` | `Get-ChildItem` (alias: `dir`, `gci`) |  |
# | `cd` | `Set-Location` (alias: `chdir`, `sl`) |  |
# | `pwd` | `Get-Location` (alias: `gl`) |  |
# | `mkdir` | `New-Item -ItemType Directory` (alias: `md`) |  |
# | `rmdir` | `Remove-Item -ItemType Directory` (alias: `rd`) |  |
# | `rm` | `Remove-Item` (alias: `del`) | Use `-Force` for hidden/read-only files. |
# | `cp` | `Copy-Item` (alias: `cpi`) |  |
# | `mv` | `Move-Item` (alias: `mi`) |  |
# | `cat` | `Get-Content` (alias: `gc`) |  |
# | `echo` | `Write-Output` (alias: `echo`) |  |
# | `head` | `Get-Content -TotalCount <number>` |  |
# | `tail` | `Get-Content -Tail <number>` |  |
# | `grep` | `Select-String` (alias: `sls`) |  |
# | `find` | `Get-ChildItem -Recurse | Where-Object { ... }` | PowerShell's `Where-Object` is very powerful. |
# | `chmod` | No direct equivalent. Use ACLs (`Get-Acl`, `Set-Acl`). |  |
# | `chown` | No direct equivalent. Use ACLs. |  |
# | `du` | `Get-ChildItem -Recurse | Measure-Object -Property Length -Sum` |  |
# | `df` | `Get-PSDrive` |  |
# | `ps` | `Get-Process` (alias: `gps`) |  |
# | `kill` | `Stop-Process` |  |
# | `top` | No direct, simple equivalent. Use Task Manager or `Get-Process` with sorting. |  |
# | `netstat` | `Get-NetTCPConnection`, `Get-NetUDPConnection` |  |
# | `ifconfig` | `Get-NetIPConfiguration` |  |
# | `ping` | `Test-Connection` |  |
# | `traceroute` | `Test-NetConnection -TraceRoute` |  |
# | `ssh` | `ssh` (PowerShell has an SSH client) |  |
# | `scp` | `scp` (PowerShell has an SCP client) |  |
# | `tar` | `tar` (PowerShell has `tar` and `Expand-Archive`) or use `7zip` |  |
# | `gzip` | `Compress-Archive` |  |
# | `gunzip` | `Expand-Archive` |  |
# | `date` | `Get-Date` |  |
# | `cal` | `Get-Date` (for current month) or use a calendar module |  |
# | `whoami` | `$env:USERNAME` or `Get-CimInstance Win32_ComputerSystem | Select-Object UserName` |  |
# | `w` | `Get-Process | Where-Object {$_.MainWindowTitle} ` | Shows logged on users with GUI applications. No exact equivalent to show all users logged on via command line. |
# | `history` | `Get-History` |  |
# | `man` | `Get-Help` |  |
# | `less` | `less` (PowerShell has `less`) or `more` |  |
# | `diff` | `Compare-Object` (alias: `diff`) |  |
# | `patch` | No direct equivalent. |  |
# | `cut` | `Select-String -Pattern "..."` or string manipulation |  |
# | `sort` | `Sort-Object` |  |
# | `uniq` | `Get-Unique` |  |
# | `wc` | `Get-Content | Measure-Object` |  |
# | `awk` | PowerShell is more powerful, but no direct 1:1 equivalent. Use `Where-Object`, `ForEach-Object`, etc. |  |
# | `sed` | No direct, simple equivalent. String manipulation or regular expressions. |  |
# | `xargs` | PowerShell pipelines are generally better, but `ForEach-Object -Parallel` can be similar. |  |
# | `tee` | `Tee-Object` |  |

# Define functions for Linux commands with PowerShell equivalents
function ls {
    Write-Output "Use 'Get-ChildItem' in PowerShell to list directory contents."
}

function pwd {
    Write-Output "Use 'Get-Location' in PowerShell to print the current working directory."
}

function cd {
    Write-Output "Use 'Set-Location' in PowerShell to change the current directory."
}

function mkdir {
    Write-Output "Use 'New-Item -ItemType Directory' in PowerShell to create a new directory."
}

function rmdir {
    Write-Output "Use 'Remove-Item -Recurse' in PowerShell to remove directories."
}

function rm {
    Write-Output "Use 'Remove-Item' in PowerShell to delete files or directories."
}

function cp {
    Write-Output "Use 'Copy-Item' in PowerShell to copy files or directories."
}

function mv {
    Write-Output "Use 'Move-Item' in PowerShell to move or rename files or directories."
}

function touch {
    Write-Output "Use 'New-Item -ItemType File' in PowerShell to create an empty file."
}

function chmod {
    Write-Output "PowerShell does not have a direct equivalent for 'chmod'. Use .NET APIs or Windows ACL tools for permission changes."
}

function man {
    Write-Output "Use 'Get-Help <command>' in PowerShell to display command documentation."
}

function cat {
    Write-Output "Use 'Get-Content' in PowerShell to display file contents."
}

function less {
    Write-Output "PowerShell does not have a direct equivalent for 'less'. Use 'Out-Host -Paging' for similar functionality."
}

function head {
    Write-Output "Use 'Get-Content -TotalCount <n>' in PowerShell to display the first <n> lines of a file."
}

function tail {
    Write-Output "Use 'Get-Content -Tail <n>' in PowerShell to display the last <n> lines of a file."
}

function grep {
    Write-Output "PowerShell does not have a direct equivalent for 'grep'. Use Select-String for pattern matching."
}

function ps {
    Write-Output "Use 'Get-Process' in PowerShell to display information about active processes."
}

function kill {
    Write-Output "Use 'Stop-Process -Id <PID>' in PowerShell to terminate processes by PID."
}

function ping {
    Write-Output "Use 'Test-Connection' in PowerShell to test network connectivity."
}

function sudo {
    Write-Output "Run PowerShell as Administrator for elevated privileges. No direct equivalent for 'sudo'."
}

function echo {
    Write-Output "Use 'Write-Output' or simply type text directly in PowerShell to print text or variables."
}

function history {
    Write-Output "PowerShell 7+ supports '$History.GetEntries()' to view command history. Alternatively, use Get-History."
}

function apt {
    Write-Output "PowerShell does not have a built-in package manager. Use third-party tools like Chocolatey or Winget on Windows."
}

function exit {
    Write-Output "Use 'exit' in PowerShell to exit the current session."
}

function shutdown {
    Write-Output "Use the 'Stop-Computer' cmdlet or shutdown.exe for shutting down or restarting the system in Windows."
}