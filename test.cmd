# 2> nul & powershell.exe -ExecutionPolicy Bypass -NoProfile -Command "[scriptblock]::Create((Get-Content -LiteralPath '%~f0' -Raw)).Invoke()" #& EXIT /B
# Hides PowerShell Console
Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();
[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
'
$consolePtr = [Console.Window]::GetConsoleWindow()
[Console.Window]::ShowWindow($consolePtr, 0)
Add-Type -AssemblyName System.Windows.Forms

$ip = get-WmiObject Win32_NetworkAdapterConfiguration | Where {$_.Ipaddress.length -gt 1} 
$txtIP = "`nMy IP addresses:`n" + ( $ip | % {$_.ipaddress} | % {'' + $_ + "`n"} )
$pcname = "My PC name: " + [System.Net.Dns]::GetHostName() + "`n"
$username = "`nI'm logged in as: " + $env:USERDOMAIN + '\' + $env:USERNAME + "`n"

$MessageText = $pcname + $username + $txtIP 

[System.Windows.Forms.MessageBox]::Show($MessageText,'About my PC','OK','Information')