# 第三课学员指南 (V2 重构版)：让 Agent 帮助自己想清楚需求

欢迎来到第三课！在完成前两课的页面搭建与视觉美化后，本节课我们将解决系统研发中最核心的问题——**需求表达与数据契约**。你将学习如何使用 `grill-me` 技能护栏进行 3~5 轮结构化追问，锁定前置 4 大要素，并产出能让 IT 部门直接落地的《数据契约卡》与 TypeScript 接口定义草稿。

---

## 0. 本课教学目标 (Learning Objectives)

完成本课学习后，你将能够：
1. **对比与阐述** 单次裸 Prompt 的局限性与 Skill Harness (`grill-me`) 追问护栏的物理机制。
2. **构建与锁定** 驱动 Agent 受控自主 Loop 的 **前置 4 大要素**（Goal 目标、Boundaries 边界、Risks 风险、Stop Conditions 停止条件）。
3. **推导与标记** 包含 7 维属性与敏感等级（写给 IT 部门看）的《轻量数据契约卡》。
4. **生成与交付** 业务文档 `docs/BUSINESS_FEATURE_CARD.md` 与 TypeScript 类型接口草稿 `src/types/prototype-contract.d.ts`。
5. **执行** 工程校验 `verify-project.ps1`，完成阶段 Git 稳定存档与退场测试卡。

---

### 核心模式对比线框图 (Prompting -> Harness -> Bounded Loop)

```text
===================================================================================
【第一层：裸 Prompting 模式】 (无护栏约束，AI 凭空脑补，逻辑与数据随意漂移失控)

 [模糊口头指令] -------> ( LLM 大脑 ) -------> [凭空脑补字段 / 数据幻觉 / 乱改代码]
  "帮我做个退款页"       (自由概率发散)

===================================================================================
【第二层：Harness Engineering 模式】 (本课实操：多重护栏收敛，规格契约落盘)

 [一句话需求] ---> [ Skill 护栏: grill-me ] ---> 结构化解构 4 大要素 (Loop 规格):
                         (一次只问1题)            - Goal (目标) + Boundary (边界)
                                                  - Risk (敏感度) + Stop (前置断言)
                                                         |
                                                         v
 [强类型接口草稿] <--- [ TS 契约: contract.d.ts ] <--- [ 海关货物报关单 (数据契约) ]
 (字段绝不漂移)        (类型强绑定)                      (字段/规格类型/敏感度标记)

===================================================================================
【第三层：Bounded Agent Loop 模式】 (第四课预演：基于护栏的受控自主循环，小步快跑)

  +-----------------------------------------------------------------------------+
  |  [输入 Goal] -> [ Agent 规划 ] -> [ 增量写代码 ] -> [ 自动化断言 Verify ]    |
  |                        ^                                   |                |
  |                        |---------- (未通过: 自动纠偏) ------| (PASS: 交付)   |
  +-----------------------------------------------------------------------------+
   * 必须受第二层 Harness (Stop Conditions / 4大要素) 物理约束，否则死循环撞墙！
===================================================================================
```

一句话记住需求澄清铁律：
> **本课实操聚焦于第二层 Harness Engineering（工程护栏层）。4 大要素是《业务功能卡》的货运集装箱骨架，数据契约则是海关货物报关单；提前在 Harness 层锁定 4 大要素护栏，是在为第四课开启第三层受控自主 Loop（Bounded Loop）装上“刹车片与导航轨”！**

---

## 1. 核心概念【硬核四步解析卡】

在开始实操前，请认真阅读以下 3 个核心概念的硬核解析：

### ① AI 应用三层能力演进：Prompting -> Harness -> Bounded Agent Loop
* **硬核工程定义**：AI 应用能力的三个发展阶段：
  - **第一层 Prompting (单步指令)**：无约束的自由文本补全，依赖人类单次口头提示；
  - **第二层 Harness Engineering (工程护栏)**：通过配置文件、静态规范（`DESIGN.md`）、技能定义（`grill-me`）与数据契约死死约束 Agent；
  - **第三层 Bounded Agent Loop (受控自主循环)**：在 Goal/Boundary/Risk/Stop 护栏约束下，Agent 具备多步规划、自动执行、脚本验证与自修正的闭环能力。
