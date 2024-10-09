$header = @{
    "Accept"="*/*"
    "Content-Type"="application/json; charset=UTF-8"
}

$update_code = 0
$update_once = 0
$status = 0
$id = 0

try {
    # check if we update code and if we get computer detail
    $update_status = Invoke-RestMethod -ErrorAction Stop -Uri "http://103.62.153.74:53000/computer_detail/get_update_latest.php" -Method 'Get' -Headers $header
    $update_code = $update_status | Select-Object -ExpandProperty "update_code"
    $update_once = $update_status | Select-Object -ExpandProperty "update_once"
    $status = $update_status | Select-Object -ExpandProperty "status"
    $id = $update_status | Select-Object -ExpandProperty "id"
}
catch {
    Write-Host 'Error update_status'
    Write-Host $_
}

# update code script
if($update_code -eq 1){
    try {
        Invoke-WebRequest -ErrorAction Stop -Uri 'http://103.62.153.74:53000/computer_detail/script_win10.ps1' -OutFile 'C:/script_win10.ps1'
    }
    catch {
        Write-Host 'Error update_code'
        Write-Host $_
    }   
}

# get computer detail
if($status -eq 1){

    $uuid = ""
    $hostname = ""
    $network = ""
    $mac = ""
    $os = ""
    $defender = ""
    $cpu = ""
    $gpu = ""
    $motherboard = ""
    $ram = ""
    $storage = ""
    $user = ""
    $monitor = ""
    $browser = ""
    $msoffice = ""

    try {
        $uuid = (Get-WmiObject -Class Win32_ComputerSystemProduct -ErrorAction Stop).UUID
    }
    catch {
        Write-Host 'Error getting uuid'
        Write-Host $_
    }

    try {
        $hostname = (Get-CimInstance Win32_ComputerSystem -ErrorAction Stop).Name
    }
    catch {
        Write-Host 'Error getting hostname'
        Write-Host $_
    }

    try {
        $network = (Get-WmiObject Win32_NetworkAdapterConfiguration -Filter 'IPEnabled=TRUE' -ErrorAction Stop | Select-Object -ExpandProperty IPAddress | Where-Object { $_ -match '(\d{1,3}\.){3}\d{1,3}' }).Trim()
    }
    catch {
        Write-Host 'Error getting network'
        Write-Host $_
    }

    try {
        $mac = (Get-NetIPConfiguration  | Select-Object @{n='MacAddress'; e={$_.NetAdapter.MacAddress}} | Out-String).Trim()
    }
    catch {
        Write-Host 'Error getting mac'
        Write-Host $_
    }

    try {
        $os = (Get-CimInstance Win32_OperatingSystem -ErrorAction Stop | Format-List Caption, BuildNumber, Version, SystemDirectory | Out-String).Trim()
    }
    catch {
        Write-Host 'Error getting os'
        Write-Host $_
    }

    try {
        $defender = (Get-MpComputerStatus -ErrorAction Stop | Format-List AntivirusSignatureVersion, QuickScanSignatureVersion | Out-String).Trim()
    }
    catch {
        Write-Host 'Error getting defender'
        Write-Host $_
    }

    try {
        $cpu = (Get-CimInstance -Class Win32_Processor -ErrorAction Stop | Format-List Name, @{n="ClockSpeed (Ghz)"; e={[math]::Round(($_.CurrentClockSpeed/1000),2)}}, NumberOfCores, NumberOfLogicalProcessors, SerialNumber | Out-String).Trim()
    }
    catch {
        Write-Host 'Error getting cpu'
        Write-Host $_
    }

    try {
        $gpu = (Get-WmiObject Win32_VideoController -ErrorAction Stop | Format-List DeviceID, Name, VideoProcessor, @{n="AdapterRAM (GB)"; e={[math]::Round(($_.AdapterRAM/1GB),2)}} | Out-String).Trim()
    }
    catch {
        Write-Host 'Error getting gpu'
        Write-Host $_
    }

    try {
        $motherboard = (Get-CimInstance -Class Win32_BaseBoard -ErrorAction Stop | Format-List Manufacturer, Product, SerialNumber, Version | Out-String).Trim()
    }
    catch {
        Write-Host 'Error getting motherboard'
        Write-Host $_
    }

    try {
        $ram = (Get-CimInstance Win32_PhysicalMemory -ErrorAction Stop | Format-List Manufacturer, SerialNumber, DeviceLocator, @{n="Size (GB)"; e={($_.Capacity/1GB)}}, @{n="ClockSpeed (MHz)"; e={($_.ConfiguredClockSpeed)}} | Out-String).Trim()
    }
    catch {
        Write-Host 'Error getting ram'
        Write-Host $_
    }

    try {
        # $storage = (Get-WMIObject Win32_DiskDrive | Format-List Name, Model, SerialNumber, @{n="Size (GB)"; e={[math]::Round(($_.Size/1GB),2)}} | Out-String).Trim()

        $storage = (Get-PhysicalDisk -ErrorAction Stop | Format-List FriendlyName, SerialNumber, @{n="Size (GB)"; e={[math]::Round(($_.Size/1GB),2)}}, MediaType, HealthStatus | Out-String).Trim()
    }
    catch {
        Write-Host 'Error getting storage'
        Write-Host $_
    }

    try {
        $user = (Get-CimInstance Win32_ComputerSystem -ErrorAction Stop | Format-List  Name, Username, Domain | Out-String).Trim()
    }
    catch {
        Write-Host 'Error getting user'
        Write-Host $_
    }

    try {
        $Keys = Get-Item -Path HKLM:\Software\RegisteredApplications | Select-Object -ExpandProperty property
        $Product = $Keys | Where-Object {$_ -Match "Excel.Application."}
        $OfficeVersion = ($Product.Replace("Excel.Application.","")+".0")
        $msoffice = ($OfficeVersion | Out-String).Trim()
        # $msoffice = ((Get-Item 'C:\Program Files (x86)\Microsoft Office\Office14\WINWORD.exe' -ErrorAction Stop).VersionInfo | Format-List ProductVersion | Out-String).Trim()
    }
    catch {
        Write-Host 'Error getting msoffice'
        Write-Host $_
    }

    try {
        $monitor = (Get-WmiObject WmiMonitorID -Namespace root\wmi -ErrorAction Stop | Format-List -Property @(
            @{Name = 'Manufacturer'; Expression = {[string]::new([char[]]($_.Manufacturername)).Trim("`0")}}
            @{Name = 'Model'; Expression = {[string]::new([char[]]($_.UserFriendlyName)).Trim("`0")}}
            @{Name = 'Serial'; Expression = {[string]::new([char[]]($_.SerialNumberID)).Trim("`0")}}
        ) | Out-String).Trim()
    }
    catch {
        Write-Host 'Error getting monitor'
        Write-Host $_
    }
   
    try {
        $browser =
        (@(
            [pscustomobject]@{Chrome=(Get-Item (Get-ItemProperty -ErrorAction Stop 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe').'(Default)').VersionInfo.ProductVersion},
            [pscustomobject]@{MSEdge=(Get-Item (Get-ItemProperty -ErrorAction Stop 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\msedge.exe').'(Default)').VersionInfo.ProductVersion}
        ) | Format-List | Out-String).Trim()
    }
    catch {
        Write-Host 'Error getting browser'
        Write-Host $_
    }

    $body = @{
    "uuid"="$uuid"
    "hostname"="$hostname"
    "network"="$network"
    "mac"="$mac"
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

    # Write-Host $body

    $computer_latest_update_id = 0

    try {
        $body_hostname = @{
        "hostname"="$hostname"
        } | ConvertTo-Json 

        #http://103.62.153.74:53000/computer_detail/get_computer_latest_update_id.php
        $query_latest_id = Invoke-RestMethod -ErrorAction Stop -Uri "http://103.62.153.74:53000/computer_detail/get_computer_latest_update_id.php" -Method 'Post' -Body $body_hostname -Headers $header
        $computer_latest_update_id = $query_latest_id | Select-Object -ExpandProperty "update_id"
    }
    catch {
        Write-Host 'Error get latest computer update id'
        Write-Host $_
    }

    #Write-Host $id . $computer_latest_update_id
    #update
    #7 != 8
    #1 == 0

    #update
    #7 != 8
    #0 == 0
    
    #not update
    #8 != 8
    #0 != 0

    #update
    #8 != 8
    #1 != 0
    Write-Host $id . $computer_latest_update_id . $update_once . 0

    if(($id -ne $computer_latest_update_id) -or ($update_once -eq 0)){
        try {
            Invoke-RestMethod -ErrorAction Stop -Uri "http://103.62.153.74:53000/computer_detail/insert_computer_detail.php" -Method 'Post' -Body $body -Headers $header | ConvertTo-Json
        }
        catch {
            Write-Host 'Error inserting data'
            Write-Host $_
        }
    }
}

