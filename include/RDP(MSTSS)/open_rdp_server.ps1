Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server" -Name fDenyTSConnections -Value 0 -Force
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" -Name UserAuthentication -Value 1 -Force
netsh.exe advfirewall firewall add rule name="Open RDP Port 3389" dir=in action=allow protocol=TCP localport=3389

netstat -aon | findstr "3389"