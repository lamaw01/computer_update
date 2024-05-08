
# Get-WmiObject Win32_NetworkAdapterConfiguration -Filter 'IPEnabled=TRUE' | Select-Object -ExpandProperty IPAddress | Where-Object { $_ -match '(\d{1,3}\.){3}\d{1,3}' }

Get-WmiObject Win32_NetworkAdapterConfiguration | Select-Object -ExpandProperty MacAddress