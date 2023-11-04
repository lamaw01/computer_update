# $user = Get-CimInstance Win32_ComputerSystem | Format-Table  Name, Username, Domain | Out-Host
# Write-Host $user

$properties = @{}
Get-CimInstance -Class Win32_ComputerSystem | ForEach-Object {
    $properties['name'] = $_.Name
    $properties['username'] = $_.Username
    $properties['domain'] = $_.Domain
}
$user = New-Object psobject $properties | ConvertTo-Json
Write-Host $user