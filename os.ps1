$os = Get-CimInstance Win32_OperatingSystem | Format-Table Caption, BuildNumber, Version, SystemDirectory | Out-Host
Write-Host $os