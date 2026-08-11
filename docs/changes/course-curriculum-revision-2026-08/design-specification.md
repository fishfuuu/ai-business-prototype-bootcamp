# 课程知识架构与课程级设计规格 — course-curriculum-revision-2026-08

Status: DRAFT

## Delta Summary Card — S1D/S1E Formal Design Review Findings Closure

| Delta | S1D/S1E scope | Gate impact |
|---|---|---|
| **ADDED** | User-approved A02 scope amendment; root `CLAUDE.md` and `.claude/skills/teacher-plan-architect/SKILL.md` compatibility entry; root-CLAUDE and shim negative/conformance obligations; pre-Gate-A `acceptance-rubric.md` embedded RED test plan chapter preparation semantics; explicit A-RUBRIC-DRAFT, A-RED-PROTOCOLS and A-ACCEPTANCE-REVIEW phases | Records the boundary and phase separation without entering Gate A, `DESIGN_FROZEN`, `TESTS_RED`, `ACCEPTANCE_FROZEN`, or implementation |
| **MODIFIED** | Correct the test lifecycle order; expand current candidate from 5 to 7 production files while retaining exactly 6 protocols/0 reports; distinguish protocol semantics from external run evidence; correct Phase 1 `ACCEPTED` handoff to future independent changes; split rubric drafting, RED protocol execution and independent acceptance review | Prevents tests from being written after the wrong gate, rubric/failure/freeze phases being merged, shim drift, stale root rules, and false programme completion |
| **REMOVED** | No user-confirmed course decision is removed. The prior five-file Phase 1 candidate is replaced by the user-approved seven-file boundary; student-package CLAUDE, lesson files, derived assets, and scripts remain outside this active change | Keeps the programme goal intact while limiting A02 to mother-repository/Claude compatibility governance |
| **CLARIFIED** | Root `CLAUDE.md` is maintainer/Agent policy, not learner course正文; `student-package/templates/CLAUDE.md` is the learner export and is untouched; canonical TPA v2 remains under `.agents`; `.claude` is a minimal fail-closed shim; S1D allowed design/UIC/task-board writes are historical, while S1E allows only design-specification and task-board writes | Makes authority, compatibility, phase ownership and fail-closed behavior auditable without claiming runtime repair |

**Change scope:** S1D established the A02 boundary and lifecycle design; S1E changes only this design specification and the coordination task board to separate A-RUBRIC-DRAFT, A-RED-PROTOCOLS and A-ACCEPTANCE-REVIEW. S1E does not create Briefs, Skill/reference entities, test entities, reports, acceptance rubric, production files, UIC amendments or lifecycle records. The current Gate A candidate is the single seven-production/six-test/zero-report Phase 1 boundary defined exactly in J6; the full ten-lesson programme remains a later sequence of independently controlled changes.

## A. 文档头与权威边界

| 字段 | 值 |
|---|---|
| Project | `ailearning` |
| Change ID | `course-curriculum-revision-2026-08` |
| Risk / lifecycle | `L2` / `DRAFT` |
| Base commit | `25c6f3d9214e29378f4945f51a977dc06603c8e4` |
| User Intent Contract | `docs/changes/course-curriculum-revision-2026-08/user-intent-contract.md` (v1.3, A01/A02 appended) |
| Lifecycle state of record | `.agent-workflow/changes/course-curriculum-revision-2026-08/delivery-state.json` |
| Document purpose | 课程级知识架构、能力链、教学运行与后续分片的 DRAFT 设计依据 |

本规格服从 UIC D01–D20 及 append-only amendments A01/A02、仓库事实和全局 L2 工作流。它不是 Gate A，不是 `DESIGN_FROZEN`，不是 `TESTS_RED`，不是 `ACCEPTANCE_FROZEN`，也不是课程正文、测试或生产实施授权。本文中的验收证据、production boundary 和后续 Slice 均为待独立评审的设计候选；只有后续门禁按规范批准后才可实施。A01/A02 只拆分 active-change delivery scope，不缩小十课 programme goal。

当前未提交的 `docs/COURSE_ROADMAP.md` 处置仍为 `PRESERVE_UNREVIEWED_DRAFT`：保留、不接受、不拒绝、不继续编辑。本规格把它当作待审事实输入，绝不因引用其中内容而认可其“Official/唯一权威执行版”等自我声明。

### A1. 本次设计输入与排除项

设计输入包括：UIC、HEAD 与当前未提交路线图候选 Diff、L1–L10 主版教师教案与学员指南、项目规则与术语文件、课程模板、历史设计对齐材料、V2/V3 只读对照、`package.json` 与 `scripts/` 实体。V2/V3 和未提交路线图只是历史/候选证据，不是本次设计 authority。

本规格不修改课程正文，不发明 D01–D20 之外的新课程范围，不决定真实业务责任，也不把文档中的绝对化声称当成已实现能力。`docs/PROJECT_STATE.md` 是学员个人原型的跨课连续性模板，不是本变更的 lifecycle authority。

## B. 当前事实审计

下表区分“材料声称”和“仓库可验证事实”。设计处置仅定义后续方向，不在 S1D 实施。

| 面向 | 当前声称 | 仓库事实 | 冲突 | DRAFT 设计处置 |
|---|---|---|---|---|
| 课程路线图 | 候选稿自称 Official/唯一权威，并同时写“IT 直接落地”和非生产就绪 | 候选稿是未提交工作树 Diff，尚未评审；生命周期仍为 `DRAFT` | 文档自我声明越过门禁；“直接落地”与非生产就绪相冲突 | 后续只在获批的路线图 Slice 中改为“产品决策与开发启动包”，并保留未完成的架构、安全、集成、测试和生产审批 |
| 十课教师教案 | 每课均为 90 分钟、10–30 人、固定五个 Pause Points，并常要求 `verify-project.ps1` PASS | UIC 班型为 10–15 人、1 教师+1 助教；现有“授课模式”合计 83 分钟而时间轴为 90 分钟；没有逐任务试讲数据 | 班型、助教运行、时间证据和验证口径均未对齐 | 90 分钟作为上限与初始预算；逐课试讲校准；不把固定 Pause Point 数或统一模板当业务真理 |
| 十课学员指南 | 多处要求 CLI、手工 Git、MCP 挂载、自动验证/恢复，且把文本规则称为“物理”控制 | 学员默认无终端/Git/MCP 基础；相关自动能力并不普遍存在 | 学员负担和控制强度被夸大 | 普通学员只执行业务判断和教师预配置入口中的安全动作；工程操作移到教师/助教轨或工程背景层 |
| npm 命令 | 路线图把 `npm run verify` 与验证脚本并列，历史材料还声称 doctor/test:ui | `package.json` 只有 `dev`、`build`、`typecheck`、`preview`；不存在 npm `verify`、`doctor` 或 `test:ui` | 不存在能力被写成课堂条件 | 在能力真实实现并单独验证前，正文不得引用这些命令作为通过条件 |
| 学员验证脚本 | 路线图引用母仓库 `scripts/verify-student-project.ps1` | 母仓库该路径不存在；同名实体只存在于 `student-package/templates/scripts/`，导出后才可能进入学员包 | “模板存在”被外推为“母仓库/十课能力存在” | 精确描述资产所在层；不得用导出模板证明十课统一验证能力 |
| `AGENTS.md` | 路线图把它作为仓库实体与独立审查链接 | 根目录及跟踪文件中不存在实体 `AGENTS.md`；会话层系统指令不是仓库文件 | 链接断裂，审查契约不可由该文件证明 | L8 使用外部独立评审工作流或隔离新会话；是否新增仓库文件必须另立 Slice |
| 根 `CLAUDE.md` / `verify-project.ps1` | 根规则要求任何变更运行 `verify-project.ps1`，并把 typecheck/build 100% 作为完成证明；同时包含旧班型、Pause 和治理措辞 | 根 `CLAUDE.md` 是母仓库 Agent/维护者规则；`verify-project.ps1` 确实存在，但含旧路线图/L1–L4 字符串契约、固定文件清单、参考 hash、typecheck 和生产 build；会写 `dist`。真正学员版是 `student-package/templates/CLAUDE.md`，本 Phase 1 不改 | 母仓库维护规则、课程 authority 和学员版边界混在一起；脚本不能证明 MCP、课堂业务验收或不存在的自动化 | Phase 1 候选只把根 `CLAUDE.md` 对齐为维护者规则：班型/时长/Pause/教案结构引用 locked/frozen/approved authority，不硬编码旧默认；verify-project 定位为遗留维护检查，不作课程通过证明；脚本治理留 future change；保留真实安全/依赖/Git/学员包隔离边界，文字规则不冒充 runtime hard control |
| `.claude/skills/teacher-plan-architect/SKILL.md` | Claude 兼容入口提供完整 TPA 文本，并重复固定 Pause、Git、verify、100% 等旧规则 | 文件实体存在，当前内容与 `.agents/skills/teacher-plan-architect/SKILL.md` 重复并带旧契约 | 两份 Skill 可能漂移并形成第二 authority | Phase 1 候选把 `.agents/skills/teacher-plan-architect/SKILL.md` 保留为唯一 canonical v2；`.claude` 只保留合法 frontmatter/触发描述并指向 canonical exact path；不复制八模块细则、Brief schema、版本、项目默认或审批逻辑；canonical 缺失/不可解析/校验失败时 fail-closed |
| 自动恢复 | GLOSSARY、L5/L6 与候选矩阵出现“一键恢复”“自动 `git restore`” | `scripts/` 无课程 Checkpoint 自动恢复实现；现有局部安装 rollback 或测试临时文件清理不等价 | 人工恢复、局部回滚和运行时恢复被混称 | 当前只承诺有界停止、范围确认与教师/助教恢复；自动化须实现、测试、评审后才能命名 |
| L7/L8 证据 | 材料声称四类证据与独立审计报告可自动生成并已有效 | 当前 `docs/LESSON_07_EVIDENCE_INDEX.md` 与 `docs/LESSON_08_AUDIT_REPORT.md` 是 placeholder | 文件存在不等于证据成立 | 后续用可追溯的观察记录与独立会话产物；placeholder 不得计入验收 |
| L10 打包 | `package-it-handover.ps1` 被描述为含完整源码、完整证据、可无缝接入的一键交付 | 脚本只打包六项，不含完整 `src`；缺项时会创建 placeholder；会写 Quickstart、ZIP 并覆盖旧 ZIP | 打包成功不等于材料完整、审查 PASS 或生产就绪 | 最后独立治理打包脚本；缺关键材料应失败而非伪造 placeholder；交付定位为开发启动草案 |
| 学生包 | 课程材料易形成十课均有统一导出/验证链的印象 | 当前导出覆盖主要是通用/L1、L2 fallback、另一路 L2–L4 overlay；L4 有专用 verifier，L3–L10 没有统一完整链 | 局部资产被外推到全课程 | 教师教案批准后逐课推进指南与派生学生包，不能批量假定同步 |
| `PROJECT_STATE.md` | 文件名可能被误读为项目交付状态 | 文首与内容表明它是学员原型系统、范围、字段、轨迹的连续性模板，且被导出到学生包 | 与生命周期 state of record 名称近似 | 保留为教学连续性载体；生命周期只读 per-change delivery state |
| 控制层 | `CLAUDE.md`、红线与课程材料把规则、Hook 名、Git 口令称为物理硬控制 | 多个 Hook 只出现在文本/注释中，未找到运行时拦截实现；Git 不理解业务审批 | 指导、门禁、运行时控制混称 | 按 H 节三层模型分开；只有有执行代码和失败证据的约束才可称 runtime hard control |
| 历史资料 | V2/V3、设计对齐审计与完成报告可能被误当当前权威 | V2/V3 是历史版本；`DESIGN_ALIGNMENT_*` 是历史视觉对齐记录且不在学生包安全范围内 | 历史完成报告与当前 L2 状态可能冲突 | 只读取可复用结构与反例；不删除、不合并、不批量同步，不作为 lifecycle 证据 |

### B1. 脚本存在性不等于当前可运行性

`scripts/run-l2b-isolation-tests.cjs`、`run-l2c-isolation-tests.cjs`、`run-l4-verifier-isolation-tests.cjs` 等会创建临时产物、工作树或改写测试对象；文件名中的 “isolation” 不能替代逐条副作用审查。本 S1A 未运行这些脚本，也未运行会写 `dist` 的 `verify-project.ps1`。

## C. Knowledge Architecture Analysis

### C1. 输入画像

- **Input type:** `course / scope-and-sequence`。
- **Domain:** 业务主管的 AI Agent 原型、证据判断、风险治理与 IT 交接。
- **Learner stage:** 在职业务主管；业务经验强，代码、Git、MCP、终端基础默认低。
- **Course form:** 十课、五周，每周两课，10–15 人，1 教师+1 助教，单课不超过 90 分钟。

### C2. 学习目标

1. 学员能把本部门的模糊业务问题收敛成有边界、可验收、使用 Mock 或已脱敏数据的原型任务。
2. 学员能沿十课累计构建部门原型，并在控制流、证据链、失败降级和独立审查中判断“继续、停止、升级或拒绝”。
3. 学员能区分开发工具链、产品业务 API 链和模型 API 链，并能解释 MCP 在工具接入中的位置与非位置。
4. 学员能以证据和风险为基础完成主管确权，输出非生产就绪的产品决策与开发启动包，让 IT 开始正式设计与开发而非直接上线。

### C3. 三类知识结构与近似比例

以下比例是基于课程任务和依赖关系的解释性估计，不是精确测量；合计为 100%。

| 知识结构 | 近似比例 | 判断依据 | 设计影响 |
|---|---:|---|---|
| Hierarchical（层级/前置） | 40% | 原型、契约、切片、诊断、证据、审查、边界与交接形成明显产物依赖链；安全前置不可后补 | 显式标记 hard/soft prerequisite，不以课号相邻关系冒充硬依赖 |
| Horizontal（横向/透镜） | 30% | 同一原型要反复从业务价值、协作拓扑、证据可靠性、数据风险和交接完整性观察 | 每课使用共同 conceptual hubs，但更换问题和证据透镜，避免十课碎片化 |
| Dispositional（倾向/判断） | 30% | 主管价值主要体现在定义问题、授权/停止、裁决证据、承担边界，而非记忆工程术语 | 以可观察决策行为评价；AI 不自动评分真实业务判断或风险责任 |

### C4. Hierarchical：硬/软前置链

硬链指缺少前一产物就无法安全或真实完成后一任务；软链只提高质量，不阻断进入。

```text
运营预检 + Mock/无密钥边界
  → L1 可运行的受控原型与业务问题
  → L3 业务边界 + 数据契约 + 验收/停止条件
  → L4 一个可见薄切片与稳定候选
  → L7 浏览器验收证据
  → L8 上下文隔离的独立审查与主管处置
  → L10 产品决策与开发启动包

L3 契约 + L4 稳定候选
  → L6 事实化诊断
  --（L7/L8 失败路径的 soft support）→ L7 / L8
```

```text
L1 Agent/Tool/ReAct 的最小体验
  → L4 计划—执行薄切片体验
  → L5 控制流、约束层与记忆的系统串联
  → L6 有界反思与停止升级
```

```text
L3 数据契约
  → L7 MCP 最小模型与证据入口
  → L9 开发工具链 / 业务 API / 模型 API 三链
  → L10 交接边界
```

主要软链为：L2 视觉基线帮助 L3/L4 表达但不是业务契约的硬前置；L5 Harness 认知帮助 L6 但不替代 L3 契约与 L4 稳定候选；L6 诊断是 L7 失败路径的重要回退，不是进入浏览器验收的必备输入；L8 审查提高 L9 边界判断质量，但 L9 的硬前置主要是 L3 数据契约和 L7 MCP 模型。

### C5. Horizontal：conceptual hubs 与 lenses

| Conceptual hub | 每课反复追问的 lens | 从初级到成熟的变化 |
|---|---|---|
| 业务问题与决策价值 | 谁遇到什么异常、要作什么决定、什么不做 | 从“想做一个页面”到有 owner、范围、停止条件和交接价值 |
| 协作拓扑与控制权 | 谁分派、谁执行、谁汇总、谁独立审、谁最终负责 | 从单 Agent 指令到按业务信号选择模式，不把多 Agent 当炫技 |
| 证据与可靠性 | 什么事实能证明行为、失败如何显现、证据是否独立 | 从肉眼可见结果到多源证据、隔离审查与可追溯处置 |
| 数据、权限与风险 | 哪些数据可进入 AI、谁授权、何时拒绝或停止 | 从 Mock/no-key 前置到三链、红线和责任归属 |
| 连续原型与交接 | 本课产物如何成为下课输入、IT 还缺什么 | 从一个部门原型到非生产开发启动包，显式列出未完成工程工作 |

### C6. Dispositional：可观察行为进阶

| 水平 | 主管定义问题 | 授权 / 停止 | 证据裁决 | 边界意识 |
|---|---|---|---|---|
| Emerging | 描述痛点但范围、owner、成功条件含混 | 倾向让 Agent “先做完再看” | 以页面看起来合理或 AI 自述为通过 | 能说“敏感数据要小心”，但不能指出进入 AI 前动作 |
| Developing | 能写出用户、触发、结果与基本非目标 | 能设置一个确认点或重试次数 | 能要求截图、日志或可见状态之一，并指出缺证据 | 能使用 Mock、标记敏感字段，知道密钥不能给学员 |
| Competent | 能建立业务边界、数据契约、GWT 与 stop/escalation | 能区分可委派动作、高风险动作和必须人工处置的决定 | 能交叉检查行为、工程、范围证据，并对独立审查 finding 作处置 | 能事前脱敏、区分三链、说明教师真实调用为何必须仓库外 |
| Extending | 能比较多个部门场景的边界和可复用契约 | 能按风险与协作信号选择调度/流水线/审查，并为例外设升级路径 | 能识别证据盲区、假阳性和上下文污染，主动要求补证 | 能把指导规则、workflow gate、runtime control 分层，并为 IT 列出生产化缺口 |

