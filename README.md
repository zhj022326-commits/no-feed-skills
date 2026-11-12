# no-feed-skills

本仓库收录十四个可独立调用的 Agent Skills。

## Skill 列表

### knowledge-assembler

用于把多领域知识组装成有解释力的文章，并支持在同一对话中切换论证路径。只改标题、润色已有稿件、查询单项事实或生成摘要时通常不触发。

目录：[`skills/knowledge-assembler/`](skills/knowledge-assembler/)

### self-narrative-restoration

仅对当事人的第一人称自我叙事进行还原，识别自我美化、利益包装、责任转移、事实偷换或叙事越权；范围外输入使用固定引导语，符合范围但无值得还原内容时使用唯一终止语。

目录：[`skills/self-narrative-restoration/`](skills/self-narrative-restoration/)

### life-archive

维护用户可编辑的 Markdown 人生档案；只在用户明确要求归档当前对话或启动人生访谈时使用。

目录：[`skills/life-archive/`](skills/life-archive/)

### 三分法

检查文章中作者与目标观众的战队关系，找出把目标观众变成批评、贬低或教育对象的表达，并在保留观点、攻击力和语言风格的前提下改写。

目录：[`skills/three-part-method/`](skills/three-part-method/)

### content-production

评估已有开口并生成参考，为开口或现象寻找具体理论，或把理论和观点转换成有观看动机的开口；不默认扩写成完整脚本或文章。

目录：[`skills/content-production/`](skills/content-production/)

### manuscript-diagnostic

依据《内容生产综合模型》诊断完整或局部稿件，识别实际使用的方法、评价文本效果，并用原文证据提出调整建议。默认交付诊断报告，不整篇改写稿件。

目录：[`skills/manuscript-diagnostic/`](skills/manuscript-diagnostic/)

### ai-logic-review

依据六类固定判例审查 AI 回答、评论、分析或论证中的可确认逻辑偏离，逐条列出原文证据和逻辑关系；不做事实裁决、立场评价、反驳、改写或建议。

目录：[`skills/ai-logic-review/`](skills/ai-logic-review/)

### interactive-learning

根据用户提供的教材、文章、主题或知识点，立即开始互动学习，并在领学、启发、测验、实践和复述之间切换。

目录：[`skills/interactive-learning/`](skills/interactive-learning/)

### eight-emotions-four-uses

基于“八情四用模型”为观点、选题和观点型文案生成、诊断或转换情绪修辞角度。

目录：[`skills/eight-emotions-four-uses/`](skills/eight-emotions-four-uses/)

### moral-emotion

根据《道德情绪传播模型》改写用户已有的观点、句子、故事或文案，提高道德情绪感染力和传播价值，并在每次改稿后提供可继续选择的创作方向。

目录：[`skills/moral-emotion/`](skills/moral-emotion/)

### thinking-mistake-notebook

《思维错题本》通过情境生成、错误思维模拟和互动复盘，帮助用户观察错误认知如何从正常欲望、经验、利益与直觉中产生并逐步强化。

目录：[`skills/thinking-mistake-notebook/`](skills/thinking-mistake-notebook/)

### strong-personality

《强者人格》以“始终站在自己一边，同时尊重事实”为核心，独立审查用户叙事、拆解混乱概念，并围绕现实利益、资源和行动空间给出明确回应。

目录：[`skills/strong-personality/`](skills/strong-personality/)

### video-interactive-learning（完整版）

把抖音、B站、YouTube 等视频链接转换成学习材料：优先取得字幕，没有字幕时进行语音识别，语音失败后只抽帧一次救稿，然后整理知识并立即开始互动学习。

当前版本为 `1.0.1`，已包含基于 yt-dlp PR #17826 的抖音 HTTP 403 兼容修复，并保持 Python 3.10+ 兼容。

公开包只保留运行源码、依赖、许可证和必要说明；上游测试媒体、演示图片、测试套件及开发工程文件不随 Skill 下载。

目录：[`skills/video-interactive-learning/`](skills/video-interactive-learning/)

### video-interactive-learning-lite（轻量版）

面向豆包等原生具备视频链接读取、字幕提取或语音转写能力的 Agent。它只负责文字稿质量判断、知识整理和互动教学，不携带视频下载、语音转写、抽帧或环境安装程序。

目录：[`skills/video-interactive-learning-lite/`](skills/video-interactive-learning-lite/)

两个版本不要同时按同一用途调用：

| 版本 | 适用环境 | 视频取稿方式 | 额外依赖 |
| --- | --- | --- | --- |
| `video-interactive-learning` | 宿主缺少稳定取稿能力，或需要 Skill 自行兜底 | 平台字幕、语音转写，失败时一次抽帧救稿 | Python 3.10+ 或 uv，首次转写需下载模型 |
| `video-interactive-learning-lite` | 豆包等宿主已原生具备完整视频取稿能力 | 直接调用宿主已有能力 | 无 |

