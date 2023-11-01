# get product name
# $windowsProductName = Get-ComputerInfo | Select-Object -ExpandProperty "WindowsProductName" 
# Write-Host $windowsProductName

# get build version
# $osHardwareAbstractionLayer = Get-ComputerInfo | Select-Object -ExpandProperty "OsHardwareAbstractionLayer"
# Write-Host $osHardwareAbstractionLayer

# get defender version
# $antivirusSignatureVersion = Get-MpComputerStatus | Select-Object -ExpandProperty "AntivirusSignatureVersion"
# Write-Host $antivirusSignatureVersion

# get hostname
# $csDNSHostName = Get-ComputerInfo | Select-Object -ExpandProperty "CsDNSHostName"
# Write-Host $csDNSHostName

# get ip addresses
# $ipAddress = Get-NetIPAddress -AddressFamily IPv4 | Select-Object -ExpandProperty "IPAddress"
# Write-Host $ipAddress

# get machine id
# $machineId = (Get-CimInstance -Class Win32_ComputerSystemProduct).UUID
# Write-Host $machineId

# get cpu info
# $csProcessors = Get-WMIObject win32_Processor | Select-Object -ExpandProperty name
# Write-Host $csProcessors

# get ram total
# $csTotalPhysicalMemory = Get-ComputerInfo | Select-Object -ExpandProperty "CsTotalPhysicalMemory"
# Write-Host $csTotalPhysicalMemory

# get motherboard model
# $csModel = Get-ComputerInfo | Select-Object -ExpandProperty "CsModel"
# Write-Host $csModel

# get network domain
# $csDomain = Get-ComputerInfo | Select-Object -ExpandProperty "CsDomain"
# Write-Host $csDomain

# get last boot time
# $osLastBootUpTime = Get-ComputerInfo | Select-Object -ExpandProperty "OsLastBootUpTime"
# Write-Host $osLastBootUpTime

$infos = Get-ComputerInfo

$windowsProductName = ""
$OsVersion = ""
$csDNSHostName = ""
$csModel = ""
$csDomain = ""
$osLastBootUpTime = ""

foreach ($info in $infos) 
{
    $windowsProductName = $info.OsName
    $OsVersion = $info.OsVersion
    $csDNSHostName = $info.CsDNSHostName
    $csModel = $info.CsModel
    $csModel = $info.s
    $csDomain = $info.CsDomain
    $osLastBootUpTime = $info.OsLastBootUpTime
}

$antivirusSignatureVersion = Get-MpComputerStatus | Select-Object -ExpandProperty "AntivirusSignatureVersion"
$ipAddress = Get-NetIPAddress -AddressFamily IPv4 | Select-Object -ExpandProperty "IPAddress"
$machineId = (Get-CimInstance -Class Win32_ComputerSystemProduct).UUID
$csProcessors = Get-WMIObject win32_Processor | Select-Object -ExpandProperty name
$totalRam = (Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum).sum /1gb
$usedSpace = Get-PSDrive C | Select-Object -ExpandProperty "Used"
$usedSpaceGB = [math]::Round($usedSpace / 1GB,2)
$freeSpace = Get-PSDrive C | Select-Object -ExpandProperty "Free"
$freeSpaceGB = [math]::Round($freeSpace / 1GB,2)
$totalSpace = Get-Volume C | Select-Object -ExpandProperty "Size"
$totalSpaceGB = [math]::Round($totalSpace / 1GB,2)
$diskHealthStatus = Get-Volume -DriveLetter C | Select-Object -ExpandProperty "HealthStatus"
$MediaType = Get-PhysicalDisk | Where-Object { $_.DeviceID -eq 0 } | Select-Object -ExpandProperty "MediaType"

Write-Host $machineId
Write-Host $windowsProductName
Write-Host $OsVersion
Write-Host $antivirusSignatureVersion
Write-Host $csDNSHostName
Write-Host $ipAddress
Write-Host $csDomain
Write-Host $csProcessors
Write-Host $csModel
Write-Host $totalRam
Write-Host $usedSpaceGB
Write-Host $freeSpaceGB
Write-Host $totalSpaceGB
Write-Host $diskHealthStatus
Write-Host $MediaType
Write-Host $osLastBootUpTime

# # insert data to database
# $body = @{
#  "windowsProductName"="$windowsProductName"
#  "osHardwareAbstractionLayer"="$OsVersion"
#  "antivirusSignatureVersion"="$antivirusSignatureVersion"
#  "csDNSHostName"="$csDNSHostName"
#  "ipAddress"="$ipAddress"
#  "machineId"="$machineId"
# } | ConvertTo-Json

# $header = @{
#  "Accept"="*/*"
#  "Content-Type"="application/json; charset=UTF-8"
# }

# Invoke-RestMethod -Uri "http://103.62.153.74:53000/script/insert_computer_data.php" -Method 'Post' -Body $body -Headers $header | ConvertTo-Json

# # command to execute script
# PowerShell.exe -File "C:\Projects\computer_update_script\computer_update.ps1" -ExecutionPolicy Bypass

# schtasks /create /tn "computer_update" /sc onstart /delay 0005:00 /rl highest /ru system /tr "powershell.exe -file C:\computer_update.ps1"