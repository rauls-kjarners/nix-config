@echo off
set WSLENV=TRID_FILE/p:LOCK_FILE/p
set TRID_FILE=%~1
set LOCK_FILE=%TEMP%\wezterm_%RANDOM%.lock

echo locked > "%LOCK_FILE%"

C:\Windows\System32\wsl.exe -d NixOS -u nixos -e bash -c "echo '#!/usr/bin/env bash' > /mnt/c/Users/rauls/AppData/Local/Temp/runner.sh"
C:\Windows\System32\wsl.exe -d NixOS -u nixos -e bash -c "echo 'nvim \"$TRID_FILE\"' >> /mnt/c/Users/rauls/AppData/Local/Temp/runner.sh"
C:\Windows\System32\wsl.exe -d NixOS -u nixos -e bash -c "echo 'rm \"$LOCK_FILE\"' >> /mnt/c/Users/rauls/AppData/Local/Temp/runner.sh"

wezterm-gui.exe start --always-new-process --domain WSL:NixOS -- bash --login /mnt/c/Users/rauls/AppData/Local/Temp/runner.sh

:waitloop
if exist "%LOCK_FILE%" (
    ping 127.0.0.1 -n 2 > nul
    goto waitloop
)
