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

# (Get-WmiObject Win32_OperatingSystem).Version

#Get-WmiObject Win32_OperatingSystem | Format-List Caption, BuildNumber, Version, SystemDirectory

# $ram = (Get-WmiObject Win32_PhysicalMemory | Format-List Manufacturer, SerialNumber, DeviceLocator, @{n="Size (GB)"; e={($_.Capacity/1GB)}}, @{n="ClockSpeed (MHz)"; e={($_.ConfiguredClockSpeed)}} | Out-String).Trim("`0")
# Write-Host $ram
# (Get-WmiObject Win32_PhysicalMemory).ConfiguredClockSpeed

# $BodyBytes = [System.Text.Encoding]::UTF8.GetBytes($Body);
# # Set the URI of the web service
# $URI = [System.Uri]'http://103.62.153.74:53000/computer_detail/insert_computer_detail.php';

# # Create a new web request
# $WebRequest = [System.Net.HttpWebRequest]::CreateHttp($URI);
# # Set the HTTP method
# $WebRequest.Method = 'POST';
# # Set the MIME type
# $WebRequest.ContentType = 'application/json; charset=UTF-8';
# # Write the message body to the request stream
# $WebRequest.GetRequestStream().Write($BodyBytes, 0, $BodyBytes.Length);

# $monitor = (Get-WmiObject WmiMonitorID -Namespace root\wmi | Format-List -Property @(
#         @{Name = 'Manufacturer'; Expression = {[System.Text.Encoding]::ASCII.GetString($_.Manufacturername).Trim("`0")}}
#         @{Name = 'Model'; Expression =  {[System.Text.Encoding]::ASCII.GetString($_.UserFriendlyName).Trim("`0")}}
#         @{Name = 'Serial'; Expression = {[System.Text.Encoding]::ASCII.GetString($_.SerialNumberID).Trim("`0")}}
#         @{Name = 'Width'; Expression = {(Get-WmiObject CIM_VideoController).CurrentHorizontalResolution}}
#         @{Name = 'Heigth'; Expression = {(Get-WmiObject CIM_VideoController).CurrentVerticalResolution}}
#         @{Name = 'Caption'; Expression = {(Get-WmiObject CIM_VideoController).Caption}}
# ) | Out-String).Trim()

# Write-Host $monitor

# wmic diskdrive get index, model, serialnumber, size

# $drive_serialnumber = Get-Partition -DriveLetter C  | Get-Disk | select-object -ExpandProperty SerialNumber
# $drive_serialnumber.trim()

# $disk = (Get-PSDrive).Name -match '^[a-z]$'
# Foreach ($i in $disk)
# {
# #   Write-Host $i". " -nonewline
#   Get-Partition -DriveLetter $i | Get-Disk | Format-List Number, FriendlyName, SerialNumber, HealthStatus, Size
# }

# $storage = (Get-WMIObject Win32_DiskDrive | Format-List Name,Model,Description,SerialNumber,Size | Out-String).Trim()
# # $storage2 = (Get-PhysicalDisk | Format-List FriendlyName, MediaType, HealthStatus | Out-String).Trim()
# # $storage = $storage1 + "`r`n`r`n" + $storage2
# Write-Host $storage

# $storage = (Get-WMIObject Win32_DiskDrive | Format-List Name, Model, Description, SerialNumber, @{n="Size (GB)"; e={[math]::Round(($_.Size/1GB),2)}} | Out-String).Trim()
# Write-Host $storage

# Get-ItemProperty 'HKEY_CLASSES_ROOT\Word.Application\CurVer'
# $officeCheck = (Get-ItemProperty -Path "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Office\14.0\Outlook")
# Write-Host $officeCheck

# (New-Object -ComObject word.application).version

# Get-ItemProperty -Path 'HKLM:Software\Classes\Word.Application\CurVer'.('(Default)')
$msoffice = ((Get-Item 'C:\Program Files (x86)\Microsoft Office\Office14\WINWORD.exe').VersionInfo | Format-List ProductVersion | Out-String).Trim()
Write-Host $msoffice