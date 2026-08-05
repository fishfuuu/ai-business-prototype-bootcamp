# 第三课学员指南 (V2 闭环版)：把模糊想法变成可执行的业务契约

欢迎来到第三课！在前两课中，我们完成了界面搭建与视觉规则约束（`DESIGN.md`）。本节课我们将解决业务原型研发中最核心的问题——**“如何把模糊业务想法变成可执行、可验收的业务契约”**。需求不是一句简单的 Prompt，而是一组经过确认的业务决定。你将学习如何唤醒 `grill-me` 追问护栏进行结构化澄清，前置锁定 **6 大业务要素**，将数据契约统一收扣至 `docs/BUSINESS_FEATURE_CARD.md`，并生成 TypeScript 类型草稿 (`src/types/prototype-contract.d.ts`) 与模拟数据 (`src/mocks/prototype-data.ts`)，通过 **三层验收（工程验证、契约验证、主管验收）** 完成阶段版本归档。

---

## 0. 本课教学目标 (Learning Objectives)

完成本课学习后，你将能够：
1. **对比与阐述** 单次口头 Prompt 的模糊局限，以及使用 `grill-me` 技能护栏收敛业务契约的底层优势。
2. **区分与解构** **Acceptance Criteria (基于 Given-When-Then 的验收条件)** 与 **Stop / Escalation Conditions (Agent 停止或上提熔断条件)** 的本质区别。
3. **推导与锁定** 业务契约 **6 大核心要素**（Goal 业务目标、User & Problem 问题定义、Boundary 边界线、Risk 风险隐私、Acceptance Criteria 验收场景、Stop Conditions 停止条件）。
4. **校验与把控** **阻断性待确认事项强校验门禁 (Fail-Closed Blocking Gate)**，确保无未决阻断项落盘。
5. **生成与归档** 承载 9 大完整章节的《业务功能卡与数据契约》(`docs/BUSINESS_FEATURE_CARD.md`)、TypeScript 类型草稿 (`src/types/prototype-contract.d.ts`) 与 Mock 数据 (`src/mocks/prototype-data.ts`)。
6. **执行** **三层验收（工程验证、契约验证、主管验收）**，更新 `docs/PROJECT_STATE.md`，并通过 `git add --` 选择性暂存完成 Git 稳定存档。

---

### 核心模式对比线框图 (Prompting -> Harness 契约锁定 -> 进阶 Loop 预告)

```text
===================================================================================
【第一层：裸 Prompting 模式】 (无护栏约束，口头指令模糊，AI 凭空脑补与数据漂移)

  [模糊口头指令] -------> ( LLM 自由发散 ) -------> [凭空脑补字段 / 数据幻觉 / 需求越界]
   "帮我做个退款页"

===================================================================================
【第二层：Harness Engineering 模式】 (本课实操：把模糊想法变成可执行的业务契约)

  [一句话需求] ---> [ Skill 护栏: grill-me ] ---> 结构化解构 6 大业务要素:
                       (3-5分支, 5-7轮)           - 1. User & Problem (使用者与问题定义)
                                                  - 2. Goal (业务目标与成功指标)
                                                  - 3. Boundary (In/Out of Scope 边界)
                                                  - 4. Risk (数据敏感度与隐私)
                                                  - 5. Acceptance Criteria (Given-When-Then 验收条件)
                                                  - 6. Stop / Escalation (停止与上提熔断条件)
                                                         │
                                                         ▼
                                          [ 阻断性待确认事项强校验门禁 ]
                                          (未通过: BLOCKING_GATE_FAILED 拒绝落盘)
                                                         │ (全通过: 允许落盘)
                                                         ▼
  [ TS 类型草稿 ] <--- [ 模拟数据 ] <--- [ 业务功能卡与数据契约 (9大完整章节) ]
  (contract.d.ts)   (prototype-data.ts)     (docs/BUSINESS_FEATURE_CARD.md)

===================================================================================
【第三层：Bounded Agent Loop 模式】 (第四课预演：基于契约护栏的受控自主循环)

  ┌─────────────────────────────────────────────────────────────────────────────┐
  │  [输入 Goal] ──> [ Plan 实施计划 ] ──> [ 增量写代码 ] ──> [ 自动化断言 Verify ]│
  │                         ▲                                        │          │
  │                         └────── (验证失败: 停止上提) ─────────────┘ (PASS: 交付)│
  └─────────────────────────────────────────────────────────────────────────────┘
   * 验证失败规则：停止执行 -> 保存证据 -> 由主管裁决修复、调整计划或上提，决不盲目自动循环！
===================================================================================
```

