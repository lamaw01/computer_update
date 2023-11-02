#(Get-WmiObject -Class Win32_ComputerSystemProduct).UUID

# $uuid = (Get-WmiObject -Class Win32_ComputerSystemProduct).UUID
# Write-Host $uuid

$defender = Get-MpComputerStatus | Format-Table AntivirusSignatureVersion, QuickScanSignatureVersion | Out-Host
Write-Host $defender