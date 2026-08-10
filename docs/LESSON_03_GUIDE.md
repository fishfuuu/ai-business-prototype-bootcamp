# 第三课学员操作指南 — 把模糊想法变成可执行的业务契约：grill-me 澄清与 3 份契约冻结

> 💡 **本课的核心思想只有一句话：**  
> **不要急着写代码，先用三份契约锁定业务边界与测试验收标准。**

---

## 一、 本课背景、底层原理与学习目标

### 1.1 业务背景与真实痛点
在实际业务开发中，最常踩的坑是“需求模糊不清就直接开工”。主管口头说“做一个工单管理功能”，AI 凭空想象补充了许多不符合实际业务逻辑的字段；或者遇到歧义时 AI 自作主张，导致最终写出来的代码与真实业务大相径庭。

### 1.2 宏观受控闭环
本课的核心工程机制，是将业务需求澄清纳入一条**“`grill-me` 追问澄清 ➔ 契约文档冻结 ➔ TS 类型声明 ➔ 模拟数据灌入 ➔ 升阶与只读预检”**的受控闭环中：
1. **唤醒 `grill-me` 互动追问**：通过 `/grill-me` 追问式 Skill，AI 像资深架构师一样反向提问主管，澄清边界条件、`Given-When-Then` 验收标准与 `Stop / Escalation` 条件（升阶熔断条件）。
2. **三份契约落盘与冻结**：
   - 契约 1：[`docs/BUSINESS_FEATURE_CARD.md`](file:///d:/AILearning/docs/BUSINESS_FEATURE_CARD.md)（业务功能卡与 6 大业务要素）。
   - 契约 2：[`src/types/prototype-contract.d.ts`](file:///d:/AILearning/src/types/prototype-contract.d.ts)（TypeScript 数据契约字典）。
   - 契约 3：[`src/mocks/prototype-data.ts`](file:///d:/AILearning/src/mocks/prototype-data.ts)（静态 Mock 模拟数据集）。
3. **Task 3A 只读预览门禁**：在生成最终代码前，必须先进行 Task 3A 只读结构预览，未经主管授权不得修改任何现有源码（严禁使用路径切换命令 `cd <project-path>`）。

### 1.3 核心学习目标
完成本课实操后，你将能够：
1. 掌握唤醒并使用 `/grill-me` 互动澄清 Skill 梳理业务 6 大要素。
2. 掌握落盘与冻结 3 份业务与数据契约的方法。
3. 掌握 `Given-When-Then` 验收条件与 `Stop / Escalation` 升阶熔断机制。
4. 掌握 Task 3A 只读结构预览门禁与 Task 3B 授权落盘的物理分工。

---

## 二、 💡 本课核心工程概念卡 (Core Concepts)

### 核心概念 1：`grill-me` 追问澄清机制与业务功能卡 (`BUSINESS_FEATURE_CARD.md`)
- **硬核工程定义**：AI 扮演资深产品架构师，通过连续多轮针对性提问，逼平业务模糊点并落盘为包含 6 大业务要素的功能契约的交互范式。
- **底层运作机制**：AI 扫描现有工程上下文，针对使用者与问题、业务目标、边界范围 (In/Out of Scope)、风险敏感度、`Given-When-Then` 验收场景与 `Stop / Escalation` 暂停条件依次提问。
- **具象业务比喻**：**装修开工前的主材确认清单** 📝。在敲墙前，业主和工长必须对齐瓷砖品牌、开关插座数量并签字确认。
- **IT 沟通场景**：“需求已通过 `grill-me` 完成澄清，并落盘为包含 6 大要素的 `BUSINESS_FEATURE_CARD.md` 业务契约。”

### 核心概念 2：数据契约 (Data Contract TS Types & Mock Data)
- **硬核工程定义**：使用 TypeScript Interface 强类型定义业务对象的物理字段，并配合 Mock 数据文件实现的前后端数据协议。
- **底层运作机制**：在 `prototype-contract.d.ts` 中声明字段类型（如 `status: 'pending' | 'resolved'`），在 `prototype-data.ts` 中填充静态测试对象。
- **具象业务比喻**：**海关进口商品的标准报关单海关编码** 📦。规定了每个包裹里装什么物品、什么格式，违规格式直接扣留。
- **IT 沟通场景**：“我们冻结了 `prototype-contract.d.ts` 数据契约，保证前端界面与数据字典 100% 匹配。”

### 核心概念 3：`Given-When-Then` 验收标准与 `Stop / Escalation` 升阶条件
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

### Task 1: 唤醒 `/grill-me` 追问 Skill 澄清需求

#### ⚡ 极速操作步骤
1. 在 Claude Code CLI 窗口中输入：
   ```text
   /grill-me
   ```
2. 针对工单管理功能回答 AI 提出的 3 轮追问（包括正常流、边界容错与 `Stop / Escalation` 升阶条件）。

#### 💡 独立自学原理解析
> **为什么不能让 AI 直接生成代码？**  
> AI 擅长回答问题，但在没有约束时极易自行脑补业务细节。`/grill-me` 强制 AI 提问主管，把隐藏在脑海中的业务细节梳理出来。

---

### Task 2: 落盘并冻结三份契约资产

#### ⚡ 极速操作步骤
1. 检查并确认落盘的三份契约资产：
   - 契约 1：[`docs/BUSINESS_FEATURE_CARD.md`](file:///d:/AILearning/docs/BUSINESS_FEATURE_CARD.md)
   - 契约 2：[`src/types/prototype-contract.d.ts`](file:///d:/AILearning/src/types/prototype-contract.d.ts)
   - 契约 3：[`src/mocks/prototype-data.ts`](file:///d:/AILearning/src/mocks/prototype-data.ts)
2. 输入自然盖章口令：
   ```text
   同意冻结三份业务与数据契约
   ```

#### 🔍 代码/契约声明预览
```typescript
// src/types/prototype-contract.d.ts
export interface WorkOrder {
  id: string;
  title: string;
  priority: 'low' | 'medium' | 'high';
  status: 'pending' | 'in_progress' | 'resolved';
}
```

---

### Task 3A: 只读结构预览门禁 (Read-Only Preview)

#### ⚡ 极速操作步骤
1. 在生成任何新代码前，命令 AI 仅展示 Task 3A 只读结构预览：
   ```text
   请输出 Task 3A 只读结构预览，展示即将生成的组件文件目录结构，不要修改任何代码。
   ```
2. **安全防线**：检查控制台，确认未执行任何文件写入操作，严禁在命令中使用 `cd <project-path>` 等路径切换操作。

#### 💡 独立自学原理解析
> **Task 3A 只读预览门禁的作用**  
> 在真正写入代码前，让主管预览即将修改的文件清单。只有在主管确认物理结构合理后，才过渡到 Task 3B 的授权落盘。

---

### Task 3B: 授权落盘并验证数据契约

#### ⚡ 极速操作步骤
1. 下发授权口令：
   ```text
   确认 Task 3A 预览无误，授权写入数据契约
   ```
2. 验证浏览器 `http://localhost:5173/` 页面成功加载了 `prototype-data.ts` 中的数据。

---

## 五、 💡 常见概念误区与正确理解 (Mindset Transformation)

| 常见误区 (Misconception) | 正确硬核理解 (Correct Engineering Reality) | 如何纠偏与护栏防护 (Remedy & Guardrails) |
| :--- | :--- | :--- |
| **误区 1：“需求只需要口头说一句，AI 会自动补全所有逻辑”** | AI 补全的逻辑 90% 不符合真实业务，会导致后续大面积重构。 | 唤醒 `/grill-me` 互动追问，强迫梳理边界与异常处理。 |
| **误区 2：“数据类型随意写，不需要定义 TypeScript 数据契约”** | 没有强类型 Interface 约束，前端组件和 Mock 数据字段容易对不上。 | 强制冻结 `prototype-contract.d.ts`，作为物理字段数据契约。 |
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
1. **[概念填空题]** 在第三课中，用于逼平业务模糊点并反向追问主管的 Slash Command 指令是 ____________。
2. **[契约选择题]** 在第三课冻结的三份契约资产中，用于定义 TypeScript 数据字段接口的文件是 ____________。
   - A. `BUSINESS_FEATURE_CARD.md`
   - B. `prototype-contract.d.ts`
   - C. `prototype-data.ts`
   - D. `PROJECT_STATE.md`
3. **[IT 沟通场景题]** 当你需要向 IT 开发团队交接需求时，你应该怎么说？
   - **参考回答**：“我们已经通过 `grill-me` 完成了需求澄清，落盘了包含 Given-When-Then 的业务功能卡与 `prototype-contract.d.ts` 数据契约。”

---

### 阶段 2：课后自学拓展思考题 (Self-Study Extension)
4. **[原理思考题]** 为什么我们在 Task 3 中强调必须先进行 Task 3A 只读结构预览，然后再执行 Task 3B 写入？
