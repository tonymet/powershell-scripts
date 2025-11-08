# winget_update_checker_notifier.ps1
# This script checks for available Winget updates and sends a Windows toast notification.
# It should be scheduled to run when the user is logged on.

# --- Configuration ---
#$updateExecutorScriptPath = "C:\Scripts\winget_update_executor.ps1" # IMPORTANT: Set the correct path to the executor script
$notificationTitle = "Winget Updates Available!"
$notificationMessage = "Click 'Install Updates' to apply them now."
$notificationButtonText = "Install Updates"
$notificationButtonAction = "powershell.exe -NoProfile -File `"$updateExecutorScriptPath`" -Verb RunAs" # Launches the executor script as admin

# --- Function to check for BurntToast module and install if missing ---
function Install-BurntToastModule {
    if (-not (Get-Module -ListAvailable -Name BurntToast)) {
        Write-Host "BurntToast module not found. Attempting to install..."
        try {
            Install-Module -Name BurntToast -Scope CurrentUser -Force -Confirm:$false -ErrorAction Stop
            Write-Host "BurntToast module installed successfully."
            return $true
        }
        catch {
            Write-Error "Failed to install BurntToast module: $($_.Exception.Message)"
            Write-Error "Please install it manually by running: Install-Module -Name BurntToast -Scope CurrentUser"
            return $false
        }
    }
    return $true
}
function Start-WingetUpdate(){
    # --- Main Logic ---
    Write-Host "Checking for BurntToast module..."
    if (-not (Install-BurntToastModule)) {
        Write-Error "Cannot proceed without BurntToast module. Exiting."
        exit 1
    }

    # Ensure the executor script exists
    # if (-not (Test-Path $updateExecutorScriptPath)) {
    #     Write-Error "Update executor script not found at '$updateExecutorScriptPath'. Please create it first."
    #     exit 1
    # }

    Write-Host "Checking for Winget updates..."

    # Run winget upgrade --all and capture output as JSON
    # We use a temporary file to capture output reliably, especially for JSON
    $tempJsonFile = [System.IO.Path]::GetTempFileName()
    try {
        Start-Process -FilePath "winget.exe" -ArgumentList "upgrade --all --output JSON" -Wait -NoNewWindow -PassThru -RedirectStandardOutput $tempJsonFile | Out-Null
        #Start-Process -FilePath "winget.exe" -ArgumentList "upgrade --all --output JSON" -Wait -NoNewWindow -PassThru | Out-Null
        $wingetOutputJson = Get-Content $tempJsonFile | ConvertFrom-Json
    }
    catch {
        Write-Error "Failed to run winget or parse JSON output: $($_.Exception.Message)"
        Remove-Item $tempJsonFile -ErrorAction SilentlyContinue
        exit 1
    }
    finally {
        Remove-Item $tempJsonFile -ErrorAction SilentlyContinue
    }

    # Check if there are any packages with 'UpgradeAvailable' status
    $updatesAvailable = $false
    if ($wingetOutputJson -and $wingetOutputJson.Packages) {
        # Filter packages to only include those with an available upgrade
        $upgradablePackages = $wingetOutputJson.Packages | Where-Object { $_.UpgradeAvailable -eq $true }
        if ($upgradablePackages.Count -gt 0) {
            $updatesAvailable = $true
            $notificationMessage = "Found $($upgradablePackages.Count) updates for your applications."
            Write-Host "Found $($upgradablePackages.Count) Winget updates."
        }
    }

    if ($updatesAvailable) {
        Write-Host "Sending Winget update notification..."
        try {
            # Create a button for the notification
            $button = New-BTButton -Content $notificationButtonText -Arguments $notificationButtonAction -ActivationType Protocol
            
            # Send the toast notification
            New-BurntToastNotification -AppId "WingetUpdater" `
                                    -Text $notificationTitle, $notificationMessage `
                                    -Button $button `
                                    -Scenario Reminder `
                                    -Expiration 600 # Notification will expire after 10 minutes if not clicked
            Write-Host "Notification sent."
        }
        catch {
            Write-Error "Failed to send BurntToast notification: $($_.Exception.Message)"
            exit 1
        }
    } else {
        Write-Host "No Winget updates found."
    }

    Write-Host "Winget update checker finished."
}