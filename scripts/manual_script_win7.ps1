$status = 1

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

    try{
        $uuid = (Get-WmiObject -Class Win32_ComputerSystemProduct -ErrorAction Stop).UUID
    }
    catch {
        Write-Host 'Error getting uuid'
        Write-Host $_
    }
    
    try{
        $hostname = $env:COMPUTERNAME
    }
    catch {
        Write-Host 'Error getting hostname'
        Write-Host $_
    }

    try{
        $network = (Get-WmiObject Win32_NetworkAdapterConfiguration -Filter 'IPEnabled=TRUE' -ErrorAction Stop | Select-Object -ExpandProperty IPAddress | Where-Object { $_ -match '(\d{1,3}\.){3}\d{1,3}' }).Trim()
    }
    catch {
        Write-Host 'Error getting network'
        Write-Host $_
    }

    try {
        $mac = (Get-NetIPConfiguration | Select-Object @{n='MacAddress'; e={$_.NetAdapter.MacAddress}} | Out-String).Trim()
    }
    catch {
        Write-Host 'Error getting mac'
        Write-Host $_
    }

    try {
        $os = (Get-WmiObject Win32_OperatingSystem -ErrorAction Stop | Format-List Caption, BuildNumber, Version, SystemDirectory | Out-String).Trim()
    }
    catch {
        Write-Host 'Error getting os'
        Write-Host $_
    }

    try {
        $defender = (Get-ItemProperty -Path -ErrorAction Stop "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*", "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*" | Where-Object { $_.DisplayName -eq "Avast Free Antivirus" } | Select-Object DisplayName, DisplayVersion | Format-List | Out-String).Trim()
    }
    catch {
        Write-Host 'Error getting defender'
        Write-Host $_
    }
    
    try {
        $cpu = (Get-WMIObject win32_Processor -ErrorAction Stop | Format-List Name, @{n="ClockSpeed (Ghz)"; e={[math]::Round(($_.CurrentClockSpeed/1000),2)}}, NumberOfCores, NumberOfLogicalProcessors, SerialNumber | Out-String).Trim()
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
        $motherboard = (Get-WMIObject Win32_BaseBoard -ErrorAction Stop | Format-List Manufacturer, Product, SerialNumber, Version | Out-String).Trim()
    }
    catch {
        Write-Host 'Error getting motherboard'
        Write-Host $_
    }
    
    try {
        $ram = (Get-WMIObject Win32_PhysicalMemory -ErrorAction Stop | Format-List Manufacturer, SerialNumber, DeviceLocator, @{n="Size (GB)"; e={($_.Capacity/1GB)}}, @{n="ClockSpeed (MHz)"; e={($_.ConfiguredClockSpeed)}} | Out-String).Trim()
    }
    catch {
        Write-Host 'Error getting ram'
        Write-Host $_
    }

    try {
        # $storage = (Get-WMIObject Win32_DiskDrive | Format-List Name, Model, SerialNumber, @{n="Size (GB)"; e={[math]::Round(($_.Size/1GB),2)}} | Out-String).Trim()

        $storage = (Get-WMIObject Win32_DiskDrive -ErrorAction Stop | Format-List Name, Model, SerialNumber, @{n="Size (GB)"; e={[math]::Round(($_.Size/1GB),2)}} | Out-String).Trim()
    }
    catch {
        Write-Host 'Error getting storage'
        Write-Host $_
    }
    
    try {
        $user = (Get-WMIObject Win32_ComputerSystem -ErrorAction Stop | Format-List  Name, Username, Domain | Out-String).Trim()
    }
    catch {
        Write-Host 'Error getting user'
        Write-Host $_
    }
    
    try {
        $msoffice = ((Get-Item 'C:\Program Files (x86)\Microsoft Office\Office14\WINWORD.exe' -ErrorAction Stop).VersionInfo | Format-List ProductVersion | Out-String).Trim()
    }
    catch {
        Write-Host 'Error getting msoffice'
        Write-Host $_
    }
    
    try {
        $monitor = (Get-WmiObject WmiMonitorID -Namespace root\wmi -ErrorAction Stop | Format-List -Property @(
            @{Name = 'Manufacturer'; Expression = {[System.Text.Encoding]::ASCII.GetString($_.Manufacturername).Trim("`0")}}
            @{Name = 'Model'; Expression =  {[System.Text.Encoding]::ASCII.GetString($_.UserFriendlyName).Trim("`0")}}
            @{Name = 'Serial'; Expression = {[System.Text.Encoding]::ASCII.GetString($_.SerialNumberID).Trim("`0")}}
    ) | Out-String).Trim()
    }
    catch {
        Write-Host 'Error getting monitor'
        Write-Host $_
    }

    try {
        $browser = ((New-Object psobject -Property @{
            Name = "Chrome"
            Version = (Get-Item (Get-ItemProperty -ErrorAction Stop 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe').'(Default)').VersionInfo.ProductVersion
        }) | Format-List | Out-String).Trim()
    }
    catch {
        Write-Host 'Error getting browser'
        Write-Host $_
    }

    # $json = @{
    # "uuid"="$uuid"
    # "hostname"="$hostname"
    # "network"="$network"
    # "mac"="$mac"
    # "os"="$os"
    # "defender"="$defender"
    # "cpu"="$cpu"
    # "gpu"="$gpu"
    # "motherboard"="$motherboard"
    # "ram"="$ram"
    # "storage"="$storage"
    # "user"="$user"
    # "monitor"="$monitor"
    # "browser"="$browser"
    # "msoffice"="$msoffice"
    # }

    # Define the path to the text file
$filePath = "C:\$hostname.txt"

# Define the strings you want to write
$strings = @(
    "uuid : $uuid", 
    "hostname: $hostname", 
    "network: $network" , 
    "mac: $mac", 
    "os: $os", 
    "defender: $defender", 
    "cpu: $cpu",
    "gpu: $gpu",
    "motherboard: $motherboard",
    "ram: $ram",
    "storage: $storage",
    "user: $user",
    "monitor: $monitor",
    "browser: $browser",
    "msoffice: $msoffice"
    )

# Loop through each string and append it to the text file
foreach ($string in $strings) {
    Add-Content -Path $filePath -Value $string
}
}