# 第三课学员操作指南 — 把模糊想法变成可执行的业务契约：grill-me 澄清与 3 份契约冻结

> 💡 **本课的核心思想只有一句话：**  
> **不要急着写代码，先用三份契约锁定业务边界与测试验收标准。**

---

## 一、 本课背景、底层原理与学习目标

### 1.1 业务背景与真实痛点
在实际业务开发中，最常踩的坑是“需求模糊不清就直接开工”。主管口头说“做一个工单管理功能”，AI 凭空想象补充了许多不符合实际业务逻辑的字段；或者遇到歧义时 AI 自作主张，导致最终写出来的代码与真实业务大相径庭。

### 1.2 宏观受控闭环
本课的核心工程机制，是将业务需求澄清纳入一条**“`grill-me` 追问澄清 ➔ 契约文档冻结 ➔ TS 类型声明 ➔ 模拟数据灌入 ➔ 升阶与只读预检”**的受控闭环中：
1. **唤醒 `grill-me` 互动追问**：通过 `/grill-me` 追问式 Skill，AI 像资深架构师一样反向提问主管，解构 6 大业务要素、`Given-When-Then` 验收标准与 `Stop / Escalation` 条件（升阶熔断条件）。
2. **三份契约落盘与冻结**：
   - 契约 1：[`docs/BUSINESS_FEATURE_CARD.md`](file:///d:/AILearning/docs/BUSINESS_FEATURE_CARD.md)（业务功能卡与 6 大业务要素）。
   - 契约 2：[`src/types/prototype-contract.d.ts`](file:///d:/AILearning/src/types/prototype-contract.d.ts)（TypeScript 数据契约字典）。
   - 契约 3：[`src/mocks/prototype-data.ts`](file:///d:/AILearning/src/mocks/prototype-data.ts)（静态 Mock 模拟数据集）。
3. **Task 3A 只读预览门禁**：在生成最终代码前，必须先进行 Task 3A 只读结构预览，未经主管授权不得修改任何现有源码（严禁使用路径切换命令 `cd <project-path>`）。

### 1.3 核心学习目标
完成本课实操后，你将能够：
1. 掌握唤醒并使用 `/grill-me` 互动澄清 Skill 梳理业务 6 大要素。
2. 掌握落盘与冻结 3 份业务与数据契约的方法，理解假数据标记敏感度的脱敏规约价值。
3. 掌握 `Given-When-Then` 验收条件与 `Stop / Escalation` 升阶熔断机制。
4. 掌握 Task 3A 只读结构预览门禁与 Task 3B 授权落盘的物理分工。

---

## 二、 💡 本课核心工程概念卡 (Core Concepts)

### 核心概念 1：`grill-me` 追问澄清机制与 6 大业务要素 (`BUSINESS_FEATURE_CARD.md`)
- **硬核工程定义**：AI 扮演资深产品架构师，通过连续多轮针对性提问，逼平业务模糊点并落盘为包含 6 大业务要素的功能契约的交互范式。
- **底层运作机制**：AI 扫描现有工程上下文，针对 6 大要素依次提问：
  1. **User & Problem**：使用者与业务痛点定义
  2. **Goal**：业务目标与成功指标
  3. **Boundary**：In/Out of Scope 显式边界
  4. **Risk**：数据敏感度与隐私标记
  5. **Acceptance Criteria**：`Given-When-Then` 结构化业务验收场景
  6. **Stop / Escalation**：触发请示主管的暂停熔断条件
- **具象业务比喻**：**装修开工前的主材确认清单** 📝。在敲墙前，业主和工长必须对齐瓷砖品牌、开关插座数量并签字确认。
- **IT 沟通场景**：“需求已通过 `grill-me` 完成澄清，并落盘为包含 6 大要素的 `BUSINESS_FEATURE_CARD.md` 业务契约。”

### 核心概念 2：工程拨乱反正卡：为什么假数据也要标记敏感度？
- **硬核工程定义**：在原型开发阶段为 Mock 字段标注隐私等级（公开 / 内部 / 严禁发送 AI），建立面向生产环境的脱敏规约。
- **底层运作机制**：在原型中标记敏感度不是给当下的 Mock 假数据看的，而是写给未来 IT 部门的**生产网关脱敏规约 (Sanitization Guardrail)**。提前告知 IT 部门未来生产系统上线时，安全网关必须在物理层切断该敏感字段，禁止送入任何公共 LLM 模型。
- **具象业务比喻**：**演习炸药箱上的红字警示标签** ⚠️。即使里面装的是演习用的无害沙子，箱子上也必须贴好“高危物品”标签，防止真打仗时工人搬错。
- **IT 沟通场景**：“数据契约表标注了敏感等级，作为未来生产 API 网关脱敏过滤的交接规约。”

### 核心概念 3：数据契约与海关报关单 (Data Contract TS Types & Mock Data)
- **硬核工程定义**：使用 TypeScript Interface 强类型定义业务对象的物理字段，并配合 Mock 数据文件实现的前后端数据协议。
- **底层运作机制**：在 `prototype-contract.d.ts` 中声明字段类型（如 `status: 'pending' | 'resolved'`），在 `prototype-data.ts` 中填充静态测试对象。
- **具象业务比喻**：**海关进口商品的标准报关单海关编码** 📦。《业务功能卡》是集装箱的物理骨架，`prototype-contract.d.ts` 是标准海关报关单。
- **IT 沟通场景**：“我们冻结了 `prototype-contract.d.ts` 数据契约，保证前端界面与数据字典 100% 匹配。”

### 核心概念 4：`Given-When-Then` 验收标准与 `Stop / Escalation` 升阶条件
- **硬核工程定义**：行为驱动开发 (BDD) 的结构化验收语法，配合异常越界时的自动停止与人工升阶响应机制。
- **底层运作机制**：定义 `Given`(前置条件) -> `When`(触发动作) -> `Then`(预期结果)；当遇到数据丢失或规则冲突时触发 Stop 熔断，升阶至主管干预。
- **具象业务比喻**：**工厂流水线的紧急拉绳熔断阀** 🛑。组装顺畅时按流程运转，一旦发现零部件开裂，拉绳停机并升阶给车间主任。
- **IT 沟通场景**：“功能卡包含了完整的 Given-When-Then 验收链条与 Stop / Escalation 升阶条件，规避了黑盒风险。”

---

## 三、 🔄 核心模式对比线框图 (Prompting -> Harness 契约锁定 -> 进阶 Loop 预告)

```text
===================================================================================
【第一层：裸 Prompting 模式】(无护栏约束，口头指令模糊，AI 凭空脑补与数据漂移)
   [模糊口头指令] -------> ( LLM 自由发散 ) -------> [凭空脑补字段 / 数据幻觉 / 需求越界]
   "帮我做个退款页"
===================================================================================
【第二层：Harness Engineering 模式】(本课实操：把模糊想法变成可执行的业务契约)
   [一句需求] ---> [ Skill 护栏: grill-me ] ---> 结构化解构 6 大业务要素:
                   (3-5分支, 5-7轮)             - 1. User & Problem (使用者与问题定义)
                                                - 2. Goal (业务目标与成功指标)
                                                - 3. Boundary (In/Out of Scope 边界)
                                                - 4. Risk (数据敏感度与隐私)
                                                - 5. Acceptance Criteria (业务验收场景)
                                                - 6. Stop / Escalation (请示主管门禁)
                                                        │
                                                        ▼
                                       [ 强校验需求门禁: 没想清楚不准开工 ]
                                       (未通过: [需求遗漏拦截] 拒绝落盘)
                                                        │ (全通过: 允许落盘)
                                                        ▼
   [ 数据字典表 ] <--- [ 模拟数据 ] <--- [ 业务功能卡与数据契约 (9大完整章节) ]
   (contract.d.ts)   (prototype-data.ts)  (docs/BUSINESS_FEATURE_CARD.md)
===================================================================================
【第三层：Bounded Agent Loop 模式】(第四课预演：基于契约护栏的受控自主循环)
   ┌────────────────────────────────────────────────────────────────────────┐
   │  [输入 Goal] --> [ Plan 实施计划 ] --> [ 增量写代码 ] --> [ 校验 Verify ] │
   │                         ▲                                       │      │
   │                         └─────── (验证失败: 停止上提) <─────────┘      │
   │                                                             (PASS: 交付)│
   └────────────────────────────────────────────────────────────────────────┘
   * 验证失败规则: 停止执行 -> 保存证据 -> 由主管裁决修复、调整计划或上提！
===================================================================================
```

---

## 四、 🛠️ 课堂实操与自学导引任务清单

### Task 1: 唤醒 `grill-me` 技能进行需求追问

#### ⚡ 极速操作步骤
1. 在 Claude Code CLI 窗口中下发 `grill-me` 发起提示词模板：
   ```text
   请使用 grill-me 技能帮我梳理需求。

   我的业务原型类型是：【B. 任务与流程型】
   我的业务痛点与一句话需求是：【运营主管每天需要手动统计超时未履约的工单，效率低且容易漏单，希望能有一个自动预警和催单的工单处理看板】

   请按照 grill-me 规范，每次只问我 1 个最关键的问题，帮我理清目标、边界与核心字段。
   在需求澄清完毕前，绝对不要修改任何代码与文件。
   ```
2. 针对工单管理功能回答 AI 提出的 3~5 轮追问（包括正常流、边界容错与 `Stop / Escalation` 升阶条件）。

🚨 **防错救急路径 (Skill 装载降级救援)**：
> 如果 Agent 一次抛出了 2 个以上问题，或者擅自开启了文件修改，说明 Skill 未成功激活。请立即发送：  
> 👉 **`请重新读取并严格遵循 .claude/skills/grill-me/SKILL.md 的物理指令，一次只问我一个问题！`**

---

### Task 2: 数据契约卡梳理与敏感度标记

#### ⚡ 极速操作步骤
1. 在 CLI 中发送数据契约梳理提示词模板：
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
2. 检查输出的数据契约表，确认包含了完整的 7 维属性与敏感等级标注。

---

### Task 3: 功能卡、TS 类型与 Mock 种子数据只读预览与 HITL 盖章落盘 (Task 3A / 3B)

#### ⚡ 极速操作步骤
1. **Task 3A 只读方案汇总与预览**：发送提示词模板：
   ```text
   请将前面的讨论成果汇总：

   1. 拟定 Markdown 文档《业务功能卡》内容预览（包含 Goal、Boundaries、Risks、Given-When-Then 格式的 Stop Conditions）。
   2. 拟定 TypeScript 接口草稿（src/types/prototype-contract.d.ts）与 Mock 种子数据（src/mocks/prototype-data.ts）的导出代码预览。

   请只输出预览方案，等待我回复许可口令，严禁提前写入文件。
   ```
2. 在收到 Agent 输出预览无误后，发送 **HITL 授权盖章口令**：  
   👉 **`同意方案，请开始落盘功能卡与契约资产`**
3. **Task 3B 接收授权，自动落盘契约文件**：确认生成 3 份文件：
   - [`docs/BUSINESS_FEATURE_CARD.md`](file:///d:/AILearning/docs/BUSINESS_FEATURE_CARD.md)
   - [`src/types/prototype-contract.d.ts`](file:///d:/AILearning/src/types/prototype-contract.d.ts)
   - [`src/mocks/prototype-data.ts`](file:///d:/AILearning/src/mocks/prototype-data.ts)

---

### Task 4: 验证、状态更新与 Git 提交

#### ⚡ 极速操作步骤
1. 打开 [`docs/PROJECT_STATE.md`](file:///d:/AILearning/docs/PROJECT_STATE.md)，更新以下内容：
   - 将 **L03 课程状态** 改为 `PASS`；
   - 在 **前置基线 Git SHA** 确认记有第二课完结的 Commit SHA；
   - 填写 **下一课输入**：“以 `BUSINESS_FEATURE_CARD.md` 与 `prototype-contract.d.ts` 为依据开启第 4 课开发”。
2. 在 PowerShell 中运行 Git 提交指令：
   ```powershell
   git status
   git add .
   git diff --cached
   git commit -m "feat: complete lesson 3 requirement, data contract cards and ts interface draft"
   git log --oneline -5
   ```
3. 运行 `git log -1 --oneline` 确认本次生成的本课落盘 Commit SHA，该 SHA 将作为第 4 课的前置基线凭证。

---

## 五、 💡 常见概念误区与正确理解 (Mindset Transformation)

| 常见误区 (Misconception) | 正确硬核理解 (Correct Engineering Reality) | 如何纠偏与护栏防护 (Remedy & Guardrails) |
| :--- | :--- | :--- |
| **误区 1：“直接发‘帮我做个退款页面’最省事”** | 模糊指令会导致 AI 凭空脑补字段与数据幻觉，后续接后端时项目直接崩溃。 | 必须使用 `grill-me` 强制完成 3~5 轮追问。 |
| **误区 2：“现在用的都是假数据，不需要标敏感度”** | 敏感度标记是写给 IT 部门的交接契约，告知生产环境哪些真实字段不可送入 LLM。 | 在 Task 2 表格中必须显式标明敏感等级（公开/内部/严禁发送AI）。 |
| **误区 3：“遇到业务异常或数据缺失时让 AI 随意猜测 fallback”** | 盲目静默掩盖报错会导致坏数据写入系统。 | 在功能卡中明确定义 `Stop / Escalation` 升阶条件，异常时拉绳停机。 |
| **误区 4：“AI 生成代码前不需要经过只读预览”** | 直接让 AI 修改源码可能误删已有逻辑。 | 执行 Task 3A 只读结构预览门禁，确认无误后再授权 Task 3B 写入。 |

---

## 六、 ❓ 常见操作报错与 Troubleshooting 指南

| 报错/异常现象 | 物理原因 | 解决与纠偏方案 |
| :--- | :--- | :--- |
| 页面提示 `TypeError: Cannot read property of undefined` | Mock 数据字段与 TS 接口声明不一致 | 核对 `prototype-contract.d.ts` 与 `prototype-data.ts` 字段。 |
| AI 尝试运行 `cd <project-path>` 导致报错 | 执行了多余的路径切换指令 | 提示 AI 保持在工程根目录，禁止执行 `cd` 指令。 |

---

## 七、 📝 巩固与退场测试题库 (4 题精选)

### 阶段 1：课堂退场盖章测试 (Exit Ticket)
1. **[演进填空题]** AI 应用能力的三个阶段分别是：裸 Prompting ➔ ____________ Engineering ➔ Bounded Agent ____________。第三课实操停留在第 ____________ 层。
2. **[契约选择题]** 在第三课冻结的三份契约资产中，用于定义 TypeScript 数据字段接口的文件是 ____________。
   - A. `BUSINESS_FEATURE_CARD.md`
   - B. `prototype-contract.d.ts`
   - C. `prototype-data.ts`
   - D. `PROJECT_STATE.md`
3. **[IT 沟通场景题]** 当你需要向 IT 开发团队交接需求时，你应该怎么说？
   - **参考回答**：“我们已经通过 `grill-me` 完成了需求澄清，落盘了包含 Given-When-Then 的业务功能卡与 `prototype-contract.d.ts` 数据契约，敏感字段已标注脱敏规约。”

---

### 阶段 2：课后自学拓展思考题 (Self-Study Extension)
4. **[原理思考题]** 为什么在第一阶段写代码前，就要先生成 `src/types/prototype-contract.d.ts` 这种 TypeScript 类型文件？它在 IT 交接中起什么作用？
