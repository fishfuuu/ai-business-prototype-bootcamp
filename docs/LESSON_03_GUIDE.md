# 第三课学员指南 (V2 闭环版)：把模糊想法变成可执行的业务契约

欢迎来到第三课！在前两课中，我们完成了页面搭建与视觉美化。本节课我们将解决业务原型研发中最核心的问题——**“如何把模糊业务想法变成可执行、可验收的业务契约”**。需求不是一句简单的 Prompt，而是一组经过确认的业务决定。你将学习如何唤醒 `grill-me` 追问护栏进行结构化澄清，前置锁定 **6 大业务要素**，将数据契约统一收扣至 `docs/BUSINESS_FEATURE_CARD.md`，并生成 TypeScript 类型草稿 (`src/types/prototype-contract.d.ts`) 与模拟数据 (`src/mocks/prototype-data.ts`)，通过 **三层验收（工程验证、契约验证、主管验收）** 完成阶段版本归档。

---

## 0. 本课教学目标 (Learning Objectives)

完成本课学习后，你将能够：
1. **对比与阐述** 单次口头 Prompt 的模糊局限，以及使用 `grill-me` 技能护栏收敛业务契约的底层优势。
2. **区分与解构** **Acceptance Criteria (基于 Given-When-Then 的验收条件)** 与 **Stop / Escalation Conditions (Agent 停止或上提熔断条件)** 的本质区别。
3. **推导与锁定** 业务契约 **6 大核心要素**（Goal 业务目标、User & Problem 问题定义、Boundary 边界线、Risk 风险隐私、Acceptance Criteria 验收场景、Stop Conditions 停止条件）。
4. **生成与归档** 承载 9 大完整章节的《业务功能卡与数据契约》(`docs/BUSINESS_FEATURE_CARD.md`)、TypeScript 类型草稿 (`src/types/prototype-contract.d.ts`) 与 Mock 数据 (`src/mocks/prototype-data.ts`)。
5. **执行** **三层验收（工程验证、契约验证、主管验收）**，并通过 `git add --` 选择性暂存完成 Git 稳定存档。

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
                          (一次只问 1 题)         - 1. User & Problem (使用者与问题定义)
                                                  - 2. Goal (业务目标与成功指标)
                                                  - 3. Boundary (In/Out of Scope 边界)
                                                  - 4. Risk (数据敏感度与隐私)
                                                  - 5. Acceptance Criteria (Given-When-Then 验收条件)
                                                  - 6. Stop / Escalation (停止与上提熔断条件)
                                                         │
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

一句话记住需求澄清铁律：
> **本课实操聚焦于第二层 Harness Engineering（工程护栏层）。需求不是一句 Prompt，而是一组经过确认的业务决定；在 Harness 层锁定 6 大要素与数据契约，是在为第四课开启受控自主 Loop 装上“刹车片与导航轨”！**

---

## 1. 核心概念与护栏机制

### 1.1 核心概念卡：Prompting -> Harness (5分钟概念卡)
- **Prompting (单次指令)**：口头描述任务，AI 容易产生凭空脑补与需求漂移；
- **Harness Engineering (工程护栏)**：本课核心。通过配置文件、`grill-me` 追问与 `BUSINESS_FEATURE_CARD.md` 业务契约，死死约束 Agent 修改范围。
- *(注：第三层 Bounded Agent Loop 属于第四课预告，不在本课展开。)*

### 1.2 关键概念区分：Acceptance Criteria (验收条件) vs. Stop Conditions (停止/上提条件)
为防止概念混淆，全课程严格区分：
- **Acceptance Criteria (验收条件)**：用于判断**功能做出来后是否正确**，格式采用场景化 `Given [上下文] / When [操作] / Then [预期结果]`。
- **Stop / Escalation Conditions (停止与上提条件)**：用于判断 **Agent 什么时候必须熔断暂停并呈报主管**。例如：
  1. 关键字段来源未确认或存在冲突；
  2. 用户指令试图访问真实敏感数据；
  3. 需求范围超出已批准的 In Scope 边界；
  4. 达到最大追问轮数仍无法达成一致。

