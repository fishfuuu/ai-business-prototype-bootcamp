# 主管 AI 原型制作训练营课程路线图

状态：Official Execution v1.4 Candidate（需求契约冻结门禁、2D状态解耦、增量切片精简与双提交归档版）  
更新时间：2026-08-05  

内容来源与权威说明：
- `docs/COURSE_ROADMAP.md`：**结合当前仓库状态、超级业务 PM 定位、Agent 三代架构演进、Subagent 演进暗线、MCP 暗线、工程防错 5 规则与【四步概念公式】整理后的唯一权威执行版（Authoritative Execution Plan）。**
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
3. **具象业务比喻 (Business Metaphor)**：建立大脑记忆锚点，降低心理门槛。
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

## 4. 高阶工程防错 5 大防护规则 (Robustness & Patch Rules)

为防止教学实操中出现卡死、白屏、死循环和弹窗风暴，全课程严格注入 5 大高阶防错机制：

1. **Subagent 超时熔断规则 (Subagent Lifecycle & Timeout Rule)**：
   派发给子智能体（如静默测试 Subagent）的独立任务必须设置物理超时阈值（如 `DurationSeconds: 60`），超时自动释放，决不挂起主 Agent。
2. **Subagent 预授权与只读沙箱规则 (Subagent Read-only Sandbox Rule)**：
   静默后台运行的 Subagent 仅继承只读工具权限 (Read-only Tools)，写权限修改动作必须返回主 Agent 界面由主管签署 HITL 口令确认。
3. **Subagent 产物强制物理落盘规则 (Disk Persistence Rule)**：
   Subagent 产出的所有测试截图、DOM 操作日志与检查报告，必须物理落盘写入本地磁盘目录（`local-backups/`）与 `PROJECT_STATE.md`，决不随 Context 重置而蒸发。
4. **双 Agent 两轮仲裁门禁 (2-Round HITL Arbitration Rule)**：
   第 8 课开发 Agent 与只读审查 Agent 辩论超过 2 轮时，强制阻断自动循环，引发主管 CEO 仲裁盖章。
5. **Mock 数据降级保护桥梁 (Mock Fallback Bridge)**：
   第 9~10 课真 AI 接口连接失败、网络超时或非法返回时，系统自动降级回 Mock Data 结构化渲染，保证 100% 演示不白屏崩盘。

> [!NOTE]
> **关于各阶段课程（第 1–10 课）基线与进展双维度状态说明**：  
> - **第 1—2 课**：`Repository Content Status: BASELINE` | `Teaching Validation Status: PILOT_PASSED`
> - **第 3 课 (V2.1 修订版)**：`Repository Content Status: CANDIDATE` (第3课既有基线存在，本轮 V2.1 修订为候选状态) | `Teaching Validation Status: PILOT_PENDING`
> - **第 4 课**：`Repository Content Status: CANDIDATE` (候选课程内容与工程实现就绪，待复核合入) | `Teaching Validation Status: PILOT_PENDING`
> - **第 5—10 课**：`Repository Content Status: PLANNED` | `Teaching Validation Status: NOT_TESTED`

---

## 5. 10 课演进总览与能力矩阵

### 10 课演进总览

