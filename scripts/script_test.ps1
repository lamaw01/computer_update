# $header = @{
#     "Accept"="*/*"
#     "Content-Type"="application/json; charset=UTF-8"
# }

# # check if we update code and if we get computer detail
# $update_status = Invoke-RestMethod -Uri "http://103.62.153.74:53000/computer_detail/get_update_latest.php" -Method 'Get' -Headers $header

# $update_code = $update_status | Select-Object -ExpandProperty "update_code"
# Write-Host $update_code

# # update code script
# if($update_code -eq 1){
#     Invoke-WebRequest -Uri 'http://103.62.153.74:53000/computer_detail/script_win10.ps1' -OutFile 'C:/script_win10.ps1'
# }

# $status = $update_status | Select-Object -ExpandProperty "status"
# Write-Host $status

# # get computer detail
# if($status -eq 1){

#     $uuid = (Get-WmiObject -Class Win32_ComputerSystemProduct).UUID

#     $hostname = (Get-CimInstance Win32_ComputerSystem).Name

#     $network = (Get-WmiObject Win32_NetworkAdapterConfiguration -Filter 'IPEnabled=TRUE' | Select-Object -ExpandProperty IPAddress | Where-Object { $_ -match '(\d{1,3}\.){3}\d{1,3}' }).Trim()

#     $os = (Get-CimInstance Win32_OperatingSystem | Format-List Caption, BuildNumber, Version, SystemDirectory | Out-String).Trim()

#     $defender = (Get-MpComputerStatus | Format-List AntivirusSignatureVersion, QuickScanSignatureVersion | Out-String).Trim()

#     $cpu = (Get-CimInstance -Class Win32_Processor | Format-List Name, @{n="ClockSpeed (Ghz)"; e={[math]::Round(($_.CurrentClockSpeed/1000),2)}}, NumberOfCores, NumberOfLogicalProcessors, SerialNumber | Out-String).Trim()

#     $motherboard = (Get-CimInstance -Class Win32_BaseBoard | Format-List Manufacturer, Product, SerialNumber, Version | Out-String).Trim()

#     $ram = (Get-CimInstance Win32_PhysicalMemory | Format-List Manufacturer, SerialNumber, DeviceLocator, @{n="Size (GB)"; e={($_.Capacity/1GB)}}, @{n="ClockSpeed (MHz)"; e={($_.ConfiguredClockSpeed)}} | Out-String).Trim()

#     $storage = (Get-WMIObject Win32_DiskDrive | Format-List Name, Model, SerialNumber, @{n="Size (GB)"; e={[math]::Round(($_.Size/1GB),2)}} | Out-String).Trim()

#     $user = (Get-CimInstance Win32_ComputerSystem | Format-List  Name, Username, Domain | Out-String).Trim()

#     $monitor = (Get-WmiObject WmiMonitorID -Namespace root\wmi | Format-List -Property @(
#         @{Name = 'Manufacturer'; Expression = {[string]::new([char[]]($_.Manufacturername)).Trim("`0")}}
#         @{Name = 'Model'; Expression = {[string]::new([char[]]($_.UserFriendlyName)).Trim("`0")}}
#         @{Name = 'Serial'; Expression = {[string]::new([char[]]($_.SerialNumberID)).Trim("`0")}}
#     ) | Out-String).Trim()

#     $browser =
#     (@(
#         [pscustomobject]@{Name="Chrome";Version=(Get-Item (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe').'(Default)').VersionInfo.ProductVersion},
#         [pscustomobject]@{Name="MSEdge";Version=(Get-Item (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\msedge.exe').'(Default)').VersionInfo.ProductVersion}
#     ) | Format-List | Out-String).Trim()

#     $body = @{
#     "uuid"="$uuid"
#     "hostname"="$hostname"
#     "network"="$network"
#     "os"="$os"
#     "defender"="$defender"
#     "cpu"="$cpu"
#     "motherboard"="$motherboard"
#     "ram"="$ram"
#     "storage"="$storage"
#     "user"="$user"
#     "monitor"="$monitor"
#     "browser"="$browser"
#     } | ConvertTo-Json

#     Invoke-RestMethod -Uri "http://103.62.153.74:53000/computer_detail/insert_computer_detail.php" -Method 'Post' -Body $body -Headers $header | ConvertTo-Json
# }

# check if we update code and if we get computer detail
$req = [System.Net.WebRequest]::Create("http://103.62.153.74:53000/computer_detail/get_update_latest.php")
$resp = $req.GetResponse()
$reqstream = $resp.GetResponseStream()
$stream = new-object System.IO.StreamReader $reqstream
$result = $stream.ReadToEnd()
$ref = [System.Reflection.Assembly]::LoadWithPartialName("System.Web.Extensions")
$ser = New-Object System.Web.Script.Serialization.JavaScriptSerializer
$obj = $ser.DeserializeObject($result)

