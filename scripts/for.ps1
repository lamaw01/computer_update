# $infos = Get-ComputerInfo

# $windowsProductName = ""
# $osHardwareAbstractionLayer = ""
# $csDNSHostName = ""
# $csTotalPhysicalMemory = ""
# $csModel = ""
# $csDomain = ""
# $osLastBootUpTime = ""

# foreach ($info in $infos) 
# {
#     $windowsProductName = $info.WindowsProductName
#     $osHardwareAbstractionLayer = $info.OsHardwareAbstractionLayer
#     $csDNSHostName = $info.CsDNSHostName
#     $csTotalPhysicalMemory = $info.CsTotalPhysicalMemory
#     $csModel = $info.CsModel
#     $csDomain = $info.CsDomain
#     $osLastBootUpTime = $info.OsLastBootUpTime

# } 
# Write-Host $windowsProductName
# Write-Host $osHardwareAbstractionLayer
# Write-Host $csDNSHostName
# Write-Host $csTotalPhysicalMemory
# Write-Host $csModel
# Write-Host $csDomain
# Write-Host $osLastBootUpTime

# $usedSpace = Get-PSDrive C | Select-Object -ExpandProperty "Used"
# [math]::Round($usedSpace / 1GB,2)
# $freeSpace = Get-PSDrive C | Select-Object -ExpandProperty "Free"
# [math]::Round($freeSpace / 1GB,2)
# $usedSpace = Get-PSDrive C | Select-Object -ExpandProperty "Used"
# $usedSpaceGB = [math]::Round($usedSpace / 1GB,2)
# $freeSpace = Get-PSDrive C | Select-Object -ExpandProperty "Free"
# $freeSpaceGB = [math]::Round($freeSpace / 1GB,2)
# $totalSpace = Get-Volume C | Select-Object -ExpandProperty "Size"
# $totalSpaceGB = [math]::Round($totalSpace / 1GB,2)

# Write-Host $usedSpaceGB
# Write-Host $freeSpaceGB
# Write-Host $totalSpaceGB

# Get-PhysicalDisk | Select-Object -ExpandProperty "MediaType"
# $MediaType = Get-PhysicalDisk | Where-Object { $_.DeviceID -eq 0 } | Select-Object -ExpandProperty "MediaType"
# Write-Host $MediaType

# (Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum).sum /1gb


# $motherboardManufacturer = (Get-CimInstance -Class Win32_BaseBoard).Manufacturer
# $motherboardProduct = (Get-CimInstance -Class Win32_BaseBoard).Product
# $motherboardSerial = (Get-CimInstance -Class Win32_BaseBoard).SerialNumber
# $motherboardVersion = (Get-CimInstance -Class Win32_BaseBoard).Version


# Write-Host $motherboardProduct
# Write-Host $motherboardManufacturer
# Write-Host $motherboardVersion
# Write-Host $motherboardSerial

# $properties = @{}
# Get-CimInstance Win32_OperatingSystem | ForEach-Object {
#     $InstanceName = if($_.Path -match 'process\((.*#\d+)\)'){
#         $Matches[1]
#     } 
#     else {
#         $_.InstanceName
#     }
#     $properties[$InstanceName] = $_.CookedValue
# }
# New-Object psobject -Property $properties |ConvertTo-Json

# $properties = @{}
# Get-CimInstance Win32_Processor | ForEach-Object {
#     $properties['Name'] = $_.Name
# }
# New-Object psobject $properties | ConvertTo-Json

# (Get-CimInstance -ClassName CIM_VideoController).CurrentHorizontalResolution
# (Get-CimInstance -ClassName CIM_VideoController).CurrentVerticalResolution
# (Get-CimInstance -ClassName CIM_VideoController).Caption

# [pscustomobject]@{
#     DeviceName   = $screen.Caption
#     Width        = $screen.CurrentHorizontalResolution
#     Height       = $screen.CurrentVerticalResolution
#     BitsPerPixel = $screen.CurrentBitsPerPixel
# }

# $header1 = @{
#     "Accept"="*/*"
#     "Content-Type"="application/json; charset=UTF-8"
# }
# $data = Invoke-RestMethod -Uri "http://192.168.221.21/computer_details/computer_detail_api/update_status.php" -Method 'Get' -Headers $header1
# $update = $data | Select-Object -ExpandProperty "update"
# # Write-Host $update
# if($update -eq $true){
#     Write-Host 'IF'
# }else{
#     Write-Host 'ELSE'
# }
# Invoke-WebRequest -Uri "http://192.168.221.21/computer_details/computer_detail_api/get_computer_detail.php" -UseBasicParsing | Select-Object StatusCode

    # $uuid | Out-File -FilePath C:\Projects\computer_update_script\log.txt -Append
    # $hostname | Out-File -FilePath C:\Projects\computer_update_script\log.txt -Append
    # $network | Out-File -FilePath C:\Projects\computer_update_script\log.txt -Append
    # $os | Out-File -FilePath C:\Projects\computer_update_script\log.txt -Append
    # $defender | Out-File -FilePath C:\Projects\computer_update_script\log.txt -Append
    # $cpu | Out-File -FilePath C:\Projects\computer_update_script\log.txt -Append
    # $motherboard | Out-File -FilePath C:\Projects\computer_update_script\log.txt -Append
    # $ram | Out-File -FilePath C:\Projects\computer_update_script\log.txt -Append
    # $storage | Out-File -FilePath C:\Projects\computer_update_script\log.txt -Append
    # $user | Out-File -FilePath C:\Projects\computer_update_script\log.txt -Append
    # $monitor | Out-File -FilePath C:\Projects\computer_update_script\log.txt -Append
    # Write-Host $uuid
    # Write-Host $hostname
    # Write-Host $os
    # Write-Host $defender
    # Write-Host $cpu
    # Write-Host $motherboard
    # Write-Host $ram
    # Write-Host $storage
    # Write-Host $user
    # Write-Host $network
    # Write-Host $monitor