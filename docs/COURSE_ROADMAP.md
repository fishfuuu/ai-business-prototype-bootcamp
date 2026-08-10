# 主管 AI 原型制作训练营课程路线图

状态：Official Execution v1.5 Master Edition（认知负荷调优、有界排错熔断、双Agent上下文隔离与IT交接归档版）  
更新时间：2026-08-10  

内容来源与权威说明：
- `docs/COURSE_ROADMAP.md`：**结合当前仓库状态、超级业务 PM 定位、Agent 三代架构演进、Subagent 演进暗线、MCP 暗线、工程防错 8 大规则与【四步概念公式】整理后的唯一权威执行版（Authoritative Execution Plan）。**
- `docs/主管 AI 原型制作训练营.md`：**保留为历史课程设计来源与背景文案原稿（Historical Design Manuscript），必须引用本权威执行版。**

---

## 1. 课程定位与终局目标

### 核心定位

课程目标不是培养专业的 Vue/TypeScript 程序员，而是借助 Coding Agent（Claude Code / Codex），将运营主管培养为“超级业务产品经理（Super Business PM）”。

主管不需要去搞底层的生产服务器运维或复杂并发代码，而是要掌握：
1. **高保真原型控盘能力**：在 2 小时内用自然语言 + AI 跑出可运行、可点击、带模拟数据的高保真原型系统。
2. **需求与数据契约表达能力**：将口头需求标准化为《业务功能卡》、数据契约卡与明确的输入/输出边界。
3. **工程护栏与版本证据管理能力**：掌握安全沙箱授权、`CLAUDE.md` 护栏、Grounding (事实锚定)、三分记忆模型（工作记忆、外部长期记忆、版本证据）与有界排错方法，防止项目失控。
4. **可复核证据驱动的验收与审查能力**：基于可复核、可重复生成的四类证据（视觉、行为、工程、范围）完成自动化验收，并在独立审查上下文隔离下引导 Codex 进行代码审查。
5. **确定性与概率性逻辑切割能力**：准确判断普通功能（确定性规则）与 AI 功能（概率性生成），坚持 HITL 人工确认，在结业时输出让 IT 部门直接落地的《IT 原型交接包》。

---

### 三层能力成熟度模型 (Three-Layer Maturity Model)

训练营帮助主管实现三层 AI 协作能力跨越：
- **第一层：Prompting (单次指令)** —— 通过单次指令描述任务，理解裸 Prompt 局限。
- **第二层：Harness Engineering (工程护栏)** —— 通过规则 (`CLAUDE.md`)、文件 (`PROJECT_STATE.md`)、Skills (`grill-me`, `design-lint`)、测试 (`verify-project.ps1`)、权限与工作流约束 Agent 执行。
- **第三层：Bounded Agent Loop (受控 Agent 循环)** —— 在明确目标、边界、工具、风险和停止条件下，让 Agent 进行受控自主循环，主管在关口行使人在回路 (HITL) 盖章。

---

### 教学设计与概念解析四步范式 (Pedagogical 4-Step Formula)

为解决概念浮于表面与比喻失真问题，全课程所有硬核概念（LLM, Tools, Agent, ReAct, Tokens, MCP, Git, Linters）统一执行**【四步概念解析公式】**：
1. **硬核工程定义 (Engineering Definition)**：使用标准的 IT/软件工程术语，讲清物理本质。
2. **底层运作机制 (Underlying Mechanism)**：解释代码、内存、接口或数据在底层的实际流转逻辑。
3. **具象业务比喻 (Business Metaphor)**：建立大脑记忆锚点，降低心理门槛（如：把 Git 双 Commit 比喻为“买房拿到钥匙入住 (Commit A) 与 去房管局过户登记 (Commit B)”）。
4. **IT 沟通与交接价值 (Handoff Value)**：明确主管学完后向 IT 汇报与交接时的具体表达。

---

### 训练营支持的三类业务原型

