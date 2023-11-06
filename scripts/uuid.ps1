$properties = @{}
Get-WmiObject -Class Win32_ComputerSystemProduct | ForEach-Object {
    $properties['uuid'] = $_.UUID
}
$uuid = New-Object psobject $properties | ConvertTo-Json
Write-Host $uuid

