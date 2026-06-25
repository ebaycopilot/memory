@echo off
setlocal
if "%~1"=="" exit /b 1
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0OpenClaw-Gateway-Monitor.ps1" -LogPath "%~1"