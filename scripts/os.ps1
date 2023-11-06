# $os = Get-CimInstance Win32_OperatingSystem | Format-Table Caption, BuildNumber, Version, SystemDirectory, LastBootUpTime | Out-Host
# Write-Host $os

$properties = @{}
Get-CimInstance Win32_OperatingSystem | ForEach-Object {
    $properties['caption'] = $_.Caption
    $properties['buildNumber'] = $_.BuildNumber
    $properties['version'] = $_.Version
    $properties['systemDirectory'] = $_.SystemDirectory
}
$os = New-Object psobject $properties | ConvertTo-Json
Write-Host $os