### 1.3 `BUSINESS_FEATURE_CARD.md` 9 大完整章节
数据契约统一写入 `docs/BUSINESS_FEATURE_CARD.md`，避免维护过多散乱文件：
1. **User & Problem**：使用者与责任角色、当前工作流程与现有问题及事实证据（标记 `[事实]`、`[决定]`、`[假设]`、`[待确认]`）；
2. **Goal**：业务目标、期望产生的决策动作与成功指标；
3. **In Scope / Out of Scope**：包含与明确不做范围冻结线；
4. **Business Rules**：核心业务规则；
5. **Risks and Data Policy**：数据敏感等级（公开/内部/严禁发送AI）与隐私防护；
6. **Acceptance Scenarios**：基于 `Given-When-Then` 的验收场景；
7. **Stop / Escalation Conditions**：Agent 停止与上提熔断条件；
8. **Data Contract**：数据契约表（字段名、业务含义、数据类型、必填、数据来源、示例值、敏感等级）；
9. **Open Decisions**：开放决定与待确认事项。

### 1.4 三类业务原型深度分支契约
- **A. 监控与决策型**：重点确认指标口径、时间范围、基准、阈值、异常等级、下钻维度、触发动作；
- **B. 任务与流程型**：重点确认角色、业务状态、状态转换、允许动作、驳回/撤销、权限边界；
- **C. 操作工具型**：重点确认输入、校验、处理规则、输出、失败处理、HITL 确认点。

### 1.5 TypeScript 类型草稿定位
`src/types/prototype-contract.d.ts` 为后续原型开发提供字段和类型基线，降低字段漂移及沟通成本；**它不是正式生产 API 合同，也不能替代运行时校验和 IT 评审**。

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
我想针对我选定的业务原型方向做需求澄清。请一次只问一个问题，帮助我澄清使用者与问题、目标、边界、风险、Given-When-Then 验收场景、停止条件与数据契约。
```

**完成标准**：
- [ ] 完成 3–5 轮对话，逐题澄清 6 大业务要素。
- [ ] 标注 `[事实]`、`[决定]`、`[假设]` 与 `[待确认]` 事项。

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

**完成标准**：
- [ ] 项目根目录成功生成：
  - `docs/BUSINESS_FEATURE_CARD.md`
  - `src/types/prototype-contract.d.ts`
  - `src/mocks/prototype-data.ts`

---

### 任务 3：三层验收与选择性暂存 Git 存档 (Verify & Commit 阶段)

**三层验收标准**：
1. **工程验证**：运行 `npm run typecheck` 与 `npm run build` PASS。
2. **契约验证**：确认 `prototype-contract.d.ts` 与 `prototype-data.ts` 字段 100% 对应。
3. **主管验收**：主管核对 `BUSINESS_FEATURE_CARD.md` 中问题、边界、规则、验收场景与待确认事项。

**Git 选择性暂存指令**：
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

## 3. 课后退场自测 (Exit Ticket)

> **退出门禁题**：`Acceptance Criteria (验收条件)` 与 `Stop Conditions (停止条件)` 的核心区别是什么？

* **参考答案**：
  验收条件（Given-When-Then）用于判断功能做出后是否正确；停止/上提条件用于判断 Agent 什么时候必须暂停执行并呈报主管（如关键字段未确认、需求超界或规则冲突）。

---

## 4. 常见卡点与排错 (FAQ)

| 卡点现象 | 根因分析 | 处理建议 |
| --- | --- | --- |
| Agent 一口气问了 5 个问题 | 未成功激活 `grill-me` 技能护栏 | 发送 `/grill-me` 明确要求“一次只问 1 个问题” |
| Agent 擅自写了代码 | 缺少 Task 3A/3B 门禁控制 | 提示 Agent：“现在只输出文字预览，等待我的授权口令” |
| 无法区分假设与事实 | 业务想法未经过验证 | 在文档中使用 `[假设]` 与 `[待确认]` 标签标注 |