这些倾向必须落在具体业务情境和已有知识上，不能脱离课程产物单独打人格分。真实业务责任、风险接受和主管判断只能由人类教师/业务 owner 评议，不能交给 AI 自动定分。

### C7. Mixed architecture tensions

1. **先体验与安全前置的张力：** ReAct、证据链等可先体验后命名；数据、权限、密钥和停止条件必须在对应实操前讲清。
2. **累计原型与统一案例的张力：** 教师统一工作台保证全班共同语言，学员个人原型保证迁移；两轨必须用同一能力标准但不共享真实数据。
3. **工程真实性与零基础可进入的张力：** 学员需要理解工程交接价值，但不能把 CLI、Git、MCP 配置和框架术语变成通关门槛。
4. **自动证据与主管责任的张力：** 自动检查可确认结构、格式或确定性行为；它不能替代业务正确性、授权、风险和生产决策。
5. **固定十课与真实时间的张力：** 保留课序和 90 分钟上限，但通过删减工程背景、预配置环境与试讲数据校准，而不是虚构精确完成时间。

### C8. 教学顺序、评价与 AI 辅导边界

- **教学顺序：** 最小实操 → 3–5 分钟概念抽象 → 新业务场景迁移；L5 只串联 L1–L4 已有体验，L6 才把完整有界 Reflection 变成可观察能力。
- **自动可核对：** 文件/字段是否存在、Mock 标记、场景结构、确定性计算、链接或命令实体、证据索引完整性；只有真实检查能力存在时才使用。
- **教师核对：** 业务边界、风险归属、停止/授权是否合理、证据是否足够、交接缺口是否诚实。
- **混合核对：** AI 可提示缺字段、冲突或证据缺口；学员说明理由，教师/业务 owner 作最终处置。
- **AI 辅导可以做：** 追问模糊需求、起草 Mock、解释术语、对照契约、指出候选证据缺口、提供低风险练习反馈。
- **AI 辅导不得做：** 自动批准真实数据、自动接受高风险动作、代替独立审查、给真实主管业务判断自动打分、宣称生产就绪。

### C9. Skill compatibility / design constraints

本规格完整应用 `curriculum-knowledge-architecture-designer` 的三类结构、前置链、比例、进阶行为、评价与 AI 辅导边界。Backward Design、Constructive Alignment、Bloom ABCD、WHERETO、八模块教师教案和双轨学员指南可作为后续单课设计的候选框架，但其适用性必须逐 Slice 由 UIC、仓库事实和本规格裁剪。

`curriculum-knowledge-architecture-designer` 是分析方法，不是课程权威来源。后续同类内容冲突的裁决顺序为：**locked UIC → frozen design specification → approved roadmap → direction-specific approved source object → Skill defaults**；`DESIGN_FROZEN` 只是验证相关材料已经冻结的 lifecycle gate，不是一个内容文档。direction-specific source 由 M 节规定，不能用宽泛的“approved lesson artifacts”代替。仓库事实对所有“已实现/可运行”声称具有否证约束。当前仍未冻结，因此本 DRAFT 不能替代未来 frozen design specification。

当前 `teacher-plan-architect`、`teaching-lesson-plan` 与根 `CLAUDE.md` 中的固定三类图、PASS 双提交/FAIL patch 清扫、学员手工 `git commit`/`git restore`、每课 `verify-project.ps1` PASS、Working Tree 100% Clean、固定五个 Pause Points、100% alignment，以及“物理本质/物理区分”等要求，不是本 change 的硬约束，也不得传播为后续课程事实。两个 Skill 的 Stage A 方向、根维护规则和 `.claude` 兼容入口只按 J 节“有条件采纳”；本 S1D 不修改 Skill 或根规则文件，也不授权 Stage B。

### C10. 分析方法限制与倾向能力前置

三类型框架是课程设计工具和有意简化的模型，不声称穷尽所有知识形态。本次诊断基于仓库中 **stated curriculum** 与用户确认的设计目标；它不能证明课堂实际执行的 **enacted curriculum**，更不能代替试讲、课堂观察或学习效果证据。

| 倾向能力 | 必要 hierarchical 前置 | 必要 horizontal lenses | 前置不足时的风险 |
|---|---|---|---|
| 定义问题 | 业务问题边界、数据契约、验收/停止场景 | 业务价值、连续原型与交接 | 只会复述模板字段，不能判断范围和非目标 |
| 授权 / 停止 | 工具权限、stop/escalation、有界排错、三层控制 | 数据/权限风险、协作拓扑与控制权 | 把 AI 建议或 Git 记录误当授权，或无限重试 |
| 证据裁决 | 验收场景、事实诊断、证据链、独立审查 | 证据可靠性、业务问题 lens | 以“看起来正确”或工具 PASS 标题替代真实证据 |
| 边界意识 | Mock/事前脱敏、MCP 最小模型、三链、风险红线 | 数据风险、交接完整性 | 会背禁令但不能判断数据流、凭证责任和生产缺口 |

Emerging→Extending 是情境敏感、可能来回波动的观察带，不是线性人格等级。同一主管可能在熟悉业务上 Competent、在新技术链路上 Developing；只有前置知识与情境证据充足时，才可判断倾向能力发展。

AI 辅导建议也不假设现成系统具备自动跨 knowledge type 的 mode switching。每个辅导活动必须显式说明当前是在补前置概念、换横向 lens，还是练习主管处置；涉及真实责任时转交人类教师/业务 owner。

## D. 十课能力与依赖架构

### D1. 课序判断

保留 L1–L10 主顺序，但不接受“上一课天然是下一课硬前置”的现有元数据。课程的真实累计链是：L1 建立安全原型体验，L3 形成契约，L4 形成薄切片，L6/L7 分别建立诊断与证据，L8 完成独立审查，L9 澄清技术链路，L10 交接。L2 是视觉判断与版本证据的横向层，L5 是 L1–L4 的系统串联层；两者重要，但不能被写成所有后课的硬门槛。

### D2. 知识与前置表

| 课次 | 课程角色 / 能力增量 | Hard prerequisite | Soft prerequisite | 必须掌握（2–3） | 需要识别 | 工程背景术语 | 首次出现 → 再次迁移 → 系统串联 |
|---|---|---|---|---|---|---|---|
| L1 | 从业务问题进入受控 Agent 原型；完成首个安全、可见的 Mock 闭环 | 课前环境预检通过；Mock/no-key/事前脱敏规则已讲 | 无课程内容前置 | 受控 Agent 原型；工具与权限边界；Mock 数据边界 | **只体验不命名：** 模型提出下一步、工具执行、人工确认；业务问题边界雏形 | Vue、Vite、CLI、文件路径 | Agent/Tool/Mock 首次体验；业务问题边界只做形成性体验 → L3 正式契约化、L4 切片化 → L5 控制串联、L10 责任串联 |
| L2 | 把“好不好看”变成可说明的视觉判断与版本证据 | L1 有可运行、可观察页面 | 学员能描述本部门视觉/信息优先级 | 视觉证据基线；设计约束映射；版本节点 | 多模态分析、Context、Design Token、Diff | CSS、Git object/commit、截图工具 | 视觉证据/版本首次命名 → L4 候选版本、L7 证据 → L10 交接可追溯性 |
| L3 | 把模糊需求冻结成业务、数据和验收边界 | L1 的业务场景与 Mock 原型 | L2 的视觉证据帮助表达但非必需 | 业务问题边界；数据契约；验收场景 | 敏感度分级、字段追溯关系、既有停止/升级政策的应用 | TypeScript interface、Schema、Markdown 表 | 契约/事前脱敏首次正式化 → L4 实施、L6 诊断、L7 验收、L9 三链 → L10 交接 |
| L4 | 把批准的契约变成一个可见、可验证的最小变化 | L3 契约；L1 可运行原型 | L2 版本节点 | 薄切片；技术状态与业务状态分离；两阶段版本证据 | Plan-and-Execute、Working Tree、Verifier、discard/rollback 区别 | Git staging/commit、组件 state、测试层 | 薄切片/状态分离首次 → L5 控制串联、L6 故障、L7 验收 → L10 产物追溯 |
| L5 | 把 L1–L4 的局部体验串成控制流、约束层和来源图 | L1 的“循环/计划/确认”体验、L3 契约、L4 计划与薄切片 | L2 Context/版本认知 | 控制流选择；指导/门禁/运行时三层；source of truth | 只用口语比较循环、计划、复核；工作/情节/长期记忆是教师背景，不要求同时命名 ReAct/Plan-and-Execute/Reflection | `CLAUDE.md`、会话压缩、状态文件 | L1/L4 体验在此做一次决策框架比较；Reflection 只预告 → L6 完整实践 → L10 治理总结 |
| L6 | 用事实而非猜测诊断失败，并在预算内停止或升级 | L3 契约与停止条件；L4 稳定候选 | L5 控制/记忆图 | 事实锚定诊断；有界排错；停止与升级 | 五层诊断、日志证据、重试预算 | Console/Network、stack trace、patch、Git restore | 有界 Reflection 首次完整实践 → L7 失败路径、L8 finding 处置 → L10 风险记录 |
| L7 | 通过单一浏览器入口理解 MCP 最小模型并建立证据链 | L3 验收场景；L4 可运行候选 | L6 诊断作为失败回退 | MCP host/client/server/tool 最小模型；单一浏览器验收入口；证据链 | **教师/工程背景：** Headed/headless、DOM、Console、Network、QA subagent、JSON-RPC、Playwright、DevTools、YAML；学员不承担这些名称的独立掌握 | 同左 | MCP/证据正式首次 → L8 独立审查、L9 三链区分 → L10 交接证据 |
| L8 | 用上下文隔离的独立审查形成 finding，并由主管处置 | L7 候选证据与可审对象 | L2/L4 的版本差异认知；L6 停止升级 | 上下文隔离；独立 finding；主管 HITL 处置 | 六种模式名称全部可见但只做一张选型框架；不按六个名称逐项背诵或实现 | Agent role file、Diff、审计模板 | 独立审查/协作选型首次系统化 → L10 处置与交接；独立判断是“选模式、设边界、作处置”三项，不是拓扑名词记忆 |
| L9 | 区分确定/概率工作和三条技术链，设计可解释降级 | L3 数据契约；L7 MCP 最小模型 | L8 审查视角 | 确定性工作与概率性工作对照；开发/业务/模型三链；fallback 来源与失败显性化 | API schema、超时、结构化模型输出；fallback 作为行为，不另立概念卡 | HTTP、database、AbortController、MCP transport | 三链首次明确 → L10 交接架构边界；Mock/fallback 从 L1/L3 再迁移 |
| L10 | 汇总证据、审查、红线和未完成事项，完成主管确权与 IT 启动交接 | L3 契约、L7 证据、L8 处置、L9 三链边界 | L2 视觉/版本证据、L6 诊断记录 | 风险红线与非目标；产品决策与开发启动包；交接决策 | 生产就绪缺口、能力分级、后续工程门禁 | ZIP、README、架构/安全/测试清单 | 十课概念与证据系统串联；明确终点是开发起点而非生产终点 |

### D2a. Learner-facing concept exposure ledger

“每课 2–3 个必须掌握概念”只约束终结性核心概念数量，不允许用复合标题隐藏多个独立判断。下表把学员看到的 named label、只体验的 plain-language action、教师/工程背景和 independently assessed judgment 分开；同一课的暴露量可以高于核心考核量，超出部分必须删减、迁移或留在教师轨道。

| 课次 | Student-facing named labels（首次/复访） | Plain-language experience（不命名） | Teacher-only / engineering background | Independently assessed judgments | 暴露控制处置 |
|---|---|---|---|---|---|
| L1 | 受控 Agent 原型、工具/权限边界、Mock 数据（3 个核心） | 模型提出下一步、工具执行、主管确认；业务问题边界雏形 | LLM、ReAct、Workflow、HITL 只由教师解释或不出现名称 | 选择继续/拒绝一个动作；标记 Mock | ReAct/Workflow/HITL 不在学员侧同时正式命名；环境/CLI 由预检和助教承接 |
| L2 | 视觉证据基线、设计约束映射、版本证据（3 个核心） | 参考→规则→页面前后对比 | CSS、Git object、截图工具 | 说明一条规则落点和一个版本差异 | Token/Context 只作教师或迁移背景，不能再加第四张概念卡 |
| L3 | 业务问题边界、数据契约、验收场景（3 个新标签） | 按既有安全政策作停止/升级；不重新命名 Stop/Escalation | TypeScript interface、Schema、GWT 句式 | 业务范围、字段边界、验收结果和停止理由分别可观察 | 停止政策是 L1 安全前置的复访，不以“Acceptance & Stop”复合名偷占一个名额 |
| L4 | 薄切片、技术/业务状态、两阶段版本记录（3 个核心） | 只做一个可见变化并比较状态 | staging、commit、组件 state | 选择一个范围受控切片，指出两类状态差异 | 双 Commit 仍是比喻；Git 命令不成为额外学员标签 |
| L5 | 控制流选择、三层控制分类、Source of Truth（3 个核心） | 比较循环/计划/复核，不要求命名三种模式 | ReAct、Plan-and-Execute、Reflection、Project Memory、会话压缩 | 按业务信号选流、把规则分层、指出冲突时权威对象 | 三层内部三个层名可见但只评一次分类判断；Project Memory 不独立考核 |
| L6 | 事实锚定诊断、有界排错、停止/升级应用（3 个核心/应用） | 从日志和契约排除猜测 | Console/Network、stack trace、patch、restore | 选择继续/停止/升级并给证据 | 不把自动恢复、patch 清扫或 PASS 标题当概念 |
| L7 | MCP 最小模型、单一浏览器验收入口、证据链（3 个核心） | 入口触发后台能力并回到可见证据 | Headed/headless、DOM、Console、Network、QA、JSON-RPC、Playwright、DevTools、YAML | 解释 MCP 非业务 API；链接场景—观察—证据 | 工程标签教师-only；学员不配置多 MCP，不把工具名当掌握量 |
| L8 | 上下文隔离、独立 finding、HITL 处置（3 个核心）+ 六模式名称 | 用一张框架比较六种协作信号 | role file、Diff、审计模板 | 选模式、设隔离边界、作接受/修复/停止/延期决定 | 明示六名称+三判断的真实暴露量；不宣称“只有三个概念”或要求六套实现 |
| L9 | 确定性工作、概率工作、三链模型（3 个核心；前两者为两个标签） | 观察 Mock/fallback 来源和失败显性化 | HTTP、database、AbortController、MCP transport | 把对象/凭证/数据/owner 归入正确链，并解释降级 | 两个对照标签分别判断；fallback 是行为证据，不另发概念卡 |
| L10 | 风险红线、产品决策与开发启动包（2 个核心） | 盘点缺口、拒绝 placeholder、说明下一步 | ZIP、README、架构/安全/测试清单 | 判断可开始/不可上线的边界并承担理由 | 不增加“生产就绪”或“一键交接”标签 |

该 ledger 是设计负荷证据，不是终结性评分表。若试讲显示同一课的 named labels 或独立判断仍超出 90 分钟，必须回到该课 DRAFT Slice 做删减/迁移，不得靠把名称合并成复合词伪造合规。

### D3. 双轨动作、成果与证据表

教师案例始终是“业务异常预警与闭环处置工作台”；学员始终推进自己的部门原型。两轨共享概念与验收结构，不共享真实数据、密钥或教师真实调用配置。

