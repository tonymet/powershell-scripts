# WingetNotifier.psm1
# A module to check for Winget updates and send native Windows Toasts with actionable buttons.

Function Register-WingetUpdateProtocol {
    <#
    .SYNOPSIS
        Registers a custom URL protocol (wingetupdate://) to trigger the executor script.
    .DESCRIPTION
        Toasts cannot launch arbitrary scripts directly for security reasons.
        This function registers a custom protocol in HKCU that points to your update executor script.
    .PARAMETER ExecutorScriptPath
        The full path to the script that performs the actual update (e.g., winget_update_executor.ps1).
    #>
    Param (
        [Parameter(Mandatory=$true)]
        [string]$ExecutorScriptPath
    )

    if (-not (Test-Path $ExecutorScriptPath)) {
        Write-Error "Executor script not found at $ExecutorScriptPath"
        return
    }

    $protocolName = "wingetupdate"
    $basePath = "HKCU:\Software\Classes\$protocolName"

    # Command to run: Powershell -> Start-Process (for Admin) -> Executor Script
    # We use 'Start-Process -Verb RunAs' to ensure the UAC prompt appears when clicked.
    $command = "powershell.exe -WindowStyle Hidden -Command `"Start-Process powershell.exe -ArgumentList '-ExecutionPolicy Bypass -File \\`"$ExecutorScriptPath\\`"' -Verb RunAs`""

    try {
        # Create the Protocol keys (No Admin rights needed for CurrentUser)
        New-Item -Path $basePath -Force | Out-Null
        New-ItemProperty -Path $basePath -Name "(default)" -Value "URL:Winget Update Protocol" -PropertyType String -Force | Out-Null
        New-ItemProperty -Path $basePath -Name "URL Protocol" -Value "" -PropertyType String -Force | Out-Null

        New-Item -Path "$basePath\shell\open\command" -Force | Out-Null
        New-ItemProperty -Path "$basePath\shell\open\command" -Name "(default)" -Value $command -PropertyType String -Force | Out-Null

        Write-Host "Successfully registered '${protocolName}://' protocol to trigger: $ExecutorScriptPath" -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to register protocol: $_"
    }
}

Function Invoke-WingetUpdateCheck {
    <#
    .SYNOPSIS
        Checks for Winget updates and sends a native Toast notification if found.
    #>
    [CmdletBinding()]
    Param()

    # 1. Check for Updates
    Write-Verbose "Checking for winget updates..."
    $tempFile = [System.IO.Path]::GetTempFileName()

    try {
        # Run winget and capture JSON output
        Start-Process "winget" -ArgumentList "upgrade --all --include-unknown --output JSON" -NoNewWindow -Wait -RedirectStandardOutput $tempFile

        # Read file content safely
        $content = Get-Content $tempFile -Raw -ErrorAction SilentlyContinue
        if ([string]::IsNullOrWhiteSpace($content)) {
            Write-Verbose "No output from winget."
            return
        }

        $json = $content | ConvertFrom-Json
        $updateCount = 0

        if ($json.Packages) {
            $updateCount = ($json.Packages | Where-Object { $_.UpgradeAvailable }).Count
        }

        if ($updateCount -gt 0) {
            Write-Host "Found $updateCount updates." -ForegroundColor Cyan
            Send-NativeToast -Title "Winget Updates Available" -Message "Found $updateCount applications requiring updates." -ButtonText "Install All" -ProtocolAction "wingetupdate://run"
        } else {
            Write-Host "No updates found." -ForegroundColor Green
        }
    }
    catch {
        Write-Error "Error checking winget: $_"
    }
    finally {
        if (Test-Path $tempFile) { Remove-Item $tempFile }
    }
}

Function Send-NativeToast {
    Param(
        [string]$Title,
        [string]$Message,
        [string]$ButtonText,
        [string]$ProtocolAction
    )

    # Load Windows Runtime Assemblies
    $null = [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime]
    $null = [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime]

    # Construct XML for Native Toast with Button
    $xml = @"
<toast launch="action=viewUpdates">
    <visual>
        <binding template="ToastGeneric">
            <text>$Title</text>
            <text>$Message</text>
        </binding>
    </visual>
    <actions>
        <action content="$ButtonText" arguments="$ProtocolAction" activationType="protocol"/>
    </actions>
</toast>
"@

    $xmlDoc = New-Object Windows.Data.Xml.Dom.XmlDocument
    $xmlDoc.LoadXml($xml)

    $toast = [Windows.UI.Notifications.ToastNotification]::New($xmlDoc)

    # Use a specific AppID (PowerShell's default usually works, but unique is better for grouping)
    $appId = "{1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\WindowsPowerShell\v1.0\powershell.exe"

    [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($appId).Show($toast)
}

Export-ModuleMember -Function Register-WingetUpdateProtocol, Invoke-WingetUpdateCheck