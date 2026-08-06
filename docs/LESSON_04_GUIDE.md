# 第四课学员指南 (V2 闭环版)：把大需求拆成连续的小成功

欢迎来到第四课！在前三课中，我们完成了界面搭建、视觉规则约束（`DESIGN.md`）以及需求与数据契约锁定（`grill-me`）。本节课我们将解决大型业务原型开发中最容易出现的崩溃点——**“巨石代码盲开与上下文记忆失控”**。本课的核心思想只有一句话：

> **不要让 Agent 一口气完成整个功能，而是先形成计划，每次只完成一个可验证的小切片。**

你将学习如何采用 **Plan & Execute 增量范式**，将大需求拆解并保存至 `docs/LESSON_04_IMPLEMENTATION_PLAN.md` 实施计划中，通过 **Step级 Workflow 授权门禁（`授权执行 Step 1`）** 落地首个薄切片。在整个过程中，我们将引入 IT 研发核心概念 **Working Tree (工作区/工作树)**——把它当成 AI 手艺切菜的“砧板”，学会如何在砧板上受控切片、进行 **页面技术状态调试器 (`prototypeState`)** 验证，并在失败时清扫砧板恢复干净工作区。

---

## 0. 本课教学目标 (Learning Objectives)

完成本课学习后，你将能够：
1. **对比与阐述** 一次性巨石代码盲开的退化风险，以及 **先计划、后执行、做小切片** 的增量实施优势。
2. **掌握 IT 跨界术语** **`Working Tree (工作区 / 工作树)`**，理解其作为“AI 改写代码手艺砧板”的物理含义及其 Clean/Dirty 状态流转。
3. **遵守与继承** 第三课的 **契约冻结规则 (Contract Freeze Rule)**，通过 **契约交接门禁 (Pre-Plan Gate)** 校验第三课 3 份契约资产的一致性（若存在冲突将触发 `[契约冲突拦截] 需求卡与数据定义不一致，请先核对` (CONTRACT_ASSET_MISMATCH) 拒绝生成计划）。
4. **生成与保存** 包含 `plan_status` 与状态枚举（`PENDING / READY / IN_PROGRESS / COMPLETED / BLOCKED`）的外部长期记忆计划 `docs/LESSON_04_IMPLEMENTATION_PLAN.md`（Step 2..N 默认为 `PENDING`，`allowed_files` 必须为具体文件路径）。
5. **精准区分** **界面技术呈现状态 (Loading/Empty/Error/Success)** 与 **业务处理流程状态 (待处理/处理中/已阻塞/已完成)** 的本质区别。
6. **掌握与触发** **Step级 Workflow 授权门禁**（匹配 `授权执行 Step 1` 或 `授权开始 Step 1`），受控解锁首个切片编码。
7. **执行** **三层验收 (Verifier -> 人工点击 -> 主管验收) 与版本归档 (`确认完成 Step 1`)**；若验证失败，体验 **失败快照备份、清扫 Working Tree 自动恢复干净工作区与问题记录 (`同意记录 Step 1 问题`)**。

---

### 核心模式对比线框图 (巨石盲开 vs 增量切片 + 实施计划 + 调试验证)