训练营全课程持续贯穿支持三类典型业务原型，学员可根据自己部门的真实业务场景自由选择：
1. **A. 监控与决策型**：适合经营分析、异常监控、投产分析、履约预警（看指标 -> 看异常 -> 下钻明细 -> 做出决策）。
2. **B. 任务与流程型**：适合预算申请、退货处理、工单派发、单据审批（创建记录 -> 处理任务 -> 状态流转 -> 推进下一步）。
3. **C. 操作工具型**：适合文案生成、规则计算、数据整理、格式转换（输入 -> 规则处理 -> 结果输出 -> 人工确认/复制/导出）。

---

## 2. 学员与节奏

| 项 | 说明 |
| --- | --- |
| 第一批对象 | 运营主管 |
| 后续扩展 | 可复用于其他一级主管 / 业务负责人 |
| 每周建议投入 | 1–2 小时 |
| 标准课堂 | 约 90 分钟（成果展示 8 分钟，微型演示 17 分钟，概念核对 10 分钟，学员实操 45 分钟，总结验证 10 分钟） |
| 控场设置 | 每节课包含 **3–5 个固定暂停提问点 (Pause Points)** |
| 测评方式 | 每节课包含 **Exit Ticket (退场测试卡)** 与 **常见概念误区表 (Misconceptions Table)** |
| 成果要求 | 每节课必须产生肉眼可见成果 |

---

## 3. 工具分工与角色契约

### 1. Claude Code（主要实施者 / 开发 Agent）
- 需求解构与方案推演
- 页面与组件增量创建
- 执行 **ReAct 范式**、**Plan & Execute 范式** 与 **Subagent 调度**
- 本地调试与自测验证 (学员：`verify-student-project.ps1` / Verifier Subagent；维护者：`verify-project.ps1`)

### 2. Codex（独立审查者 / 审计 Agent）
- 从第 8 课开始正式引入（基于 `AGENTS.md` 规范）
- **独立审查上下文隔离**：新建独立会话，仅调取已确认需求、稳定 Commit 与 Candidate Commit 的 Diff
- 审查隐患、逻辑越界与未授权的范围修改，只读不修改代码
- 提供独立审查意见（阻断/重要/建议）

### 3. 主管（最终裁决者 / 人在回路盖章官 / 中央调度系统）
- 掌控 Workflow 推进阶段
- 行使 Keep / Omit / Remove / Modify 裁决权
- 对 Codex 审查意见做出四个决定：接受、拒绝、延期、超出本次范围
- 签署人在回路 (HITL) 授权，完成最终业务验收

---

## 4. 高阶工程防错 8 大防护规则 (Robustness & Patch Rules)

为防止教学实操中出现卡死、白屏、死循环和弹窗风暴，全课程严格注入 8 大高阶防错机制：

1. **Subagent 超时熔断规则 (Subagent Lifecycle & Timeout Rule)**：
   派发给子智能体（如静默测试 Subagent）的独立任务必须设置物理超时阈值（如 `DurationSeconds: 60`），超时自动释放，决不挂起主 Agent。
2. **Subagent 预授权与只读沙箱规则 (Subagent Read-only Sandbox Rule)**：
   静默后台运行的 Subagent 仅继承只读工具权限 (Read-only Tools)，写权限修改动作必须返回主 Agent 界面由主管签署 HITL 口令确认。
3. **Subagent 产物强制物理落盘规则 (Disk Persistence Rule)**：
   Subagent 产出的所有测试截图、DOM 操作日志与检查报告，必须物理落盘写入本地磁盘目录（`local-backups/`）与 `PROJECT_STATE.md`，决不随 Context 重置而蒸发。
4. **双 Agent 两轮仲裁门禁 (2-Round HITL Arbitration Rule)**：
   第 8 课开发 Agent 与只读审查 Agent 辩论超过 2 轮时，强制阻断自动循环，引发主管 CEO 仲裁盖章。
