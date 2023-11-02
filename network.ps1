$network = Get-NetIPAddress | Format-Table IPAddress, PrefixLength, SuffixOrigin
Write-Host $network
