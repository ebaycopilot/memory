# MEMORY.md

- Windows startup for OpenClaw should use a resilient log-driven flow: first `openclaw gateway run` in a separate PowerShell window that stays open, then use a separate monitor window to watch the gateway log for `[gateway] ready` and `[heartbeat] started` (up to 600 seconds) before opening a new PowerShell window for `openclaw dashboard`.
- After the dashboard opens, also open GitHub Copilot usage page at `https://github.com/settings/copilot/features`.
- Removed the old Evernote/印象笔记 startup shortcut from the Windows Startup folder.
- The startup launcher currently lives at `C:\Users\Administrator\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\OpenClaw Startup.cmd`.
- A synchronized repo copy of the startup launcher lives at `startup\OpenClaw Startup.cmd`.
- Keyword shortcut for this setup: `开机启动小龙虾`.
  - Use this as the trigger phrase to recall the startup context and continue editing from there.
  - Once the startup task is marked complete, do not modify this memory again unless the user explicitly says to reopen or change the startup setup.

- `D:\github\social` has a dedicated project memory at `memory\repos\social.md`.
  - Trigger phrases: `social 仓库`, `搜索 repo`, `抖音截图评论工具`, `这个仓库` when the active repo is social.
  - Before optimizing that repo, read the dedicated project memory first and append significant decisions/results there.
  - For any social-related work, immediately commit and push changes: code in `D:\github\social` on `develop`, memory in `D:\github\memory` on `main`.