5. **Mock 数据降级保护桥梁 (Mock Fallback Bridge)**：
   第 9~10 课真 AI 接口连接失败、网络超时或非法返回时，系统 0.1 秒内自动降级回 Mock Data 结构化渲染，保证 100% 演示不白屏崩盘。
6. **排错范围界定与 2 轮硬熔断规则 (Bounded Debugging & Patch Fallback Rule)**：
   第 6 课排错严格限定在“界面呈现与 `prototype-contract.d.ts` 契约不一致的领域”，严禁深挖底层代码；同一 Bug 最多自修 2 轮，超轮次降级运行 `git restore .` 恢复并打上 `.patch` 补丁。
7. **独立审查上下文隔离与 CEO 2 轮仲裁门禁 (Context-Isolated Audit Rule)**：
   第 8 课 Codex 必须在全新的独立会话中开启，只读取 Candidate Commit 的 `git diff`；若双 Agent 辩论满 2 轮未达成一致，强制触发出发主管 CEO 仲裁盖章。
8. **确定性/概率性切割与红线规约 (Deterministic vs. Probabilistic Cut Rule)**：
   计算与状态流转由确定性代码执行；智能生成由 LLM 执行且须经过 HITL 确认；编写《物理红线清册》排除高危业务。

---

## 5. 10 课演进总览与能力矩阵

### 10 课演进总览

| 阶段 | 课次 | 明线主题 | 三层能力成熟度与暗线要求 | Agent 架构与工具演进 | 可见成果 |
| --- | --- | --- | --- | --- | --- |
| **一、界面与外观** | **1** | 从业务问题创建第一个系统页面 | **Prompting → Loop 初体验**；Tools 权限沙箱；模拟数据红线；初始化 `PROJECT_STATE.md` | **ReAct 范式** (单步自修)；Tools 沙箱与 127.0.0.1 试衣镜 | 可运行系统雏形、侧栏菜单、模拟数据、`PROJECT_STATE.md` |
| | **2** | 用参考图与设计规则做出像样的页面 | **视觉 Harness (`DESIGN.md`) & 事实锚定**；**双 Token 制衡**；物理点开 `DESIGN.md`；Git 节点1/2存档 | **ReAct 范式**；**MCP/Plugin 概念启蒙**；`design-lint` | 高颜原型、`DESIGN.md`、首个 Git 稳定 Commit |
| **二、需求与结构** | **3** | 把模糊想法变成可执行的业务契约 | **Prompt vs Skill Harness (`grill-me`)**；前置 **6 大要素**；脱敏规约；数据契约收扣于 `BUSINESS_FEATURE_CARD.md` | **ReAct + Skill 约束**；`grill-me` | 《业务功能卡与数据契约》(`BUSINESS_FEATURE_CARD.md`) + TS 类型草稿 + Mock 数据 |
| | **4** | 把大需求拆成连续的小成功 | **增量实施 (Plan & Execute)**；持久化计划 (`LESSON_04_IMPLEMENTATION_PLAN.md`)；房产过户双 Commit 比喻；三层验收与版本归档 | **Plan & Execute 范式**；**后台静默 Verifier Subagent** (跑自测与日志落盘) | 已批准实施计划 + 一次完整版本归档 (Commit A 源码 + Commit B 状态推进) |
| **三、防崩与排错** | **5** | 建立不会轻易失控的项目 | **工程 Harness (`CLAUDE.md`)**；**三分记忆模型**；**【解药 1：环境脱幻与独立工具箱】** | **Plan & Execute 范式**；`CLAUDE.md` 项目护栏 | 带项目护栏、Git 恢复能力与独立工具箱的稳定系统 |
| | **6** | 学会定位和修复问题 | **事实锚定排错**；五层诊断卡；**契约排错 & 有界排错 Loop (最多 2 轮，不得改断言)**；重新应用 `step-N-blocked.patch` | **ReAct 有界自修**；Console/日志锚定 | 带有五层 Bug 诊断、2 轮熔断与回归证据的系统 |
| **四、双 Agent 验收** | **7** | 让 Agent 实际操作页面完成验收 | **断言 Harness 自动化**；停止条件转 Playwright 自动化断言；四类可复核证据链 | **Subagent + Browser MCP** (Browser-Tester 抓截图) | 带有四类可复核证据链的验收记录 |
| | **8** | Claude Code 开发，Codex 独立审查 | **独立审查上下文隔离 (`AGENTS.md`)**；只读审查 Candidate Commit；**主管 CEO 2 轮仲裁门禁** | **Multi-Agent 范式** (开发 Agent + Codex 审计) | 经过双 Agent 审计与主管裁决的代码 |
| **五、AI 融入与交付** | **9** | 业务 Agent 场景判断与产品设计 | **确定性 vs. 概率性切割**；AI 隐私边界与 HITL；**【解药 2：外部真实数据 MCP 插座与 Mock 降级保护桥梁】** | **Multi-Agent + API MCP 插座**；结构化 JSON 草稿 | 带 AI 契约、真实 MCP 演示与 Mock 降级保护的场景矩阵 |
| | **10** | 落地有限 AI 功能与 IT 交接 | **受控 AI 功能闭环**；《IT 原型交接包》与**【解药 3：部门不可 Agent 化物理红线清册】** | **Multi-Agent + MCP 架构**；`find-skills` (选型) | 可点真 AI 演示原型、红线清册 + 《IT 原型交接包》 |

