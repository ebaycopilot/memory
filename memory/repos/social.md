# social 仓库专项记忆

> 作用：记录 `D:\github\social` 仓库相关的长期上下文、决策、优化计划和后续对话摘要。之后只要用户提到 social 仓库、搜索 repo、抖音/截图/评论流水线，优先查看本文件。

## 仓库定位

- 本地路径：`D:\github\social`
- GitHub remote：`https://github.com/hypothesisobservation/social`
- 当前代码开发分支：`develop`。
- 早先曾新建过 `development` 分支；后续按用户要求统一使用 `develop`。
- 用户最初称它为“搜索这个 repo”，后确认实际是 `social`。

## 当前理解

这是一个面向抖音/视频内容的本地自动化工具仓库。用户明确将仓库主要分为三个部分：

1. 抓视频。
2. 截图。
3. 评论。

当前流水线理解：

1. 抓取抖音用户主页或接收指定视频 URL。
2. 生成截图任务 JSON。
3. 使用 Playwright 连接本地 Chrome CDP `http://localhost:9222` 截图。
4. 基于截图生成 `image-to-text.json`。
5. 调用火山方舟兼容 OpenAI API 的豆包视觉模型生成评论、弹幕或笔记。

主要目录：

- `.claude/skills/tiktok-view/`：抓取用户主页、解析作品列表、生成截图请求。
- `.claude/skills/screenshot-capture/`：读取截图请求并截图。
- `.claude/skills/photo-comments/`：扫描截图目录并生成图片转文字请求。
- `.claude/skills/image-to-text/`：调用视觉模型生成文本。
- `memory/tiktok/watch-mcp-data.json`：用户名到抖音主页 URL 的本地映射。

## 已发现的问题

高优先级：

- `README.md` 中出现过真实/疑似真实的 `ARK_API_KEY` 示例，应立即轮换密钥，并从 README 和必要时从 Git 历史中清理。
- README 路径过期，仍引用 `.claude/skills/tiktok/...`、`comment.js`、`gpt5.js`、`comment_gpt5.js`，但当前实际目录是 `tiktok-view`、`screenshot-capture`、`photo-comments`、`image-to-text`。
- `photo-comments` 命名不一致：`SKILL.md` 和 `.gitignore` 中写成 `photo-cocmments`。
- `.claude/settings.local.json` 与 `memory/tiktok/watch-mcp-data.json` 被 git 跟踪；需要评估是否应转为本地文件并提供 example。

中优先级：

- 根目录没有统一 `package.json`，依赖和命令分散在各 skill 目录。
- 多处硬编码参数：`videoCount = 1`、`shotCount = 10`、`interval = 3500`、`MAX_SHOTS = 66`。
- 多处硬编码 CDP 地址：`http://localhost:9222`。
- `connectOverCDP` 后使用 `browser.close()` 可能误关用户的远程调试浏览器；更安全的是 CDP 连接默认 `disconnect()`，自己启动的浏览器才 `close()`。

## 验证记录

- 在 `D:\github\social` 执行过非 `node_modules` 的 JS 语法检查：`checked=10 failed=0`。
- 依赖识别：
  - `tiktok-view`: `playwright@1.58.2`
  - `screenshot-capture`: `playwright@1.59.1`
  - `image-to-text`: `openai@6.34.0`
- `git status --short --branch`：已切换为 `## develop...origin/develop`，工作区干净。

## 建议的优化顺序

P0：

1. 轮换/废弃 README 中暴露过的 API Key。
2. 删除 README 中真实 key，改为占位符。
3. 修 README 过期路径与错误用法。

P1：

1. 统一 `photo-comments` 命名。
2. 根目录增加统一 `package.json` 和脚本。
3. 把视频数、截图数、间隔、最大截图数、CDP 地址改为 CLI 参数或配置。
4. CDP 浏览器连接默认使用 `disconnect()`。
5. 整理 `.gitignore`，避免本地配置和生成数据入库。

P2：

1. 加最小测试：参数解析、路径生成、JSON 读写。
2. 加 lint/format。
3. 把 prompt 模板抽成配置文件。
4. 给 `image-to-text.json` 定义 schema，减少手改 JSON 出错。

## 对话使用约定

- 之后用户说“这个仓库”“social 仓库”“搜索 repo”“抖音截图评论工具”等，优先按 `D:\github\social` 理解。
- 任何对话只要以 `social` 或 `社交` 开头，就表示用户要在 `D:\github\social` 仓库工作；直接进入该仓库上下文，不要再反复确认。
- 开始任何优化前，先查看本文件，避免重复分析。
- 重要决策、修复结果、踩坑和下一步计划都追加到本文件。
- 和 `social` 相关的任何改动都要立即提交并推送。
- 代码改动：在 `D:\github\social` 的 `develop` 分支完成、提交并推送。
- 记忆改动：同步到 `D:\github\memory` 的 `main` 分支，提交并推送。
