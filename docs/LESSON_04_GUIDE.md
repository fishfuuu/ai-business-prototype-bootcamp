# 第四课学员指南 (V2 闭环版)：把大需求拆成连续的小成功

欢迎来到第四课！在前三课中，我们完成了界面搭建、视觉规则约束（`DESIGN.md`）以及需求与数据契约锁定（`grill-me`）。本节课我们将解决大型业务原型开发中最容易出现的崩溃点——**“巨石代码盲开与上下文记忆失控”**。你将学习如何唤醒 `/incremental-implementation` 架构护栏，采用 **Plan & Execute 增量范式**，将大需求拆解并持久化写入 `docs/LESSON_04_IMPLEMENTATION_PLAN.md`，通过 **Step级 Workflow 授权门禁（`授权执行 Step 1`）** 落地首个薄切片，并在前端引入 **`prototypeState` 调试切换器**，配合 **`Verifier Subagent` 静默自测** 与 Git 存档，完成可复核的增量交付。

---

## 0. 本课教学目标 (Learning Objectives)

完成本课学习后，你将能够：
1. **对比与阐述** 一次性巨石代码生成的退化风险，以及 **Plan & Execute 范式** 结合 `/incremental-implementation` 架构护栏物理收敛的优势。
2. **校验与断言** 第三课交付的前置 Git 基线 SHA、`BUSINESS_FEATURE_CARD.md`、`src/types/prototype-contract.d.ts` 以及 `src/mocks/prototype-data.ts`（Task 0 基线检查）。
3. **驱动与持久化** `/incremental-implementation` 技能，将 3–5 步增量计划落盘至外部长期记忆 `docs/LESSON_04_IMPLEMENTATION_PLAN.md`。
4. **掌握与触发** **Step级 Workflow 授权门禁**（首行精确匹配 `授权执行 Step 1`），解锁首个垂直切片编码。
5. **编写与物理验证** 带有 **`prototypeState` 调试切片（Loading 骨架屏、Empty 空数据、Error 报错重试、Success 正常呈现）** 可视化切换能力的 Vue 业务组件。
6. **派遣与调用** **`Verifier Subagent`（`.claude/agents/verifier.md` 或 `scripts/run-lesson-verifier.ps1`）** 静默跑通编译自测，在不污染主 Context 的前提下完成 **Atomic Git Commit 稳定存档**。

---

### 核心模式对比线框图 (巨石盲开 vs 增量切片 + 持久化 Plan + Verifier)

```text
===================================================================================
【第一层：一次性巨石盲开】 (无步骤约束，AI 一口气改 10 个文件，爆 Token 且无法定位错误)

  [复杂需求卡] ───> ( LLM 盲开输出 1000 行代码 ) ───> [ 样式崩溃 / 白屏 / 找不到原因 ]
                       (一次性修改全套逻辑)

===================================================================================
【第二层：/incremental-implementation + 持久化 Plan + Step级 Workflow 门禁】

  [Task 0 基线断言] ───> [ 唤醒 /incremental-implementation ]
                                 │ (只读预览 Plan)
                                 ▼
                     [ 授权保存 Lesson 04 实施计划 ]
                                 │ (落盘至 docs/LESSON_04_IMPLEMENTATION_PLAN.md)
                                 ▼
                     ┌────────────────────────────────┐
                     │ Workflow 门禁首行: "授权执行 Step 1" │
                     └────────────────────────────────┘
                                 │
                                 ▼
                        ( Step 1 切片: 4 状态 UI ) 
                                 │
                                 ▼
                     [ Verifier Subagent 静默自测 ] ───> [ PASS: Atomic Git Commit ]

===================================================================================
【第三层：prototypeState 物理调试切换器】 (可视化调试，彻底消除交接死角)

   ┌────────────────────────────────────────────────────────────────────────┐
   │ [Prototype Debug] 状态切换: (◯ Loading  ◯ Empty  ◯ Error  ● Success)   │
   ├────────────────────────────────────────────────────────────────────────┤
   │ 1. Loading  : 骨架屏 / 菊花图 (数据拉取中)                             │
   │ 2. Empty    : 空数据占位图 ("暂无满足条件的工单")                      │
   │ 3. Error    : 错误提示 + 重试按钮 ("网络异常，点击重试")                │
   │ 4. Success  : 正常数据列表 / 视图                                     │
   └────────────────────────────────────────────────────────────────────────┘
===================================================================================
```

---

## 1. 核心概念与护栏机制

### 1.1 为什么必须使用持久化计划 `docs/LESSON_04_IMPLEMENTATION_PLAN.md`？
如果增量计划只保存在聊天窗口中，一旦执行 `/clear` 重置上下文，计划就会丢失；同时 Codex 或主管也无法根据固定计划进行复核。
因此，本课要求将拆解计划持久化写入 **`docs/LESSON_04_IMPLEMENTATION_PLAN.md`**，作为外部长期记忆。

### 1.2 Step级 Workflow 授权门禁规则
为了防止 Agent 误识别用户意图或连续冲动修改代码，物理 Skill 设置了严格的 **Step级 Workflow 授权门禁**：
- 用户发送的消息**首行必须精确等于**：
  ```text
  授权执行 Step N
  ```
- 其中 `N` 必须匹配 `docs/LESSON_04_IMPLEMENTATION_PLAN.md` 中当前等待执行的步骤。
- 每次授权只允许 Agent 执行一个 Step，不得自动执行下一步，验证失败时不得自行修改代码或自作主张 Git Commit。