---

## 1. 核心概念与护栏机制

### 1.1 核心概念卡：Prompting -> Harness (5分钟概念卡)
- **Prompting (单次指令)**：口头描述任务，AI 容易产生凭空脑补与需求漂移；
- **Harness Engineering (工程护栏)**：本课核心。通过配置文件、`grill-me` 追问与 `BUSINESS_FEATURE_CARD.md` 业务契约，死死约束 Agent 修改范围。

### 1.2 关键概念区分：Acceptance Criteria (验收条件) vs. Stop Conditions (停止/上提条件)
- **Acceptance Criteria (验收条件)**：用于判断**功能做出来后是否正确**，格式采用场景化 `Given [上下文] / When [操作] / Then [预期结果]`。
- **Stop / Escalation Conditions (停止与上提条件)**：用于判断 **Agent 什么时候必须熔断暂停并呈报主管**。例如：关键字段来源未确认、需求超界、规则冲突或达到追问轮数上限。

### 1.3 阻断性待确认事项强校验门禁 (Fail-Closed Blocking Gate)
在 3–5 个主要决策分支、5–7 轮追问中，若以下 6 项核心内容仍存在 `[待确认]`，**`grill-me` 会输出 `BLOCKING_GATE_FAILED` 拒绝落盘文件，不得进入第四课**：
1. 核心使用者与责任角色；
2. 核心字段来源；
3. 关键业务规则；
4. 敏感数据处理方式；
5. In Scope 边界线；
6. 至少 1 个核心 Given-When-Then 验收场景。

非阻断问题留在 Section 9 `Open Decisions`，格式：`[事项 | 负责人 | 截止日期 | 是否阻断: 否 | 影响范围]`。

### 1.4 `BUSINESS_FEATURE_CARD.md` 9 大完整章节
数据契约统一写入 `docs/BUSINESS_FEATURE_CARD.md`：
1. User & Problem；2. Goal；3. In Scope / Out of Scope；4. Business Rules；5. Risks and Data Policy；6. Acceptance Scenarios；7. Stop / Escalation Conditions；8. Data Contract；9. Open Decisions。

### 1.5 契约冻结与变更规则 (Contract Freeze Rule)
> **主管验收 PASS 后，`BUSINESS_FEATURE_CARD.md` 成为第四课的唯一需求基线。后续如需修改范围、业务规则、数据契约或验收场景，必须先更新 `BUSINESS_FEATURE_CARD.md` 并重新获得主管确认，不得直接在实施代码中静默改变需求。**

---

## 2. 学员实操任务

### 任务 0：基线检查
检查项目环境与上一课状态：
```text
请检查当前 Git 状态，确认 docs/PROJECT_STATE.md 存在且工作区干净。
```

---

### 任务 1：唤醒 `grill-me` 追问澄清 (Interview 阶段)

**操作指令**：
```text
/grill-me
我想针对我选定的业务原型方向做需求澄清。请一次只问一个问题，控制在 5-7 轮内帮助我澄清使用者与问题、目标、边界、风险、Given-When-Then 验收场景、停止条件与数据契约。
```

---

### 任务 2：生成契约预览与 HITL 授权落盘 (Preview & Write 阶段)

**操作指令 1 (Task 3A 聊天窗口预览)**：
```text
澄清完成，请在聊天窗口中输出 docs/BUSINESS_FEATURE_CARD.md (含9大章节)、src/types/prototype-contract.d.ts 与 src/mocks/prototype-data.ts 的预览。不要修改任何磁盘文件。
```

**操作指令 2 (Task 3B HITL 授权落盘)**：
```text
同意方案，请开始落盘功能卡与契约资产
```

---

### 任务 3：三层验收、更新 PROJECT_STATE.md 与选择性暂存 Commit (Verify & Commit 阶段)

**三层验收标准**：
1. **工程验证**：运行 `npm run typecheck` 与 `npm run build` PASS。
2. **契约验证**：确认 `prototype-contract.d.ts` 与 `prototype-data.ts` 字段名、类型、必填性、枚举和示例语义一致。
3. **主管验收**：主管核对 `BUSINESS_FEATURE_CARD.md` 包含 9 大章节，无阻断性待确认事项。

**更新 PROJECT_STATE.md 与 Git 选择性暂存指令**：
1. 更新 `docs/PROJECT_STATE.md`：
   - 设置 `L03` 状态为 `PASS`；
   - 记录本课产物路径与下一课输入。
