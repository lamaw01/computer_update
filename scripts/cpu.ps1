$cpu = (Get-CimInstance -Class Win32_Processor | Format-List Name, @{n="ClockSpeed (Ghz)"; e={[math]::Round(($_.CurrentClockSpeed/1000),2)}}, NumberOfCores, NumberOfLogicalProcessors, SerialNumber | Out-String).Trim()
Write-Host $cpu

# $properties = @{}
# Get-CimInstance Win32_Processor | ForEach-Object {
#     $properties['cpu'] = $_.Name
# }
# $cpu = New-Object psobject $properties | ConvertTo-Json
# Write-Host $cpu

# (Get-CimInstance -Class Win32_Processor).Name
# (Get-CimInstance -Class Win32_Processor).NumberOfCores
# (Get-CimInstance -Class Win32_Processor).NumberOfLogicalProcessors
# (Get-CimInstance -Class Win32_Processor).CurrentClockSpeed
