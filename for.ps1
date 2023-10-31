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

(Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum).sum /1gb