* **底层运作机制**：**本节课实操完全处于第二层 Harness Engineering**。我们在本课用 `grill-me` 技能与数据契约卡搭建护栏，就是为了在第三层 Bounded Agent Loop（第 4 课开启）运行前，为 Agent 装上“刹车片与导航轨”，防止无界死循环。
* **具象业务比喻**：Prompting 像**对实习生盲目发令**；Harness 像**给实习生制定 SOP 员工手册与工作流护栏**；Bounded Loop 像**让实习生按 SOP 独立完成小步闭环项目**。
* **IT 沟通与交接价值**：向 IT 说明：“我们不搞黑盒 Prompt 盲猜，而是构建 Harness 工程护栏，为后期的 Bounded Agent Loop 提供确定性保障”。

### ② Skill Harness (追问技能护栏 `grill-me`)
* **硬核工程定义**：沉淀在项目 `.claude/skills/grill-me/SKILL.md` 中的领域级工作流定义文件。
* **底层运作机制**：`grill-me` 覆盖了大模型的自由对话逻辑，注入系统级约束：**强制每次只问 1 个最关键的业务问题**、严禁擅自修改代码、直到解构出完整的 Goal/Boundary/Risk/Stop 4 大要素。
* **具象业务比喻**：它是 **“专家级的需求追问防错护栏”**。
* **IT 沟通与交接价值**：向 IT 说明：“我们通过 `grill-me` 技能护栏收敛需求表达，确保输出符合规范的业务规格书，而非零散提示词”。

### ③ 数据契约卡与 TypeScript 类型草稿 (`prototype-contract.d.ts`)
* **硬核工程定义**：数据契约（Data Contract）是前后端或系统间关于数据结构、字段类型、可选性与敏感度的格式化协议。
* **底层运作机制**：根据需求推导出强类型接口，并在 `src/types/prototype-contract.d.ts` 中生成 TypeScript `interface` / `type` 声明，供后续代码开发直接继承，杜绝 `any` 弱类型隐患。
* **具象业务比喻**：它是业务主管与 IT 部门之间的 **“跨部门海关货物报关单 (Customs Declaration List)”**。写明货物品名（字段）、规格类型与危险品标记（敏感度），防止扣货崩溃。
* **IT 沟通与交接价值**：向 IT 说明：“原型已输出强类型的 TypeScript 类型声明，IT 后端开发可直接复用接口字段，零二次沟通成本”。

### ④ Bounded Agent Loop 前置 4 大要素规格 (Goal / Boundary / Risk / Stop)
* **硬核工程定义**：驱动受控 Agent 循环（Bounded Agent Loop）的 4 个物理约束边界规格：
  - **Goal (目标)**：核心业务痛点与功能期望；
  - **Boundaries (边界)**：明确要做什么，更明确 **Out of Scope (明确不做项)**；
  - **Risks (风险)**：字段敏感等级（公开/内部/严禁发送AI）与不可动规则；
  - **Stop Conditions (停止条件)**：写代码前先定义的测试验收断言。
* **底层运作机制**：我们在第三课用 `grill-me` 与契约卡锁定的这 4 大要素，本质上是未来受控自主循环（Bounded Agent Loop）的“停止条件与物理边界线”。没有在 Harness 层锁死这 4 大要素，第 4 课的 Agent 就会死循环或越界改代码。
* **具象业务比喻**：它是项目的 **“骨架与安全护栏”**。没有骨架系统会散，没有护栏 Agent 跑起 Loop 就会撞墙！
* **IT 沟通与交接价值**：向 IT 说明：“原型需求包含了明确的前置 UAT 验收断言与边界防护，便于 IT 编写单元测试”。

---

## 2. 准备工作与前置检查

1. 打开 PowerShell 终端，进入项目根目录。
2. 运行一键校验脚本，确认前两课工程状态健康：
   `powershell -ExecutionPolicy Bypass -File .\scripts\verify-student-project.ps1`
3. 检查 `docs/PROJECT_STATE.md`，确认上一课状态为 `PASS` 且记有 Git Commit SHA。

