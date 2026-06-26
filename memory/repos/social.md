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

## 改造记录

### 2026-06-26：评论部分新增“手动截图直接评论”入口

用户要求：只改第三部分“评论”，新增功能为用户提供截图后，先把截图保存到某个文件夹，再调用评论脚本直接根据这些截图生成评论；不得影响原有“抓视频 → 截图 → 评论”流程。

已实现：

- 新增 `.claude/skills/photo-comments/from-images.js`。
- 用法：`node ./.claude/skills/photo-comments/from-images.js <名称> <截图路径...> [--title <标题>] [--force|-f]`。
- 脚本会把手动截图复制到 `memory/tiktok/generated/<名称>/manual-<timestamp>/`，再直接生成 `comment` 并写入该目录的 `index.json`。
- `comments.js` 导出 `generateContentFromFolder`，让新增入口复用评论部分原有 prompt。
- `image-to-text` 从仅支持 PNG 扩展为支持 `png/jpg/jpeg/webp`，原 PNG 流程不受影响。
- 更新 `.claude/skills/photo-comments/SKILL.md` 说明原流程与新增手动截图入口。
- social 仓库提交并推送：`de52ce4 Add manual screenshot comment entry` 到 `develop`。

验证：

- `node --check` 检查非 `node_modules` 下 JS：`syntax_failed=0`。
- `from-images.js --help` 可输出用法。
- `parseArgs` 最小解析验证通过。

### 2026-06-26：手动截图入口首次实际图片测试

- 用户在微信直接发送了一张图片，作为新增“手动截图直接评论”入口的实际测试输入。
- 图片已保存到 `D:\github\social\memory\tiktok\generated\手动截图\manual-20260626124533487\01.jpg`。
- 因当前环境未设置 `ARK_API_KEY`，仓库脚本不能实际调用豆包视觉模型；本次使用 OpenClaw 当前可见图片能力 fallback 生成评论，并写入同目录 `index.json`。
- 生成评论：`太厉害了！小朋友拿着奖牌和证书的样子特别自信，数学袋鼠全国金奖含金量很高，背后肯定离不开平时的坚持和努力，真心为他骄傲！`
- 该目录属于 `memory/tiktok/generated/`，被 social 仓库 `.gitignore` 忽略，不推送到 social 代码仓库。

### 2026-06-26：使用 README 中 ARK_API_KEY 真实调用评论脚本

- 用户说明 `ARK_API_KEY` 在 `README.md` 中，可直接使用。
- 出于安全原因，不在对话或记忆中记录 key 明文。
- 已从 `README.md` 读取 key 到当前进程环境变量，并运行：`node ./.claude/skills/photo-comments/from-images.js 手动截图 C:\Users\Administrator\.openclaw\media\inbound\055840c9-8643-4713-8bc0-e9c16a8c15fe.jpg --title "数学袋鼠获奖"`。
- 脚本成功保存截图到 `D:\github\social\memory\tiktok\generated\手动截图\manual-20260626124842052` 并生成评论。
- 真实脚本生成评论：`哇哦，数学袋鼠竞赛拿金奖呢，太厉害啦小朋友！小小年纪就这么牛，未来肯定潜力无限。这奖状和金牌就是你努力的证明，继续加油，以后说不定还能在更多竞赛中大放光彩！`

### 2026-06-26：调整豆包 AI 从图片获取评论的接口

用户通过图片说明：功能已可用，接下来要调整“调用豆包 AI 从图片获取评论”的接口。

已实现：

- 新增 `.claude/skills/image-to-text/doubao-vision.js`，将豆包视觉调用从 `image-to-text/index.js` 中抽成独立接口。
- 新接口：`generateTextFromImagePaths(imagePaths, prompts, options)`，可直接传图片路径数组给豆包视觉模型生成文本。
- 兼容接口：`generateTextFromImageFolder(folderPath, startIndex, endIndex, prompts, options)`，保留原有文件夹流程。
- `comments.js` 新增/导出 `generateContentFromImagePaths(type, imagePaths, opts)`，评论层可直接基于图片路径数组生成评论。
- `from-images.js` 改为通过 `generateContentFromImagePaths()` 调用评论接口，而不是再绕回文件夹读取。
- `ARK_API_KEY` 读取逻辑：优先使用环境变量；如果没有设置，则从仓库根目录 `README.md` 读取，不在日志或记忆里记录 key 明文。
- 更新 `.claude/skills/photo-comments/SKILL.md` 说明新接口。
- social 仓库提交并推送：`c38fa33 Refactor Doubao image comment interface` 到 `develop`。

验证：

- 非 `node_modules` 下 JS 语法检查：`syntax_failed=0`。
- 接口导出检查通过：`generateTextFromImagePaths`、`generateTextFromImageFolder`、`generateContentFromImagePaths` 都可用。
- 清除当前进程 `ARK_API_KEY` 后，运行 `from-images.js`，成功从 README 兜底读取 key 并真实调用豆包生成评论。
- 测试图片保存目录：`D:\github\social\memory\tiktok\generated\接口测试\manual-20260626174319960`。
- 真实测试评论：`看来这接口调整还挺有讲究呢！从图上看有了阶段性成果，后续继续调整。很好奇调整完成后会有啥新功能，期待博主分享后续进展哈！`