| 课次 | 教师统一案例演示 | 学员个人原型动作 | 课堂内可见成果 | 课间微任务 / 每周完整成果 | 主要验收证据 | Mock / 数据 / 密钥 / MCP 边界 | 90 分钟主线风险与控制 |
|---|---|---|---|---|---|---|---|
| L1 | 用 Mock 异常卡展示“识别→建议→主管确认”，含一次拒绝越权动作 | 选择一个部门异常问题，套用安全模板生成首个 Mock 页面/卡片 | 可运行的首屏 + 一张问题边界卡 | **微任务 1（10–15m）：** 补齐 owner、触发、非目标；不提交完整成果 | 教师观察一次业务判断；可见 Mock 标记；问题卡 | 实操前先讲 Mock、事前脱敏、无真实 Key；教师不做仓库内真实调用 | **高：** 首次环境+概念易拥堵；预检在课前，教师给预置入口，工程术语只识别 |
| L2 | 对统一工作台做“参考→规则→前后证据”比较，展示版本节点但不要求手工 Git | 为个人原型标注信息优先级并完成一个视觉/信息结构调整 | 前后对比 + 三条设计约束及理由 | **周成果 1（30–45m，L2 后）：** 问题边界、Mock 首屏、视觉决策合并成一份基线 | 前后截图/观察；约束与页面元素一一对应；版本证据由工具或教助生成 | 继续只用 Mock；截图不得含真实业务数据 | **高：** 多模态、视觉和版本操作并发；砍掉手工 staging/commit，保留主管确权含义 |
| L3 | 把统一案例的“逾期异常”收敛为字段、规则、GWT 和 stop/escalation | 为个人原型完成业务边界、数据字典、Mock 样例、两条验收场景 | 可检查的业务/数据/验收三合一卡 | **微任务 2（10–15m）：** 做一次敏感字段与 Mock 标签复核 | 字段—规则—场景追溯；真实数据事前脱敏检查；非目标存在 | 主管定边界，课程供模板，Agent 起草，教助查脱敏；不上传真实数据 | **高：** 追问与三份契约易超时；使用单一模板并限制两条场景、一个主流程 |
| L4 | 按批准契约实现统一案例一个状态切片，展示正常/空/失败但不许自动宣称通过 | 在个人原型完成一个获准切片，并能切换至少两个业务状态 | 一个肉眼可见切片 + 技术状态/业务状态说明 | **周成果 2（30–45m，L4 后）：** 契约、切片和验收证据组成一个版本记录 | 契约追溯；状态可见；教师/助教核对；两阶段版本记录可由工具代办 | 只改 Mock 路径；双 Commit 只作版本/确权比喻；不要求学员 CLI/Git | **高：** 计划、实现、状态、验证密集；每人只做一个切片，失败转教助，不跑虚构 Verifier |
| L5 | 把 L1 ReAct、L4 Plan、规则、状态来源画成统一工作台控制图；演示规则拒绝与真正硬控制的差别 | 为个人原型选择控制流，标明规则、确认点、状态来源与恢复责任 | “主管项目控制卡” + source-of-truth 图 | **微任务 3（10–15m）：** 为一个风险动作补授权/停止节点 | 学员能说明为何选该流、哪些是指导/门禁/运行时、状态以何为准 | 不接真实服务；文本规则不称物理防火墙；不要求关闭终端做“一键恢复”表演 | **中高：** 抽象度高且易脱离原型；每个概念必须回指 L1/L4 刚完成动作，Reflection 留到 L6 |
| L6 | 向统一工作台注入一个已脱敏故障，演示正常修复、证据不足停止、助教恢复三种结局 | 对个人原型或同构安全 fixture 写事实卡，完成最多两轮诊断并作继续/停止决定 | 诊断报告 + 修复后可见状态或明确停止/升级记录 | **周成果 3（30–45m，L6 后）：** 一份脱敏诊断证据包与恢复责任说明 | 实际观察、契约断言、轮次记录、停止理由；不以脚本标题代替行为证据 | 日志先脱敏；不得粘贴 Token/完整抓包；恢复由教助按确认范围执行 | **高：** 故障类型和工具会拖时；使用一故障、一主假设、两轮上限，禁止 `git restore .` 口令化 |
| L7 | 教师后台组合工具，从学员只见的单一浏览器入口演示正常、失败/降级、证据链与拒绝 | 在预配置入口验收个人原型一个场景，记录行为与范围证据 | 浏览器验收卡 + 可追溯证据索引 | **微任务 4（10–15m）：** 标出一个证据盲区和补证方式 | 场景—观察—证据路径一致；能口述 host/client/server/tool；能说 MCP 不是业务 API | 学员不配置 MCP 服务/Key；后台工具对学员透明；所有输入输出为 Mock/脱敏产物 | **极高：** 首次 MCP 加工具术语拥堵；学员只做单入口验收，JSON-RPC/YAML/DevTools 均降为背景 |
| L8 | 用隔离上下文审查统一候选，工具不可用时切到隔离新会话；展示 finding→HITL 处置 | 提交个人原型的脱敏候选包，读取独立 finding，作 accept/fix/stop/defer 决定 | 独立审查 finding + 主管处置卡 | **周成果 4（30–45m，L8 后）：** 审查证据、处置理由和下一步边界 | 审查上下文隔离声明；finding 引证；处置者与理由；工具兜底未跳过审查 | 审查只接收脱敏/Mock 资产；六模式用于选型，不搭六套系统 | **极高：** 六模式与审查易挤压；只深演示调度、流水线、独立审查，其他比较识别 |
| L9 | 在仓库外受控教师环境对照一次真实调用与 Mock/fallback，屏幕只展示脱敏输入输出；画清三链 | 为个人原型画三链责任图，并设计一个可见 fallback 与来源标签 | 三链图 + 正常/失败两种来源可见的行为记录 | **微任务 5（10–15m）：** 补一条失败显性化与 owner | 三链对象、凭证责任和数据流正确；fallback 不伪装真实成功 | 学员全程 Mock；真实调用完全仓库外；不提供 Key/MCP 配置；不混业务 API 与模型 API | **极高：** API/MCP/模型术语密集；不写真实接入代码，只做责任图与预置行为实验 |
| L10 | 汇总统一工作台的正常、失败、证据、拒绝、审查与三链，示范诚实列缺口的启动包 | 盘点十课个人原型，进行 Mock/脱敏互评，形成主管决策和 IT 下一步 | 产品决策与开发启动包目录 + 五分钟业务汇报 | **周成果 5（30–45m，L10 后）：** 完成包与互评处置；不是对外上线动作 | 契约、证据、审查、红线、三链、未完成项可追溯；缺项不得用 placeholder 代替 | 互评只看 Mock/脱敏逻辑；包无密钥/真实数据；明确非生产就绪 | **高：** 资产盘点易超时；课内只做关键缺口和决策，完整整理为本周唯一成果 |

### D4. 课序缺口与拥堵闭环

D2a 是本节的负荷审计依据。以下处置同时检查 named labels、plain-language experience 和 independently assessed judgments，不再把复合标题当作一个概念或用“recognize”掩盖学员实际暴露。

| 结构问题 | 诊断 | 本设计闭环 |
|---|---|---|
| L1 概念过载 | 当前一次引入约七个核心概念，同时要求零基础学员操作环境 | 必掌握压到三项；学员只做“模型提出—工具执行—主管确认”的 plain-language experience，LLM/ReAct/Workflow/HITL 名称留作教师背景或暂不出现；预检移到课前 |
| L2→L3 假硬依赖 | 视觉重构不是业务/数据契约的必要条件 | L3 hard prerequisite 改为 L1 场景与 Mock，L2 仅 soft |
| L5 串联缺前置体验 | ReAct 和 Plan 已体验，Reflection 在 L5 前没有完整行为 | L5 只预告 Reflection；L6 的事实—尝试—批判—停止成为首次完整体验 |
| L5 缺个人原型成果 | 当前转向 `/init`、`/compact` 和规则文件，业务成果弱 | 以个人原型控制卡和来源图为可见成果，不要求会话技巧表演 |
| L6 自动恢复声称 | 文档把无范围的 `git restore .` 与 patch 清扫说成安全自动能力 | 设计为有界停止、范围确认和教助恢复；自动化留到脚本治理 |
| L7 术语拥堵 | MCP、双浏览器工具、QA subagent、DOM/网络/JSON-RPC 同时出现 | 学员只掌握最小 MCP、单入口和证据链；后台技术降为工程背景 |
| L8 六模式过载 | 当前要求全部掌握且称“公认拓扑” | 三深三浅；作为本课程主管决策框架，不是唯一行业标准 |
| L9 三链混淆 | “API MCP”混合工具协议、业务服务、数据库和模型调用 | 用开发工具链/业务 API/模型 API 三链替代混称；学员不接真实服务 |
| 安全首次出现过晚 | 事前脱敏、权限、Key 边界在若干实操之后才明确 | L1 实操前讲 Mock/no-key/事前脱敏；L3、L7、L9 逐层迁移 |
| 时间缺证据 | 所有教案共用 90 分钟表，但无逐 Task 试讲数据且存在 83/90 口径差 | 90 分钟是上限和预算；按课记录试讲时间、完成率、助教接管和删减点 |
| 复合命名掩盖暴露 | `Acceptance & Stop`、`Project Memory / Source of Truth`、六模式和三层控制都包含多个独立标签/判断 | E2 拆分 canonical/背景；D2a 逐项记 named labels 与判断；核心数量、课堂暴露量和评估量分别报告 |

## E. 概念登记册与语义波

### E1. 首次概念四步法的课程级约束

首次成为“必须掌握”的概念，必须紧接一段最小实操并在 3–5 分钟内完成：

1. **是什么 / 不是什么：** 给出 canonical term、最小定义和明确非例；
2. **机制：** 说明关键对象、数据或控制如何流转；
3. **业务类比与反例：** 类比必须标注边界，并给出至少一个会误导的反例；
4. **刚完成实操与交接价值：** 指出它对应学员刚才完成的哪一步，以及主管为何要用该词作判断或与 IT 交接。

四步法不是课前术语讲座。除安全/权限/数据前置外，先让学员完成一个受控动作，再命名动作中的结构，并立即换一个业务情境迁移。

### E2. 课程级概念登记册

| Canonical term | 通俗定义 | 首次体验 / 正式掌握课 | 后续迁移课 | 集成课 | 考核级别 |
|---|---|---:|---|---:|---|
| Business Problem Boundary（业务问题边界） | 说明谁在什么触发下要作什么决定，以及本次明确不解决什么 | L1 形成性体验 / L3 正式掌握 | L4、L8 | L10 | L3 必须掌握；不计入 L1 核心概念 |
| Controlled Agent Prototype（受控 Agent 原型） | 在明确工具、数据、权限和人工确认范围内完成小闭环的可观察原型；不是自主生产系统 | L1 | L4、L5、L9 | L10 | 必须掌握 |
| Tool / Permission Boundary（工具与权限边界） | Agent 能看、能做、必须先问和绝不能做的边界 | L1 | L3、L5、L8 | L10 | 必须掌握 |
| Mock Data（Mock 数据） | 明确标记、按业务规则合成且不含真实敏感信息的练习数据；不是“把真实数据改个名字” | L1 | L3、L6、L9 | L10 | 必须掌握 |
| ReAct | 观察—思考—行动—再观察的局部循环；不是无限自主尝试 | L1 口语体验 / L5 教师命名 | L6 | L10 | 教师背景；L5 只作控制流比较，不独立考名词 |
| Visual Evidence Baseline（视觉证据基线） | 用前后对照和可说明规则记录界面判断，而不是只说“更好看” | L2 | L4、L7 | L10 | 必须掌握 |
| Design Constraint Mapping（设计约束映射） | 把参考意图转成可核对规则，并指出每条规则落在何处 | L2 | L4、L7 | L10 | 必须掌握 |
| Version Evidence（版本证据） | 能追溯“批准前/批准后”候选差异的记录；不等于业务审批本身 | L2 | L4、L8 | L10 | 必须掌握 |
| Data Contract（数据契约） | 把字段、含义、范围、枚举和数据规则写成双方可核对的约定 | L3 | L4、L6、L7、L9 | L10 | 必须掌握 |
| Acceptance Scenario（验收场景） | 用给定条件、动作和可观察结果描述如何判断；不是只列功能名 | L3 | L4、L7、L8 | L10 | 必须掌握；与停止政策分别观察 |
| Stop / Escalation Policy（停止 / 升级政策） | 预先定义何时不再尝试、由谁接管、需要什么新证据 | L1 安全政策 / L3 应用 | L6、L8、L9 | L10 | L3 不作为新概念讲授；作为既有安全政策的独立处置判断 |
| Thin Slice（薄切片） | 一次只完成一个可见、可验证、可回退评估的纵向变化；不是把任务拆成无结果的技术碎片 | L4 | L5、L6、L7 | L10 | 必须掌握 |
| Technical vs Business State（技术状态 / 业务状态） | 加载、错误等系统状态与待处理、已升级等业务含义是两套不同状态 | L4 | L6、L9 | L10 | 必须掌握 |
| Two-stage Version Record（两阶段版本记录） | 分开记录候选实现和主管处置，帮助追溯；Git 本身不理解确权 | L4 | L8 | L10 | 必须掌握其含义；Git 命令属背景 |
| Control Flow Selection（控制流选择） | 根据任务是否需局部循环、明确计划或独立复核选择流程 | L5 | L6、L8 | L10 | 必须掌握 |
| Guidance / Gate / Runtime Control（三层约束） | 分清文字指导、流程批准点和真实执行拦截，避免把承诺当代码；三个层名在曝光账中分别计数 | L5 | L6、L8、L9 | L10 | 三层分类判断必须掌握；不把复合标题当一个名词记忆 |
| Source of Truth（事实来源） | 识别冲突时哪个对象拥有长期权威；项目记忆只是可能的输入，不自动成为权威 | L5 | L6、L8 | L10 | 必须掌握 |
| Project Memory（项目记忆） | 保存当前工作上下文或历史经验的载体；可能过期，不能替代权威记录 | L5 教师背景 | L6、L8 | L10 | 需要识别，不独立考核 |
| Fact-anchored Diagnosis（事实锚定诊断） | 从可观察错误、输入和契约开始缩小原因，而不是让 AI 猜修复 | L6 | L7、L8 | L10 | 必须掌握 |
| Bounded Debugging（有界排错） | 在明确轮次、范围和停止条件内诊断；失败也要留下可交接证据 | L6 | L7、L9 | L10 | 必须掌握 |
| MCP Minimum Model（MCP 最小模型） | host 代表用户发起能力调用，client 连接 server，server 暴露 tools；它不是产品业务 API | L7 | L8、L9 | L10 | 必须掌握 |
| Single Browser Acceptance Entry（单一浏览器验收入口） | 学员只通过教师预配置入口执行验收，后台工具组合不转化为学员配置任务 | L7 | L8、L9 | L10 | 必须掌握 |
| Evidence Chain（证据链） | 从验收场景到观察、原始证据和结论的可追溯关系 | L7 | L8、L10 | L10 | 必须掌握 |
| Context-isolated Independent Review（上下文隔离独立审查） | 审查者只拿约定候选、规格和证据，不继承实现者自我辩护 | L8 | L10 | L10 | 必须掌握 |
| Collaboration Pattern Selection（协作模式选型） | 按依赖、并行性、独立性和最终责任选择协作方式，而不是追求 Agent 数量 | L8 | L10 | L10 | 六个名称全部可见；只评三项判断：选模式、设隔离边界、作 HITL 处置 |
| HITL Disposition（人类处置） | 人对 finding 作接受、修复、停止或延期决定并承担理由 | L8 | L9 | L10 | 必须掌握 |
| Deterministic Work / Probabilistic Work（确定工作 / 概率工作） | 分别识别可用固定规则重复计算的工作和依赖模型生成、需证据约束的工作 | L9 | L10 | L10 | 两个对照标签分别可见、分别判断；不以复合名折算为一个概念 |
| Three-chain Model（三链模型） | 区分开发期工具调用、产品业务 API 和模型 API 的对象、凭证、数据与责任 | L9 | L10 | L10 | 必须掌握 |
| Fallback Provenance（降级来源） | 失败时显示替代结果的来源、原因和限制，不把 Mock 冒充真实成功 | L9 | L10 | L10 | 必须掌握 |
| Risk Redline（风险红线） | 当前原型明确不自动执行、必须人工批准或留给生产工程的事项 | L10 | — | L10 | 必须掌握 |
| Product Decision & Development Start Package（产品决策与开发启动包） | 汇集问题、契约、证据、处置、红线和下一步，供 IT 开始正式设计开发；不是可上线产品 | L10 | — | L10 | 必须掌握 |

工程背景术语如 Vue、TypeScript、CSS、Git staging、JSON-RPC、YAML、Playwright、DevTools、HTTP、database、`AbortController`、ZIP 等，只在帮助主管识别交接对象时解释，不按编码或命令记忆考核。

### E3. 每课最小语义波

| 课次 | 具体实操 | 3–5 分钟抽象（明确回指“刚完成哪一步”） | 新业务场景迁移 |
|---|---|---|---|
| L1 | 在 Mock 异常卡上选择“建议处理/拒绝越权” | 回指刚才 Agent 调用工具前后的可见变化，命名受控 Agent、权限边界和 Mock | 换成库存、客服或人力异常，判断哪些动作仍须主管确认 |
| L2 | 对统一工作台做一次前后对照并标注信息优先级 | 回指刚才从参考图提取规则并落到页面的位置，命名视觉证据基线和约束映射 | 换成学员部门看板，保留业务优先级而非照抄样式 |
| L3 | 把一个“超时工单”口语需求写成字段和两条场景 | 回指刚才被追问后新增的 owner、范围、字段和停止条件，命名契约与验收场景 | 换成另一个部门异常，判断哪些字段可复用、哪些必须重定 |
| L4 | 只实现一个状态变化并切换正常/失败 | 回指刚才只改一个可见闭环的动作，命名薄切片与两类状态 | 换到个人原型的另一状态，判断是否仍是一个可验收切片 |
| L5 | 把过去四课动作贴到控制流和来源图 | 回指刚才在哪些步骤循环、计划、确认、记录，命名控制流和三层约束 | 给一个新风险任务选择流，并说明何处必须加入 gate |
| L6 | 对一个已脱敏故障完成事实卡和第一轮假设 | 回指刚才用日志/契约排除猜测的动作，命名事实诊断和有界排错 | 换一个不同故障，决定继续第二轮还是停止升级 |
| L7 | 从单一浏览器入口执行一个验收场景并保存证据路径 | 回指刚才由入口触发后台工具并回到观察结果的链，命名 MCP 最小模型和证据链 | 换一个失败/降级场景，指出需要什么补证而非更多工具名 |
| L8 | 在隔离会话中得到一个带引证 finding | 回指刚才审查者没有继承实现对话、主管再作处置的步骤，命名独立审查与 HITL | 换成合规或财务高风险场景，判断需更强隔离还是停止 |
| L9 | 对照 Mock 正常路径和教师屏幕中的仓库外真实调用/失败路径 | 回指刚才不同凭证、数据和责任所在，命名三链与 fallback 来源 | 换一个模型摘要或业务查询场景，重新画三链并标明降级 |
| L10 | 盘点一份包中“已有证据”和“尚缺生产工程” | 回指刚才拒绝用 placeholder 补缺项的决定，命名开发启动包与风险红线 | 换成 IT 接包会议，说明三项可以开始和三项不能直接上线的事项 |

### E4. 先体验后命名与必须前置

**可先体验后命名：** L1 的 ReAct 局部循环、L2 的版本差异、L4 的 Plan-and-Execute、L7 的证据链、L8 的协作拓扑比较。体验必须受控，随后同课完成最小完整解释，不能把首次定义全部推迟到 L5。

