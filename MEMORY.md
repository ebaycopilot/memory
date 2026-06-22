# MEMORY.md

- Windows startup for OpenClaw should use a resilient two-step flow: first `openclaw gateway run`, then only open `openclaw dashboard` after Gateway is ready, and also open GitHub Copilot usage page at `https://github.com/settings/copilot/features`.
- The preferred wait window for Gateway readiness is 300 seconds.
- The current startup launcher path is `C:\Users\Administrator\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\OpenClaw Startup.cmd`.\n- Removed the old Evernote/印象笔记 startup shortcut from the Windows Startup folder.
- Keyword shortcut for this setup: `开机启动小龙虾`.
  - Use this as the trigger phrase to recall the startup context and continue editing from there.
  - Once the startup task is marked complete, do not modify this memory again unless the user explicitly says to reopen or change the startup setup.
