
<#
.SYNOPSIS
Runs the SQLite VACUUM command on all known SQLite database files within the Microsoft Edge Default User Profile.

.DESCRIPTION
This script finds common SQLite database files used by the Chromium-based Microsoft Edge browser (e.g., History, Cookies, Web Data, etc.).
It then attempts to execute the 'VACUUM;' command on each file, which rebuilds the database, reclaiming unused space, and reducing fragmentation.

.PREREQUISITES
1. Microsoft Edge MUST be completely closed before running this script, as the database files are locked when in use.
2. The 'sqlite3.exe' command-line executable must be available in your system's PATH environment variable.

.NOTES
Use this script at your own risk. It's recommended to back up your Edge profile folder before running if you have any concerns.
Default Profile Path: C:\Users\<Username>\AppData\Local\Microsoft\Edge\User Data\Default
#>
function Invoke-EdgeVacuum {
    # --- Configuration ---

    # Define the common database file names (most are file-extensionless)
    $DatabaseFileNames = @(
        "History",
        "Cookies",
        "Web Data",
        "Login Data",
        "Favicons",
        "Top Sites",
        "Segments",
        "Origin Bound Certs",
        "QuotaManager"
    )

    # Define additional extensions to search for in the directory
    $DatabaseExtensions = @(
        "*.db",
        "*.sqlite"
    )

    # --- Setup and Validation ---

    Write-Host "--- Microsoft Edge SQLite Database Vacuum Utility ---" -ForegroundColor Cyan

    # 1. Check if sqlite3.exe is available
    if (-not (Get-Command sqlite3.exe -ErrorAction SilentlyContinue)) {
        Write-Error "The 'sqlite3.exe' command-line tool was not found in your system's PATH."
        Write-Error "Please download the SQLite command-line shell and ensure 'sqlite3.exe' is accessible."
        return
    }

    # 2. Check for running Edge processes
    if (Get-Process -Name msedge -ErrorAction SilentlyContinue) {
        Write-Warning "Microsoft Edge is currently running and locking the database files."
        Write-Warning "Please close all Edge windows and try again."
        return
    }

    # 3. Determine the Edge profile path
    $EdgeDataPath = "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default"

    if (-not (Test-Path $EdgeDataPath)) {
        Write-Error "Edge Default Profile path not found at: $EdgeDataPath"
        Write-Error "If you use a different profile, please modify the script's \$EdgeDataPath variable."
        return
    }

    Write-Host "Target Profile Directory: $EdgeDataPath" -ForegroundColor Yellow
    Write-Host "Searching for database files..." -ForegroundColor Yellow

    # --- Find Database Files ---

    $FoundFiles = @()

    # Find files based on common names (no extension)
    foreach ($name in $DatabaseFileNames) {
        $filePath = Join-Path -Path $EdgeDataPath -ChildPath $name
        if (Test-Path $filePath -PathType Leaf) {
            $FoundFiles += Get-Item $filePath
        }
    }

    # Find files based on extensions
    foreach ($ext in $DatabaseExtensions) {
        $FoundFiles += Get-ChildItem -Path $EdgeDataPath -Filter $ext -File
    }

    # Remove duplicates
    $FoundFiles = $FoundFiles | Select-Object -Unique

    if ($FoundFiles.Count -eq 0) {
        Write-Host "No SQLite database files found in the specified profile path." -ForegroundColor Yellow
        return
    }

    Write-Host "Found $($FoundFiles.Count) potential database file(s) to vacuum." -ForegroundColor Green

    # --- Execute VACUUM Command ---

    $VacuumCount = 0
    $ErrorCount = 0

    foreach ($File in $FoundFiles) {
        Write-Host "-> Processing $($File.Name)..." -NoNewline

        # Construct the command to run sqlite3.exe.
        # It opens the database and executes the SQL command 'VACUUM;'
        try {
            $initialSize = (Get-Item $File.FullName).Length
            # Use -c to pass the command directly
            sqlite3.exe $($File.FullName) "VACUUM;" 2>$null | Out-Null
            $ExitCode = $LASTEXITCODE

            if ($ExitCode -eq 0) {
                $finalSize = (Get-Item $File.FullName).Length
                $sizeDifference = $initialSize - $finalSize
                Write-Host " VACUUM Success (Initial: $((($initialSize) / 1MB) -as [decimal].ToString()) MB, Final: $((($finalSize) / 1MB) -as [decimal].ToString()) MB, Saved: $((($sizeDifference) / 1MB) -as [decimal].ToString()) MB)" -ForegroundColor Green
                $VacuumCount++
            } else {
                # sqlite3.exe sometimes exits with non-zero code even on success, but it's mainly for errors
                Write-Host " VACUUM Failed (Exit Code $ExitCode). File might be locked or not a valid SQLite DB." -ForegroundColor Red
                $ErrorCount++
            }

        } catch {
            Write-Host " VACUUM Error: $($_.Exception.Message)" -ForegroundColor Red
            $ErrorCount++
        }
    }

    # --- Summary ---
    Write-Host ""
    Write-Host "--- Summary ---" -ForegroundColor Cyan
    Write-Host "Vacuum Operations Successful: $VacuumCount" -ForegroundColor Green
    Write-Host "Vacuum Operations Failed/Skipped: $ErrorCount" -ForegroundColor Red
    Write-Host "Operation Complete." -ForegroundColor Cyan
}

# Run the function
#Invoke-EdgeVacuum