```text
===================================================================================
【第一层：一次性巨石盲开】 (无步骤约束，AI 一口气改 10 个文件，砧板一片狼藉无法定位错误)

  [复杂需求卡] ───> ( LLM 盲开输出 1000 行代码 ) ───> [ 样式崩溃 / 白屏 / 砧板废弃 ]
                       (一次性修改全套逻辑)

===================================================================================
【第二层：增量切片实施 + Working Tree (工作区) 状态控制】 (本课实操)

  [起始状态: Working Tree 100% Clean (干净砧板)]
                        │
                        ▼
  [前置需求契约 (3份)] ───> [ Pre-Plan Gate 校验 ] ───> [ 生成增量计划 ]
                                                                │ (只读预览 Plan, Step 2..N 默认为 PENDING)
                                                                ▼
                                                    [ 同意保存实施计划 ]
                                                                │ (落盘至 docs/LESSON_04_IMPLEMENTATION_PLAN.md)
                                                                ▼
                                                    ┌────────────────────────────────┐
                                                    │ Workflow 门禁: "授权执行 Step 1"   │
                                                    └────────────────────────────────┘
                                                                │
                                                                ▼
                                              ( Step 1 薄切片编码 ➔ Working Tree 变为 Dirty )
                                                                │
                                                                ▼
  [ 三层验收: Verifier -> 人工点击 -> 主管验收 ]
                             │
                             ├─────────────────────────────────────────┐
                             ▼                                         ▼
  [ PASS: 确认完成 Step 1 ➔ 打包归档 Commit A ]       [ FAIL/拒绝: 备份快照 ➔ 清扫 Working Tree 还原 Clean ]
  [ ➔ Working Tree 恢复 100% Clean (干净砧板) ]       [ ➔ 同意记录 Step 1 问题 ➔ 留给第 6 课诊断 ]

===================================================================================
【第三层：页面技术状态调试器】 (可视化调试，彻底消除交接死角)

   ┌────────────────────────────────────────────────────────────────────────┐
   │ [Prototype Debug] 状态切换: (◯ Loading  ◯ Empty  ◯ Error  ● Success)   │
   ├────────────────────────────────────────────────────────────────────────┤
   │ 1. Loading  : 骨架屏 / 菊花图 (数据加载中)                             │
   │ 2. Empty    : 空数据占位图 ("暂无满足条件的业务记录")                  │
   │ 3. Error    : 错误提示 + 重试按钮 ("网络异常，点击重试")                │
   │ 4. Success  : 正常数据列表 / 视图                                     │
   └────────────────────────────────────────────────────────────────────────┘
===================================================================================
```

---

## 1. 核心概念与护栏机制

### 1.1 💡 IT 跨界沟通术语卡：Working Tree (工作区 / 工作树)
> - **标准 IT 术语**：`Working Tree`（中文常用译名：**工作区** 或 **工作树**）。
> - **通俗生活类比**：就像 **厨师切菜的砧板** 或 **画家的画板**。你当前打开文件夹、修改代码、AI 正在写入文件的地方，就是你的“Working Tree (工作区)”。
> - **与 IT 沟通场景**：当你未来把原型交接给 IT 部门时，说“我已经清空了 Working Tree 恢复到了干净基线”，IT 工程师会立刻意识到你具备非常专业的工程素养，毫无沟通障碍。

### 1.2 契约交接门禁 (Pre-Plan Gate)
`BUSINESS_FEATURE_CARD.md` 是第四课唯一的需求权威来源。生成实施计划前，Agent 必须校验数据字典定义表与模拟数据。若存在字段名、类型、必填性、枚举或业务含义冲突，输出 `[契约冲突拦截] 需求卡与数据定义不一致，请先核对` (CONTRACT_ASSET_MISMATCH)，禁止生成或保存实施计划。

### 1.3 实施计划状态机枚举 (Step Status Enum)
`docs/LESSON_04_IMPLEMENTATION_PLAN.md` 严格限定 5 种状态：
- `PENDING`：后续未开始步骤的默认初始状态（Step 2..N 初始状态）；
- `READY`：前置步骤已完成，等待主管下发 `授权执行 Step N`；
- `IN_PROGRESS`：已下发授权，正在编码执行中；
- `COMPLETED`：三层验收通过且完成 Commit A / Commit B 归档；
- `BLOCKED`：自测、页面验证或主管业务拒绝后，备份快照并恢复干净 Working Tree 后的阻断状态。

### 1.4 `allowed_files` 精确文件路径规范
实施计划中 `allowed_files` **必须列出具体文件路径**（例如 `["src/pages/HomePage.vue", "src/components/WorkOrderBoard.vue"]`），**严格禁止填写 `src/components/` 等目录**。

