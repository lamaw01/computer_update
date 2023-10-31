import subprocess
result = subprocess.run([r'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe', r'C:\Projects\computer_update_script\computer_update.ps1'], stdout=subprocess.PIPE, stderr=subprocess.STDOUT, shell=True)
print(result)