2. 执行选择性暂存与 Commit：
```bash
git status
git add -- docs/BUSINESS_FEATURE_CARD.md
git add -- src/types/prototype-contract.d.ts
git add -- src/mocks/prototype-data.ts
git add -- docs/PROJECT_STATE.md
git diff --cached --name-only
git diff --cached
git commit -m "feat: complete lesson 3 business and data contracts"
```

---

## 4. 学员课后记忆卡与退场测试 (Exit Ticket & Misconceptions)

### ✍️ 学员概念互动填空 (Interactive Concept Fill-in-the-Blanks)
1. **Prompting vs. Harness**：盲发口头 Prompt 容易引发 AI 凭空脑补与需求漂移；通过 **`grill-me` 技能护栏** 进行 3–5 分支、5–7 轮结构化追问，本质是将模糊需求转化为 **确定性的业务契约**。
2. **Given-When-Then vs. Stop Conditions**：基于场景的 `Given-When-Then` 用于判断 **功能做出来后是否正确**（验收条件）；而 `Stop Conditions` 用于判断 **Agent 什么时候必须熔断暂停并呈报主管**（停止与上提条件）。
3. **契约三件套**：第三课落盘的三大契约资产分别是 Markdown 格式的《业务功能卡》(`docs/BUSINESS_FEATURE_CARD.md`)、TypeScript 类型草稿 (`src/types/prototype-contract.d.ts`) 以及运行时模拟种子数据 (`src/mocks/prototype-data.ts`)。
4. **强校验门禁 (Fail-Closed Blocking Gate)**：若使用者角色、核心字段来源、业务规则、敏感数据处理方式、In Scope 边界线或 Given-When-Then 场景存在 `[待确认]` 事项，`grill-me` 会输出 **`BLOCKING_GATE_FAILED`** 拒绝落盘文件。

### 💡 常见概念误区与正确理解 (Misconceptions vs. Correct Engineering Reality)

| 常见误区 (Misconception) | 正确硬核理解 (Correct Engineering Reality) | 如何纠偏与护栏防护 (Remedy & Guardrails) |
| :--- | :--- | :--- |
| **误区 1：“直接给 AI 发‘帮我做个工单预警页面’最省事”** | 口头一句话需求缺乏数据来源与规则边界，AI 会凭空编造字段名与数据结构，到了第四课增量编码时直接产生类型崩溃。 | 唤醒 `grill-me` 护栏，强制通过 3–5 个决策分支、5–7 轮追问锁死 6 大业务要素。 |
| **误区 2：“把 Given-When-Then 用例当成 Stop Conditions”** | 验收用例是描述成功/异常的页面行为预期（Acceptance Criteria）；Stop Conditions 是约束 Agent 权限越界、规则冲突或未决事项时的熔断自杀开关。 | 明确区分两类概念，Stop Conditions 必须包含“触发未决阻断项时自动暂停并上呈主管”。 |
| **误区 3：“带着 `[待确认]` 事项也能强行落盘写代码”** | 阻断性事项未澄清意味着需求基准缺失，在缺失基准上写代码会导致后续大面积二次重构与沟通蒸发。 | 触发 Blocking Gate 强校验门禁，未通过时输出 `BLOCKING_GATE_FAILED` 拒绝落盘。 |
| **误区 4：“在 Mock 假数据里标记敏感度是多此一举”** | 在原型中标记敏感等级是写给未来 IT 部门的 **生产网关脱敏规约**，告知生产环境哪些字段物理禁止送入 LLM 模型。 | Task 2 契约表格中必须显式标明敏感等级（Public / Internal / Secret）。 |

---

### 🎯 退场测试题 (Exit Ticket)

* **问题 1**：`Acceptance Criteria (Given-When-Then 验收条件)` 与 `Stop Conditions (停止上提条件)` 的本质区别是什么？
* **参考答案**：
  - `Acceptance Criteria` 描述功能开发完成后如何判断其输出与逻辑是否正确（Given 上下文 / When 操作 / Then 预期结果）。
  - `Stop Conditions` 描述 Agent 在执行过程中遇阻或触及权限边界时，何时必须熔断暂停并向上呈报主管裁决。
* **问题 2**：为什么在写入磁盘前要生成 `src/types/prototype-contract.d.ts` 类型草稿？
* **参考答案**：
  - TypeScript 类型草稿是强类型的数据契约，能在编码前锁定字段名称、数据类型与必填属性，防止第四课 AI 增量编码时字段随心所欲飘移；同时 IT 部门接手后可直接复用该接口定义。
