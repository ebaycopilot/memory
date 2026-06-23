# MEMORY.md

- Windows startup for OpenClaw should use a resilient log-driven flow: first `openclaw gateway run` in a separate PowerShell window that stays open, then use a separate monitor window to watch the gateway log for `[gateway] ready` and `[heartbeat] started` (up to 600 seconds) before opening a new PowerShell window for `openclaw dashboard`.
- After the dashboard opens, also open GitHub Copilot usage page at `https://github.com/settings/copilot/features`.
- Removed the old Evernote/印象笔记 startup shortcut from the Windows Startup folder.
- The startup launcher currently lives at `C:\Users\Administrator\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\OpenClaw Startup.cmd`.\n- A synchronized repo copy of the startup launcher lives at `startup\OpenClaw Startup.cmd`.
- Keyword shortcut for this setup: `开机启动小龙虾`.
  - Use this as the trigger phrase to recall the startup context and continue editing from there.
  - Once the startup task is marked complete, do not modify this memory again unless the user explicitly says to reopen or change the startup setup.
