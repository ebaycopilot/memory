param(
  [Parameter(Mandatory = $true)]
  [string]$LogPath
)

$Host.UI.RawUI.WindowTitle = 'OpenClaw Gateway Log Tail'
Write-Host ''
Write-Host '[startup] live log follow begins'
Write-Host '[startup] press Ctrl+C to stop following the log'
Get-Content -Path $LogPath -Tail 20 -Wait