# $1 = (Get-WmiObject Win32_VideoController).Name
# $2 = (Get-WmiObject Win32_VideoController).VideoProcessor
# $3 = (Get-WmiObject Win32_VideoController).AdapterRAM

# Write-Host $1 - $2 - $3


$gpu = (Get-WmiObject Win32_VideoController | Format-List DeviceID, Name, VideoProcessor, @{n="AdapterRAM (GB)"; e={[math]::Round(($_.AdapterRAM/1GB),2)}} | Out-String).Trim()
Write-Host $gpu