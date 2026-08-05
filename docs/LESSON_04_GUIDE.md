# 第四课学员指南 (V2 闭环版)：把大需求拆成连续的小成功

欢迎来到第四课！在前三课中，我们完成了界面搭建、视觉规则约束（`DESIGN.md`）以及需求与数据契约锁定（`grill-me`）。本节课我们将解决大型业务原型开发中最容易出现的崩溃点——**“巨石代码盲开与上下文记忆失控”**。本课的核心思想只有一句话：

> **不要让 Agent 一口气完成整个功能，而是先形成计划，每次只完成一个可验证的小切片。**

你将学习如何采用 **Plan & Execute 增量范式**，将大需求拆解并保存至 `docs/LESSON_04_IMPLEMENTATION_PLAN.md` 实施计划中，通过 **Step级 Workflow 授权门禁（`授权执行 Step 1`）** 落地首个薄切片，并在前端引入 **页面技术状态调试器 (`prototypeState`)**，配合 **静默自测工具 (`Verifier Subagent`)** 与版本归档，完成受控的增量交付。

---

## 0. 本课教学目标 (Learning Objectives)

完成本课学习后，你将能够：
1. **对比与阐述** 一次性巨石代码盲开的退化风险，以及 **先计划、后执行、做小切片** 的增量实施优势。
2. **遵守与继承** 第三课的 **契约冻结规则 (Contract Freeze Rule)**，以 `docs/BUSINESS_FEATURE_CARD.md` 为唯一需求基线。
3. **生成与保存** 包含 `plan_status` 与状态枚举（`PENDING / READY / IN_PROGRESS / COMPLETED / BLOCKED`）的外部长期记忆计划 `docs/LESSON_04_IMPLEMENTATION_PLAN.md`。
4. **精准区分** **页面技术呈现状态 (Loading/Empty/Error/Success)** 与 **业务流程状态 (待处理/处理中/已阻塞/已完成)** 的本质区别。
5. **掌握与触发** **Step级 Workflow 授权门禁**（首行精确匹配 `授权执行 Step 1`），受控解锁首个切片编码。
6. **验证与体验** 带有 **页面技术状态调试器 (Prototype Debug)** 的前端原型，以及针对三类原型方向的 Step 1 薄切片。
7. **执行** **三层验收 (Verifier -> 人工点击 -> 主管验收) 与一次完整版本归档 (Commit A 源码 + Commit B 状态推进)**；若验证失败，正确执行 **`BLOCKED` 失败 Patch 导出与干净工作树恢复**。

---

### 核心模式对比线框图 (巨石盲开 vs 增量切片 + 实施计划 + 调试验证)

