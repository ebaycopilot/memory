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
  - Trigger phrases: `social`, `社交`, `社交评论`, `搜索评论开始`, `social 仓库`, `抖音截图评论工具`, or `这个仓库` when the active repo is social.
  - Before optimizing that repo, read the dedicated project memory first and append significant decisions/results there.
  - Social comment workflow: wait for the full Moments material batch, route generation through the comment skill, and display the generated JSON `comment` field.
  - Branch convention: general historical pipeline work used `develop`; the standalone social-commenter agent and current comment workflow live on `agent`.
  - For social-related work, immediately commit and push changes: code/agent changes in `D:\github\social` on the active target branch, and memory changes in `D:\github\memory` on `main`.
