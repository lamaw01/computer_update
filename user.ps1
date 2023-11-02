$user = Get-CimInstance Win32_ComputerSystem | Format-Table  Name, Username, Domain | Out-Host
Write-Host $user
