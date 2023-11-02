$uuid = (Get-WmiObject -Class Win32_ComputerSystemProduct).UUID

$hostname = (Get-CimInstance Win32_ComputerSystem).Name

$os = Get-CimInstance Win32_OperatingSystem | Format-Table Caption, BuildNumber, Version, SystemDirectory

$defender = Get-MpComputerStatus | Format-Table AntivirusSignatureVersion, QuickScanSignatureVersion

$cpu = Get-CimInstance Win32_Processor | Format-Table Name

$motherboard = Get-CimInstance -Class Win32_BaseBoard | Format-Table Manufacturer, Product, SerialNumber, Version -Auto

$ram = Get-CimInstance Win32_PhysicalMemory | Format-Table Manufacturer, SerialNumber, DeviceLocator, @{n="Size (GB)"; e={($_.Capacity/1GB)}; align="center"}, @{n="ClockSpeed (MHz)"; e={($_.ConfiguredClockSpeed)}; align="center"} -Auto

$storage =  Get-CimInstance Win32_LogicalDisk | Format-Table DeviceID, ProviderName, VolumeName, VolumeSerialNumber, HealthStatus, @{n="Size (GB)"; e={[math]::Round(($_.Size/1GB),2)}; align="center"}, @{n="FreeSpace (GB)"; e={[math]::Round(($_.FreeSpace/1GB),2)}; align="center"}

$user = Get-CimInstance Win32_ComputerSystem | Format-Table  Name, Username, Domain

$network = Get-NetIPAddress | Format-Table IPAddress, PrefixLength, SuffixOrigin

$monitor = Get-WmiObject WmiMonitorID -Namespace root\wmi | Format-Table -Property @(
    @{Name = 'Manufacturer'; Expression = {[string]::new([char[]]($_.Manufacturername)).Trim("`0") }; Alignment="center";}
    @{Name = 'Model'; Expression = { [string]::new([char[]]($_.UserFriendlyName)).Trim("`0")  };  Alignment="center";}
    @{Name = 'Serial'; Expression = { [string]::new([char[]]($_.SerialNumberID)).Trim("`0")  };  Alignment="center";}
)


$uuid | Out-File -FilePath C:\Projects\computer_update_script\log.txt -Append
$hostname | Out-File -FilePath C:\Projects\computer_update_script\log.txt -Append
$os | Out-File -FilePath C:\Projects\computer_update_script\log.txt -Append
$defender | Out-File -FilePath C:\Projects\computer_update_script\log.txt -Append
$cpu | Out-File -FilePath C:\Projects\computer_update_script\log.txt -Append
$motherboard | Out-File -FilePath C:\Projects\computer_update_script\log.txt -Append
$ram | Out-File -FilePath C:\Projects\computer_update_script\log.txt -Append
$storage | Out-File -FilePath C:\Projects\computer_update_script\log.txt -Append
$user | Out-File -FilePath C:\Projects\computer_update_script\log.txt -Append
$network | Out-File -FilePath C:\Projects\computer_update_script\log.txt -Append
$monitor | Out-File -FilePath C:\Projects\computer_update_script\log.txt -Append
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

# $body = @{
#  "uuid"="$uuid"
#  "hostname"="$hostname"
#  "os"="$os"
#  "defender"="$defender"
#  "cpu"="$cpu"
#  "motherboard"="$motherboard"
#  "ram"="$ram"
#  "storage"="$storage"
#  "user"="$user"
#  "network"="$network"
#  "monitor"="$monitor"
# } | ConvertTo-Json

# $header = @{
#  "Accept"="*/*"
#  "Content-Type"="application/json; charset=UTF-8"
# }

# Invoke-RestMethod -Uri "http://103.62.153.74:53000/script/insert_data.php" -Method 'Post' -Body $body -Headers $header | ConvertTo-Json
