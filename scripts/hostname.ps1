$properties = @{}
Get-CimInstance Win32_ComputerSystem | ForEach-Object {
    $properties['hostname'] = $_.Name
}
$uuid = New-Object psobject $properties | ConvertTo-Json
Write-Host $uuid