---

### 10 节课共同规则（统一的“每课结束动作”）

从第二课起，每节课结束前必须固定执行以下 5 个管理动作：

```text
每课结束固定执行：
1. 更新 docs/PROJECT_STATE.md (更新业务事实与会话摘要)
2. 运行本课规定的学员验证脚本或 Verifier（课程维护者另行运行 verify-project.ps1 进行全量门禁断言）
3. 查看 git diff 确认修改范围
4. 提交本课稳定版本 (git commit)
5. 记录下一课的明确输入
```

---

## 6. 每课详细路线

### 第 1 课：从业务问题创建第一个系统页面
* **定位**：零基础学员建立三类业务原型分类认知、AI Agent 人机协作认知、ReAct 单步范式、Tools 权限沙箱与模拟数据安全红线。
* **主要内容**：
  1. 工具预检与沙箱授权：确认工程环境正常，用【四步概念公式】解析 LLM、Tools、Agent、ReAct、Workflow 的底层物理机制。
  2. 选择“A. 监控与决策型 / B. 任务与流程型 / C. 操作工具型”原型方向并输入业务上下文。
  3. **初始化 `docs/PROJECT_STATE.md`**：记录系统名称、使用者、原型类型、核心业务问题及敏感级别。
  4. 遵照模拟数据红线，体验 ReAct 感知微调 Loop，生成首个包含侧栏菜单与 Mock 数据信息的系统雏形。
* **执行文档**：[LESSON_01_GUIDE.md](LESSON_01_GUIDE.md) 与 [LESSON_01_TEACHER_PLAN.md](LESSON_01_TEACHER_PLAN.md)。

---

### 第 2 课：用参考图与设计规则做出像样的企业页面
* **定位**：根据业务目的选择信息结构与参考图，完成视觉 Harness 重构，掌握 AI Token 随机性与 Design Token 制衡、多模态能力迁移、物理点开 `DESIGN.md` 与 Git 节点 1/2 存档证据。
* **主要内容**：
  1. **Task 1：结构提取 (15 分钟)**：多模态提取参考图首屏布局与视觉主次，100% 过滤杂色。
  2. **Task 2：规范映射 (15 分钟)**：**物理点开 `DESIGN.md` 查看字典**，映射 Token 与组件，事实锚定到规范。
  3. **Task 3：视觉裁决与重构 (10 分钟)**：**节点 1 Git 存档 `baseline: complete lesson 1 prototype`**；主管下达 Keep / Omit / Remove / Modify 裁决，发送授权口令重构页面；监视 Diff 红绿视图，一键 Discard 还原。
  4. **Task 4：对比验证与成果存档 (10 分钟)**：试衣镜对比与 1 次人在回路微调；运行验证 `verify-student-project.ps1` 输出 `[PASS]`；**节点 2 Git 存档 `style: complete lesson 2 visual refactor`**。
