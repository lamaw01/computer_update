# $storage =  Get-CimInstance Win32_LogicalDisk | Format-Table DeviceID, ProviderName, VolumeName, VolumeSerialNumber, HealthStatus, @{n="Size (GB)"; e={[math]::Round(($_.Size/1GB),2)}; align="center"}, @{n="FreeSpace (GB)"; e={[math]::Round(($_.FreeSpace/1GB),2)}; align="center"} | Out-Host
# Write-Host $storage

# $properties = @{}
# Get-CimInstance -Class Win32_LogicalDisk | ForEach-Object {
#     $properties['deviceID'] = $_.DeviceID
#     $properties['providerName'] = $_.ProviderName
#     $properties['volumeName'] = $_.VolumeName
#     $properties['volumeSerialNumber'] = $_.VolumeSerialNumber
#     $properties['healthStatus'] = Get-PhysicalDisk
#     $properties['size'] = [math]::Round(($_.Size/1GB),2)
#     $properties['freeSpace'] = [math]::Round(($_.FreeSpace/1GB),2)
# }
# $storage = New-Object psobject $properties | ConvertTo-Json
# Write-Host $storage

# (Get-CimInstance Win32_LogicalDisk).DriveType
# (Get-CimInstance Win32_LogicalDisk).Name
# (Get-CimInstance Win32_LogicalDisk).VolumeDirty

# Get-PhysicalDisk | Select-Object ObjectId 

# $storage1 = (Get-CimInstance Win32_LogicalDisk | Format-List DeviceID, VolumeName, VolumeSerialNumber, @{n="Size (GB)"; e={[math]::Round(($_.Size/1GB),2)};}, @{n="FreeSpace (GB)"; e={[math]::Round(($_.FreeSpace/1GB),2)}} | Out-String).Trim()
# $storage2 = (Get-PhysicalDisk | Format-List FriendlyName, MediaType, HealthStatus | Out-String).Trim()
# $storage = $storage1 + "`r`n`r`n" + $storage2
# Write-Host $storage

# $storagekd = [PSCustomObject]@{}

# Get-CimInstance Win32_LogicalDisk | ForEach-Object {
#     # $_.DeviceID
#     # $_.VolumeSerialNumber

#     $storagekd | Add-Member -MemberType NoteProperty -Name "DeviceID" -Value $_.DeviceID -Force
# }

# $browser =
#     (@(
#         [pscustomobject]@{name="Chrome";version=(Get-Item (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe').'(Default)').VersionInfo.ProductVersion},
#         [pscustomobject]@{name="MSEdge";version=(Get-Item (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\msedge.exe').'(Default)').VersionInfo.ProductVersion},
#         [pscustomobject]@{name="Firefox";version=(New-Object -ComObject WScript.Shell).RegRead("HKLM\SOFTWARE\Mozilla\Mozilla Firefox\CurrentVersion")}
#     ) | Format-List | Out-String).Trim()

# Write-Host $storagekd

# Get-PhysicalDisk |ft 

# $storage1 = (Get-WMIObject Win32_DiskDrive | Format-List Name, Model, SerialNumber, @{n="Size (GB)"; e={[math]::Round(($_.Size/1GB),2)}} | Out-String).Trim()
# $storage2 = (Get-PhysicalDisk | Format-List FriendlyName, @{n="Size (GB)"; e={[math]::Round(($_.Size/1GB),2)};}, MediaType, HealthStatus | Out-String).Trim()
# $storage2 = (Get-PhysicalDisk | Format-List MediaType | Out-String).Trim()

# $storage1 = (Get-WMIObject Win32_DiskDrive | Format-List Name, Model, SerialNumber, @{n="Size (GB)"; e={[math]::Round(($_.Size/1GB),2)}} | Out-String).Trim()

$storage2 = (Get-PhysicalDisk | Format-List FriendlyName, SerialNumber, @{n="Size (GB)"; e={[math]::Round(($_.Size/1GB),2)}}, MediaType, HealthStatus | Out-String).Trim()

# Write-Host $storage1
Write-Host $storage2