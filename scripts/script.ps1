$header1 = @{
    "Accept"="*/*"
    "Content-Type"="application/json; charset=UTF-8"
}

$data = Invoke-RestMethod -Uri "http://103.62.153.74:53000/computer_detail/update_status.php" -Method 'Get' -Headers $header1

$update = $data | Select-Object -ExpandProperty "update"

if($update -eq $true){

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

    $monitor = (Get-WmiObject WmiMonitorID -Namespace root\wmi | Format-List -Property @(
        @{Name = 'Manufacturer'; Expression = {[string]::new([char[]]($_.Manufacturername)).Trim("`0")}}
        @{Name = 'Model'; Expression = { [string]::new([char[]]($_.UserFriendlyName)).Trim("`0")  }}
        @{Name = 'Serial'; Expression = { [string]::new([char[]]($_.SerialNumberID)).Trim("`0")  }}
        @{Name = 'Width'; Expression = {(Get-CimInstance -ClassName CIM_VideoController).CurrentHorizontalResolution}}
        @{Name = 'Heigth'; Expression = {(Get-CimInstance -ClassName CIM_VideoController).CurrentVerticalResolution}}
        @{Name = 'Caption'; Expression = {(Get-CimInstance -ClassName CIM_VideoController).Caption}}
    ) | Out-String).Trim()

    $browser =
    (@(
        [pscustomobject]@{Name="Chrome";Version=(Get-Item (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe').'(Default)').VersionInfo.ProductVersion},
        [pscustomobject]@{Name="MSEdge";Version=(Get-Item (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\msedge.exe').'(Default)').VersionInfo.ProductVersion}
    ) | Format-List | Out-String).Trim()

    $body = @{
    "uuid"="$uuid"
    "hostname"="$hostname"
    "network"="$network"
    "os"="$os"
    "defender"="$defender"
    "cpu"="$cpu"
    "motherboard"="$motherboard"
    "ram"="$ram"
    "storage"="$storage"
    "user"="$user"
    "monitor"="$monitor"
    "browser"="$browser"
    } | ConvertTo-Json

    Write-Host $body

    $header2 = @{
        "Accept"="*/*"
        "Content-Type"="application/json; charset=UTF-8"
    }

    Invoke-RestMethod -Uri "http://103.62.153.74:53000/computer_detail/insert_computer_detail.php" -Method 'Post' -Body $body -Headers $header2 | ConvertTo-Json

}