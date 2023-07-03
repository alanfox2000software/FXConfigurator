@echo off
chcp 65001
net.exe session 1>NUL 2>NUL || (Echo This script requires elevated rights. & pause & Exit /b 1)
reg query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > NUL && set OS=32 || set OS=64
"%~dp0NSudoLC%OS%.exe" -U:T -P:E -UseCurrentConsole "%~dp0AutoHotkeyU%OS%.exe" "%~dp0FXConfigurator.ahk"