**必须在实操前讲：** Mock/真实数据区别、真实数据事前脱敏、密钥不得进入仓库/材料/学员包、工具/权限边界、高风险动作的确认/停止、L7 学员不自行配置 MCP 服务、L8 审查上下文隔离、L9 教师真实调用完全在仓库外、L10 互评只使用 Mock/脱敏逻辑。它们属于安全和责任前置，不能用“先试错再讲概念”的方式教学。

## F. 双轨教学与课堂运行

### F1. 两条连续轨道

| 轨道 | 固定对象 | 教学职责 | 十课连续性 | 禁止漂移 |
|---|---|---|---|---|
| 教师统一案例 | 业务异常预警与闭环处置工作台 | 提供全班共同语境，演示正常、失败、证据、拒绝、审查和仓库外受控真实调用对照 | 每课只增加本课能力，不另起无关案例 | 不把教师后台工具和真实调用配置发给学员；不以演示成功代替学员证据 |
| 学员个人原型 | 学员自己的部门异常/处置原型 | 让主管把共同能力迁移到本部门问题，并持续保存边界、Mock、证据与处置 | L1 建立，L2–L9逐步增强，L10汇总 | 不每课重建项目；不输入真实敏感数据；不要求实现六套系统或真实接口 |

当某课需要统一 fixture（如 L6 故障）时，学员先在教师安全 fixture 上理解方法，再把“诊断问题/证据要求/停止条件”迁移到个人原型；不是把共享 fixture 当个人主线的替代品。

### F2. 教师演示最低清单

每个课程能力在统一案例中至少覆盖与该课相关的以下项；无需每课机械重复全部六项：

1. **正常路径：** 输入、关键决策点、可见结果；
2. **失败 / 降级：** 失败如何显性化，是否停止、降级或由助教接管；
3. **证据链：** 场景、观察、原始证据与结论如何相连；
4. **拒绝 / 停止：** 数据、权限、轮次或风险超界时如何不执行；
5. **真实调用 / Mock 对照：** 只在需要的课程由教师从仓库外受控环境屏幕演示，输入输出须预先脱敏；
6. **责任归属：** Agent 可建议什么，主管批准什么，教师/助教与 IT 分别接管什么。

### F3. 班级运行

- **班型：** 10–15 人，1 教师+1 助教。教师维持共同主线；助教负责个别环境、恢复和补课包。
- **环境预检：** L1 前 30–45 分钟独立完成入口、依赖、浏览器和样例可用性检查；不占 L1 正式 90 分钟主线。
- **3 分钟接管：** 个别学员因环境问题阻塞超过 3 分钟，助教立即接管到预置 fallback；教师不让全班等待。
- **缺课恢复：** 缺课者先跟随教师标准案例，完成 20–30 分钟标准补课包并通过最小证据检查，才恢复个人原型主线。
- **课堂上限：** 90 分钟到点结束主线；未完成的工程排障转助教，不以延长全班课时解决设计过载。

### F4. 90 分钟预算模板

以下是课程设计预算，不是机械一刀切，也不是已试讲数据。各段可在相邻段间调节，但总时长不得超过 90 分钟，且不得删除安全前置、核心实操、可见成果与退场判断。

| 段落 | 建议范围 | 目的 |
|---|---:|---|
| 进入与安全边界 | 5–8 分钟 | 回顾前置、说明本课不做、确认 Mock/权限 |
| 教师最小演示 | 8–12 分钟 | 先让学员看见完整业务闭环 |
| 首次概念语义波 | 10–15 分钟 | 每个首次核心概念 3–5 分钟并回指刚完成实操 |
| 任务说明与检查点 | 5–8 分钟 | 说明个人原型动作、证据和停止条件 |
| 学员主实操 | 25–35 分钟 | 完成一个可见纵向结果；环境问题由助教接管 |
| 迁移、失败与证据 | 10–15 分钟 | 换业务场景，处理一个失败或证据盲区 |
| 汇总与退场卡 | 5–8 分钟 | 检查成果、布置微任务或周成果 |

逐课试讲必须记录实际教师讲解、学员完成、助教接管、失败恢复与删减时间。没有这些数据时，只能标“预算”和风险，不能宣称某课已经精确适配 90 分钟。

两分钟退场预算默认只放 **1–2 个必答提示**（一个本课判断、一个风险/下一步）；3–5 题或更多反思题进入课后题库。若未来单课设计需要更多必答题，必须显式增加可行时长并重新平衡总预算，不能一边保留两分钟一边塞入 3–5 题。当前路线图候选中的 `10+15+18+10+25+10+2` 仅是未评审 DRAFT 参考，既不是试讲证据，也不是 Skill 默认预算。

### F5. 三类产物分离

| 产物 | 发生时间 | 规模 | 目的 | 不得替代 |
|---|---|---:|---|---|
| 课堂内可见成果 | 每一课、课内完成 | 一个最小可检查结果 | 证明本课能力发生，供教师即时反馈 | 不能被课后作业替代 |
| 课间微任务 | 每周第一课后到第二课前 | 10–15 分钟 | 复习、补字段、做一次迁移 | 不能膨胀成完整项目 |
| 每周完整成果 | 每周第二课后 | 30–45 分钟，仅一个 | 合并本周两课产物，形成连续原型版本 | 不能每课都布置一个 30–45 分钟作业 |

## G. 六种 Agent 协作模式

六种模式是**本课程的主管决策框架**，不是行业唯一分类，不要求学员实现六套工程系统。深讲/演示三种，其他三种只做识别比较；任何模式的最终业务责任仍在人。

| Canonical 名称 | 层级 | 适用业务信号 | 主管决策问题 | 主要误用风险 | 课程映射 |
|---|---|---|---|---|---|
| Orchestrator–Workers（调度者—执行者） | 深讲 / 演示 | 一个 owner 可把工作拆成若干边界清楚的子任务并汇总 | 子任务边界、输入输出、失败返回和最终合并者是谁？ | 调度者成为瓶颈；子 Agent 越权；汇总看似完整但证据丢失 | L5 用控制卡命名；L7 教师后台演示调度多个工具；L8 比较选型 |
| Sequential Pipeline（顺序流水线） | 深讲 / 演示 | 后一步必须消费前一步已验收产物 | 每一站的契约是什么？哪一步失败就必须停止？ | 上游错误传播；把流程经过当质量通过；无限返工 | L3 契约→L4切片→L7证据作为既有体验；L8系统比较；L10交接 |
| Context-isolated Review（上下文隔离独立审查） | 深讲 / 演示 | 候选需要不受实现叙事影响的规格/证据复核 | 审查者允许看到什么？finding 要引证什么？谁处置？ | 自审冒充独立；上下文泄漏；审查者替主管承担业务责任 | L8 核心实操，并以 HITL 处置收口；L10 复用 |
| Parallel Fan-out / Fan-in（并行扇出—汇总） | 识别 / 比较 | 多个互不依赖的调查或方案可并行 | 哪些任务真的独立？结果如何去重与仲裁？ | 重复劳动、相互冲突、合并时遗漏少数意见 | L8 用两个短案例比较，不要求搭系统 |
| Peer-to-Peer Collaboration（对等协作） | 识别 / 比较 | 多个同等专长角色需要互相补充信息 | 谁拥有最终输出？如何防止循环讨论？ | 无 owner、责任稀释、消息爆炸和共识幻觉 | L8 识别与反例；不要求学员实现网络 |
| HITL Arbitration（人机协作仲裁） | 识别为独立模式；在独立审查演示中体验 | 风险、歧义或冲突必须由授权人决断 | 触发人工的阈值是什么？谁有权限接受风险？如何记录理由？ | 人只盖章、不看证据；把 Git/AI 输出误当审批；责任不清 | L1/L3 持续出现确认点；L8 finding 处置；L10 最终确权 |

`Context-isolated Review` 的深讲演示必须以 HITL 处置结束，但这不把两者混为同一机制：前者负责产生独立 finding，后者负责承担决定。

## H. 安全与技术边界

### H1. Mock 与真实调用责任链

1. 主管定义字段、含义、枚举、范围、流程和业务合理性；
2. 课程方提供结构模板、安全检查和预置入口；
3. Agent 只起草明确标记的合成数据；
4. 教师/助教检查脱敏、敏感信息和展示范围；
5. 真实数据必须在进入任何 AI 前完成脱敏；
6. 教师真实模型/API 调用完全位于仓库外受控教师环境；
7. 本仓库、课程材料与学员包只保留 Mock 或已脱敏产物，绝不包含教师密钥、真实调用配置或未脱敏输入。

教师演示真实调用时，学员只看经过脱敏的输入、输出、失败和 Mock 对照，不获得 Key、服务配置或可复用凭证。屏幕录制、截图与导出证据也须经过同样检查。

### H2. L7 / L8 / L9 技术边界

- **L7：** 学员理解 host/client/server/tool 最小模型，并通过教师预配置的**单一浏览器验收入口**操作；后台可组合多个工具。MCP 是工具接入协议层，不是产品前端调用后端的业务 API。学员无需自行配置 MCP 服务。
- **L8：** 独立审查的关键是上下文隔离、输入边界和 finding 引证，不绑定品牌。默认工具不可用时必须改用隔离的新审查会话，不得跳过审查，也不得把同一实现会话改名为审查。
- **L9：** 开发工具链处理开发期文件/浏览器/验证工具；业务 API 链连接产品与业务服务；模型 API 链连接受控服务与模型。三链分别描述调用者、凭证、数据、失败和 owner，MCP 不与后两链混称。

### H3. 双 Commit 与 CEO 决策树

- **双 Commit：** 只作为“两阶段版本记录 / 主管确权”的教学比喻。候选实现记录与主管处置记录可分开追溯，但 Git 不理解业务审批、权限或风险；普通学员不必手工执行 Git 命令。
- **CEO 三大决策树：** 只作为主管面对价值、风险和处置的决策框架，不是代码运行时硬控制，也不是行业通用标准。其名称不能替代具体 owner、阈值、证据和升级路径。

### H4. 三层控制模型

| 层 | 定义 | 当前可用例 | 证明要求 | 禁止称呼 |
|---|---|---|---|---|
| Guidance（指导性约束） | 文档、提示词、模板和课堂规则，帮助人/Agent按约定行动 | Mock 标签、两轮建议、脱敏清单、`CLAUDE.md` 文本规则 | 文本存在且学员能解释；违反时可能仍可执行 | 不得称“物理锁”“运行时拒止” |
| Workflow gate（流程门禁） | 明确输入、角色和批准/停止条件的人工或系统流程 | 助教 3 分钟接管、L3 授权点、L8 独立审查与 HITL、课程审批顺序 | 有 owner、状态、记录和失败/拒绝路径 | 不得因为写了口令就称代码硬控制 |
| Runtime hard control（运行时硬控制） | 执行系统在越界动作发生前可重复拦截或限制 | 只有后续找到/实现并测试的具体权限、schema、allowlist 或拦截代码 | 可执行实现、负向测试、绕过分析、版本与 owner | 未有代码和测试证据前不得使用“物理/100%/绝不可能” |

现有 Hook 名、注释、Git 口令、红线文档和 CEO 决策树均不能独立证明 runtime hard control。后续课程材料统一使用上述分层术语，停止用“工程护栏”笼统覆盖三层。

### H5. 母仓库规则与 Claude 兼容入口边界

| 对象 | Phase 1 候选职责 | 明确禁止 |
|---|---|---|
| 根 `CLAUDE.md` | 母仓库维护者/Agent 工作规则；引用 locked UIC、frozen design 和 approved roadmap/template 的课程 authority；保留真实安全、依赖、Git 与学员包隔离边界；将 `verify-project.ps1` 标为遗留维护检查 | 不称学员课程正文；不硬编码旧 10–30 人、固定五 Pause、旧 22 节治理、verify/100% 为课程通过条件；不把文字规则称 runtime hard control；不改学员版模板 |
| `student-package/templates/CLAUDE.md` | 真正导出的学员版规则，保持本 Phase 1 只读 | 不因根规则对齐而同步或批量修改 |
| `.agents/skills/teacher-plan-architect/SKILL.md` | 唯一完整 canonical TPA v2，承载已批准的方法/渲染约束 | 不让 Skill 持有 lifecycle、artifact ownership、schema duplication 或 approval power |
| `.claude/skills/teacher-plan-architect/SKILL.md` | 最小合法 frontmatter/触发兼容入口，指向 canonical exact path | 不复制八模块细则、Brief schema、版本、项目默认、审批逻辑；canonical 缺失、不可解析或校验失败时不得继续 |

## I. 既有候选稿发现闭环矩阵

优先级只表示设计风险排序，不表示已批准实施。P0 是安全、生命周期、虚假能力或用户硬边界；P1 是课程累计能力和可实施性；P2 是可在不改变主线时延后的表达优化。

| ID | Priority | 候选稿发现 | 目标处置 | 后续验收证据 |
|---|---|---|---|---|
| F01 | P0 | “让 IT 直接落地”与同文“非生产就绪”冲突 | 全部改为“产品决策与开发启动包”；列明架构、安全、集成、测试、运维与生产审批缺口 | 路线图、L10 教案/指南和打包说明无“直接上线/无缝生产”承诺；包内有未完成项 |
| F02 | P1 | 四步法缺“对应刚完成哪一步实操” | 每个首次核心概念紧接最小动作，第四步明确回指动作与主管交接价值 | 十课概念表抽查：首次课、实操步骤、3–5 分钟卡和迁移场景可追溯 |
| F03 | P0 | 事前脱敏、教师仓库外真实调用与密钥边界不完整 | 三条独立写清：进入 AI 前脱敏；教师真实调用完全仓库外；仓库/材料/学员包只含 Mock/脱敏产物且无 Key | 路线图与 L1/L3/L7/L9/L10 材料一致；学生包扫描与人工检查无凭证/未脱敏样本 |
| F04 | P0 | 不存在的 npm `verify`、母仓库 `verify-student-project.ps1`、实体 `AGENTS.md` 被当能力 | 删除课堂通过声称或精确标为“待实现/仅导出模板”；断链不得保留 | `package.json`/实体路径与文字逐项一致；不存在资产不进入验收命令 |
| F05 | P1 | “一键恢复”仍被写成现成成果 | 改为有界停止、范围确认、助教恢复；自动恢复只有实现并通过负向测试后再命名 | L5/L6 不出现无证据“一键/100%”；恢复步骤有 owner、范围和失败路径 |
| F06 | P0 | 候选 Diff 删除课程级“每课课堂内可见成果”规则 | 恢复为课程硬规则，并与微任务、每周完整成果分列 | 路线图课程规则和十课矩阵均有三列，且每课有课内可见成果 |
| F07 | P1 | “学员无需 MCP”过宽，与 L7 正式学习冲突 | 改为“学员无需自行配置 MCP 服务；只使用教师预配置单一浏览器入口” | L7 能解释最小模型与非业务 API；无学员多服务配置步骤 |
| F08 | P0 | “八大防护”混合指导规则、workflow gate、runtime hard control | 用 H4 三层矩阵逐项归类；无代码/测试证据者不得称硬控制 | 每项有层级、owner、证据；runtime 项有实现与负向测试，否则降级措辞 |
| F09 | P1 | 六种协作模式在候选路线图中缺失或定位模糊 | 使用 G 节本课程框架，调度/流水线/独立审查深讲，其他三种识别 | 路线图和 L8 一致；无“行业唯一/公认唯一”；不要求实现六套系统 |
| F10 | P1 | 统一 90 分钟数字无真实试讲依据，现有材料同时出现不足与超载信号 | 把 90 分钟定义为上限和初始预算；逐课收集真实时间、完成率、助教接管、删减点 | 每课有试讲记录与超时处置；无用填充或伪造精确时间；主线实际不超过 90 分钟 |

矩阵中的 F01–F10 必须在未来路线图、单课与派生资产 Slice 中保持可追溯状态：`open → addressed → independently checked`。S1A 只建立闭环目标，没有把任何 finding 标为已修复。

## J. 后续实施分片与 production boundary DRAFT

### J1. 门禁顺序

本节只给出未来小步顺序，不授权写入。正确的批准、测试和实施顺序为：

1. 当前设计 DRAFT 完成 advisory review，修正 blocker；
2. Formal Independent Design Review 通过；
3. 进入 **A-RUBRIC-DRAFT**：仅在 Gate A 前创建/完善精确路径 `docs/changes/course-curriculum-revision-2026-08/acceptance-rubric.md`（DRAFT），其中 RED test plan 只能是该文件内嵌的固定章节，使用户可见 scope、non-goals、acceptance 和 risk；不创建独立 RED-plan 文件/路径，不创建/运行六个冻结协议，不声称失败证据，不记录 `TESTS_RED`，也不锁定 rubric；
4. 用户 Gate A 明确批准设计与**精确** production file boundary，生命周期按工具进入 `DESIGN_FROZEN`；
5. 进入 **A-RED-PROTOCOLS**：`DESIGN_FROZEN` 后，授权 acceptance-test writer 在保持 production zero-diff 的前提下创建并运行六个协议；
6. 真实预实现失败证据成立后，才按工具记录 `TESTS_RED`；
7. 进入 **A-ACCEPTANCE-REVIEW**：Independent Acceptance Review 复核 rubric、protocol semantics、失败原因和真实 run/event evidence；阶段内不修改 production；
8. 只有 Gate A 仍有效且 acceptance semantics 未变化时，生命周期才按工具进入 `ACCEPTANCE_FROZEN`；
9. implementation writer 才可按一个受控 production Slice 实施；协议不是最后一个 production Slice，实施后必须按 rubric 复跑相关协议并取得 GREEN/人工证据。每个 Slice 独立验证、回报、停止，不能用前一批准覆盖下一 Slice。

课程文档也属于 L2 production implementation；不能因为是 Markdown 就绕过设计和验收冻结。`teacher-plan-architect` v2 同样只能在 Gate A 之后，并满足适用的 acceptance freeze 后实施。