### 1.3 `prototypeState` 调试切换器（`import.meta.env.DEV`）
在纯前端原型中，静态 Mock 数据（`src/mocks/prototype-data.ts`）会导致页面永远处于 `Success` 状态。
我们在 Step 1 组件中植入基于开发环境控制的状态切换器：
```typescript
const showPrototypeDebug = import.meta.env.DEV
const prototypeState = ref<'loading' | 'empty' | 'error' | 'success'>('success')
```
在页面顶部渲染带有 `Prototype Debug` 标识的组件，让主管和讲师可以**物理点击按钮直接验证 4 种 UI 视图**。

### 1.4 `Verifier Subagent` 后台静默自测
为了防止成百上千行的 `npm run build` 日志塞满主 Context 记忆窗口，我们派遣 `.claude/agents/verifier.md` 后台子智能体（或运行 `scripts/run-lesson-verifier.ps1`）：
* 允许范围：`npm run typecheck`, `npm run build`, `verify-project.ps1`；
* 绝不允许修改 `src/` 或 `docs/`；
* 完整日志写入 `local-backups/lesson-04-evidence/step-1-verification.log`；
* 主窗口只接收 1 行极简断言结果：`[PASS] Step 1 Verification clean | Log: local-backups/lesson-04-evidence/step-1-verification.log`。

---

## 2. 学员实操任务

### 任务 0：前置基线与契约断言 (Baseline Check)

**目标**：验证起点环境干净，确认第三课产物就绪。

**操作指令**：
在 Claude Code CLI 中输入：
```text
请检查当前 Git 状态，确认 docs/BUSINESS_FEATURE_CARD.md、src/types/prototype-contract.d.ts 以及 src/mocks/prototype-data.ts 物理存在且工作区干净。
```

**完成标准**：
- [ ] 确认基线处于干净状态（`working tree clean`），三份前置契约文件完好。

---

### 任务 1：唤醒 Skill，生成并持久化增量计划 (Plan 阶段)

**目标**：使用 `/incremental-implementation` 生成计划，并授权落盘至 `docs/LESSON_04_IMPLEMENTATION_PLAN.md`。

**操作指令 1 (只读预览)**：
```text
/incremental-implementation
请读取 docs/BUSINESS_FEATURE_CARD.md、src/types/prototype-contract.d.ts 与 src/mocks/prototype-data.ts，生成 3-5 步增量实施计划预览。注意：现在只输出 Plan 预览，不要改动任何文件。
```

**操作指令 2 (授权落盘)**：
```text
授权保存 Lesson 04 实施计划
```

**完成标准**：
- [ ] 成功在项目根目录下生成 `docs/LESSON_04_IMPLEMENTATION_PLAN.md` 文件，包含目标、非目标、Step 1–N 及其验收条件。
- [ ] 暂未修改任何业务源码文件。

---

### 任务 2：下发授权门禁，植入 4 状态调试切换器 (Execute 阶段)

**目标**：下发 `授权执行 Step 1`，完成 Step 1 切片编码，并在 Vue 原型中植入 `prototypeState` 调试切换器。

**操作指令**：
```text
授权执行 Step 1
```

**完成标准**：
- [ ] 打开浏览器页面，看到带有 `Prototype Debug` 标识的顶部单选切换按钮。
- [ ] 物理点击 Loading / Empty / Error / Success，界面流畅切换 4 种 UI 视图。

---

### 任务 3：派遣 Verifier Subagent 静默自测与 Git 提交 (Verify 阶段)

**目标**：调用 Verifier Subagent 跑通静默构建校验，完成 90 分钟课堂首个 Atomic Git Commit 存档。

**操作指令**：
```text
Step 1 代码已写完，请派遣 Verifier Subagent 在后台运行 scripts/run-lesson-verifier.ps1 -Step 1 进行校验。确认 PASS 后提示我提交 Git Commit。
```

**完成标准**：
- [ ] 终端接收到干净的 1 行提示：`[PASS] Step 1 Verification clean | Log: local-backups/lesson-04-evidence/step-1-verification.log`。
- [ ] 成功执行 `git commit`，提交日志形如 `feat(prototype): step 1 - add skeleton with 4-state debug toggle`。

---

## 3. 课后退场自测 (Exit Ticket)

> **退出门禁题**：第四课 90 分钟课堂交付的核心成果是什么？后续 Step 如何进行？

* **参考答案**：
  课堂交付一份已批准的外部长期记忆计划 `docs/LESSON_04_IMPLEMENTATION_PLAN.md` + 一个经过 Verifier 验证的完整切片 (Step 1) + 1 个稳定 Git Commit。课后按相同循环（`授权执行 Step N` -> `Verifier 自测` -> `Git Commit`）依次完成剩余 Step。

---

## 4. 常见卡点与排错 (FAQ)

| 卡点现象 | 根因分析 | 处理建议 |
| --- | --- | --- |
| 发送指令后 Agent 没有写文件 | 消息首行未严格匹配 `授权执行 Step N` | 检查发送的消息第一行是否精确等于 `授权执行 Step 1` |
| 点击调试切片界面无反应 | 误用了 `src/data/` 路径或变量未定义 | 确认使用了冻结路径 `src/mocks/prototype-data.ts` |
| Verifier 显示 FAIL | TS 类型错误或语法构建失败 | 查看 `local-backups/lesson-04-evidence/step-1-verification.log` 提取日志排错 |
