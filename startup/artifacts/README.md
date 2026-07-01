# Startup artifacts

This directory stores durable binary artifacts related to the OpenClaw startup and token refresh workflow.

## oc-vscode-copilot-bridge.vsix

- Source: C:\Users\Administrator\AppData\Local\Temp\oc-vscode-copilot-bridge.vsix\n- Purpose: local VS Code bridge extension used to refresh GitHub Copilot / social-commenter tokens at startup.
- Size: 2828 bytes
- SHA256: 2815072A9C1DD36E717D53DF673F0D2EE82E93A9FA81A48121BE36F41D66ACAA
- LastWriteTime: 2026-06-30 20:05:17

Keep this artifact with the startup workflow rather than in the social repository, because it is infrastructure for authentication and bootstrapping rather than part of the social-commenting application itself.