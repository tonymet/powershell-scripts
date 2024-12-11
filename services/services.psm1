# credit stackexchange mklement0 https://stackoverflow.com/questions/54773305/powershell-how-to-find-out-which-running-services-arent-part-of-os-and-non-ms
# #requires -runAsAdministrator

function Get-ServiceFileInfo {

  Set-StrictMode -Version 1

  Get-Service | ForEach-Object {

    # PowerShell Core only:
    # Get the service binary path, which may or may not be the true service 
    # executable.
    $binaryPath = $_.BinaryPathName
    
    # Windows PowerShell:
    # We fall back on trying to obtain the "ImagePath" value from the registry.
    # Note: Even in PowerShell Core there appear to be services that Get-Service fails 
    #       to query even when running as admin, such as "SshdBroker"
    #       (a non-terminating error is issued).
    #       Reading from the registry is needed in that case too, 
    #       but, only succeeds when running as admin.
    if (-not $binaryPath) {
      $binaryPath = try { Get-ItemPropertyValue -EA Ignore "HKLM:\SYSTEM\CurrentControlSet\Services\$($_.Name)" ImagePath } catch { }
    }
    
    # Test for svchost.exe, which indicates the need to look for the service-specific DLL path elsewhere.
    if ($binaryPath -like '*\svchost.exe *') {
      # Get the actual binary (DLL) from the registry, subkey "Parameters", value "ServiceDLL"
      # NOTE: Some services exist in *2* (multiple?) incarnations, as "<name>"" and "<name>_<num>"
      #       Only the "<name>" incarnation has the "ServiceDLL" value, so we fall back on that.
      foreach ($keyName in $_.Name, ($_.Name -split '_')[0]) {
        # NOTE: Most DLL-based services store the "ServiceDLL" value in the "Parameters" subkey, but
        #       some have it in the service's root key itself.
        foreach ($subKeyName in "$keyName\Parameters", $keyName) {
          $binaryPath = try { Get-ItemPropertyValue -EA Ignore "HKLM:\SYSTEM\CurrentControlSet\Services\$subKeyName" ServiceDLL } catch { }
          if ($binaryPath) { break }
        }
      }
    }
    
    # Sanitize the path:
    # * Some values have enclosing "...", so we strip them, 
    # * others have arguments, so we only take the first token.
    $binaryPath = if ($binaryPath.StartsWith('"')) {
      ($binaryPath -split '"')[1]
    } else {
      # The path / command line isn't or doesn't start with a double-quoted token, which
      # can mean one of two things:
      #  * It is a command line based on an unquoted executable, possibly with arguments.
      #  * It is a service DLL path - possibly with spaces in the (expanded) path.
      if (Test-Path -LiteralPath $binaryPath -Type Leaf) {
        $binaryPath # Value as a whole is a file path
      } else {
        (-split $binaryPath)[0] # Value is a command line, extract executable
      }
    }

    $FileVersionInfo = if ($binaryPath) { (Get-Item -LiteralPath $binaryPath).VersionInfo }

    # Construct the output object.        
    [pscustomobject] @{
      Name = $_.Name
      Status = $_.Status
      BinaryPath = if ($binaryPath) { $binaryPath } else { '(n/a)'; Write-Error "Failed to determine binary path for service '$($_.Name)'. Try running as admin." }
      ProductName = $FileVersionInfo.ProductName
      FileDescription = $FileVersionInfo.FileDescription
      CompanyName = $FileVersionInfo.CompanyName
    }
  }

}

Function Get-ThirdPartyServices {
  Get-ServiceFileInfo | where-object {$_.Status -eq "Running"} |where-object {$_.CompanyName -ne "Microsoft Corporation"}
}