### J2. Programme backlog and Phase 1 context（J6 为唯一 exact boundary）

以下把完整 programme goal 的未来 backlog 与当前 Phase 1 context 分开标记。J6 是唯一的 exact candidate boundary；所有路径仍**尚未注册、尚未批准**，表格不能授权本 change 批量修改课程文件。标为 `[Phase 1]` 的行只说明 J6 中的候选上下文，其他行必须在未来 change/Slice 中重新精确列路径。

| 组 | 候选路径 / 范围 | 设计说明 |
|---|---|---|
| P1 未来课程级权威与术语 | 根目录 `GLOSSARY.md` | `docs/COURSE_ROADMAP.md`、`docs/LESSON_TEMPLATE.md` 与根 `CLAUDE.md` 已进入当前 Phase 1；GLOSSARY 仍需未来独立 change，不得顺手同步 |
| P1a `[Phase 1]` 根维护规则 | `CLAUDE.md` | 母仓库/Agent 规则候选；不得混称学员课程正文；旧班型/Pause/verify/100% 规则必须改为引用课程 authority，student-package/templates/CLAUDE.md 保持只读 |
| P1b `[Phase 1]` Claude TPA compatibility shim | `.claude/skills/teacher-plan-architect/SKILL.md` | 最小兼容入口；`.agents/skills/teacher-plan-architect/SKILL.md` 是唯一 canonical v2；shim 不复制细则/schema/approval，解析失败时 fail-closed |
| P2 `[Phase 1]` Teaching Lesson Plan v2 | `.agents/skills/teaching-lesson-plan/SKILL.md` | J6 候选；Skill 只提供方法与渲染约束，不拥有 Brief 或 lifecycle |
| P2a `[Phase 1]` TLP Brief contract | `.agents/skills/teaching-lesson-plan/references/lesson-design-brief-template.md` | J6 候选；该 exact reference 是唯一 `contract_version` 与完整字段契约的 schema authority |
| P3 `[Phase 1]` Teacher Plan Architect v2 | `.agents/skills/teacher-plan-architect/SKILL.md` | J6 候选；Skill 只提供终稿渲染约束，不拥有教案、GUIDE 或审批 |
| P3a TPA references | Phase 1 不包含任何 TPA reference 文件；未来 change 若需要，必须先形成唯一精确路径决定 | 不复制 TLP Brief schema，不使用 optional/悬空引用 |
| P4 教师教案 | `docs/LESSON_01_TEACHER_PLAN.md` … `docs/LESSON_10_TEACHER_PLAN.md` | 每一课是独立 Slice；先修改、独立复核并获批，再允许对应学员指南 |
| P5 学员指南 | `docs/LESSON_01_GUIDE.md` … `docs/LESSON_10_GUIDE.md` | 只能消费已批准的对应教师教案；不能反向改写教师教案 |
| P6 逐课派生资产 | 对应课的 `lessons/0001…0010*.html`、`docs/assets/lesson-*`、学生包模板中的对应课文件 | 每课指南批准后再精确列名；HTML、图片和学生包不能先于 source lesson |
| P7 课程导出与验证 | 后续 backlog 文件为 `scripts/export-lesson-materials.ps1`、`scripts/export-student-package.ps1`、`student-package/templates/scripts/verify-student-project.ps1`、`scripts/verify-project.ps1`、`scripts/run-lesson-verifier.ps1`、`scripts/verify-lesson-04-student.ps1` | 课程正文稳定后按一个能力一个 Slice 治理；“一个脚本存在”不授权批量改脚本 |
| P8 L10 交接资产 | 后续 backlog 文件为 `scripts/package-it-handover.ps1`、`docs/IT_ENGINEER_QUICKSTART.md`、`docs/DEPARTMENT_REDLINES.md`、`docs/LESSON_07_EVIDENCE_INDEX.md`、`docs/LESSON_08_AUDIT_REPORT.md` | 最后处理；缺项必须显式失败，不能生成 placeholder 冒充证据 |

`docs/changes/course-curriculum-revision-2026-08/*.md` 是 spec files，不是 production files。历史 `*_V2.md`、`*_V3.md`、历史设计对齐材料和现有未指定课程资产默认排除，继续只读保护。

Teaching Lesson Plan Stage A disposition 为 **APPROVED WITH REQUIRED CORRECTIONS**。这只批准 J3 的 DRAFT 方向进入未来候选边界，不是 Stage B 写入授权，不是 formal design approval，也不改变 lifecycle。

### J3. 三层 Skill 职责与 Teaching Lesson Plan v2（DRAFT）

#### J3.1 拟议职责链（待冻结）

| 层 | 唯一职责 | 输入 | 输出 / 禁止 |
|---|---|---|---|
| `curriculum-knowledge-architecture-designer` | 分析课程级知识类型、概念依赖与十课顺序建议 | 仓库 stated curriculum、UIC 和设计问题 | 输出分析建议；Skill/方法本身不是 authority，只有被 locked UIC、frozen design specification 或 approved roadmap 采纳的部分才成为下游输入 |
| `teaching-lesson-plan` | 提供 Brief 生成方法与字段约束 | 上位课程约束、单课已批准目标、仓库事实 | 只由获授权执行 agent 使用它产出 Brief；不拥有 Brief、不产最终 `TEACHER_PLAN`/`GUIDE`、不修改仓库课程材料 |
| `teacher-plan-architect` | 提供唯一终稿渲染方法与边界约束 | 已校验且 `HANDOFF_READY` 的 Brief、批准模板/路线图 | 只由获授权执行 agent 使用它按八模块生成教师教案；不拥有教案或审批；教案经独立 review + user/course-owner approval 后才可生成 GUIDE |

Brief owner 是 course design owner / 对应 lesson change；TEACHER_PLAN/GUIDE owner 是 course owner / 对应 lesson change；允许 writer 都是获授权执行 agent，并通过单 writer handoff 禁止并发写同一 artifact。Independent Reviewer 负责教案 review/批准审查及 GUIDE conformance review；user/course owner 负责业务批准。Skill 只提供方法、流程和渲染约束，不持有 lifecycle、artifact ownership 或 approval authority。10–15 人、90 分钟、1 教师+1 助教、阻塞超过 3 分钟接管、默认无代码/Git/MCP 基础等，拟作为本项目 locked UIC/frozen design 的 **pass-through constraints**；它们不是通用 Skill 自己拥有的 DEFAULT。Skill 在其他项目必须读取其上游输入，不得静默套用 AILearning 参数。职责链和约束在当前 DRAFT 中均为拟议，尚未冻结。

#### J3.2 Stage A 必需纠偏

| ID | Priority | DRAFT 必需纠偏 | 候选验收方式 |
|---|---|---|---|
| TLP01 | P0 | 同类 authority 使用 locked UIC → frozen design specification → approved roadmap → direction-specific approved source object → Skill defaults；`DESIGN_FROZEN` 只是 lifecycle gate | 冲突样例不会把 gate 名当内容输入，也不会让 Skill 覆盖上位材料 |
| TLP02 | P0 | Brief 采用 `brief_readiness: DRAFT \| HANDOFF_READY`，只表示中间产物完整性；禁用像 lifecycle 的 `READY_FOR_TPA` | 输出明确声明不代表 DESIGN_REVIEWED/FROZEN、用户批准或教案批准 |
| TLP03 | P1 | Learning Sequence 中教师演示、标准案例、个人迁移、证据、收束是 coverage functions，可合并、重排 | Brief 做分钟加总且服从上游时长；固定七段输入不会被原样强制 |
| TLP04 | P1 | WHERETO 是诊断/coverage lens，不是必填七格合规表或唯一课堂脚本 | 只记录相关要素、缺口与理由；无强制七格填满 |
| TLP05 | P1 | Bloom 不永久排除 Remember/Understand；识别目标可用，终结性目标默认优先 Apply 及以上，Degree 必须业务可观察 | 目标样例区分识别与终结性证据，不以动词表机械判定 |
| TLP06 | P0 | 是否自动评分取决于判定标准而非题型 | 固定答案辨识/判断可自动核对；涉及理由、风险权衡、处置质量的证据标教师判断 |
| TLP07 | P0 | exact 3-minute recovery、缺课规则、禁止扩展等只引用/传递上游政策，不由 TLP 新定义 | 缺少上游政策时报告缺口，不生成 AILearning 默认值 |
| TLP08 | P1 | 渐进披露：`SKILL.md` 只保留职责、触发、流程、边界、质量门；完整字段只在一级 reference | `lesson-design-brief-template.md` 是唯一字段契约，无重复内嵌 schema、无悬空引用 |
| TLP09 | P0 | Brief schema 只有一个 owner：TLP reference 定义 `contract_version`；TPA 只声明消费版本并校验字段 | 修改 schema 只需改一个规范位置；版本不匹配时 TPA 明确停止 |
| TLP10 | P1 | 两分钟 Exit Ticket 和课程级预算只能传递 frozen input，不由 TLP 固化当前候选数字 | AILearning 输入得到 1–2 必答提示/上游预算；其他项目可传不同合法约束 |

#### J3.3 TLP→TPA 接口验收候选

Gate A 前，DRAFT `docs/changes/course-curriculum-revision-2026-08/acceptance-rubric.md` 内嵌的 RED test plan 章节应展示以下五类接口检查的 scope、non-goals、acceptance 和 risk；只有 Gate A 后进入 `DESIGN_FROZEN`，授权 acceptance-test writer 才可创建/运行六个 protocol，真实预实现失败成立后才记录 `TESTS_RED`：

1. 对两个 Skill 运行 `skill-creator` 提供的 `quick_validate.py`，且各自通过；
2. **fresh-agent 正向测试：** 给冻结的单课输入，TLP 只输出 `Lesson Design Brief`；TPA 消费兼容 `contract_version` 的 Brief，只输出八模块教师教案，不越权生成 GUIDE；
3. **负向测试：** 给缺失或候选路线图时不得冒充 frozen；给不存在的 verify/doctor/test:ui 时不得宣称已实现；给固定七段模板时可合并重排且分钟总和正确；
4. **触发边界测试：** “设计学习目标/证据/活动逻辑”只触发 TLP；“写仓库 TEACHER_PLAN/GUIDE”触发 TPA，且 GUIDE 仍受教师教案批准门禁；
5. **schema 负向测试：** 缺字段或 `contract_version` 不兼容时，TPA 停止并报告，不自行补造课程事实。

这些是 future acceptance protocol candidates，尚未进入 `acceptance-rubric.md`，也未授权执行。协议与外部 run/evidence record 分离；协议语义冻结后，实际运行结果必须引用真实 task/thread run event ID 或规范 evidence record；只有 Independent Acceptance Review 通过且 Gate A 语义仍有效时才可进入 `ACCEPTANCE_FROZEN`。

#### J3.4 持久 Brief 与交接引用（DRAFT 设计决定）

每课 Brief 不存在于会话记忆中，而是一个受 frozen course specification 约束的持久 handoff/report artifact。统一候选路径为：

`docs/changes/course-curriculum-revision-2026-08/lesson-briefs/LESSON_XX_DESIGN_BRIEF.md`

本 S1D 只定义路径和引用语义，不创建 `lesson-briefs/` 或任何 Brief 文件。Brief artifact owner 是 course design owner / 对应 lesson change；允许写入者是获授权的执行 agent，且必须使用 TLP v2。该 agent 负责 schema/authority/time 校验 `HANDOFF_READY`，但这不是批准。TLP Brief reference 的 exact path + `contract_version` 是唯一 schema authority；Skill 本身不是 owner 或 writer。Brief 文件的 `brief_readiness` 只能为 `DRAFT` 或 `HANDOFF_READY`，其中 `HANDOFF_READY` 仅表示字段、来源、分钟加总和上游约束完整，不代表设计评审、冻结、用户批准或教师教案批准。TPA v2 消费 `HANDOFF_READY` Brief 并校验 `contract_version`；若 Brief 改变课程目标、非目标或 acceptance meaning，必须分类为 specification gap，停止并返回设计，不得当普通实施计划处理。

TEACHER_PLAN artifact owner 是 course owner / 对应 lesson change；允许写入者是获授权的执行 agent，且必须使用 TPA v2。教师教案必须先经 Independent Reviewer review，再由 user/course owner approval；没有真实 review、approval record ID 时，教案只能是 DRAFT。GUIDE 只能由获授权执行 agent使用 TPA v2，引用**同一课次**的 approved TEACHER_PLAN 路径、版本/内容标识和真实批准记录 ID；GUIDE 生成后还必须通过 Independent Reviewer 的 conformance review，确认其未新增 scope 且忠实于批准教案。该 conformance review 不是第二次业务 Gate A，也不改变教案；只有真实 conformance record 通过后才可生成派生资产。缺 ref、错课次、过期版本、伪造 ID、spec gap 或 ref 指向未批准文件时，必须停止并返回上游。下游不得反向改写 Brief、TEACHER_PLAN 或 frozen design；冲突只能返回上游并分类为 specification gap。不得并发写同一 artifact；每个对象使用单 writer handoff。

### J4. Teacher Plan Architect v2 前置 Slice（DRAFT）

旁路阶段 A 设计稿尚未成为批准规则。未来 v2 Slice 的 DRAFT 目标是让 Skill 成为**服从课程 authority 的操作方法**，不是让 Skill 重新决定课程。该 Slice 必须在课程级路线图批准之后、任何 L1–L10 教案修订之前完成并独立验收。

阶段 A 待纠偏项作为设计输入记录如下；是否冻结由后续设计评审/Gate A 决定：

| ID | Priority | DRAFT 待纠偏 | 候选验收方式 |
|---|---|---|---|
| SA01 | P1 | 两分钟 Exit Ticket 默认 1–2 个必答提示；3–5 题进入课后题库，或显式调整课内预算 | Skill 示例、教师模板和时间校验三处一致 |
| SA02 | P0 | 权威顺序为 locked UIC → frozen design specification → approved roadmap → direction-specific approved source object → Skill defaults；knowledge architecture Skill 只是分析方法 | 冲突示例能得到同一裁决，不由 Skill 覆盖上位输入 |
| SA03 | P1 | 未评审路线图候选 `10+15+18+10+25+10+2` 不得成为 Skill 默认预算 | Skill 不引用该数字为权威；预算来自 frozen design/批准教案 |
| SA04 | P0 | `LESSON_TEMPLATE.md` 与八模块等要求冲突时必须报告并停止，不得单方面宣布为“兼容历史” | 负向冲突样例返回 blocker，不静默合并 |
| SA05 | P1 | 渐进披露：核心流程/选择规则留在 `SKILL.md`；详细教师模板、学员模板、证据/图选择器如需拆分，只放一层 references 并去重 | 所有链接可解析；无 optional 悬空引用；同一规范只有一个规范位置 |
| SA06 | P0 | 阶段 A 冲突矩阵必须给每项明确 P0/P1/P2；若编号为 C01–C18，就以 18 项计数，不得摘要称 P0 14 项却无 priority 列 | 自动/人工核对行数、priority 非空、摘要计数与表一致 |

v2 Slice 明确不把固定三类图、手工 Git、每课全仓验证、自动 patch 清扫、100% clean/alignment、固定 Pause Points 或“物理”措辞恢复为默认规则。若 references 拆分方案在 Gate A 前未确定，该 Slice 不能启动；不得边实施边决定文件边界。

### J5. 小 Slice 顺序

