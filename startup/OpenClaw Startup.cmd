@echo off
setlocal
rem OpenClaw startup launcher
set "LOG=%TEMP%\openclaw-gateway-startup.log"
del "%LOG%" 2>nul
start "OpenClaw Gateway" powershell -NoProfile -NoExit -ExecutionPolicy Bypass -Command "openclaw gateway run 2>&1 | Tee-Object -FilePath '%LOG%'; Write-Host ''; Write-Host '[startup] gateway process exited'; Pause"
start "OpenClaw Gateway Monitor" powershell -NoProfile -ExecutionPolicy Bypass -Command "$log = '%LOG%'; $deadline = (Get-Date).AddSeconds(600); $ready = $false; while((Get-Date) -lt $deadline){ if(Test-Path $log){ $text = Get-Content $log -Raw -ErrorAction SilentlyContinue; if($text -match '\[gateway\]\s+ready' -and $text -match '\[heartbeat\]\s+started'){ $ready = $true; break } } Start-Sleep -Seconds 5 }; if(-not $ready){ Write-Host '[startup] gateway not ready after 600 seconds'; exit 1 }; Start-Process powershell -ArgumentList '-NoProfile','-ExecutionPolicy','Bypass','-NoExit','-Command','openclaw dashboard'; Start-Sleep -Seconds 3; Start-Process 'https://github.com/settings/copilot/features'"