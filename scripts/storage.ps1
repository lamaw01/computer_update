# $storage =  Get-CimInstance Win32_LogicalDisk | Format-Table DeviceID, ProviderName, VolumeName, VolumeSerialNumber, HealthStatus, @{n="Size (GB)"; e={[math]::Round(($_.Size/1GB),2)}; align="center"}, @{n="FreeSpace (GB)"; e={[math]::Round(($_.FreeSpace/1GB),2)}; align="center"} | Out-Host
# Write-Host $storage

$properties = @{}
Get-CimInstance -Class Win32_LogicalDisk | ForEach-Object {
    $properties['deviceID'] = $_.DeviceID
    $properties['providerName'] = $_.ProviderName
    $properties['volumeName'] = $_.VolumeName
    $properties['volumeSerialNumber'] = $_.VolumeSerialNumber
    $properties['healthStatus'] = $_.HealthStatus
    $properties['size'] = [math]::Round(($_.Size/1GB),2)
    $properties['freeSpace'] = [math]::Round(($_.FreeSpace/1GB),2)
}
$storage = New-Object psobject $properties | ConvertTo-Json
Write-Host $storage