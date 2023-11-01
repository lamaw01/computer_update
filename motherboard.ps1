# $motherboardManufacturer = (Get-CimInstance -Class Win32_BaseBoard).Manufacturer
# $motherboardProduct = (Get-CimInstance -Class Win32_BaseBoard).Product
# $motherboardSerial = (Get-CimInstance -Class Win32_BaseBoard).SerialNumber
# $motherboardVersion = (Get-CimInstance -Class Win32_BaseBoard).Version


# Write-Host $motherboardProduct
# Write-Host $motherboardManufacturer
# Write-Host $motherboardVersion
# Write-Host $motherboardSerial

$motherboard = Get-CimInstance -Class Win32_BaseBoard | Format-Table Manufacturer, Product, SerialNumber, Version -Auto | Out-Host
Write-Host $motherboard