| Slice | 目标 | 允许文件 | 验收 | 停止条件 |
|---|---|---|---|---|
| D-REVIEW | 关闭本规格 blocker、完成 formal design review | 仅 UIC / design spec / task-board；按明确授权 | 独立评审 finding 有处置，未越过 `DRAFT` | 发现新用户需求或课程范围变化，返回 UIC/用户 |
| A-RUBRIC-DRAFT | Formal Independent Design Review APPROVED 后，在 Gate A 前只创建/完善 DRAFT acceptance rubric | 唯一允许创建/修改的 spec 文件是 `docs/changes/course-curriculum-revision-2026-08/acceptance-rubric.md`；RED test plan 只能是该文件内嵌的固定章节，不是独立文件、不产生新路径、不属于六个 protocol | 用户可见 scope、non-goals、acceptance、risk，且 D01–D20/F01–F10 映射完整；不锁定 rubric、不运行 protocol、不记录 TESTS_RED/失败证据、不进入 ACCEPTANCE_FROZEN | rubric 暴露设计/范围/验收语义变化、需要改 UIC/设计、试图创建未命名 RED-plan 文件/路径、提前创建/运行 protocol、声称失败证据或写生命周期状态 |
| A-RED-PROTOCOLS | Gate A 已批准且 `DESIGN_FROZEN` 后，创建并运行六个精确 acceptance protocols | 六个 Phase 1 test protocol paths；production zero-diff；不改 production | protocol semantics 与冻结 rubric 一致，六个路径均有真实 run/evidence ref；只有真实预实现失败证据成立才记录 `TESTS_RED` | 未 `DESIGN_FROZEN`、Gate A 语义失效、production diff、修改冻结 semantics、缺 run/evidence ref、无真实失败却记录 TESTS_RED |
| A-ACCEPTANCE-REVIEW | 在 A-RED-PROTOCOLS 完成后进行独立验收复核 | 只读复核 acceptance rubric、六个 protocol、失败原因和 run/evidence；不修改 production | Independent Reviewer 形成真实 review record；Gate A 仍有效且 semantics 未变时才允许 `ACCEPTANCE_FROZEN` | review/ref 缺失、失败原因未闭环、Gate A 失效、semantics 漂移或试图在复核阶段修改 production；返回 DRAFT，不冻结 |
| I-ROADMAP | 仅把课程级设计落到路线图，处理当前保留候选稿 | 仅 `docs/COURSE_ROADMAP.md` | D01–D20、F01–F10、十课矩阵与时间边界可追溯；候选 disposition 有明确评审处置 | dirty blob 与获批基线不符、需改其他文件、发现 spec gap |
| I-LESSON-TEMPLATE | 在 TPA v2 前对齐课程模板与八模块/时间/双轨契约 | `docs/LESSON_TEMPLATE.md` | 模板 contract test 验证八模块、可调时间算术、概念负荷、双轨、教师教案→批准→GUIDE 单向顺序，以及不固化五 Pause/三图/Git/verify/100% 默认 | 模板仍与冻结课程约束冲突、需要改路线图或 Skill authority、或冲突被静默宣布兼容 |
| I-ROOT-CLAUDE | 对齐母仓库 Agent/维护者规则与课程 authority，不改学员版 | `CLAUDE.md` | 去除/改写旧 10–30、固定五 Pause、旧 22 节、verify/100% 等课程默认；保留真实安全、依赖、Git、学生包隔离；verify-project 定位遗留维护检查 | 根规则仍把课程旧默认当硬约束、把文字称 runtime hard control、或触碰 `student-package/templates/CLAUDE.md` |
| I-TLP-V2 | 修订 Teaching Lesson Plan v2 与唯一 Brief contract | `.agents/skills/teaching-lesson-plan/SKILL.md`、`.agents/skills/teaching-lesson-plan/references/lesson-design-brief-template.md` | TLP01–TLP10、渐进披露、authority、readiness、分钟加总和负向输入通过独立复核 | reference 未在 Gate A 精确注册、Stage A 纠偏未冻结、开始生成终稿或修改课程材料 |
| I-TPA-V2 | 修订唯一 canonical Teacher Plan Architect v2 | `.agents/skills/teacher-plan-architect/SKILL.md` | SA01–SA06、authority、Brief 版本消费、教案→独立 review→user/course-owner approval→GUIDE→conformance 边界与负向冲突行为通过独立复核 | TLP contract/template 未批准、TPA 复制 Brief schema、模板冲突未报告；任何新增 TPA reference 转为未来 change |
| I-TPA-SHIM | 将 Claude 兼容入口收敛为最小 fail-closed shim | `.claude/skills/teacher-plan-architect/SKILL.md` | 合法 frontmatter/触发描述、canonical exact path、无复制细则/schema/版本/默认/审批；canonical 缺失、不可解析或校验失败时停止 | shim 漂移、第二 authority、旧规则残留、canonical 不可解析仍继续执行 |
| I-L01-TP … I-L10-TP | 每次只修订一课教师教案 | 对应的单个 `LESSON_XX_TEACHER_PLAN.md` | 依赖、2–3 概念、双轨、90 分钟、可见成果、证据与边界通过独立复核 | 前置教案/Skill 未批准、需要改指南/脚本、试讲数据缺口被伪造 |
| R-L01-TP … R-L10-TP | 独立复核并批准对应教师教案 | 只读审查；如需修正另发回同一教案 Slice | finding 全部处置，明确批准或拒绝 | 不得在审查中顺手改学员指南 |
| I-L01-G … I-L10-G | 每次用已批准教案修订对应学员指南 | 对应的单个 `LESSON_XX_GUIDE.md` | 指南不新增范围，零基础动作、证据、安全与教案一致 | 教案未批准、指南暴露新 spec gap、需改教案 |
| I-L01-D … I-L10-D | 每次生成/校准一课派生资产 | dispatch 时精确列名的该课 HTML、图片、学生包文件 | 与批准指南内容一致；链接、可见结果和安全检查通过 | 需反向改指南/教案、资产工具写出范围、真实数据/Key 风险 |
| I-VALIDATE-* | 最后按一个能力一个 Slice 实现/校准验证、导出、恢复或打包 | 每个 Slice 精确列一个脚本能力及其测试/fixture | 先有失败验收证据；副作用、负向路径和实际命令名可证；无 placeholder 冒充成功 | 课程正文未稳定、脚本需宽泛改全仓、测试写出授权边界 |

`A-RUBRIC-DRAFT`、`A-RED-PROTOCOLS` 和 `A-ACCEPTANCE-REVIEW` 是三个不同的验收阶段：前者在 Gate A 前只准备精确路径 `docs/changes/course-curriculum-revision-2026-08/acceptance-rubric.md` 及其内嵌固定 RED test plan 章节，中者在 Gate A/`DESIGN_FROZEN` 后创建并运行六个 protocol，后者独立复核语义、失败原因和 evidence；不能把它们合并成一个 Slice，也不能在 A-ACCEPTANCE-REVIEW 中修改 production。只有随后进入 `ACCEPTANCE_FROZEN`，才按下列顺序实施 production。

在 `ACCEPTANCE_FROZEN` 后，Phase 1 production implementation 顺序是：`docs/COURSE_ROADMAP.md` → `docs/LESSON_TEMPLATE.md` → `CLAUDE.md` → TLP v2（含唯一 Brief contract）→ canonical TPA v2 → `.claude` 最小兼容入口。六个协议不是最后一个 production Slice；每个已实施对象都必须按 rubric 复跑相关协议并取得 GREEN/人工证据。`GLOSSARY.md` 与 `student-package/templates/CLAUDE.md` 仍是未来独立 change。表中的 `…` 表示十个**彼此独立、逐一调度**的 Slice，不是一次批量写十课。每课严格遵循“Lesson Design Brief → 教师教案 → Independent Reviewer review → user/course-owner approval → 学员指南 → Independent GUIDE conformance review → 派生资产”的单向顺序；GUIDE conformance review 不是第二次业务 Gate A，也不改变已批准教案；任何下游发现的 specification gap 返回 DRAFT，不能反向静默修改上游。

脚本/验证能力最后处理也不代表可以一个巨大脚本 Slice 收尾。至少应把课程验证命令、学员包导出、浏览器验收证据、恢复能力和 L10 打包分成不同验收对象。

### J6. 当前 active change 的 Phase 1 exact boundary

这是本 change 唯一进入 Gate A 候选的 Phase 1；下列路径是**完整、精确、无 glob、无“至少/可能/若选择”**的候选清单。它们尚未注册到 lifecycle JSON，也没有实施授权。

#### J6.1 Candidate production files（exact）

1. `docs/COURSE_ROADMAP.md`
2. `docs/LESSON_TEMPLATE.md`
3. `CLAUDE.md`
4. `.agents/skills/teaching-lesson-plan/SKILL.md`
5. `.agents/skills/teaching-lesson-plan/references/lesson-design-brief-template.md`
6. `.agents/skills/teacher-plan-architect/SKILL.md`
7. `.claude/skills/teacher-plan-architect/SKILL.md`

TPA reference 文件不在 Phase 1 production list。课程 lesson briefs、任何 TEACHER_PLAN/GUIDE、HTML、图片、学生包、`student-package/templates/CLAUDE.md`、GLOSSARY 和脚本治理均属于未来 change/Slice，不得由本 Phase 1 boundary 推入。根 `CLAUDE.md` 与 `.claude` shim 是本 Phase 1 的两个明确兼容治理对象，不代表学员版或第二 TPA authority。

#### J6.2 Candidate test files（exact）

1. `docs/changes/course-curriculum-revision-2026-08/verification/tlp-tpa-forward-test.md`
2. `docs/changes/course-curriculum-revision-2026-08/verification/tlp-tpa-negative-test.md`
3. `docs/changes/course-curriculum-revision-2026-08/verification/tlp-tpa-trigger-boundary-test.md`
4. `docs/changes/course-curriculum-revision-2026-08/verification/tlp-tpa-schema-version-test.md`
5. `docs/changes/course-curriculum-revision-2026-08/verification/phase1-roadmap-conformance-test.md`
6. `docs/changes/course-curriculum-revision-2026-08/verification/phase1-teacher-plan-template-contract-test.md`

J6 的验收生命周期分成三个不可合并的阶段：`A-RUBRIC-DRAFT`（Formal Independent Design Review APPROVED 后、Gate A 前，只准备精确路径 `docs/changes/course-curriculum-revision-2026-08/acceptance-rubric.md` 及其内嵌固定 RED test plan 章节）；`A-RED-PROTOCOLS`（Gate A/`DESIGN_FROZEN` 后，授权 writer 创建并运行六个 protocol，保持 production zero-diff，并以真实预实现失败证据为 `TESTS_RED` 前提）；`A-ACCEPTANCE-REVIEW`（Independent Reviewer 只读复核 rubric、protocol semantics、失败原因和 run/evidence，Gate A 仍有效且 semantics 未变才允许 `ACCEPTANCE_FROZEN`）。RED test plan 不产生独立文件/路径，也不属于六个 protocol；协议语义与外部 run/evidence record 分开，任何阶段都不以修改 production 解决失败。

这些 Markdown 是 acceptance test protocol/specification 的候选路径；当前不存在、未注册、未运行。Gate A 前只能在 DRAFT `docs/changes/course-curriculum-revision-2026-08/acceptance-rubric.md` 的内嵌固定 RED test plan 章节中呈现 scope、non-goals、acceptance 和 risk；该章节不是独立文件、不会产生新路径，也不属于六个 protocol。只有 Gate A 后进入 `DESIGN_FROZEN`，授权 acceptance-test writer 才能创建并运行六个 protocol，且必须保持 production zero-diff。只有真实预实现失败证据成立后才记录 `TESTS_RED`，再由 Independent Acceptance Review 复核；实际运行结果必须由 `acceptance-rubric.md` 引用真实 task/thread run event ID 或规范 evidence record；不得修改已冻结的测试语义来填写结果。`skill-creator quick_validate.py` 的外部命令结果由上述 protocol 引用，不把 Skill 工具目录复制到本仓库。如果规范要求仓库 report file 承载运行结果，必须停止并报告，不得自行新增 report 路径。

`phase1-roadmap-conformance-test.md` 负责核对 D01–D20/F01–F10 在课程级 baseline 中的存在、一致性和无虚假能力声称，并标出哪些只能由未来 programme evidence 验证。`phase1-teacher-plan-template-contract-test.md` 负责核对八模块、可调时间算术、2–3 核心概念与 exposure ledger、教师/学员双轨、教师教案→批准→GUIDE→GUIDE conformance 的单向顺序，以及不把固定五 Pause、三类图、手工 Git、verify 或 Working Tree 100% Clean当作通用默认。

#### J6.3 Candidate report files（exact）

无。Adversarial Design Readiness self-check 作为本 `design-specification.md` 的独立章节保存；评审线程消息是外部 review record，不在本仓库伪造 report 文件。

#### J6.4 S1E forbidden files and side effects（exact rule）

S1E 允许写入集合仅为：

1. `docs/changes/course-curriculum-revision-2026-08/design-specification.md`
2. `.agent-workflow/task-board.md`

因此，下列路径和所有不在该允许集合中的写入均为 S1E forbidden：
- `docs/changes/course-curriculum-revision-2026-08/user-intent-contract.md`

- `docs/COURSE_ROADMAP.md`
- `docs/LESSON_TEMPLATE.md`
- `CLAUDE.md`
- `.agents/skills/teaching-lesson-plan/SKILL.md`
- `.agents/skills/teaching-lesson-plan/references/lesson-design-brief-template.md`
- `.agents/skills/teacher-plan-architect/SKILL.md`
- `.claude/skills/teacher-plan-architect/SKILL.md`
- `docs/changes/course-curriculum-revision-2026-08/acceptance-rubric.md`
- `.agent-workflow/changes/course-curriculum-revision-2026-08/delivery-state.json`
- `.agent-workflow/delivery-state.json`
- `.agent-workflow/project-identity.json`
- `package.json`
- `scripts/`
- `src/`
- `student-package/`
- `lessons/`
- `docs/assets/`
- 任意 `LESSON_XX`、`LESSON_XX_V2`、`LESSON_XX_V3` 教案/指南/历史文件

禁止暂存、提交、push、切分支、创建 worktree、运行会写 `dist`/日志/fixture/工作树的测试。Acceptance rubric、Phase 1 test protocol files 和任何 future report 只有在各自授权 Slice 才能创建；它们不因出现在候选列表中而获得当前写入权。`student-package/templates/CLAUDE.md` 明确禁止写入本 Phase 1。

#### J6.5 Phase 1 gate impact

Phase 1 只建立课程级批准基线、`LESSON_TEMPLATE.md` 契约、根 `CLAUDE.md` 维护规则、canonical TLP/TPA v2（含最小 `.claude` shim）和六个接口/契约验收协议边界；它不冻结十课正文，不产生 Brief，不产生 GUIDE/派生资产，不校准脚本，不改变 lifecycle。Phase 1 `ACCEPTED`（若未来门禁真的批准）只表示这七个 production 对象与六个 protocol 对象完成本 Phase 1 的独立验收，不表示 L1–L10 或完整 programme goal 已完成；它不再重走本 Phase 1 的前置 Design Review、Gate A 或 Acceptance Freeze。之后每个 lesson/guide/asset/script future change 必须按自身 scope 重新进入适用的 DRAFT、Design Review/Gate A、acceptance/test 和 implementation 门禁。

J6 的 7/6/0 计数不改变三个验收阶段的职责：A-RUBRIC-DRAFT 只产生 DRAFT 规范准备材料；A-RED-PROTOCOLS 才产生六个 protocol 及真实预实现失败证据；A-ACCEPTANCE-REVIEW 只产生独立复核记录并决定是否满足 ACCEPTANCE_FROZEN 前提。三阶段均不授权 production 写入。

## K. 设计开放项与默认值

这里只保留无法从 UIC 或当前仓库事实唯一得出的事项。默认值用于继续设计，不构成用户 Gate 0；独立评审可在冻结前要求调整。

| 开放项 | DRAFT 默认值与理由 | 冻结前需要的证据 / 决策者 |
|---|---|---|
| 教师仓库外真实调用平台和课堂展示方式 | Future operations change 采用教师受控账户、屏幕演示、预脱敏输入输出、无凭证分发；具体供应商不进入课程概念 | 教师运营 owner 在 future operations change 提供安全操作记录；不阻断当前 Phase 1 |
| 每课真实时长和删减顺序 | Future lesson Slice 使用 F4 预算，记录每段时长、完成率、助教接管和未完成项；优先删工程背景，不删安全/实操/成果 | 课程 owner 在对应教案批准时处置；不阻断当前 Phase 1 |
| 六种模式的最终中英文命名 | 本 DRAFT 采用 G 节六项作为唯一课程候选，并保持三深三浅；不保留并列命名方案 | Formal review 只检查与 UIC D13/approved roadmap 的一致性 |
| Teacher Plan Architect v2 references | Phase 1 明确不创建 TPA references；TLP reference 是唯一 Brief schema owner；任何未来 TPA reference 另立 change 并先给出一个精确路径决定 | 不阻断当前 Phase 1；不得在实施中临时新增引用 |
| 产品决策与开发启动包精确目录 | L10 future change 冻结一份明确目录：问题/非目标、数据契约、Mock 样例、验收证据、独立 finding/处置、三链、红线、未完成工程清单；不含生产系统 | L10 change 的 design/acceptance review |
| 自动能力实现范围 | 当前不实现；未来先定义人工流程，再按一个能力一个 change/Slice 建立失败验收、负向测试和副作用边界 | Future engineering change；不阻断当前 Phase 1 |

以下不是开放项：全局 mirror missing 不影响本仓库 lifecycle authority；不存在的脚本不得冒充能力；V2/V3 必须保护；Teaching Lesson Plan Stage A 仅为 `APPROVED WITH REQUIRED CORRECTIONS` 且 Stage B 未授权；普通措辞微调不能用来绕过 Gate A。

---

本 DRAFT 在 S1E 结束时应保持：lifecycle 仍为 `DRAFT`；`acceptance-rubric.md` 尚未创建；Phase 1 candidate production/test/report files 尚未注册；`docs/COURSE_ROADMAP.md` 仍是 `PRESERVE_UNREVIEWED_DRAFT`；未发生暂存或提交。

## L. Central artifact / approval decision table

本表是唯一的 artifact、state、owner、writer 和 approval/ref 语义表。除 lifecycle 外，所有批准字段都必须指向真实对象、事件或记录 ID；“之前存在过”不能代替当前字段中的 ref。当前 DRAFT 不伪造未来 approval ID。