### 2026-06-26：手动截图评论默认风格改为同事朋友圈

用户明确：自己的评论都要通过 `social` 的评论功能运行出来；需要调整的也是 `social` 的评论功能。用户身份是中年男性，评论对象常是同事朋友圈，评论需要含蓄、内敛、有深度。

已实现：

- `from-images.js` 的默认评论场景从泛化口语评论改为：微信朋友圈、中年男性、同事关系、含蓄内敛、有分寸、有深度。
- 新增可覆盖参数：`--platform`、`--relationship`、`--persona`、`--style`、`--tone`、`--length`。
- `comments.js` 的 `buildContentPrompts()` 增加朋友圈分支；当 `platform` 为 `朋友圈/微信朋友圈` 时，生成适合同事朋友圈的克制评论，不再使用抖音热评口吻。
- 增加限制：不要主动称呼对方姓名或昵称，避免生成过于熟络/突兀的开头。
- 原有抓视频生成 `image-to-text.json` 的抖音评论/弹幕流程保留，不改硬编码请求。
- social 仓库提交并推送：`a825f1b Tune manual comments for colleague moments` 到 `develop`。

验证：

- 非 `node_modules` 下 JS 语法检查：`syntax_failed=0`。
- 默认参数解析验证通过：`platform=朋友圈`、`relationship=同事`、`persona=中年男性`。
- 真实调用同事旅行朋友圈图生成评论，最终输出：`景美人稀，别有逸趣。喜来登的惬意与周遭山水相融，似在喧嚣中辟出一方静土。这趟旅程，想必为身心寻得片刻安栖。`

### 2026-06-26：同事朋友圈评论风格调轻为生活化

用户反馈：不需要这么有深度，要适当生活化一点。

已实现：

- `from-images.js` 默认 `style` 从 `含蓄内敛、有分寸、有深度` 改为 `自然生活化、有分寸、不夸张`。
- 默认 `tone` 从 `稳重、克制、有余味` 改为 `稳重但轻松，像日常同事评论`。
- `comments.js` 的朋友圈 prompt 增加约束：像真实生活里同事之间的自然评论，不要太有文采，不要故作深刻，不要上价值，不要过度抒情。
- 更新 `.claude/skills/photo-comments/SKILL.md` 默认风格说明。
- social 仓库提交并推送：`1e54890 Make colleague moment comments more natural` 到 `develop`。

验证：

- 非 `node_modules` 下 JS 语法检查：`syntax_failed=0`。
- prompt 默认参数检查通过。
- 使用同事旅行朋友圈图真实调用，输出更生活化：`这地儿看着真不错，景美，住得也舒坦。下次有类似好去处，可得多分享分享！`

### 2026-06-26：避免同事朋友圈评论出现北京口吻

用户反馈：用词不要这么像北京人说话。

已实现：

- `from-images.js` 默认 `style` 补充：使用中性普通话表达。
- 默认 `tone` 补充：不带地域口音。
- `comments.js` 的朋友圈 prompt 明确避免北京口语、儿化音和地域口吻。
- 显式禁止/规避词例：`地儿`、`可得`、`倍儿`、`甭`、`咱`、`得去`、`转转`，同时避免波浪号。
- 更新 `.claude/skills/photo-comments/SKILL.md` 默认风格说明。
- social 仓库提交并推送：`631b2ac Avoid regional phrasing in moment comments` 到 `develop`。

验证：

- 非 `node_modules` 下 JS 语法检查：`syntax_failed=0`。
- prompt 默认参数检查通过。
- 使用同事旅行朋友圈图真实调用，输出更中性：`风景真美，这喜来登看着确实不错。玩得挺惬意啊，有机会我也去体验体验。`

### 2026-06-27：朋友圈评论改为多角度短候选

用户要求：朋友圈评论尽量简短；希望从不同角度给几个评论，每个角度都精简一点，然后用户自己选择。

已实现：

- `from-images.js` 默认 `lengthDesc` 改为 `每条30字以内`。
- 新增 `--variants <数量>` 参数，默认 `4`。
- `comments.js` 的朋友圈 prompt 改为默认输出多条候选，从认可、轻松、共鸣、祝福、适度调侃等不同角度生成。
- 输出格式为编号列表，每条一行，不写角度名，方便直接复制其中一条。
- social 仓库提交并推送：`0ac177f Generate concise moment comment options` 到 `develop`。

验证：

- 非 `node_modules` 下 JS 语法检查：`syntax_failed=0`。
- 默认参数检查通过：`variants=4`、`lengthDesc=每条30字以内`。
- 使用朋友圈情绪图真实调用，输出：
  1. `谁没点低谷，坚持住就有转机。`
  2. `生活像游戏，总会有难打的关。`
  3. `感同身受，相信会迎来胜利时刻。`
  4. `别灰心，说不定下一秒就能破局。`

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
