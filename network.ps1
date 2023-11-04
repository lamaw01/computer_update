# $network = Get-NetIPAddress | Format-Table IPAddress, PrefixLength, SuffixOrigin
# Write-Host $network

# $network = Get-NetIPAddress -AddressFamily IPv4 | Out-Host
# Write-Host $network

# $network = Get-NetIPConfiguration | Where-Object InterfaceDescription -eq "Realtek Virtual Adapter" | Out-Host
# Write-Host $network

# $properties = @{}
# Get-NetIPConfiguration | Where-Object InterfaceIndex | ForEach-Object {
#     $properties['interfaceAlias'] = $_.InterfaceAlias
#     $properties['dnsServer'] = $_.DNSServer
#     $properties['ipv4Address'] = $_.IPv4Address
# }
# $network = New-Object psobject $properties | ConvertTo-Json
# Write-Host $network

$ipAddress = (Get-NetIPAddress | Where-Object {$_.AddressState -eq "Preferred" -and $_.ValidLifetime -lt "24:00:00"}).IPAddress
Write-Host $ipAddress