* **执行文档**：[LESSON_02_GUIDE.md](LESSON_02_GUIDE.md) 与 [LESSON_02_TEACHER_PLAN.md](LESSON_02_TEACHER_PLAN.md)。

---

### 第 3 课：把模糊想法变成可执行的业务契约
* **定位**：对比单次 Prompt 与 Skill Harness（`grill-me`），前置锁定 6 大要素（目标、问题定义、边界、风险、Given-When-Then 验收场景、停止条件），校验阻断门禁，将数据契约统一落盘至 `docs/BUSINESS_FEATURE_CARD.md` 并生成 TypeScript 类型草稿。
* **主要内容**：
  1. 使用 `grill-me` Skill 进行 3–5 分支、5–7 轮追问对话，体会一次只问一个问题的约束，解构 6 大业务要素。
  2. **假数据脱敏规约 (Sanitization Guardrail)**：在 Mock 表格中标注“公开 / 内部 / 严禁发送 AI”，作为写给未来 IT 部门的生产网关脱敏规约。
  3. **数据契约收扣与契约冻结规则**：在 `docs/BUSINESS_FEATURE_CARD.md` 中嵌入完整数据契约表，生成 TypeScript 类型草稿 (`src/types/prototype-contract.d.ts`) 与 Mock 数据 (`src/mocks/prototype-data.ts`)。主管验收 PASS 后契约冻结。
  4. **Task 3A 只读结构预览门禁**：在生成最终代码前，必须进行 Task 3A 只读结构预览，未经主管授权不得修改任何现有源码（严禁使用路径切换命令 `cd`）。
* **执行文档**：[LESSON_03_GUIDE.md](LESSON_03_GUIDE.md) 与 [LESSON_03_TEACHER_PLAN.md](LESSON_03_TEACHER_PLAN.md)。

---

### 第 4 课：把大需求拆成连续的小成功
* **定位**：引入 **增量实施范式 (Incremental Implementation)**，先做计划，每次只授权完成一个可重复验证的小切片。在外部长期记忆 `docs/LESSON_04_IMPLEMENTATION_PLAN.md` 中管理步骤状态，引入页面技术呈现状态调试器 (`prototypeState`)，通过三层验收与代码版本归档防范回归风险。
* **主要内容**：
  1. **解析 Plan & Execute 范式**：先生成 `docs/LESSON_04_IMPLEMENTATION_PLAN.md` 实施计划，经主管审批授权后分步执行。
  2. **精准区分 2D 状态与双 Commit 比喻**：区分页面技术呈现状态与业务流程状态。使用“房产过户双节点比喻”（Commit A 源码交房 vs Commit B 状态确权登记）降维认知。
  3. **落地 Step 1 调试切片**：结合三类原型方向落地首个切片，植入页面技术状态调试器，完成 4 种界面点击验证。
  4. **三层验收与干净项目工作区恢复**：结合后台 Verifier 静默自测、人工页面点击与主管业务验收完成一次完整版本归档 (Commit A 源码 + Commit B 状态推进)；自测或页面验证失败时，导出 `.patch` 补丁，执行 `git restore` 恢复干净源码，仅提交 Commit B 状态并将步骤标记为 `BLOCKED`。
* **执行文档**：[LESSON_04_GUIDE.md](LESSON_04_GUIDE.md) 与 [LESSON_04_TEACHER_PLAN.md](LESSON_04_TEACHER_PLAN.md)。

---

### 第 5 课：建立不会轻易失控的项目
* **定位**：建立 Vue 项目心理地图、工程 Harness（`CLAUDE.md`）、Plan & Execute 深入与三分记忆模型。