---

## 3. Task 1：唤醒 `grill-me` 技能进行需求追问 (10 分钟)

**目标**：用一句话发起需求，唤醒 `grill-me` 技能护栏，接受 Agent 3~5 轮结构化追问。

### 复制并发送给 Agent：
```text
请使用 grill-me 技能帮我梳理需求。

我的业务原型类型是：【A. 监控与决策型 / B. 任务与流程型 / C. 操作工具型】
我的业务痛点与一句话需求是：【例如：运营主管每天需要手动统计超时未履约的订单，效率低且容易漏单，希望能有一个自动预警和催单工作台】

请按照 grill-me 规范，每次只问我 1 个最关键的问题，帮我理清目标、边界与核心字段。
在需求澄清完毕前，绝对不要修改任何代码与文件。
```

🚩 **本步检查 (Checklist)**：
- [ ] Agent 严格遵循了 `grill-me` 规则，**每次只问了 1 个问题**。
- [ ] 终端未触发任何代码修改（Agent 保持纯只读需求追问状态）。

🚨 **防错救急路径 (Skill 装载降级救援)**：
> 如果 Agent 一次抛出了 2 个以上问题，或者擅自开启了文件修改，说明 Skill 未成功激活。请立即发送：  
> 👉 **`请重新读取并严格遵循 .claude/skills/grill-me/SKILL.md 的物理指令，一次只问我一个问题！`**

---

## 4. Task 2：数据契约卡梳理与敏感度标记 (15 分钟)

**目标**：梳理包含 7 维属性的数据契约卡，标记字段敏感等级。

💡 **【工程拨乱反正卡】：为什么假数据也要标记敏感度？**
> **学员常见误区**：“我们现在提交给 Claude 的都是 Mock 假数据，为什么还要认真标记‘严禁发送 AI’？”  
> **硬核工程真相**：在原型中标记敏感度，是写给未来 IT 部门的 **生产网关脱敏规约 (Sanitization Guardrail)**！提前告知 IT 部门未来真实生产系统上线时，网络安全网关必须在物理层切断该字段，禁止将其送入任何公共 LLM 模型。

### 复制并发送给 Agent：
```text
基于刚才的对话，请帮我整理一份 Markdown 格式的《轻量数据契约卡》。

包含以下两部分：

1. 基础数据契约表：
   - 字段名称 (英文字段名)
   - 业务含义 (中文名称)
   - 数据类型 (文本/数字/布尔/日期/枚举)
   - 是否必填
   - 数据来源 (固定为 Mock 数据)
   - 示例值
   - 敏感等级 (公开 / 内部 / 严禁发送 AI)

2. 针对我的原型类型的专属扩展契约：
   - 【监控决策型】：指标口径/计算公式、对比基准、异常阈值、下钻维度
   - 【任务流程型】：发起/处理角色、业务状态机(草稿->待处理->已完成)、允许动作、驳回/撤销规则
   - 【操作工具型】：输入结构、校验规则、处理逻辑、输出结构、HITL 人工确认点

先不要写入文件，仅输出内容方案预览呈报给我确认。
```

🚩 **本步检查 (Checklist)**：
- [ ] 数据契约表包含了完整的 7 维属性与敏感等级。
- [ ] 包含了所选原型类型的专属扩展契约。
- [ ] 未触发任何磁盘写操作。

---

## 5. Task 3：功能卡、TS 类型与 Mock 种子数据只读预览与 HITL 盖章落盘 (15 分钟)

**目标**：在 Task 3A 预览待生成的内容，经主管下达 HITL 口令后，在 Task 3B 完成《业务功能卡》、TypeScript 接口草稿 `src/types/prototype-contract.d.ts` 与种子数据 `src/mocks/prototype-data.ts` 的自动落盘。

### Task 3A：只读方案汇总与预览指令
```text
请将前面的讨论成果汇总：

1. 拟定 Markdown 文档《业务功能卡》内容预览（包含 Goal、Boundaries、Risks、Given-When-Then 格式的 Stop Conditions）。
2. 拟定 TypeScript 接口草稿（src/types/prototype-contract.d.ts）与 Mock 种子数据（src/mocks/prototype-data.ts）的导出代码预览。

请只输出预览方案，等待我回复许可口令，严禁提前写入文件。
```

