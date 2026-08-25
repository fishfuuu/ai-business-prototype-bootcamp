# 企业 AI 业务原型训练营

> 面向最懂业务的业务主管：用 AI Agent 制作业务原型、判断 AI 融入场景、把原型包交付 IT 工程化落地。
>
> [English Version](README.en.md)

企业做 AI 化转型，最大的瓶颈往往不是技术，而是**没有人把“最懂业务的真实场景”翻译成“可以验证、可以交给技术去实现的方案”**。本训练营教业务主管用 Claude 等 Coding Agent，把部门真实业务痛点做成可运行的系统原型，学会判断哪些场景该融入 AI、用什么范式融入，并最终把“原型包 + 证据 + 决策说明”完整交付给 IT 部门。

> 说明：本仓库为**公开课程资源仓库**，不接收学员/企业的内部原型与作业提交；内部培训成果请保留在各自独立的项目仓库中。

---

## 目录

- [为什么会有这门课](#为什么会有这门课)
- [适合谁](#适合谁)
- [学完你将获得什么](#学完你将获得什么)
- [十课概览](#十课概览)
- [课程资源与重要文档](#课程资源与重要文档)
- [仓库结构](#仓库结构)
- [项目技术基座](#项目技术基座)
- [环境要求](#环境要求)
- [快速开始](#快速开始)
- [安全与合规红线](#安全与合规红线)
- [如何参与](#如何参与)
- [许可](#许可)

---

## 为什么会有这门课

很多企业引入 AI 时都卡在同一个地方：

- 技术团队不了解业务，业务团队无法把需求说清；
- 一上来就追求“全自动 / 大模型 Agent”，把规则能解决的事也交给 AI；
- 做出来的东西无法验证、无法交接，最终变成“PPT 上的 AI”。

本课程把答案收敛为一条主线：**业务主管 = 最懂业务的人**，由主管自己驱动 AI Agent 制作**低风险、可验证、可人工接管**的业务原型，在原型上验证“AI 到底能带来什么”，再带着证据和决策交给 IT 判断是否工程化落地。

核心信条：

1. **先定义，再实施**：把模糊业务说成可执行契约，而不是让 AI 猜。
2. **最简单足够**：能用规则不用 AI，能用 Workflow 不用 Agent。
3. **人在回路**：主管在关键节点批准、纠正、接管或停止，AI 不替人做业务决策。
4. **原型不等于生产**：Mock 数据、模拟行为，交付的是“决策依据”，不是可上线系统。

## 适合谁

- 企业内**最懂业务的业务主管 / 部门负责人 / 业务专家**（不要求会写代码）；
- 希望用 AI 改造部门工作流、参与企业 AI 化转型的职能负责人；
- 关注“如何让 AI 真正落地到业务”的企业管理者与技术决策者；
- 培训师 / 课程开发者可基于本仓库材料组织内部训练营。

## 学完你将获得什么

完成十课学习与作业后，你将能够：

1. **用 Claude 等 Coding Agent 制作与业务痛点直接相关的系统原型**（数据看板、流程工具、业务系统雏形）；
2. **判断在哪些业务场景融入 AI、以什么程度融入**（不用 AI / AI 辅助 / 固定 Workflow / 受控 Agent），并写出理由；
3. **为原型建立可验证的证据链**（页面行为、日志、工程检查），而不是“我觉得能跑”；
4. **形成可交付的“开发启动包”**：已确认事实、证据、缺口、产品决策与下一步，交给 IT 做判断与工程化落地；
5. 掌握与 AI 协作的工程护栏：契约冻结、增量切片、有界排错、独立评审、Mock 数据红线。

## 十课概览

| 课次 | 主题 | 核心成果 |
| --- | --- | --- |
| L1 | 从业务问题创建第一个系统页面 | 理解 LLM / Tools / Agent，做出第一个受控原型页面 |
| L2 | 让原型变得清楚、可信、能用 | 用参考图与设计规则，做出像样的企业级页面 |
| L3 | 把模糊业务说成可执行契约 | 用结构化追问冻结业务契约与数据契约 |
| L4 | 把契约切成一个可实施的薄片 | 受控 Agent 循环 + 物理状态机，增量落地 |
| L5 | 第一次把 AI/Agent 融入业务 | 逐环节判断 AI 介入层级，选出智能机会候选 |
| L6 | 用事实找 Bug，在边界内修复 | 五层诊断 + 有界排错 |
| L7 | 让 Agent 操作页面并留下验收证据 | 浏览器自动化验收 + 五环证据链 |
| L8 | Claude 执行，Codex 独立评审，主管裁决 | 上下文隔离独立评审 + accept/fix/stop/defer 处置 |
| L9 | 画出部门 AI 机会与 Agent 范式选型图 | 从单个候选扩展到部门级 AI 机会地图 |
| L10 | 冻结原型包，形成产品决策与开发启动包 | 盘点资产、产品决策、向 IT 交付启动包 |

每课配套：**学员指南（概念 + 实操）+ 交互式课程页面（演示/测验/退场自测）+ 教师教案**。

## 课程资源与重要文档

| 文档 | 说明 |
| --- | --- |
| [课程路线图](lessons/COURSE_ROADMAP.md) | 十课定位、能力矩阵、每课任务与交付要求 |
| [十课冻结基线](lessons/TEN_LESSON_FROZEN_BASELINE.md) | 十课内容冻结标准（概念、任务、证据、不做项） |
| [各课学员指南](lessons/) | `LESSON_01_GUIDE.md` ~ `LESSON_10_GUIDE.md`，概念 + 实操一体 |
| [交互式课程页面](lessons/html/) | 十课 HTML 演示页（含测验与退场自测）+ 路线图/术语 HTML |
| [术语表](GLOSSARY.md) | 课程统一术语与定义 |
| [设计规范](DESIGN.md) | 原型页面与通用组件的设计执行规范 |
| [AI 工程治理守则](CLAUDE.md) | 与 AI 协作的护栏、验证与提交规范 |

## 仓库结构

```text
ai-business-prototype-bootcamp/
├── lessons/                  # 课程主体
│   ├── COURSE_ROADMAP.md  # 十课路线图
│   ├── TEN_LESSON_FROZEN_BASELINE.md
│   ├── LESSON_XX_GUIDE.md        # 十课学员指南
│   ├── LESSON_XX_TEACHER_PLAN.md # 十课教师教案
│   └── html/                 # 交互式课程页面（10 课 + 路线图 + 术语）
├── src/                      # “试衣镜”原型工程（Vue 3 应用基座）
│   ├── pages/ components/ layouts/
│   ├── mocks/                # 全部 Mock 数据
│   └── router/ main.ts ...
├── references/               # 只读参考材料（原组件/配置/样式基线）
├── course-fixtures/          # 课程演示用故障/降级样例
├── scripts/                  # 学员包导出等课程工具
├── student-package/templates/# 学员起点包模板
├── .agents/  .claude/        # AI 协作 Skill（grill-me、$diagnose、增量实施等）
├── index.html  package.json  vite.config.ts  tsconfig.json
├── DESIGN.md  GLOSSARY.md  CLAUDE.md  README.md  LICENSE
└── start-project.bat
```

## 项目技术基座

“试衣镜”原型工程是一个开箱即用的企业后台原型基座，课程中所有原型都构建在它之上：

- **Vue 3 + TypeScript**：组合式 API + 类型安全
- **Element Plus**：企业级组件库
- **Vite**：开发服务器与构建（默认 `127.0.0.1:8888`）
- **Pinia + Vue Router**：状态与路由
- **ECharts**：数据可视化（看板、图表）
- **Tailwind CSS**：原子化样式
- 内置通用业务组件：`KpiCard`、`FilterPanel`、`DataTable`、`StatusTag` 等

## 环境要求

| 依赖 | 要求 | 说明 |
| --- | --- | --- |
| Node.js | >= 20.19.0 | 运行原型工程 |
| npm | 随 Node.js | 安装依赖 |
| 现代浏览器 | Chrome / Edge | 打开“试衣镜” |
| Claude Code（推荐） | 最新版 | 课程实操中的 Coding Agent（其它兼容 Agent 亦可） |
| MCP / Playwright（可选） | 第 7 课浏览器验收 | 安装 `@playwright/mcp` 等用于浏览器自动化取证 |

> 全程使用 **Mock / 虚构数据**，无需任何真实 API Key、模型 API Key 或数据库配置。

## 快速开始

```powershell
# 1) 安装依赖
npm install

# 2) 启动开发服务器（自动打开 http://127.0.0.1:8888）
npm run dev

# 或直接双击 start-project.bat
```

其它命令：

```powershell
npm run typecheck   # TypeScript 类型检查
npm run build       # 类型检查 + 生产构建
npm run preview     # 预览构建产物
```

## 脚本工具（教师 / 维护者）

仓库提供 3 个 PowerShell 脚本，用于生成与校验教学分发包：

| 脚本 | 作用 | 主要参数 |
| --- | --- | --- |
| `scripts/export-student-package.ps1` | **生成学生包（十课全量）**：从指定 Git 提交（默认 `HEAD`）按白名单打包运行文件 + 学员模板 + 十课指南 + 交互课件（12 份 HTML）+ 教学 Skill + 学员版路线图，自动生成 `VERSION.txt` / `PACKAGE_MANIFEST.txt` / `SHA256SUMS.txt`，通过安全校验后压缩为 ZIP 与 SHA256。**未提交的改动不会进包**。 | `-CourseState`（如 `lesson-01-start`）、`-Version`（如 `v0.1.0`）、`-SourceRef`、`-OutputDirectory`、`-PackageProfile` |
| `scripts/export-teacher-package.ps1` | **生成教师课堂交付包**：从指定 Git 提交（默认 `HEAD`）打包 10 份教案 + 10 份指南 + 交互课件 + 课程路线图 + 课程夹具（fixtures）+ 教学 Skill + 原型基座，自动生成 `VERSION.txt` / `PACKAGE_MANIFEST.txt` / `SHA256SUMS.txt` 后压缩为 ZIP 与 SHA256。**未提交的改动不会进包**。 | `-Version`（如 `v0.1.0`）、`-SourceRef`、`-OutputDirectory` |
| `student-package/templates/scripts/verify-student-project.ps1` | **学生包校验**：在学员工程内检查必需文件、禁用教师专属路径、`npm run typecheck`、`npm run build` 与环境/凭据文件扫描。 | 无（在工程根目录运行） |

> 教师/维护者专属：学生包从 Git 提交快照导出，**未提交的改动不会进入分发包**；正式分发前请先提交对应内容。

## 安全与合规红线

- **全程 Mock**：所有示例与练习数据均为虚构模拟数据，禁止真实客户、员工、经营数据；
- **禁止提交**：`.env`、Token、密码、密钥、数据库连接、生产接口地址、内部账号；
- **`references/` 只读**：参考材料不修改、不删除；
- **原型 ≠ 生产系统**：原型用于验证路径与支撑决策，上线还需安全、数据、测试、运维等门禁。

## 如何参与

本仓库以公开课程资源形式维护，欢迎通过 Issue / PR 参与：

1. 先阅读 [CLAUDE.md](CLAUDE.md) 工程治理守则与 [DESIGN.md](DESIGN.md) 设计规范；
2. 修改前运行 `npm run typecheck` 与 `npm run build`；
3. 提交时明确说明修改目标、教学影响与验证结果；
4. **不要提交真实业务数据、内部原型或任何敏感信息**。

## 致谢

本仓库的教学 Skill 与课程制作 Skill 部分来源或改编自以下开源项目，特此致谢：

| Skill | 来源 | 许可 |
| --- | --- | --- |
| `grill-me`、`diagnose`（$diagnose）、`incremental-implementation`（教学） | [mattpocock/skills](https://github.com/mattpocock/skills) | MIT |
| `teach`（课程制作） | [mattpocock/skills](https://github.com/mattpocock/skills) | MIT |
| `alterlab-teaching-design`（课程制作，原样收录） | [AlterLab-IEU/AlterLab-Academic-Skills](https://github.com/AlterLab-IEU/AlterLab-Academic-Skills) | MIT |
| `curriculum-knowledge-architecture-designer`（课程制作，原样收录） | [GarethManning/education-agent-skills](https://github.com/GarethManning/education-agent-skills) | CC BY-SA 4.0 |
| `find-skills`（课程制作） | [vercel-labs/skills](https://github.com/vercel-labs/skills) | MIT |
| `teaching-lesson-plan`（课程制作，已改造） | [mohitagw15856/pm-claude-skills](https://github.com/mohitagw15856/pm-claude-skills) | MIT |

各 Skill 文件内亦保留来源与版权标注。`teacher-plan-architect` 与 `qa-tester` 为本仓库原创。

> 注：`curriculum-knowledge-architecture-designer` 的上游为 **CC BY-SA 4.0**（与本仓库 MIT 不同），属原样收录并按上游许可再分发；后续若对其改编并公开，需同样以 CC BY-SA 4.0 发布。


## 许可

本仓库采用**分层许可**：

- **代码 / 工程基座**（`src/`、`package.json`、`vite.config.ts` 等）：[MIT License](LICENSE)。
- **课程与教学材料**（`lessons/`、`README`、`GLOSSARY.md`、`DESIGN.md`、`lessons/html/`、`course-fixtures/` 教学材料等）：[CC BY-NC-ND 4.0](LICENSE-COURSE-CC-BY-NC-ND.md) —— 可看、可学、可署名分享；**禁止商业使用**，**不得公开分发修改版**。
- **例外**：`.agents/skills/curriculum-knowledge-architecture-designer/` 按上游 [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/) 授权（见该目录 `NOTICE.md`）。

说明：早期版本（v1.0.0 及更早）按当时发布的 MIT License 提供；分层许可适用于后续版本与新增内容。应用到真实业务场景前，请确保遵守所在企业的数据合规要求。
