# $wsh = New-Object -ComObject WScript.Shell
# $wsh.SendKeys('{NUMLOCK}')

# # We need to check for both 64-bit and 32-bit software
# $regPaths = "HKLM:\SOFTWARE\Wow6432node\Microsoft\Windows\CurrentVersion\Uninstall",
#   "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"

# # Get the name of all installed software registered in the registry with Office in the name
# # (you can search for exact strings if you know them for specific versions)
# $regPaths | Foreach-Object {
#   ( Get-ItemProperty "${_}\*" DisplayName -EA SilentlyContinue ).DisplayName | Where-Object {
#     $_ -match 'office'
#   }
# }

$Keys = Get-Item -Path HKLM:\Software\RegisteredApplications | Select-Object -ExpandProperty property
$Product = $Keys | Where-Object {$_ -Match "Excel.Application."}
$OfficeVersion = ($Product.Replace("Excel.Application.","")+".0")
Write-Host $OfficeVersion