### 1.5 三层递进验收门禁与版本归档 (Three-Layer Verification Gate)
Step 1 编码完成后，必须按顺序通过三层门禁：
1. **第一层：Verifier PASS (静态工程与编译自测)**
2. **第二层：人工点击验收 PASS (页面 `Prototype Debug` 4 状态点击校验)**
3. **第三层：主管业务验收 PASS (主管下发 `主管验收 Step N 通过`)**

三层全过，下发 **`确认完成 Step N`** (或 `同意保存 Step N 成果`)，Agent 底层顺次自动完成 Commit A 源码暂存、回填 SHA 与日志、将 Step N 改为 `COMPLETED`、Step N+1 改为 `READY`，最后自动执行 Commit B 状态推进。**Working Tree 自动恢复 Clean 干净状态。**

### 1.6 校验失败时的 Clean Working Tree 清扫自动恢复机制
若 Verifier 报错、页面验证失败或主管下发 `主管拒绝 Step N 切片`：
- **课程学习结果**：**`PASS`**（学员正确执行了快照备份、清扫 Working Tree 恢复干净源码与问题记录归档流程）；
- **Step 实施结果**：**`BLOCKED`**；
- **恢复与导出动作**：
  1. 自动将失败修改备份为快照补丁：`local-backups/lesson-04-evidence/step-N-blocked.patch`；
  2. 保存 Verifier 日志并回填 `failure_summary`；
  3. **清扫 Working Tree 自动恢复干净源码**：自动撤销修改并清理未跟踪文件，使 Working Tree 物理恢复 100% Clean 干净；
  4. **自然口令归档问题**：学员下发 **`同意记录 Step N 问题`** 提交状态记录，留给第六课处理。

---

## 2. 90 分钟课堂时间安排与学员实操

完整 90 分钟课堂时间安排：
- **成果展示与 Task 0**：10 分钟
- **教师演示**：15 分钟
- **学员 Task 1 与 Task 2**：40 分钟
- **Task 3 (三层验收与版本归档)**：15 分钟
- **总结与 Exit Ticket**：10 分钟

---

### 任务 0：前置基线检查与 Working Tree 状态确认

**目标**：确认起点环境完好，Working Tree 处于 100% Clean 干净状态。

**操作指令**：
```text
请检查当前 Git 状态，确认 docs/BUSINESS_FEATURE_CARD.md、src/types/prototype-contract.d.ts 以及 src/mocks/prototype-data.ts 存在，且 Working Tree 处于 Clean 干净状态。
```

---

### 任务 1：唤醒 Skill，生成并保存实施计划 (Plan 阶段)

**操作指令 1 (只读预览)**：
```text
/incremental-implementation
请读取 docs/BUSINESS_FEATURE_CARD.md、src/types/prototype-contract.d.ts 与 src/mocks/prototype-data.ts，生成 3-5 步增量实施计划预览。注意：现在只输出 Plan 预览，不要改动任何文件。
```

**操作指令 2 (授权落盘)**：
```text
同意保存实施计划
```

---

### 任务 2：下发授权门禁，完成 Step 1 调试切片 (Execute 阶段)

**操作指令**：
```text
授权执行 Step 1
```
*(提示：指令下发后，Agent 会在你的 Working Tree (工作区/砧板) 写入 Step 1 代码，此时 Working Tree 变为 Dirty)*

---

### 任务 3：静默自测、三层验收与版本归档 (Verify & Commit 阶段)

**操作指令 1 (静默自测)**：
```text
Step 1 代码已写完，请派遣 Verifier Subagent 在后台运行 scripts/run-lesson-verifier.ps1 -Step 1 进行校验。
```

**操作指令 2 (主管业务验收通过)**：
```text
主管验收 Step 1 通过
```

**操作指令 3 (确认完成 Step 1)**：
```text
确认完成 Step 1
```
*(Agent 底层自动顺次执行 git add -- 选择性暂存提交源码与实施计划，打包入库后 Working Tree 自动恢复 Clean 干净状态)*

---

## 3. 学员课后记忆卡与退场测试 (Exit Ticket & Misconceptions)