function ConvertTo-Json([object] $item){
    add-type -assembly system.web.extensions
    $ps_js=new-object system.web.script.serialization.javascriptSerializer
    return $ps_js.Serialize($item)
}

function ConvertFrom-Json([object] $item){ 
    add-type -assembly system.web.extensions
    $ps_js=new-object system.web.script.serialization.javascriptSerializer
    #The comma operator is the array construction operator in PowerShell
    return ,$ps_js.DeserializeObject($item)
}

# update code script
if($obj.update_code -eq 1){
    (new-object System.Net.WebClient).DownloadFile('http://103.62.153.74:53000/computer_detail/script_win7.ps1','C:/script_win7.ps1')
}

# get computer detail
if($obj.status -eq 1){
    $uuid = (Get-WmiObject -Class Win32_ComputerSystemProduct).UUID

    $hostname = $env:COMPUTERNAME
    
    $network = (Get-WmiObject Win32_NetworkAdapterConfiguration -Filter 'IPEnabled=TRUE' | Select-Object -ExpandProperty IPAddress | Where-Object { $_ -match '(\d{1,3}\.){3}\d{1,3}' }).Trim()
    
    $os = (Get-WmiObject Win32_OperatingSystem | Format-List Caption, BuildNumber, Version, SystemDirectory | Out-String).Trim()
    
    $defender = (Get-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*", "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*" | Where-Object { $_.DisplayName -eq "Avast Free Antivirus" } | Select-Object DisplayName, DisplayVersion | Format-List | Out-String).Trim()
    
    $cpu = (Get-WMIObject win32_Processor | Format-List Name, @{n="ClockSpeed (Ghz)"; e={[math]::Round(($_.CurrentClockSpeed/1000),2)}}, NumberOfCores, NumberOfLogicalProcessors, SerialNumber | Out-String).Trim()
    
    $motherboard = (Get-WMIObject Win32_BaseBoard | Format-List Manufacturer, Product, SerialNumber, Version | Out-String).Trim()
    
    $ram = (Get-WMIObject Win32_PhysicalMemory | Format-List Manufacturer, SerialNumber, DeviceLocator, @{n="Size (GB)"; e={($_.Capacity/1GB)}}, @{n="ClockSpeed (MHz)"; e={($_.ConfiguredClockSpeed)}} | Out-String).Trim()
    
    $storage = (Get-WMIObject Win32_DiskDrive | Format-List Name, Model, SerialNumber, @{n="Size (GB)"; e={[math]::Round(($_.Size/1GB),2)}} | Out-String).Trim()
    
    $user = (Get-WMIObject Win32_ComputerSystem | Format-List  Name, Username, Domain | Out-String).Trim()
    
    $monitor = (Get-WmiObject WmiMonitorID -Namespace root\wmi | Format-List -Property @(
        @{Name = 'Manufacturer'; Expression = {[System.Text.Encoding]::ASCII.GetString($_.Manufacturername).Trim("`0")}}
        @{Name = 'Model'; Expression =  {[System.Text.Encoding]::ASCII.GetString($_.UserFriendlyName).Trim("`0")}}
        @{Name = 'Serial'; Expression = {[System.Text.Encoding]::ASCII.GetString($_.SerialNumberID).Trim("`0")}}
    ) | Out-String).Trim()
    
    $browser = ((New-Object psobject -Property @{
        Name = "Chrome"
        Version = (Get-Item (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe').'(Default)').VersionInfo.ProductVersion
    }) | Format-List | Out-String).Trim()
    
    $json = @{
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
    }

    $covJson = ConvertTo-Json $json
        
    $result = @{}
    try{
        $request = [System.Net.WebRequest]::Create('http://103.62.153.74:53000/computer_detail/insert_computer_detail.php')
        $request.Method = 'POST'
        $request.ContentType = 'application/json'
        $request.Accept = "application/json"
        
        $body = [byte[]][char[]]$covJson
        $upload = $request.GetRequestStream()
        $upload.Write($body, 0, $body.Length)
        $upload.Flush()
        $upload.Close()
    
        $response = $request.GetResponse()
        $stream = $response.GetResponseStream()
        $streamReader = [System.IO.StreamReader]($stream)
    
        $result['StatusCode']        = $response.StatusCode
        $result['StatusDescription'] = $response.StatusDescription
        $result['Content']           = $streamReader.ReadToEnd()
    
        $streamReader.Close()
        $response.Close()
    }
    catch{
        throw
    }
    
    $x = $result.Content
    Write-Host $x
}