| Artifact / state | Authoritative owner | Allowed writer | Required real ref field | Normal behavior | Invalid / mismatch | Fallback | Gate impact |
|---|---|---|---|---|---|---|---|
| Per-change lifecycle | `delivery_gate.py` + per-change delivery state | `delivery_gate.py` only | Tool-generated state path and transition evidence | State JSON agrees with active pointer and workflow status | Missing/contradictory state, hand-edited field, wrong change | Stop; produce State Repair Needed, no transition | Blocks all gate work |
| Locked UIC | User-confirmed intent / design owner | Authorized design writer within approved Slice | Actual source thread IDs, UIC path/version, user amendment ID when changed | D01–D20 resolve user scope; no Temp dependency | Missing source record or changed meaning without amendment | Return to user/reviewer; do not infer | Blocks design freeze |
| Frozen design specification | Independent design authority after review + user Gate A | Design writer before freeze; no implementation writer | Actual review decision record ID + user Gate A record; base commit | Design governs course-level choices under locked UIC | “Approved” prose without record, unresolved fork, stale base | Remain DRAFT; classify spec gap | Blocks Phase 1 implementation |
| Approved roadmap baseline | Course design owner after Gate A | Roadmap Slice writer only | Exact file path + blob/commit + approval record ID | Roadmap refines frozen design without adding scope | Dirty candidate treated as approved, blob mismatch, missing approval | Preserve candidate unreviewed; stop | Blocks downstream lesson work |
| TLP Brief contract | Course design owner (schema authority at exact TLP reference path) | Authorized execution agent using TLP v2 | Exact reference path + `contract_version` + design version ref | One exact reference defines fields/readiness; Skill is method only | Duplicate schema, missing version, dangling reference | TLP stops and reports schema gap | Blocks TLP→TPA interface |
| Per-lesson Design Brief | Course design owner / corresponding lesson change | Authorized execution agent using TLP v2; single-writer handoff | `course_spec_ref`, `roadmap_ref`, source lesson ID, exact Brief path/version | Persistent file at `docs/changes/.../lesson-briefs/LESSON_XX_DESIGN_BRIEF.md`; authorized agent validates schema/authority/time; `HANDOFF_READY` means completeness only | Session-only output, concurrent writer, wrong lesson, changed goal/non-goal, stale spec ref | Keep `DRAFT`; return to design; no TPA consumption | Blocks corresponding TEACHER_PLAN |
| Teacher Plan artifact | Course owner / corresponding lesson change | Authorized execution agent using TPA v2; single-writer handoff | `brief_ref` + `contract_version` + exact plan path/version | Authorized agent renders eight modules from a valid Brief; Skill is method only | Missing/stale Brief, schema mismatch, invented capability, concurrent writer | Stop; no GUIDE | Blocks teacher-plan review/approval |
| Teacher Plan review/approval | Independent Reviewer (review); user/course owner (business approval) | Reviewer records review; user/course owner records approval; TPA cannot self-approve | Actual review event ID + approval record ID, decision, version/hash | Approved plan becomes sole direct source for same-lesson GUIDE | Self-approval, wrong version, stale/absent record, semantic change during review | Keep plan DRAFT; return for revision or spec-gap classification | Blocks GUIDE |
| Student GUIDE artifact | Course owner / corresponding lesson change | Authorized execution agent using TPA v2 after approved plan; single-writer handoff | Same-lesson approved `teacher_plan_ref` + actual approval record ID + guide version | GUIDE faithfully renders approved plan for learners; no new acceptance meaning | Wrong lesson, unapproved plan, reverse change, stale version, concurrent writer | Stop and return to plan; no conformance review or derived asset | Blocks GUIDE conformance |
| Student GUIDE conformance review | Independent Reviewer | Reviewer records conformance decision; GUIDE writer cannot self-approve | Actual conformance event/record ID, GUIDE version/hash, source plan approval ref | Review confirms GUIDE is faithful, in scope, and safe; it is not a second business Gate A and does not change the plan | Missing/stale record, new scope, spec gap, reviewer self-approval | Return GUIDE upstream; do not mutate approved plan silently; classify spec gap | Blocks derived assets |
| Derived asset | Asset maintainer / approved production writer | Future per-lesson asset writer or approved export tool after GUIDE conformance | Exact GUIDE ref + GUIDE conformance record + asset version | HTML/image/student package derives only from conformant GUIDE | Asset adds scope, missing source, placeholder evidence, no conformance record | Reject asset; return upstream | Blocks packaging/release |
| Phase 1 test protocol | Acceptance-test writer after `DESIGN_FROZEN`; protocol semantics prepared in the embedded RED test plan chapter of `docs/changes/course-curriculum-revision-2026-08/acceptance-rubric.md` | Authorized acceptance-test writer; protocol writer is not lifecycle approver | Exact protocol path + input fixture version; external run/event/evidence ref is recorded separately | Six Markdown protocols define frozen semantics; real pre-implementation failure evidence may then justify recording `TESTS_RED` | Protocol written/run before `DESIGN_FROZEN`, semantics edited to fit result, missing external evidence, writes outside list | Mark protocol/evidence invalid; no `TESTS_RED`, `ACCEPTANCE_FROZEN`, or implementation | Blocks Phase 1 acceptance |

`HANDOFF_READY` is therefore a completeness state, not an authorization state. `approved`, `frozen`, `accepted`, `requires prior` and `depends on` are not satisfied by a chat assertion: the current field must hold a resolvable path/hash/event/record ID. A future task-board line may coordinate work but cannot serve as lifecycle approval unless the authorized workflow explicitly records the approval event.

## M. Direction-aware authority and dependency behavior

| Downstream artifact | May read / refine | May not override | Direct source rule | Conflict action |
|---|---|---|---|---|
| All lessons and Skills | Locked UIC, frozen design specification, approved roadmap | None of the three | Skill defaults are lowest | Stop and classify specification gap |
| Per-lesson Brief | Frozen course constraints, approved roadmap, approved single-lesson target | UIC, frozen design, roadmap | Brief may refine activities/evidence without changing goal, non-goal, or acceptance meaning | Return to design; keep Brief DRAFT |
| TEACHER_PLAN | Approved Brief and approved upstream material | Brief contract, frozen design, roadmap, UIC | Authorized execution agent using TPA v2 writes; no direct GUIDE generation before Independent Reviewer review + user/course-owner approval | Stop; no self-repair of Brief |
| GUIDE | Approved same-lesson TEACHER_PLAN and its approval record | TEACHER_PLAN, Brief, frozen design | Authorized execution agent using TPA v2 writes; TEACHER_PLAN is the direct source; no sibling lesson borrowing without explicit ref | Stop on wrong/stale/missing ref; return to plan if spec gap |
| GUIDE conformance review | Generated same-lesson GUIDE and approved plan ref | GUIDE, TEACHER_PLAN, Brief, frozen design | Independent Reviewer records conformance only; it cannot rewrite the plan and is not a second business Gate A | Stop on new scope/spec gap; no derived asset |
| Derived asset | Approved same-lesson GUIDE plus GUIDE conformance record | GUIDE, TEACHER_PLAN, Brief, frozen design | Authorized asset writer/export tool derives only from conformant GUIDE | Reject asset and return upstream |

This replaces a single linear “approved lesson artifacts” authority phrase. The dependency graph points downward; no downstream writer can mutate an upstream source. A missing or conflicting authority is a blocker, not an invitation to choose the most convenient document. A single writer owns each artifact at a time; Skills are never artifact owners or lifecycle writers.

## N. Normal, invalid, compatibility, and fallback closure

| Situation | Expected behavior | Evidence / state |
|---|---|---|
| Normal Phase 1 | Formal Independent Design Review APPROVED → A-RUBRIC-DRAFT before Gate A → user Gate A/`DESIGN_FROZEN` → A-RED-PROTOCOLS creates/runs six protocols with production zero-diff → real failure evidence records `TESTS_RED` → A-ACCEPTANCE-REVIEW → `ACCEPTANCE_FROZEN` → production order ROADMAP → LESSON_TEMPLATE → root CLAUDE → TLP → canonical TPA → `.claude` shim → rubric rerun | Exact seven production/six test candidate paths, real version refs, no lesson writes; A-RUBRIC-DRAFT, protocol semantics and external run/evidence refs remain separate |
| Normal lesson future | Authorized execution agent using TLP v2 writes Brief `DRAFT` → validates `HANDOFF_READY` → authorized execution agent using TPA v2 renders plan → Independent Reviewer review → user/course-owner approval → authorized execution agent renders GUIDE → Independent GUIDE conformance review → derived asset | Each object has path/version/ref; review, approval and conformance are real event IDs; conformance is not a second business Gate A |
| Invalid input | Candidate roadmap, missing UIC/base ref, nonexistent command, unverified capability, or unknown lesson target | Stop, keep DRAFT, emit finding; never relabel candidate as frozen/implemented |
| Root policy / shim invalid | Root `CLAUDE.md` still hard-codes old course defaults, or `.claude` shim duplicates/loses canonical path, schema, version or approval boundary | Conformance/negative protocol fails; no production acceptance; shim stops if canonical is missing, unresolvable or invalid |
| Invalid handoff | Missing Brief, wrong `contract_version`, wrong lesson, stale plan approval, forged ref, concurrent writer | Authorized agent refuses downstream render; no placeholder or guessed ref; return to single-writer handoff |
| Compatibility / migration | V2/V3/history remain preserved read-only; current dirty roadmap remains `PRESERVE_UNREVIEWED_DRAFT` until approved | Hash/blob or explicit historical path evidence; no batch synchronization |
| Tool unavailable | L7 uses teacher-preconfigured browser fallback; L8 uses isolated new review session; teacher demo may show Mock | Fallback source and isolation event recorded; review not skipped |
| Data/security failure | Real/sensitive data detected before AI entry or key/config seen in artifact | Refuse action, quarantine/replace with Mock or sanitized fixture, notify teacher/assistant; no continued processing |
| GUIDE conformance failure | GUIDE adds scope, changes acceptance meaning, lacks approved-plan ref, or reviewer cannot resolve its source | Independent Reviewer records non-conformance; return to GUIDE/plan/design as appropriate; no silent plan edit and no derived asset |
| Missing L10 material | Package builder refuses incomplete package; output remains non-production decision/start package | Missing-item list and human decision; placeholder is a failure, not evidence |
| Environment failure | Individual learner blocked >3 minutes → assistant takes over; class mainline continues | Preflight result, takeover record, completion/absence pack record |

## O. Five adversarial perspectives

| Perspective | Attack / likely rejection | Design finding and disposition | Residual risk / owner |
|---|---|---|---|
| Product | “十课仍像工程训练，业务主管看不见连续价值。” | D2/D3/D2a force every lesson to a department-prototype action, visible result, business judgment and weekly continuity; engineering labels move to teacher/background | 真实部门迁移仍需试讲观察；course owner owns pilot evidence |
| Architecture | “Brief、Skill、教案、指南各有一套 authority，最终会循环或漂移。” | L/M define course/design owners, authorized single writers, one TLP Brief schema owner, TPA method-only rendering, direction-aware refs, real review/approval/conformance IDs, no downstream write-back, exact Phase 1 boundary | Future implementers may add convenience refs or concurrent writers; reviewer must reject any new owner/schema or Skill approval power |
| Testability | “PASS 标题、文件存在或 `verify-project.ps1` 会伪造业务通过。” | B/I/N/R separate structural auto checks, human judgment, external run/event evidence, deferred programme evidence, and nonexistent capability; Phase 1 has six exact Markdown protocols | Lesson behavior and live classroom evidence remain future changes; acceptance-test writer must not promote docs-only checks or edit frozen semantics |
| Failure / recovery | “工具不可用、环境卡住、Brief 错版本或自动恢复失败时，课程会卡死/越权。” | N defines TA takeover, isolated review session, Mock fallback, fail-closed refs, bounded stop and no placeholder; automatic restore remains unimplemented | Teacher operations must rehearse fallback; no promise of one-click recovery |
| Operations / data safety | “教师真实调用、敏感数据或密钥可能通过截图、Mock、ZIP、Skill 进入仓库。” | H, N and D3 enforce external teacher environment, pre-AI de-identification, Mock-only learner artifacts, no-key package, package refusal on missing/unsafe items | External teacher platform controls are future operations change; operations owner supplies evidence before real demo |

No perspective is treated as formal approval. Residual risks are either assigned to a future change or explicitly retained as a non-production boundary.

## P. End-to-end scenario walkthroughs

这些 walkthroughs 是设计可审性证据，不是运行结果，也不创建测试文件。

| Scenario | Start state / input | Normal path | Invalid / mismatch branch | Fallback / terminal evidence |
|---|---|---|---|---|
| P1 L1 first entry + environment failure | Zero-code/Git/MCP learner; preflight finds one local browser failure | Assistant takes over after >3 minutes; learner uses preconfigured entry, makes one Mock business choice and produces visible card | Learner asked to configure MCP/key or class waits for environment repair | Takeover record + visible Mock result + absence/补课 pack if needed; class mainline continues |
| P2 L3→L4 contract to thin slice | Approved L3 business/data/acceptance artifacts exist; no real data | Future lesson execution agent uses the approved Brief/plan to complete one L4 course-material or prototype task; TPA only renders the teacher plan/GUIDE and does not implement the L4 slice | Missing field, changed acceptance meaning, wrong lesson ref or unapproved plan | Stop and return specification gap; no GUIDE/derived asset; valid future lesson task has traceable evidence |
| P3 sensitive/real data before AI | User tries to paste real customer record into an AI prompt | Preflight data check refuses; assistant replaces with sanitized/Mock fixture; teacher real call remains external | Key/config or unsanitized payload appears in repo/material/package | Refusal log, sanitized fixture, no downstream processing; security owner notified |
| P4 L7 single entry tool failure | Learner uses teacher-preconfigured browser acceptance entry; backend tool unavailable | Teacher/assistant switches to documented Mock or degraded evidence path; learner still identifies MCP minimum model | Learner is asked to mount a second MCP or MCP is described as business API | Evidence marks degraded source and limitation; no student service configuration; lesson can close with bounded result |
| P5 L8 brand tool unavailable | Candidate evidence and review request exist | Fresh isolated review session receives only approved candidate/spec/evidence, produces finding | Existing development context is reused, tool error is treated as reason to skip, or ref points to wrong candidate | New isolated session event ID; if isolation cannot be established, stop and do not call review passed |
| P6 L10 missing material | Learner has a mostly complete package but one evidence/redline item is absent | Package inventory identifies missing item; learner labels product decision/development-start package and lists IT next step | Builder creates placeholder or says production-ready despite missing item | Packaging refuses success; human decision record lists gap; no production claim |
| P7 historical candidate compatibility | Dirty roadmap candidate and V2/V3 files coexist with new DRAFT spec | Design reads candidate/history as evidence only; preserves their blobs and paths | Writer treats candidate “Official” text as approved or batch-syncs V2/V3 | Stop, preserve candidate, record blob/path evidence; route to future roadmap Slice |
| P8 absence recovery | Learner misses one class and lacks prerequisite artifact | Completes standard 20–30 minute teacher-case absence pack, passes minimum evidence check, then resumes personal prototype | Learner jumps directly to personal mainline with missing prerequisite or submits a second full weekly project | Assistant/teacher records completion; personal mainline remains paused until pack passes |

## Q. Pre-mortem and mitigation

假设课程修订已投入使用但失败，优先可能原因、预防和探测如下：

| Failure mode | Early signal | Prevention | Detection / mitigation owner |
|---|---|---|---|
| 术语过载伪装成“识别级” | 学员能复述名词却不能作一个业务判断；90 分钟超时 | D2a ledger 分开 named/plain/background/judgment；每课只保留核心判断 | 教师试讲记录、Exit Ticket 1–2 提示；course owner 回退 lesson DRAFT |
| 教师真实调用泄漏 | 截图/日志/ZIP 出现 Key、配置、真实记录或未脱敏字段 | 调用完全仓库外；AI 前脱敏；Mock/脱敏白名单；助教复核 | 课前包扫描 + 人工展示审查；operations owner 拒绝发布 |
| 自动能力被虚构 | 材料出现 npm verify/doctor/test:ui、一键恢复、100% PASS | B/N 精确能力审计；不存在命令不得进入验收；future scripts 单独 change | 命令/路径负向检查；teacher-plan reviewer 将 finding 返回 DRAFT |
| 下游反向漂移 | GUIDE 新增教师计划未批准的目标，或 asset 改写 acceptance | L/M direction-aware refs；真实 approval ID；下游禁止回写 | Interface/negative test；TPA 停止并标 spec gap |
| 90 分钟数据失真 | 教案同写 90 分钟但无 Task 实测；助教接管堆积 | F4 预算仅为上限；逐课记录实测、完成率和删减顺序 | Pilot dashboard/manual log；课程 owner 调整单课 Slice |
| Placeholder 伪成功 | L10 ZIP 或证据报告包含 placeholder，却标 PASS/生产就绪 | Package refusal on missing assets；placeholder 是失败 | Package/test record + manual review；IT owner拒收 |
| Brief/approval ref 过期 | TPA 读取旧 Brief 或同课次不同版本 | contract_version、path/hash、approval event ID 必填；不接受 prior-existence | Interface schema test；TPA fail-closed |
| 历史资料被批量覆盖 | V2/V3 hash 或 dirty roadmap blob 改变 | Phase 1 禁止 lesson/history；candidate preserve rule | Git blob/status checkpoint；执行线程停止并报告 |
| 根 CLAUDE 陈旧规则回流 | 新教案/Skill 仍被要求 10–30 人、固定五 Pause、verify/100% 或 22 节治理 | 根 CLAUDE 只做母仓库维护规则；课程参数引用 locked/frozen/approved authority；student-package CLAUDE 独立保护 | roadmap/template conformance + root-policy scan；course owner 将冲突退回 DRAFT |
| `.claude` shim 漂移或失效 | 兼容入口复制八模块/Brief schema/版本/审批，或 canonical 不可解析仍继续 | shim 只保留合法 frontmatter/触发描述和 canonical exact path；解析/校验失败 fail-closed | trigger/schema/negative protocol；Skill owner 停止入口并记录 mismatch |
| TESTS_RED 被无证据提前记录 | 没有真实预实现失败就出现 TESTS_RED，或协议为填结果被改写 | Gate A 前只展示 `docs/changes/course-curriculum-revision-2026-08/acceptance-rubric.md` 的内嵌 RED test plan 章节；DESIGN_FROZEN 后 zero-diff 运行；失败证据先于 state record | acceptance-test writer + Independent Acceptance Review 拒绝 transition |

## R. D01–D20 / F01–F10 proposed verification mapping

下表明确区分 **Phase 1 verification** 与 **Deferred programme evidence**。Phase 1 只验证课程级 baseline、`LESSON_TEMPLATE.md` contract、根 `CLAUDE.md` 维护规则、canonical TLP/TPA 与 `.claude` shim/interface protocol 是否忠实表达 UIC 和仓库事实；它不能证明十课已经试讲、课堂已稳定、L7/L8/L10 产物已生成或 programme 已完成。Deferred evidence 有 owner 和触发 change，但不阻塞 Phase 1 `ACCEPTED`。`A`=结构/命令可自动核对，`M`=教师/主管人工判断，`E`=持久路径、hash、事件或试讲证据。

