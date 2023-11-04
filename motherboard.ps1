# $motherboardManufacturer = (Get-CimInstance -Class Win32_BaseBoard).Manufacturer
# $motherboardProduct = (Get-CimInstance -Class Win32_BaseBoard).Product
# $motherboardSerial = (Get-CimInstance -Class Win32_BaseBoard).SerialNumber
# $motherboardVersion = (Get-CimInstance -Class Win32_BaseBoard).Version


# Write-Host $motherboardProduct
# Write-Host $motherboardManufacturer
# Write-Host $motherboardVersion
# Write-Host $motherboardSerial

$motherboard = Get-CimInstance -Class Win32_BaseBoard | Format-List Manufacturer, Product, SerialNumber, Version | Out-Host
Write-Host $motherboard

# $properties = @{}
# Get-CimInstance -Class Win32_BaseBoard | ForEach-Object {
#     $properties['manufacturer'] = $_.Manufacturer
#     $properties['product'] = $_.Product
#     $properties['serialNumber'] = $_.SerialNumber
#     $properties['version'] = $_.Version
# }
# $motherboard = New-Object psobject $properties | ConvertTo-Json
# Write-Host $motherboard