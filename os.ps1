$os = Get-CimInstance Win32_OperatingSystem | Format-Table Caption, BuildNumber, Version, SystemDirectory, LastBootUpTime | Out-Host
Write-Host $os