| 阶段 | 课次 | 明线主题 | 三层能力成熟度与暗线要求 | Agent 架构与工具演进 | 可见成果 |
| --- | --- | --- | --- | --- | --- |
| **一、界面与外观** | **1** | 从业务问题创建第一个系统页面 | **Prompting → Loop 初体验**；Tools 权限沙箱；模拟数据红线；初始化 `PROJECT_STATE.md` | **ReAct 范式** (单步自修)；Tools 沙箱与 127.0.0.1 试衣镜 | 可运行系统雏形、侧栏菜单、模拟数据、`PROJECT_STATE.md` |
| | **2** | 用参考图与设计规则做出像样的页面 | **视觉 Harness (`DESIGN.md`) & 事实锚定**；**双 Token 制衡**；物理点开 `DESIGN.md`；Git 节点1/2存档 | **ReAct 范式**；**MCP/Plugin 概念启蒙**；`design-lint` | 高颜原型、`DESIGN.md`、首个 Git 稳定 Commit |
| **二、需求与结构** | **3** | 把模糊想法变成可执行的业务契约 | **Prompt vs Skill Harness (`grill-me`)**；前置 **6 大要素** (问题、目标、边界、风险、Given-When-Then 验收条件、Stop 条件)；数据契约收扣于 `BUSINESS_FEATURE_CARD.md` | **ReAct + Skill 约束**；`grill-me` | 《业务功能卡与数据契约》(`BUSINESS_FEATURE_CARD.md`) + TS 类型草稿 + Mock 数据 |
| | **4** | 把大需求拆成连续的小成功 | **增量实施 (Plan & Execute)**；持久化计划 (`LESSON_04_IMPLEMENTATION_PLAN.md`)；页面技术呈现状态调试器 (`prototypeState`)；三层验收与版本归档 | **Plan & Execute 范式**；**后台静默 Verifier Subagent** (跑自测与日志落盘) | 已批准实施计划 + 一次完整版本归档 (Commit A 源码 + Commit B 状态推进) |
| **三、防崩与排错** | **5** | 建立不会轻易失控的项目 | **工程 Harness (`CLAUDE.md`)**；**三分记忆模型**；**【解药 1：环境脱幻与独立工具箱】** | **Plan & Execute 范式**；`CLAUDE.md` 项目护栏 | 带项目护栏、Git 恢复能力与独立工具箱的稳定系统 |
| | **6** | 学会定位和修复问题 | **事实锚定排错**；五层诊断卡；**有界排错 Loop (最多2轮，不得改断言)** | **ReAct 有界自修**；Console/日志锚定 | 带有五层 Bug 诊断与回归证据的系统 |
| **四、双 Agent 验收** | **7** | 让 Agent 实际操作页面完成验收 | **断言 Harness 自动化**；停止条件转 Playwright 自动化断言；四类可复核证据链 | **Subagent + Browser MCP** (Browser-Tester 抓截图) | 带有四类可复核证据链的验收记录 |
| | **8** | Claude Code 开发，Codex 独立审查 | **独立审查上下文隔离 (`AGENTS.md`)**；只读审查 Candidate Commit；**2 轮仲裁门禁** | **Multi-Agent 范式** (开发 Agent + Codex 审计) | 经过双 Agent 审计与主管裁决的代码 |
| **五、AI 融入与交付** | **9** | 业务 Agent 场景判断与产品设计 | **确定性 vs. 概率性切割**；AI 隐私边界与 HITL；**【解药 2：外部真实数据 MCP 插座与 Mock 降级】** | **Multi-Agent + API MCP 插座**；结构化 JSON 草稿 | 带 AI 契约、真实 MCP 演示与 Mock 降级保护的场景矩阵 |
| | **10** | 落地有限 AI 功能与 IT 交接 | **受控 AI 功能闭环**；《IT 原型交接包》与**【解药 3：部门不可 Agent 化物理红线清册】** | **Multi-Agent + MCP 架构**；`find-skills` (选型) | 可点真 AI 演示原型、红线清册 + 《IT 原型交接包》 |

---

### 核心暗线能力矩阵

| 暗线 | 引入 (Introduction) | 强化 (Reinforcement) | 验证/交付 (Verification/Handoff) |
| :--- | :--- | :--- | :--- |
| **Agent 架构演进** | **第 1~2 课：ReAct 范式**（Thought -> Action -> Observation 单步反馈） | **第 4 课：Plan & Execute + Subagent**（静默自测子智能体） | **第 8~10 课：Multi-Agent 范式**（开发 Agent 与审查 Agent 独立上下文隔离） |
| **Subagent 演进线** | **第 4 课：Verifier Subagent**（静默后台跑脚本，保护主 Context 记忆） | **第 7 课：Browser-Tester Subagent**（挂载 MCP 跑 Playwright 抓截图，落盘销毁） | **第 8 课：Codex Reviewer**（独立会话只读审查与 2 轮仲裁门禁） |
| **MCP 与 Plugin 扩展** | **第 1~2 课：Tools vs Plugins vs MCP**（了解概念与沙箱权限） | **第 7 课：Browser MCP / 网页控制**（Playwright 驱动浏览器自动化点击） | **第 9~10 课：DB/API MCP 插座配置**（`.claude/mcp_config.json` 与《IT 原型交接包》） |
| **Git 版本证据** | 第2课初始化、SL游戏存档比喻、节点1/2提交 | 第4课每步 Commit、第5课恢复稳定提交 | 第8课基于 Commit/Diff 审查、第10课交付版本 |
| **数据契约与接口** | 第3课定义字段/类型/敏感度/三类原型契约 | 第4课实现页面 4 种状态、第6课定位接口层 Bug | 第10课写入《IT 原型交接包》 |
| **安全边界与沙箱** | 第1课模拟数据红线与 Tools 沙箱授权 | 第5课 `CLAUDE.md` 项目护栏（依赖/密钥/框架） | 第9、10课 AI 隐私、结构化输出与 HITL 人工确认 |
| **验收设计与断言** | 第3课定义前置验收标准与停止条件 | 第4课分步验证、第6课修复回归 | 第7课四类可复核证据自动化、第8课独立审查 |

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
  1. 使用 `grill-me` Skill 进行 3–5 分支、5–7 轮追问对话，体会一次只问一个问题的约束，区分 `[事实]`、`[决定]`、`[假设]` 与 `[待确认]` 事项。
  2. **校验阻断性待确认事项强校验门禁 (Fail-Closed Blocking Gate)**：核心角色、关键字段来源、业务规则、敏感数据处理方式、In Scope 边界与至少 1 个 Given-When-Then 场景必须确认，未通过输出 `BLOCKING_GATE_FAILED` 拒绝落盘。
  3. **精准区分 Acceptance Criteria 与 Stop Conditions**：Given-When-Then 专门用于描述功能正确性验收场景；Stop Conditions 专门用于描述 Agent 触发熔断暂停并呈报主管的条件。
  4. **数据契约收扣与契约冻结规则**：在 `docs/BUSINESS_FEATURE_CARD.md` 中嵌入完整数据契约表，生成 TypeScript 类型草稿 (`src/types/prototype-contract.d.ts`) 与 Mock 数据 (`src/mocks/prototype-data.ts`)。主管验收 PASS 后契约冻结。
  5. **三层验收与选择性暂存**：通过工程验证、契约验证、主管验收三层关口，更新 `docs/PROJECT_STATE.md`，使用 `git add --` 暂存指定 4 个资产并提交。
