# $cpuName = (Get-CimInstance -Class Win32_Processor).Name
# Write-Host $cpuName

$properties = @{}
Get-CimInstance Win32_Processor | ForEach-Object {
    $properties['cpu'] = $_.Name
}
$cpu = New-Object psobject $properties | ConvertTo-Json
Write-Host $cpu

