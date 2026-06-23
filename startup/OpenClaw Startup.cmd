@echo off
setlocal
rem OpenClaw startup launcher
start "OpenClaw Gateway" powershell -NoProfile -ExecutionPolicy Bypass -Command "openclaw gateway run"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$deadline = (Get-Date).AddSeconds(600); while((Get-Date) -lt $deadline){ if(Test-NetConnection 127.0.0.1 -Port 18789 -InformationLevel Quiet){ break }; Start-Sleep -Seconds 5 }; if(-not (Test-NetConnection 127.0.0.1 -Port 18789 -InformationLevel Quiet)){ Write-Host '[startup] gateway not ready after 600 seconds'; exit 1 }; Start-Process powershell -ArgumentList '-NoProfile','-ExecutionPolicy','Bypass','-NoExit','-Command','openclaw dashboard'; Start-Sleep -Seconds 3; Start-Process 'https://github.com/settings/copilot/features'"