---

### 第 6 课：学会定位和修复问题 — 五层诊断卡与有界排错 Loop
* **定位**：事实锚定排错、五层诊断卡、契约层排错防跑偏与 2 轮硬熔断护栏。
* **主要内容**：
  1. **五层诊断卡 (Five-Layer Diagnostic Map)**：按物理环境 ➔ 数据源 ➔ 组件状态 ➔ 日志 ➔ 契约断言五层排查。
  2. **排错范围严格限定**：只排“界面呈现与 `prototype-contract.d.ts` 契约不一致”的 Bug，严禁深入底层复杂代码。
  3. **2 轮硬熔断机制**：同一 Bug 最多由 Agent 自修 2 轮；若未 PASS，强制运行 `git restore .` 恢复，并重新应用 `step-N-blocked.patch` 补丁。

---

### 第 7 课：让 Agent 实际操作页面完成验收 — 浏览器 MCP 与四类证据链
* **定位**：断言 Harness 自动化，Playwright / Browser-Tester Subagent 驱动页面自动化点击并生成四类可复核证据链。
* **主要内容**：
  1. 挂载 Browser MCP，将 L03 `Given-When-Then` 场景转化为 Headless 自动化点击剧本。
  2. **落盘四类可复核证据链**：视觉截图 (`screenshot.png`)、行为日志 (`action.log`)、工程类型 (`typecheck.log`)、范围变更 (`diff.patch`)。
  3. 测试完毕后自动销毁 Subagent 沙箱，保持主会话内存干净。

---

### 第 8 课：Claude Code 开发，Codex 独立审查 — 上下文隔离与 CEO 2 轮仲裁
* **定位**：**独立审查上下文隔离 (`AGENTS.md`)**，新建只读会话审计 Candidate Commit，2 轮仲裁门禁与主管 CEO 终审。
* **主要内容**：
  1. 遵循 [`AGENTS.md`](AGENTS.md) 规则，新建独立只读会话，消除开发 Agent 的历史思考污染。
  2. Codex 审查 Candidate Commit 的 Git Diff，仅输出审计意见（阻断/重要/建议），严禁修改代码。
  3. **双 Agent 2 轮仲裁门禁**：辩论超过 2 轮强行挂起，由主管行使 CEO 裁决权 (`[接受]` / `[拒绝]` / `[延期]`)。

---

### 第 9 课：业务 Agent 场景判断与产品设计 — 逻辑切割与 Mock 降级保护桥梁
* **定位**：确定性规则 vs. 概率性生成逻辑切割、AI 隐私边界、外部真实数据 MCP 插座配置与 Mock 降级保护桥梁。
* **主要内容**：
  1. **确定性 vs. 概率性逻辑切割**：计算与状态流转由确定性代码执行；智能生成由 LLM 执行并经过 HITL 确认。
  2. **配置 API MCP 插座**：挂载外部 API，要求 AI 返回结构化 JSON。
  3. **Mock 降级保护桥梁 (Mock Fallback Bridge)**：真实 API 失败或超时时，前端 0.1 秒内自动降级渲染 L03 静态 Mock 数据，确保演示 100% 不白屏崩盘。

---

### 第 10 课：落地有限 AI 功能与 IT 交接 — 物理红线清册与《IT 原型交接包》
* **定位**：受控 AI 功能闭环，编制部门不可 Agent 化物理红线清册，输出可让 IT 部门直接落地的《IT 原型交接包》。
* **主要内容**：
  1. **编制物理红线清册**：在 [`docs/DEPARTMENT_REDLINES.md`](DEPARTMENT_REDLINES.md) 中排除资金打款、法务合规等绝对禁止 AI 自动化的领域。
  2. **打包《IT 原型交接包》**：一键生成标准归档 ZIP 包（包含功能卡、TS 数据契约、四类测试证据链与原型源码）。
  3. 完成 5 分钟结业极客汇报演练，实现从业务主管向超级业务 PM 的跨越。
