$uuid = (Get-WmiObject -Class Win32_ComputerSystemProduct).UUID

$hostname = (Get-CimInstance Win32_ComputerSystem).Name

$network = (Get-WmiObject Win32_NetworkAdapterConfiguration -Filter 'IPEnabled=TRUE' | Select-Object -ExpandProperty IPAddress | Where-Object { $_ -match '(\d{1,3}\.){3}\d{1,3}' }).Trim()

$os = (Get-CimInstance Win32_OperatingSystem | Format-List Caption, BuildNumber, Version, SystemDirectory | Out-String).Trim()

$defender = (Get-MpComputerStatus | Format-List AntivirusSignatureVersion, QuickScanSignatureVersion | Out-String).Trim()

$cpu = (Get-CimInstance Win32_Processor | Format-List Name | Out-String).Trim()
 
$motherboard = (Get-CimInstance -Class Win32_BaseBoard | Format-List Manufacturer, Product, SerialNumber, Version | Out-String).Trim()

$ram = (Get-CimInstance Win32_PhysicalMemory | Format-List Manufacturer, SerialNumber, DeviceLocator, @{n="Size (GB)"; e={($_.Capacity/1GB)}}, @{n="ClockSpeed (MHz)"; e={($_.ConfiguredClockSpeed)}} | Out-String).Trim()

$storage = (Get-CimInstance Win32_LogicalDisk | Format-List DeviceID, ProviderName, VolumeName, VolumeSerialNumber, HealthStatus, @{n="Size (GB)"; e={[math]::Round(($_.Size/1GB),2)};}, @{n="FreeSpace (GB)"; e={[math]::Round(($_.FreeSpace/1GB),2)}} | Out-String).Trim()

$user = (Get-CimInstance Win32_ComputerSystem | Format-List  Name, Username, Domain | Out-String).Trim()

# $network = (Get-NetIPAddress | Format-List IPAddress, PrefixLength, SuffixOrigin | Out-String).Trim()

$monitor = (Get-WmiObject WmiMonitorID -Namespace root\wmi | Format-List -Property @(
    @{Name = 'Manufacturer'; Expression = {[string]::new([char[]]($_.Manufacturername)).Trim("`0")}}
    @{Name = 'Model'; Expression = { [string]::new([char[]]($_.UserFriendlyName)).Trim("`0")  }}
    @{Name = 'Serial'; Expression = { [string]::new([char[]]($_.SerialNumberID)).Trim("`0")  }}
) | Out-String).Trim()


$uuid | Out-File -FilePath C:\Projects\computer_update_script\log.txt -Append
$hostname | Out-File -FilePath C:\Projects\computer_update_script\log.txt -Append
$network | Out-File -FilePath C:\Projects\computer_update_script\log.txt -Append
$os | Out-File -FilePath C:\Projects\computer_update_script\log.txt -Append
$defender | Out-File -FilePath C:\Projects\computer_update_script\log.txt -Append
$cpu | Out-File -FilePath C:\Projects\computer_update_script\log.txt -Append
$motherboard | Out-File -FilePath C:\Projects\computer_update_script\log.txt -Append
$ram | Out-File -FilePath C:\Projects\computer_update_script\log.txt -Append
$storage | Out-File -FilePath C:\Projects\computer_update_script\log.txt -Append
$user | Out-File -FilePath C:\Projects\computer_update_script\log.txt -Append
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

# Write-Host $body

# $header = @{
#  "Accept"="*/*"
#  "Content-Type"="application/json; charset=UTF-8"
# }

# Invoke-RestMethod -Uri "http://192.168.221.21/computer_details/computer_detail_api/insert_computer_detail.php" -Method 'Post' -Body $body -Headers $header | ConvertTo-Json
