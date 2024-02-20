$header = @{
    "Accept"="*/*"
    "Content-Type"="application/json; charset=UTF-8"
}

# check if we update code and if we get computer detail
$update_status = Invoke-RestMethod -Uri "http://103.62.153.74:53000/computer_detail/get_update_latest.php" -Method 'Get' -Headers $header

$update_code = $update_status | Select-Object -ExpandProperty "update_code"

# update code script
if($update_code -eq 1){
    Invoke-WebRequest -Uri 'http://103.62.153.74:53000/computer_detail/script_win10.ps1' -OutFile 'C:/script_win10.ps1'
}

$status = $update_status | Select-Object -ExpandProperty "status"

# get computer detail
if($status -eq 1){

    $uuid = (Get-WmiObject -Class Win32_ComputerSystemProduct).UUID

    $hostname = (Get-CimInstance Win32_ComputerSystem).Name

    $network = (Get-WmiObject Win32_NetworkAdapterConfiguration -Filter 'IPEnabled=TRUE' | Select-Object -ExpandProperty IPAddress | Where-Object { $_ -match '(\d{1,3}\.){3}\d{1,3}' }).Trim()

    $os = (Get-CimInstance Win32_OperatingSystem | Format-List Caption, BuildNumber, Version, SystemDirectory | Out-String).Trim()

    $defender = (Get-MpComputerStatus | Format-List AntivirusSignatureVersion, QuickScanSignatureVersion | Out-String).Trim()

    $cpu = (Get-CimInstance -Class Win32_Processor | Format-List Name, @{n="ClockSpeed (Ghz)"; e={[math]::Round(($_.CurrentClockSpeed/1000),2)}}, NumberOfCores, NumberOfLogicalProcessors, SerialNumber | Out-String).Trim()

    $gpu = (Get-WmiObject Win32_VideoController | Format-List DeviceID, Name, VideoProcessor, @{n="AdapterRAM (GB)"; e={[math]::Round(($_.AdapterRAM/1GB),2)}} | Out-String).Trim()

    $motherboard = (Get-CimInstance -Class Win32_BaseBoard | Format-List Manufacturer, Product, SerialNumber, Version | Out-String).Trim()

    $ram = (Get-CimInstance Win32_PhysicalMemory | Format-List Manufacturer, SerialNumber, DeviceLocator, @{n="Size (GB)"; e={($_.Capacity/1GB)}}, @{n="ClockSpeed (MHz)"; e={($_.ConfiguredClockSpeed)}} | Out-String).Trim()

    # $storage = (Get-WMIObject Win32_DiskDrive | Format-List Name, Model, SerialNumber, @{n="Size (GB)"; e={[math]::Round(($_.Size/1GB),2)}} | Out-String).Trim()

    $storage = (Get-PhysicalDisk | Format-List FriendlyName, SerialNumber, @{n="Size (GB)"; e={[math]::Round(($_.Size/1GB),2)}}, MediaType, HealthStatus | Out-String).Trim()

    $user = (Get-CimInstance Win32_ComputerSystem | Format-List  Name, Username, Domain | Out-String).Trim()

    $msoffice = ((Get-Item 'C:\Program Files (x86)\Microsoft Office\Office14\WINWORD.exe').VersionInfo | Format-List ProductVersion | Out-String).Trim()

    $monitor = (Get-WmiObject WmiMonitorID -Namespace root\wmi | Format-List -Property @(
        @{Name = 'Manufacturer'; Expression = {[string]::new([char[]]($_.Manufacturername)).Trim("`0")}}
        @{Name = 'Model'; Expression = {[string]::new([char[]]($_.UserFriendlyName)).Trim("`0")}}
        @{Name = 'Serial'; Expression = {[string]::new([char[]]($_.SerialNumberID)).Trim("`0")}}
    ) | Out-String).Trim()

    $browser =
    (@(
        [pscustomobject]@{Chrome=(Get-Item (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe').'(Default)').VersionInfo.ProductVersion},
        [pscustomobject]@{MSEdge=(Get-Item (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\msedge.exe').'(Default)').VersionInfo.ProductVersion}
    ) | Format-List | Out-String).Trim()

    $body = @{
    "uuid"="$uuid"
    "hostname"="$hostname"
    "network"="$network"
    "os"="$os"
    "defender"="$defender"
    "cpu"="$cpu"
    "gpu"="$gpu"
    "motherboard"="$motherboard"
    "ram"="$ram"
    "storage"="$storage"
    "user"="$user"
    "monitor"="$monitor"
    "browser"="$browser"
    "msoffice"="$msoffice"
    } | ConvertTo-Json

    Invoke-RestMethod -Uri "http://103.62.153.74:53000/computer_detail/insert_computer_detail.php" -Method 'Post' -Body $body -Headers $header | ConvertTo-Json
}