### ✍️ 学员概念互动填空 (Interactive Concept Fill-in-the-Blanks)
1. **IT 跨界术语 Working Tree**：AI 正在写代码、做切片的物理文件夹被称为 **`Working Tree (工作区 / 工作树)`**，就像厨师切菜的砧板。
2. **Plan & Execute 范式**：增量实施的核心是 **“先形成计划，每次只授权完成一个可验证的小切片”**，计划保存于外部长期记忆 `docs/LESSON_04_IMPLEMENTATION_PLAN.md` 中。
3. **步骤状态机枚举**：实施计划中的步骤包含 5 种状态：初始步骤默认为 **`PENDING`**，前置步骤通过后变为 **`READY`**，授权后变为 **`IN_PROGRESS`**，三层验收归档后变为 **`COMPLETED`**，校验失败或主管拒绝后变为 **`BLOCKED`**。
4. **概念解耦**：**界面技术呈现状态 (`prototypeState`: Loading / Empty / Error / Success)** 用于调试 UI 数据加载与异常；而 **业务处理流程状态 (待处理 / 处理中 / 已阻塞 / 已完成)** 用于展示业务对象的生命周期。
5. **版本归档与 Working Tree 清扫**：三层验收通过后回复 **`确认完成 Step 1`** 自动归档，Working Tree 恢复 Clean；若验证失败，系统将自动 **备份失败快照** 并 **清扫 Working Tree 还原干净源码**，学员回复 **`同意记录 Step 1 问题`** 记录问题。

### 💡 常见概念误区与正确理解 (Misconceptions vs. Correct Engineering Reality)

| 常见误区 (Misconception) | 正确硬核理解 (Correct Engineering Reality) | 如何纠偏与护栏防护 (Remedy & Guardrails) |
| :--- | :--- | :--- |
| **误区 1：“让 AI 一口气写完页面所有功能效率最高”** | 一口气修改 10 个文件会导致 Working Tree 一片狼藉，爆 Context 且报错时根本无法定位根因。 | 唤醒 `incremental-implementation` 护栏，强制按 3–5 步切片，每次仅授权执行 1 个切片。 |
| **误区 2：“只要静态编译通过 (Verifier PASS)，就代表切片做对了”** | Verifier 只是静态编译检查，无法替代人工物理点击页面以及主管对业务逻辑与交互美观度的裁决。 | 严格执行 **三层递进验收 (Verifier PASS -> 人工点击 PASS -> 主管业务验收 PASS)**，缺一不可。 |
| **误区 3：“混淆界面技术呈现状态与业务处理流程状态”** | 将 `Loading` 或 `Error` 误当成业务对象的状态，导致逻辑混乱与调试失败。 | 强制前端植入 `prototypeState` 调试器（`import.meta.env.DEV`），与业务处理流程状态标签物理解耦。 |
| **误区 4：“切片报错时直接多次下发指令让 AI 撞大运”** | 在 Working Tree 堆积坏代码重试会导致残渣残留，后续 Git 提交误将坏代码打包入库。 | 系统自动备份快照补丁并清扫 Working Tree 还原 Clean 干净源码，下发 `同意记录 Step 1 问题` 归档。 |

---

### 🎯 退场测试题 (Exit Ticket)

* **问题 1**：当你向 IT 工程师说“请清扫 Working Tree 恢复 Clean 干净状态”时，是什么意思？为什么切片失败时必须执行这个动作？
* **参考答案**：
  - 意思是撤销 Working Tree (工作区) 中未提交的破损修改与未跟踪文件，将其还原至上一个稳定的 Commit 节点；切片失败时执行此动作可以清扫坏代码残渣，防止污染后续工程。
* **问题 2**：回复 `确认完成 Step 1` 时，Agent 底层顺次执行了什么操作？
* **参考答案**：
  - Agent 底层顺次自动执行了 Commit A 源码暂存提交、提取 Commit SHA 回填 Plan 状态，以及 Commit B 实施计划更新暂存，把 Working Tree 上的改动打包入库并恢复 Clean 状态。