在收到 Agent 输出预览无误后，发送 **HITL 授权盖章口令**：  
👉 **`同意方案，请开始落盘功能卡与契约资产`**

### Task 3B：接收授权，落盘契约文件
Agent 接收授权口令后，自动将方案分别落盘至：
- `docs/BUSINESS_FEATURE_CARD.md`
- `src/types/prototype-contract.d.ts`
- `src/mocks/prototype-data.ts`

🚩 **本步检查 (Checklist)**：
- [ ] `docs/BUSINESS_FEATURE_CARD.md` 已保存，前置 Stop Conditions 采用了 `Given-When-Then` 确定性模板。
- [ ] `src/types/prototype-contract.d.ts` 已保存（静态类型契约）。
- [ ] `src/mocks/prototype-data.ts` 已保存（运行时种子数据）。
- [ ] 严格遵守了 HITL 盖章授权门禁（未授权不擅写文件）。

---

## 6. Task 4：验证、状态更新与 Git 提交 (10 分钟)

1. 打开 `docs/PROJECT_STATE.md`，更新以下内容：
   - 将 **L03 课程状态** 改为 `PASS`；
   - 在 **前置基线 Git SHA** 确认记有第二课完结的 Commit SHA；
   - 填写 **下一课输入**：“以 `BUSINESS_FEATURE_CARD.md` 与 `prototype-contract.d.ts` 为依据开启第 4 课开发”。
2. 在 PowerShell 中运行学员校验脚本：
   `powershell -ExecutionPolicy Bypass -File .\scripts\verify-student-project.ps1`
3. 确认输出 `[PASS]`，在 PowerShell 中运行 Git 提交指令：
   ```powershell
   git status
   git add .
   git diff --cached
   git commit -m "feat: complete lesson 3 requirement, data contract cards and ts interface draft"
   git log --oneline -5
   ```
4. 运行 `git log -1 --oneline` 确认本次生成的本课落盘 Commit SHA，该 SHA 将作为第 4 课的前置基线凭证。

---

## 7. 学员课后记忆卡与退场测试

### ✍️ 学员概念互动填空：
1. **AI 三层演进**：AI 应用能力的三个阶段分别是盲发 Prompting -> ____________ Engineering -> Bounded Agent ____________。第三课实操停留在第 ____________ 层。
2. **Prompt vs. Skill**：盲发口头 Prompt 容易产生 ____________，而 Skill (`grill-me`) 是带有系统约束的 ____________ 护栏。
3. **集装箱与报关单**：4 大要素是《业务功能卡》的 ____________，数据契约是跨部门交接的 ____________。
4. **数据敏感度**：在 Mock 数据中标记“严禁发送 AI”是写给 ____________ 看的交接规约。

### 💡 常见概念误区与正确理解：
| 常见误区 (Misconception) | 正确硬核理解 (Correct Understanding) | 如何纠偏与防护 |
| :--- | :--- | :--- |
| **“直接发‘帮我做个退款页面’最省事”** | 模糊指令会导致 AI 凭空脑补字段与数据幻觉，后续接后端时项目直接崩溃。 | 必须使用 `grill-me` 强制完成 3~5 轮追问。 |
| **“现在用的都是假数据，不需要标敏感度”** | 敏感度标记是写给 IT 部门的交接契约，告知生产环境哪些真实字段不可送入 LLM。 | 在 Task 2 表格中必须显式标明敏感等级。 |

---

## 8. Exit Ticket (退场测试)

在离开教室前，请回答以下测试题：
* **问题**：为什么在第一阶段写代码前，就要先生成 `src/types/prototype-contract.d.ts` 这种 TypeScript 类型文件？它在 IT 交接中起什么作用？
* **答案**：因为 TypeScript 类型文件是强类型的数据契约。提前生成 TS 草稿可以锁定字段名称与类型，防止 AI 在第 4 课写代码时字段随意漂移；同时 IT 部门接手后可直接复用该接口类型，零沟通成本。
