# $chrome = (Get-Item (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe').'(Default)').VersionInfo.ProductVersion
# Write-Host $chrome

# $msedge = (Get-Item (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\msedge.exe').'(Default)').VersionInfo.ProductVersion
# Write-Host $msedge

# $firefox = (New-Object -ComObject WScript.Shell).RegRead("HKLM\SOFTWARE\Mozilla\Mozilla Firefox\CurrentVersion")
# Write-Host $firefox

# $monitor = ( Format-List -Property @(
#     @{Name = 'Chrome'; Expression = {(Get-Item (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe').'(Default)').VersionInfo.ProductVersion}}
# ) | Out-String).Trim()

# Write-Host $monitor


# $browser = New-Object -Type PSObject | Format-List -Property @(
#     @{Name = 'Chrome'; Expression = {(Get-Item (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe').'(Default)').VersionInfo.ProductVersion }}
#     @{Name = 'MSEdge'; Expression = {(Get-Item (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\msedge.exe').'(Default)').VersionInfo.ProductVersion }}
#     @{Name = 'Firefox'; Expression = {(New-Object -ComObject WScript.Shell).RegRead("HKLM\SOFTWARE\Mozilla\Mozilla Firefox\CurrentVersion") }}
# ) | Out-String
# Write-Host $browser

$browser =
    (@(
        [pscustomobject]@{name="Chrome";version=(Get-Item (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe').'(Default)').VersionInfo.ProductVersion},
        [pscustomobject]@{name="MSEdge";version=(Get-Item (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\msedge.exe').'(Default)').VersionInfo.ProductVersion},
        [pscustomobject]@{name="Firefox";version=(New-Object -ComObject WScript.Shell).RegRead("HKLM\SOFTWARE\Mozilla\Mozilla Firefox\CurrentVersion")}
    ) | Format-List | Out-String).Trim()

Write-Host $browser