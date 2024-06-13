
# Get-WmiObject Win32_NetworkAdapterConfiguration -Filter 'IPEnabled=TRUE' | Select-Object -ExpandProperty IPAddress | Where-Object { $_ -match '(\d{1,3}\.){3}\d{1,3}' }

# $os = Get-WmiObject Win32_NetworkAdapterConfiguration | Select-Object -ExpandProperty MacAddress

# $os = Get-NetIPConfiguration | 
#   Select-Object @{n='IPv4Address';e={$_.IPv4Address[0]}}, 
#          @{n='MacAddress'; e={$_.NetAdapter.MacAddress}}

# $mac = Get-NetIPConfiguration | Select-Object @{n='MacAddress'; e={$_.NetAdapter.MacAddress}}

$mac = (Get-NetIPConfiguration | Select-Object @{n='MacAddress'; e={$_.NetAdapter.MacAddress}})

Write-Host $mac