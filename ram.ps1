# $ramManufacturer = (Get-CimInstance Win32_PhysicalMemory).Manufacturer
# $ramSize = (Get-CimInstance Win32_PhysicalMemory).Capacity/1GB
# $ramSpeed = (Get-CimInstance Win32_PhysicalMemory).ConfiguredClockSpeed
# $ramSerial = (Get-CimInstance Win32_PhysicalMemory).SerialNumber

# Write-Host $ramManufacturer
# Write-Host $ramSize
# Write-Host $ramSpeed
# Write-Host $ramSerial

$ram = Get-CimInstance Win32_PhysicalMemory | Format-Table Manufacturer, SerialNumber, DeviceLocator, @{n="Size (GB)"; e={($_.Capacity/1GB)}; align="center"}, @{n="ClockSpeed (MHz)"; e={($_.ConfiguredClockSpeed)}; align="center"} -Auto | Out-Host
Write-Host $ram