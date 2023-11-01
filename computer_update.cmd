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