* **执行文档**：[LESSON_03_GUIDE.md](LESSON_03_GUIDE.md) 与 [LESSON_03_TEACHER_PLAN.md](LESSON_03_TEACHER_PLAN.md)。

---

### 第 4 课：把大需求拆成连续的小成功
* **定位**：引入 **增量实施范式 (Incremental Implementation)**，先做计划，每次只授权完成一个可重复验证的小切片。在外部长期记忆 `docs/LESSON_04_IMPLEMENTATION_PLAN.md` 中管理步骤状态，引入页面技术呈现状态调试器 (`prototypeState`)，通过三层验收与代码版本归档防范回归风险。
* **主要内容**：
  1. **解析 Plan & Execute 范式**：先生成 `docs/LESSON_04_IMPLEMENTATION_PLAN.md` 实施计划，经主管审批授权后分步执行。
  2. **精准区分 2D 状态**：区分页面技术呈现状态 (Loading/Empty/Error/Success) 与业务流程状态 (待处理/处理中/已阻塞/已完成)。
  3. **落地 Step 1 调试切片**：结合三类原型方向落地首个切片，植入页面技术状态调试器，完成 4 种界面点击验证。
  4. **三层验收与干净项目工作区恢复**：结合后台 Verifier 静默自测、人工页面点击与主管业务验收完成一次完整版本归档 (Commit A 源码 + Commit B 状态推进)；自测或页面验证失败时，导出 `.patch` 补丁，执行 `git restore` 恢复干净源码，仅提交 Commit B 状态并将步骤标记为 `BLOCKED`。
* **执行文档**：[LESSON_04_GUIDE.md](LESSON_04_GUIDE.md) 与 [LESSON_04_TEACHER_PLAN.md](LESSON_04_TEACHER_PLAN.md)。

---

### 第 5 课：建立不会轻易失控的项目
* **定位**：建立 Vue 项目心理地图、工程 Harness（`CLAUDE.md`）、Plan & Execute 深入与三分记忆模型。

---

### 第 6 课：学会定位和修复问题
* **定位**：事实锚定排错、五层诊断卡、重新应用 `step-N-blocked.patch` 与有界排错 Loop（最多 2 轮，不得擅自修改前置断言）。

---

### 第 7 课：让 Agent 实际操作页面完成验收
* **定位**：断言 Harness 自动化，Playwright / Browser-Tester Subagent 驱动页面自动化点击并生成四类可复核证据链。

---

### 第 8 课：Claude Code 开发，Codex 独立审查
* **定位**：**独立审查上下文隔离 (`AGENTS.md`)**，新建独立会话只读审计 Candidate Commit，2 轮仲裁门禁与主管 CEO 终审。

---

### 第 9 课：业务 Agent 场景判断与产品设计
* **定位**：确定性规则 vs. 概率性生成逻辑切割、AI 隐私边界、外部真实数据 MCP 插座配置与 Mock 降级保护桥梁。

---

### 第 10 课：落地有限 AI 功能与 IT 交接
* **定位**：受控 AI 功能闭环，编制部门不可 Agent 化物理红线清册，输出可让 IT 部门直接落地的《IT 原型交接包》。
