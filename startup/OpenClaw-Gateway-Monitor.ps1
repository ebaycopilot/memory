param(
  [Parameter(Mandatory = $true)]
  [string]$LogPath
)

$Host.UI.RawUI.WindowTitle = 'OpenClaw Gateway Monitor'

$deadline = (Get-Date).AddSeconds(600)
$ready = $false

while ((Get-Date) -lt $deadline) {
  if (Test-Path $LogPath) {
    $text = Get-Content -Path $LogPath -Raw -ErrorAction SilentlyContinue
    if ($text -match '\[gateway\]\s+ready' -and $text -match '\[heartbeat\]\s+started') {
      $ready = $true
      break
    }
  }
  Start-Sleep -Seconds 5
}

if (-not $ready) {
  Write-Host '[startup] gateway not ready after 600 seconds'
  exit 1
}

Start-Process powershell -ArgumentList '-NoProfile','-ExecutionPolicy','Bypass','-NoExit','-File',"$PSScriptRoot\OpenClaw-Gateway-Tail.ps1",'-LogPath',$LogPath
Start-Sleep -Seconds 2
Start-Process powershell -ArgumentList '-NoProfile','-ExecutionPolicy','Bypass','-NoExit','-Command','openclaw dashboard'
Start-Sleep -Seconds 3
Start-Process 'https://github.com/settings/copilot/features'

Write-Host ''
Write-Host '[startup] tail window launched'