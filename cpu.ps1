# $cpuName = (Get-CimInstance -Class Win32_Processor).Name

# Write-Host $cpuName

$cpu = Get-CimInstance Win32_Processor | Format-Table Name | Out-Host
Write-Host $cpu