@echo off
setlocal
rem OpenClaw startup launcher
set "LOG=%TEMP%\openclaw-gateway-startup.log"
del "%LOG%" 2>nul
start "OpenClaw Gateway" powershell -NoProfile -ExecutionPolicy Bypass -Command "openclaw gateway run 2>&1 | Tee-Object -FilePath '%LOG%'"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$log = '%LOG%'; $ready = $false; for($i = 1; $i -le 10; $i++){ Start-Sleep -Seconds 180; if(Test-Path $log){ $text = Get-Content $log -Raw -ErrorAction SilentlyContinue; if($text -match '\[gateway\]\s+ready' -and $text -match '\[heartbeat\]\s+started'){ $ready = $true; break } } }; if(-not $ready){ Write-Host '[startup] gateway not ready after 10 polls'; exit 1 }; Start-Process powershell -ArgumentList '-NoProfile','-ExecutionPolicy','Bypass','-NoExit','-Command','openclaw dashboard'; Start-Sleep -Seconds 3; Start-Process 'https://github.com/settings/copilot/features'"