## 安装

以下命令显式指定安装目标，适合终端、脚本和无终端的 AI 后台任务。只需要某一个 Skill 时，不要使用 `--all`：它会安装仓库中的全部十四个 Skills。

安装本仓库中的全部 Skills 到安装工具支持的全部 Agent：

```bash
npx -y skills add zhj022326-commits/no-feed-skills -g --all
```

只安装《思维错题本》：

```bash
npx -y skills add zhj022326-commits/no-feed-skills --skill thinking-mistake-notebook --agent "*" -g
```

只安装《强者人格》：

```bash
npx -y skills add zhj022326-commits/no-feed-skills --skill strong-personality --agent "*" -g
```

只安装《稿件综合诊断》：

```bash
npx -y skills add zhj022326-commits/no-feed-skills --skill manuscript-diagnostic --agent "*" -g
```

只安装《AI 逻辑审查》：

```bash
npx -y skills add zhj022326-commits/no-feed-skills --skill ai-logic-review --agent "*" -g
```

只安装信息流学习机完整版：

```bash
npx -y skills add zhj022326-commits/no-feed-skills --skill video-interactive-learning --agent "*" -g
```

只安装信息流学习机轻量版：

```bash
npx -y skills add zhj022326-commits/no-feed-skills --skill video-interactive-learning-lite --agent "*" -g
```

若只使用一个 Agent，优先把 `"*"` 改成其名称，减少不必要的安装操作。例如只把轻量版装到 Cursor：

```bash
npx -y skills add zhj022326-commits/no-feed-skills --skill video-interactive-learning-lite --agent cursor -g
```

后台或无终端环境不要省略 `--agent`，否则安装工具可能停在“选择 Agent”界面。`npx -y` 只跳过 npx 自身的确认；即使加上安装工具的 `-y`，也不要依赖它替你选择 Agent。`--agent "*"` 仅指该工具支持的 Agent，不代表豆包等所有平台都能通过这条命令安装。

如果 npx 冷启动慢，可以跳过 npx，手动取得仓库：

```bash
git clone --depth 1 https://github.com/zhj022326-commits/no-feed-skills.git
```

然后把 `skills/<skill-name>/` 整个目录复制到目标 Agent 的技能目录，保留其中的脚本和参考文件。豆包等要求上传文件的平台，应按其自身导入方式使用轻量版 ZIP。

## 使用

- 研究问题并组装文章：使用 `$knowledge-assembler`。
- 还原第一人称自述：使用 `$self-narrative-restoration`。
- 维护人生档案：使用 `$life-archive`。
- 检查文案是否误伤目标观众：使用 `$three-part-method`。
- 评估开口、寻找理论或把观点变成开口：使用 `$content-production`。
- 按《内容生产综合模型》诊断稿件：使用 `$manuscript-diagnostic`。
- 按六类固定判例审查 AI 文本中的可确认逻辑偏离：使用 `$ai-logic-review`。
- 立即开始互动学习：使用 `$interactive-learning`。
- 生成或检查情绪修辞角度：使用 `$eight-emotions-four-uses`。
- 把已有内容改得更有道德情绪传播力：使用 `$moral-emotion`。
- 通过情境实验观察并复盘错误认知：使用 `$thinking-mistake-notebook`。
- 以强者人格独立审查叙事、分析现实并维护主体性：使用 `$strong-personality`。
- 宿主需要自行提取视频文字稿时：使用完整版 `$video-interactive-learning`。
- 豆包等宿主已经能直接取得完整视频文字稿时：使用轻量版 `$video-interactive-learning-lite`。

## 运行依赖

- 支持 Agent Skills 的客户端
- `ai-logic-review` 无额外运行依赖；输入中必须包含待审 AI 文本，需要确认跨样本偏差时还应提供可比回答。
- `manuscript-diagnostic` 无额外运行依赖；包内同时提供理论 DOCX 原件及可检索的 Markdown。更新理论副本时可使用 PowerShell 运行 `scripts/extract-theory.ps1`。
- `video-interactive-learning` 需要 Python 3.10+ 或 uv、网络和文件读写能力；首次语音识别会下载模型。
- `video-interactive-learning-lite` 不携带代码或依赖，但宿主必须原生支持从视频链接取得完整文字稿。

## 发布内容

仓库只包含运行这些 Skills 所需的入口说明、运行代码、依赖声明、许可证和参考材料，不包含测试媒体、演示输出、本机运行记录或私密配置。
