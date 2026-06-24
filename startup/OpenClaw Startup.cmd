@echo off
setlocal
rem OpenClaw startup launcher
for /f %%I in ('powershell -NoProfile -Command "Get-Date -Format yyyyMMdd-HHmmssfff"') do set "STAMP=%%I"
set "LOG=%TEMP%\openclaw-gateway-startup-%STAMP%.log"
start "OpenClaw Gateway" powershell -NoProfile -NoExit -ExecutionPolicy Bypass -Command "openclaw gateway run 2>&1 | Tee-Object -FilePath '%LOG%'; Write-Host ''; Write-Host '[startup] gateway process exited'; Pause"
start "OpenClaw Gateway Monitor" powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0OpenClaw-Gateway-Monitor.ps1" -LogPath "%LOG%"