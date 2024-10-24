
try{
    # check if we update code and if we get computer detail
    $req = [System.Net.WebRequest]::Create("https://konek.parasat.tv:53000/computer_detail/get_update_latest.php")
    $resp = $req.GetResponse()
    $reqstream = $resp.GetResponseStream()
    $stream = new-object System.IO.StreamReader $reqstream
    $result = $stream.ReadToEnd()
    [System.Reflection.Assembly]::LoadWithPartialName("System.Web.Extensions")
    $ser = New-Object System.Web.Script.Serialization.JavaScriptSerializer
    $obj = $ser.DeserializeObject($result)
}
catch {
    Write-Host 'Error update_status'
    Write-Host $_
}

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

$update_code = 0
$update_once = 0
$status = 0
$id = 0

$update_code = $obj.update_code
$update_once = $obj.update_once
$status = $obj.status
$id = $obj.id

# update code script
if($update_code -eq 1){ # $obj.update_code -eq 1
    try{
        (new-object System.Net.WebClient).DownloadFile('https://konek.parasat.tv:53000/computer_detail/script_win7.ps1','C:/script_win7.ps1')
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


    $computer_latest_update_id = 0

    $body_hostname = @{
        "hostname"="$hostname"
    }

    $covbody_hostname = ConvertTo-Json $body_hostname

    $resultbody = @{}
    
    try{
        $request = [System.Net.WebRequest]::Create('https://konek.parasat.tv:53000/computer_detail/get_computer_latest_update_id.php')
        $request.Method = 'POST'
        $request.ContentType = 'application/json'
        $request.Accept = "application/json"
        
        $body = [byte[]][char[]]$covbody_hostname
        $upload = $request.GetRequestStream()
        $upload.Write($body, 0, $body.Length)
        $upload.Flush()
        $upload.Close()
    
        $response = $request.GetResponse()
        $stream = $response.GetResponseStream()
        $streamReader = [System.IO.StreamReader]($stream)
    
        $resultbody['StatusCode']        = $response.StatusCode
        $resultbody['StatusDescription'] = $response.StatusDescription
        $resultbody['Content']           = $streamReader.ReadToEnd()
    
        $streamReader.Close()
        $response.Close()
    }
    catch{
        throw
    }
    

    $y = $resultbody['Content']
    $objy = $ser.DeserializeObject($y)
    $computer_latest_update_id = $objy.update_id

    #Write-Host $computer_latest_update_id

    $json = @{
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
    }

    Write-Host $id . $computer_latest_update_id . $update_once . 0

    if(($id -ne $computer_latest_update_id) -or ($update_once -eq 0)){

        $covJson = ConvertTo-Json $json
            
        $result = @{}
        try{
            $request = [System.Net.WebRequest]::Create('https://konek.parasat.tv:53000/computer_detail/insert_computer_detail.php')
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

}