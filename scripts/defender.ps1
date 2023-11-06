#(Get-WmiObject -Class Win32_ComputerSystemProduct).UUID

# $uuid = (Get-WmiObject -Class Win32_ComputerSystemProduct).UUID
# Write-Host $uuid

$defender = (Get-MpComputerStatus | Format-List AntivirusSignatureVersion, QuickScanSignatureVersion | Out-String).Trim()

Write-Host $defender


# $properties = @{}
# Get-MpComputerStatus | ForEach-Object {
#     $properties['antivirusVersion'] = $_.AntivirusSignatureVersion
#     $properties['quickScanVersion'] = $_.QuickScanSignatureVersion
# }
# $defender = New-Object psobject $properties | ConvertTo-Json
# Write-Host $defender