```text
===================================================================================
【第一层：一次性巨石盲开】 (无步骤约束，AI 一口气改 10 个文件，爆 Token 且无法定位错误)

  [复杂需求卡] ───> ( LLM 盲开输出 1000 行代码 ) ───> [ 样式崩溃 / 白屏 / 找不到原因 ]
                       (一次性修改全套逻辑)

===================================================================================
【第二层：增量切片实施 + 实施计划 + 调试验证】 (本课实操)

  [前置需求契约] ───> [ 生成增量计划 ]
                             │ (只读预览 Plan, Step 2..N 默认为 PENDING)
                             ▼
                 [ 授权保存实施计划 ]
                             │ (落盘至 docs/LESSON_04_IMPLEMENTATION_PLAN.md)
                             ▼
                 ┌────────────────────────────────┐
                 │ Workflow 门禁首行: "授权执行 Step 1" │
                 └────────────────────────────────┘
                             │
                             ▼
                   ( Step 1 薄切片编码 ) 
                             │
                             ▼
  [ 三层验收: Verifier -> 人工点击 -> 主管验收 ] ───> [ PASS: 授权 Commit A + Commit B 归档 ]
                             │
                             └───> [ FAIL: 导出 .patch 补丁 ──> git restore 恢复干净源码 ──> 仅提交 Commit B 状态 ]

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

### 1.1 实施计划状态机枚举 (Step Status Enum)
`docs/LESSON_04_IMPLEMENTATION_PLAN.md` 严格限定 5 种状态：
- `PENDING`：后续未开始步骤的默认初始状态（Step 2..N 初始状态）；
- `READY`：前置步骤已完成，等待主管下发 `授权执行 Step N`；
- `IN_PROGRESS`：已下发授权，正在编码执行中；
- `COMPLETED`：三层验收通过且完成 Commit A / Commit B 归档；
- `BLOCKED`：自测或页面验证失败，导出 Patch 恢复干净源码后的阻断状态。

### 1.2 `allowed_files` 精确文件路径规范
实施计划中 `allowed_files` **必须列出精确文件路径**（例如 `["src/pages/HomePage.vue", "src/components/WorkOrderBoard.vue"]`），**严格禁止填写 `src/components/` 等目录**，防止批量误修改或误暂存无关文件。

### 1.3 三层递进验收门禁与版本归档 (Three-Layer Verification Gate)
Step 1 编码完成后，必须按顺序通过三层门禁：
1. **第一层：Verifier PASS (静态工程与编译自测)**
2. **第二层：人工点击验收 PASS (页面 `Prototype Debug` 4 状态点击校验)**
3. **第三层：主管业务验收 PASS (主管下发 `主管验收 Step N 通过`)**

三层全过，方可依次下发 `授权提交 Step N 源码` (Commit A) 与 `授权提交 Step N 状态推进` (Commit B)。

### 1.4 校验失败时的干净工作树恢复机制 (Clean Worktree Recovery)
若 Verifier 或页面验证失败：
- **课程学习结果**：**`PASS`**（学员正确执行了导出 Patch、恢复干净源码与 `BLOCKED` 记录流程）；
- **Step 实施结果**：**`BLOCKED`**；
- **恢复与导出动作**：
  1. 将失败修改导出为 Patch 补丁：`local-backups/lesson-04-evidence/step-N-blocked.patch`；
  2. 保存 Verifier 日志并回填 `failure_summary`；
  3. **恢复干净源码**：执行 `git restore -- <Step N exact allowed_files>` 还原源码至稳定基线；
  4. **仅归档状态**：下发 `授权提交 Step N 状态推进` 提交 Commit B 状态记录，留给第六课处理。

---

## 2. 学员实操任务与时间分配

建议时间分配：
- **Task 0 & 1 & 2 (基线、Plan 与 Step 1 编码)**：40 分钟
- **Task 3 (三层验收与版本归档)**：15 分钟
- **总结与 Exit Ticket**：10 分钟

---

### 任务 0：前置基线检查

**目标**：确认起点环境干净，第三课契约文件完好。

**操作指令**：
```text
请检查当前 Git 状态，确认 docs/BUSINESS_FEATURE_CARD.md、src/types/prototype-contract.d.ts 以及 src/mocks/prototype-data.ts 存在且工作区干净。
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
授权保存 Lesson 04 实施计划
```

---

### 任务 2：下发授权门禁，完成 Step 1 调试切片 (Execute 阶段)

**操作指令**：
```text
授权执行 Step 1
```

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

**操作指令 3 (授权提交 Step 1 源码 - Commit A)**：
```text
授权提交 Step 1 源码
```
*(Agent 底层执行 `git add -- <allowed_files>` 选择性暂存提交)*

**操作指令 4 (授权提交 Step 1 状态推进 - Commit B)**：
```text
授权提交 Step 1 状态推进
```
*(Agent 底层执行 `git add -- docs/LESSON_04_IMPLEMENTATION_PLAN.md` 选择性暂存提交)*

---

## 3. 课后退场自测 (Exit Ticket)

> **退出门禁题**：验证失败时，为什么必须将失败修改导出为 Patch 并执行 `git restore` 恢复干净源码？

* **参考答案**：
  导出 Patch 补丁可以完整保存失败证据（留给第六课诊断）；执行 `git restore` 恢复干净源码可以防止失败代码污染工作区，确保后续 Git 操作不误提交损坏代码。