| ID | Phase 1 verification（当前可验证；不等于课堂成立） | Deferred programme evidence（未来 owner / trigger；不作为 Phase 1 gate） | Mode |
|---|---|---|---|
| D01 | `phase1-roadmap-conformance-test` 与 template/Skill protocols 检查学员入口不把代码、Git、MCP、终端设为必需；不能证明真实学员可进入 | L1 lesson Slice 的预检、助教接管和业务判断观察；course owner 在首轮试讲 change 提供 | A + M |
| D02 | roadmap conformance 检查十课 first/revisit/integrate 结构和首概念不推迟到 L5；不能证明迁移已发生 | L1–L10 lesson sequence 与跨课产物证据；course owner 在 lesson programme change 提供 | A + M |
| D03 | template contract 要求首次核心概念四步卡、3–5 分钟及“刚完成实操”回指；不能证明教师实际讲清 | 每课教案 sample 与课堂观察；对应 lesson writer/Independent Reviewer 在教案 Slice 提供 | A + M |
| D04 | template/roadmap/Skill protocol 分离 2–3 个 mastered concepts、named exposure 和 assessed judgment，禁止复合名折算；不能证明认知负荷可行 | D2a ledger 的逐课试讲、Exit Ticket 和教师判断；course owner 在 lesson trial 提供 | A + M |
| D05 | roadmap/template contract 保留 10–15 人、1 教师+1 助教字段和 ownership；不能证明班级运行 | 班级 roster、助教运行与接管记录；operations owner 在 future delivery change 提供 | A + E |
| D06 | roadmap/template protocol 校验 5 周/每周 2 节/间隔 2–3 天与单课 ≤90 的结构约束；不能证明排期可执行 | 真实排期与每课 pilot log；course owner 在 lesson/operations change 提供 | A + E |
| D07 | template/roadmap conformance 校验 L1 前 preflight 与 >3 分钟接管政策存在；不能证明现场响应 | preflight/takeover event record；teacher/TA owner 在首次 delivery change 提供 | A + M |
| D08 | template contract 区分课堂可见成果、10–15m 微任务和每周单一 30–45m 成果；不能证明学员完成 | 逐课产物与提交记录；lesson writer/course owner 在 lesson Slice 提供 | A + M |
| D09 | baseline protocol 检查缺课包与“先通过再恢复主线”语义；不能证明补课包实际可完成 | P8 completion record；teacher/TA owner 在 delivery pilot 提供 | A + M |
| D10 | roadmap/template contract 表达教师异常工作台与学员个人原型双轨；不能证明双轨课堂稳定 | D3 双轨产物与教师观察；course owner 在 lesson Slice 提供 | A + M |
| D11 | roadmap/Skill/interface protocol 检查 Mock 四方责任、仓库外教师调用、无真实 Key/自配 MCP；不能证明外部平台执行安全 | Mock/secret scan 与教师环境 record；operations owner 在 future operations change 提供 | A + M |
| D12 | template/Skill contract 和 negative protocol 检查 AI 前脱敏、仓库/材料/学员包无密钥/未脱敏输入；不能证明每次展示安全 | 真实包扫描与人工展示审查；operations owner 在 package/delivery change 提供 | A + M |
| D13 | roadmap conformance 检查六模式名称、三深三浅和“不搭六套系统”；不能证明主管能作出模式选择 | L8 selection/disposition record；lesson owner 在 L8 change 提供 | A + M |
| D14 | template/Skill protocol 检查 L7 host/client/server/tool 与“非业务 API”、单一预配置入口；不能证明浏览器验收可用 | browser-entry record 与口述检查；L7 lesson/operations owner 在 future change 提供 | A + M |
| D15 | interface/roadmap protocol 检查 L8 隔离审查与工具不可用切隔离新会话；不能证明审查实际独立 | review event ID 与 context manifest；Independent Reviewer 在 L8 change 提供 | A + M |
| D16 | roadmap/template contract 检查开发工具链、业务 API、模型 API 三链分开；不能证明真实调用责任可执行 | three-chain artifact 与 source mapping；L9 lesson owner 在 future change 提供 | A + M |
| D17 | roadmap conformance 检查 Mock/脱敏互评、产品决策与开发启动包、非生产就绪措辞；不能证明 L10 包完整 | package inventory 与 peer-review record；L10 owner 在 package change 提供 | A + M |
| D18 | template/Skill protocol 检查双 Commit/CEO 决策树仅为比喻/处置框架；不能证明主管理解边界 | concept explanation 与 boundary check；lesson owner 在对应 lesson review 提供 | A + M |
| D19 | roadmap conformance 与 negative protocol 检查不存在 doctor/test:ui/verify 不得冒充已实现，`verify-project.ps1` 不作课堂证明；不能证明未来脚本能力 | future script change 的 command/path evidence；script owner 在独立 validation change 提供 | A + M |
| D20 | roadmap/template/root-CLAUDE/shim protocol 检查 V2/V3 保留、教案→批准→GUIDE→conformance→派生单向、canonical TPA 单一 authority 及 dirty roadmap preserve；不能证明历史资料未被未来操作覆盖 | path/hash/status checkpoint 与真实 approval/conformance refs；reviewer/course owner 在各 lesson change 提供 | A + E |
| F01 | `phase1-roadmap-conformance-test` 检查课程级 baseline 不宣称 IT 直接落地/生产就绪；L10 具体包仍未在 Phase 1 生成 | L10 package review 与 wording scan；L10 owner 在 future package change 提供 | A + M |
| F02 | template/Skill contract 检查四步法第四步必须回指刚完成实操；不能证明每张课卡执行 | concept-card sample；lesson writer/Independent Reviewer 在 lesson Slice 提供 | A + M |
| F03 | roadmap/template/Skill negative protocol 检查事前脱敏、外部教师调用、无密钥产物三边界；不能证明外部教师环境安全 | safety scan + teacher environment record；operations owner 在 future operations change 提供 | A + E |
| F04 | `phase1-roadmap-conformance-test` 以当前 package/scripts/CLAUDE/shim inventory 检查 npm、路径、AGENTS、canonical/shim 声称与实体一致；不能证明不存在能力未来会实现 | command/path/shim-resolution evidence；script/Skill owner 在 independent validation change 提供 | A |
| F05 | roadmap/template contract 检查“一键恢复”被写成有界停止/助教恢复，自动能力另立 change；不能证明恢复流程可用 | lesson wording、recovery walkthrough 与 failure test；lesson/script owner 在 future change 提供 | A + M |
| F06 | template/roadmap protocol 检查每课可见成果与课间/每周成果不混称；不能证明十课产物均存在 | roadmap/lesson matrix；course owner 在 lesson programme change 提供 | A + M |
| F07 | L7 contract 检查“无需自行配置 MCP 服务”与“学习 MCP 最小模型”并存；不能证明学员口述达标 | L7 boundary explanation；lesson owner 在 L7 review 提供 | A + M |
| F08 | roadmap/template/Skill/root-CLAUDE/shim protocol 检查规则文本、workflow gate、runtime hard control 分层，并拒绝 shim 漂移/不可解析继续执行；不能证明仓库有 runtime hook | H4 control table、shim negative check 与 future negative runtime claims；architecture/Skill/script owner 在 validation change 提供 | A + M |
| F09 | roadmap conformance 检查六模式缺失/误定位处置已闭环；不能证明主管能在案例中选型 | G/D2a/L8 decision record；L8 lesson owner 在 future lesson change 提供 | A + M |
| F10 | template contract 校验 90 分钟上限/预算和可调时间算术；不能把未测数据写成“适配” | real pilot time log、完成率、接管和删减记录；course owner 在 lesson trial change 提供 | A + E |

当前 `delivery-state.json.test_files` 仍为空；上述六个路径只是冻结后可注册的 Markdown acceptance test protocols。实际 run/event evidence 必须由 `acceptance-rubric.md` 引用真实记录，不能靠修改协议语义补写结果；未来 programme evidence 不阻塞 Phase 1 `ACCEPTED`。

## S. Adversarial Design Readiness self-check（S1E recalculation）

本节在 S1D 的 Delta、A02、决策表、authority、behavior、adversarial、walkthrough、pre-mortem、current/deferred 映射和 exact boundary 完成后，于 S1E 补齐验收阶段拆分并重算。它是 dispatch-readiness 过程证据，不是 lifecycle gate、formal reviewer approval、`DESIGN_FROZEN`、`TESTS_RED` 或 `ACCEPTANCE_FROZEN`。

### S1. State and implementation readiness

| Checklist area | Evidence / result | Status |
|---|---|---|
| State readiness | `workflow_status.py --json` 指向 per-change delivery state；project `ailearning`、change、L2、DRAFT 正确；mirror missing 明确非阻断；`blocked=[]`；当前 runtime sync 报告 `l2-implement-loop`/`tm` OUTDATED，未修复、未据此宣称 transition 可用 | PASS with runtime-sync note |
| No pre-implementation production write | S1F 当前只允许的两文件是 `design-specification.md` 与 `.agent-workflow/task-board.md`；UIC 是 forbidden 且未修改；Phase 1 七个 production/六个 test/零 report 仅候选，未注册/创建；COURSE_ROADMAP dirty candidate untouched | PASS |
| Closed design decisions | A01/A02 已记录；Phase 1 选定七个 production paths、六个 test protocol paths、零 report paths；Phase 1 不含 student-package CLAUDE、TPA refs、lesson files、scripts；root CLAUDE/shim职责、template 前置顺序、TLP/TPA artifact owner/writer、GUIDE conformance 和 ref semantics 已收敛 | PASS |
| Test lifecycle | J1/J3/J6/L/N 一致拆分为 A-RUBRIC-DRAFT（Gate A 前，仅 DRAFT `docs/changes/course-curriculum-revision-2026-08/acceptance-rubric.md` 的内嵌 RED test plan 章节）→ Gate A/`DESIGN_FROZEN` → A-RED-PROTOCOLS（六个 protocol，production zero-diff）→ real failure evidence records `TESTS_RED` → A-ACCEPTANCE-REVIEW（Independent Reviewer 只读复核）→ `ACCEPTANCE_FROZEN`；协议语义与实际 run evidence 分离 | PASS |
| Code path evidence | 已读取 state JSON、UIC、HEAD/working roadmap/diff、20份 L1–L10 主版教案/指南、V2/V3 对照、root CLAUDE、student-package/templates/CLAUDE、canonical TPA、.claude shim、GLOSSARY/PROJECT_STATE/LESSON_TEMPLATE/DESIGN_ALIGNMENT、package.json、scripts inventory与关键脚本全文 | PASS |
| Data semantics | S2 逐项定义人数、时长、概念数、readiness、lifecycle、ref、secret scan 与 blob/stat；null/zero/negative/边界规则不被误当通过 | PASS |
| Frontend/backend or artifact contract | S3 明确 UIC/spec/roadmap/Brief/plan/guide/asset 的输入、输出、owner、writer、direct source 与 fallback；当前 Phase 1 不触碰前端/后端代码 | PASS |
| Edge / negative / compatibility | N、P、Q 及新增 A02 处置覆盖缺 ref、错课次、候选路线图、root CLAUDE 陈旧规则、.claude shim 漂移/解析失败、旧 V2/V3、secret、tool unavailable、missing package、absence、time overflow、placeholder | PASS |
| Scope boundary | J6 exact seven-production/six-test/zero-report lists；student-package CLAUDE、future lesson/script backlog 与 active Phase 1 分离；S1E forbidden rule 明确 | PASS |
| Reviewer attack simulation | O 五视角逐项有 finding/disposition/residual risk；P walkthrough 覆盖 first/normal/invalid/compatibility/failure | PASS |
| Dispatch readiness | 所有上项 PASS；本次只请求 focused formal re-review，不执行 reviewer transition；Gate A、DESIGN_FROZEN、TESTS_RED、ACCEPTANCE_FROZEN 和 implementation 仍未授权 | PASS |

### S2. Data semantics for design-state fields

| Field / metric | Definition and unit | Boundary / null / zero / negative behavior | Source / consumer |
|---|---|---|---|
| `cohort_size` | Integer people count, inclusive 10–15 | Negative/zero invalid for planned class; null means not planned, never PASS; not a measured attendance result | UIC → course operations / teacher plan |
| `lesson_duration_minutes` | Integer minutes for one lesson, hard upper bound 90 | Negative invalid; 0 means no session delivered; null means unmeasured; >90 is a time finding, not silently rounded | UIC/design → lesson trial record |
| `micro_task_minutes` | Integer 10–15 minutes between lessons | 0/null means missing micro-task; >15 is overload finding; not merged with weekly result | UIC/D3 → weekly plan |
| `weekly_complete_minutes` | One integer 30–45 minute result after weekly second lesson | 0/null means missing weekly result; a second result is an excess-scope finding | UIC/D3 → weekly submission |
| `core_concept_count` | Integer 2–3 independently mastered concepts per lesson | Negative/zero invalid; named exposure may exceed it and is separately logged in D2a; null is unreviewed | UIC/D2/D2a → teacher review |
| `brief_readiness` | Enum `DRAFT` or `HANDOFF_READY` | Any other value invalid; `HANDOFF_READY` never means approved/frozen; null blocks TPA | TLP reference → TPA |
| `lifecycle` | Workflow enum currently `DRAFT` | Unknown/forged values invalid; transition only tool-authorized; null/contradictory state blocks | delivery_gate → workflow_status |
| `approval_ref` | String pointing to real event/record ID plus artifact version | Missing, stale, wrong lesson, or non-resolving ID means not approved; no “prior existence” fallback | reviewer/approver → GUIDE/asset |
| `guide_conformance_ref` | String pointing to Independent Reviewer conformance event plus GUIDE version/hash | Missing, stale, wrong lesson, or non-resolving ID blocks derived assets; it is not a second business Gate A | conformance reviewer → derived asset |
| `test_lifecycle` | Ordered workflow checkpoints: A-RUBRIC-DRAFT after Formal Independent Design Review and before Gate A → Gate A/`DESIGN_FROZEN` → A-RED-PROTOCOLS authoring/execution with zero production diff → real failure evidence records `TESTS_RED` → A-ACCEPTANCE-REVIEW → `ACCEPTANCE_FROZEN` | Authoring/execution before `DESIGN_FROZEN`, recording `TESTS_RED` without real pre-implementation failure evidence, changing semantics after freeze, or missing run/review evidence is invalid; implementation remains blocked | delivery workflow → acceptance-test writer/reviewer |
| `secret_scan` | Boolean result over repo/material/package candidate | `false` means no detected secret; `true` or unknown/null blocks external demo/package; scan does not prove business safety alone | safety check → teacher/operations |
| `roadmap_blob` / `diff_additions` / `diff_deletions` | Blob ID and integer line counts for current candidate evidence | Negative counts invalid; current values are process evidence only, not course acceptance; any blob change stops S1E | Git → task-board/report |

No field depends on array order, frontend color mapping, calendar period, or year/month/day aggregation in Phase 1. If a future lesson/asset introduces such data, its change must define source, unit, null and migration semantics before implementation.

### S3. Artifact interface contract

| Producer | Input fields/source | Output fields/consumer | New/retained/removed | Missing-field fallback |
|---|---|---|---|---|
| UIC | User decisions, source thread IDs, append-only amendments | D01–D20, A01/A02 scope distinction, non-goals → design/roadmap/Skills/CLAUDE boundary | Retains all D01–D20; A01/A02 add delivery scope only and do not alter programme goal | Stop and request user clarification; no inference |
| Frozen design | Locked UIC + repository facts + approved review/Gate A refs | Course sequence, authority, Phase 1 list → roadmap/template/root CLAUDE/Skills/shim | Adds design fields; does not remove UIC fields | Remain DRAFT; classify spec gap |
| Root CLAUDE policy | Locked UIC/frozen design, repository safety/dependency/Git facts | Maintainer/Agent rules → maintenance workflow; learner export remains student-package template | Retains real safety, dependency, Git and package isolation; removes old course defaults from authority role | Stop root-rule alignment; do not modify learner template or call text runtime hard control |
| Canonical TPA + Claude shim | Frozen TPA contract and canonical exact path | Canonical v2 method plus minimal `.claude` compatibility pointer → authorized agent trigger | Canonical `.agents` owns full method; shim has no duplicate schema/version/default/approval | Fail closed if canonical missing, unresolvable or validation fails |
| TLP Brief | Frozen course inputs, approved lesson target, contract version | Authorized execution agent using TLP v2 writes Brief fields/readiness → TPA | Adds lesson reasoning; cannot alter upper-level goals; course design owner owns artifact | `DRAFT`, report missing source/contract |
| TPA plan | HANDOFF_READY Brief + template/roadmap refs | Authorized execution agent using TPA v2 writes eight-module TEACHER_PLAN + plan version | Adds rendered plan; course owner owns artifact; no GUIDE before Independent Review + user/course-owner approval | Stop without plan/approval ref |
| Approved plan | Independent Review record + user/course-owner approval record + exact plan version | Direct source ref → GUIDE | Retains plan meaning; no downstream reinterpretation | GUIDE not generated |
| GUIDE | Approved same-lesson plan/ref | Authorized execution agent using TPA v2 writes learner steps/evidence/safety → conformance review | Adds learner rendering only; course owner owns artifact; no new acceptance meaning | Stop on stale/wrong ref or spec gap |
| GUIDE conformance review | GUIDE version + approved plan ref | Independent Reviewer writes conformance record → derived asset | Confirms fidelity/scope/safety; does not rewrite plan or act as second business Gate A | Return GUIDE upstream; no derived asset |
| Derived asset | Approved GUIDE + GUIDE conformance record | Authorized asset writer/export tool writes HTML/image/package → operations/IT | Adds representation only; no new acceptance meaning | Reject asset/package |
