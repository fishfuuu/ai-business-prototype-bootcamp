# 第四课学员指南 (V2 闭环版)：把大需求拆成连续的小成功

欢迎来到第四课！在前三课中，我们完成了界面搭建、视觉规则约束（`DESIGN.md`）以及需求与数据契约锁定（`grill-me`）。本节课我们将解决大型业务原型开发中最容易出现的崩溃点——**“巨石代码盲开与上下文记忆失控”**。你将学习如何唤醒 `/incremental-implementation` 架构护栏，采用 **Plan & Execute 增量范式**，将大需求拆解并持久化写入 `docs/LESSON_04_IMPLEMENTATION_PLAN.md` 状态机文档，通过 **Step级 Workflow 授权门禁（`授权执行 Step 1`）** 落地首个薄切片，并在前端引入 **`prototypeState` 调试切换器**，配合 **`Verifier Subagent` 静默自测** 与 **两提交状态推进协议（Commit A + Commit B）**，完成可复核的增量交付。

---

## 0. 本课教学目标 (Learning Objectives)

完成本课学习后，你将能够：
1. **对比与阐述** 一次性巨石代码生成的退化风险，以及 **Plan & Execute 范式** 结合 `/incremental-implementation` 架构护栏物理收敛的优势。
2. **校验与断言** 第三课交付的前置 Git 基线 SHA、`docs/BUSINESS_FEATURE_CARD.md`、`src/types/prototype-contract.d.ts` 以及 `src/mocks/prototype-data.ts`（Task 0 基线检查）。
3. **驱动与持久化** `/incremental-implementation` 技能，将包含 `plan_status` 与 `current_waiting_step` 状态机的实施计划落盘至外部长期记忆 `docs/LESSON_04_IMPLEMENTATION_PLAN.md`。
4. **掌握与触发** **Step级 Workflow 授权门禁**（首行精确匹配 `授权执行 Step 1`），解锁首个垂直切片编码。
5. **编写与物理验证** 带有 **`prototypeState` 调试切片（Loading 骨架屏、Empty 空数据、Error 报错重试、Success 正常呈现）** 可视化切换能力的 Vue 业务组件。
6. **派遣与调用** **`Verifier Subagent`（运行 `scripts/run-lesson-verifier.ps1 -Step 1`）** 静默跑通编译与学员自测（`scripts/verify-lesson-04-student.ps1`）。
7. **签署与执行** **两提交状态推进协议（Commit A 源码提交 + Commit B 状态推进提交）**，完成代码与状态机的解耦归档。

---

### 核心模式对比线框图 (巨石盲开 vs 增量切片 + 持久化 Plan 状态机 + Verifier + 两提交协议)

```text
===================================================================================
【第一层：一次性巨石盲开】 (无步骤约束，AI 一口气改 10 个文件，爆 Token 且无法定位错误)

  [复杂需求卡] ───> ( LLM 盲开输出 1000 行代码 ) ───> [ 样式崩溃 / 白屏 / 找不到原因 ]
                       (一次性修改全套逻辑)

===================================================================================
【第二层：/incremental-implementation + 持久化 Plan 状态机 + 两提交协议】

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
                     [ Verifier Subagent 静默自测 ] ───> [ PASS ]
                                 │
                                 ├───> [ 授权提交 Step 1 源码 ] ───> (Commit A: feat)
                                 │
                                 └───> [ 授权提交 Step 1 状态推进 ] ───> (Commit B: docs)
                                                                            │
                                                                            ▼
                                                          ( current_waiting_step -> 2 )

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

### 1.1 为什么必须使用持久化计划 `docs/LESSON_04_IMPLEMENTATION_PLAN.md` 状态机？
如果增量计划只保存在聊天窗口中，一旦执行 `/clear` 重置上下文，计划就会丢失；同时 Codex 或主管也无法根据固定计划进行复核。
因此，本课要求将拆解计划持久化写入 **`docs/LESSON_04_IMPLEMENTATION_PLAN.md`**，结构包含：
```yaml
plan_status: APPROVED
current_waiting_step: 1

steps:
  - id: 1
    name: "组件骨架与 prototypeState 4 状态调试切片"
    status: READY
    allowed_files: ["src/components/WorkOrderBoard.vue"]
    acceptance: "支持 prototypeState 4 状态调试按钮切换"
    verification_log: ""
    commit_sha: ""
  - id: 2
    name: "绑定 Mock 数据与渲染列表"
    status: BLOCKED
    allowed_files: ["src/components/WorkOrderBoard.vue"]
    acceptance: "成功渲染列表"
    verification_log: ""
    commit_sha: ""
```

### 1.2 两提交状态推进协议 (Two-Commit State Transition Protocol)
为了避免“在 Commit 前回填 Commit SHA 导致再次产生未提交修改”的自引用逻辑闭环问题，我们采用两提交协议：
1. **Commit A (源码提交)**：代码通过 Verifier 后，主管下发 `授权提交 Step 1 源码`，提交业务组件代码并取得 Commit A SHA；
2. **状态更新**：把 Commit A SHA 回填至计划，Step 1 改为 `COMPLETED`，Step 2 改为 `READY`，`current_waiting_step` 自动推进至 2；
3. **Commit B (状态推进提交)**：主管下发 `授权提交 Step 1 状态推进`，提交 `docs/LESSON_04_IMPLEMENTATION_PLAN.md` 状态更迭。
*(注：当完成最后一个 Step 时，状态机 `plan_status` 改为 `COMPLETED`，`current_waiting_step` 改为 `null`。)*

### 1.3 `prototypeState` 调试切换器（`import.meta.env.DEV`）
在纯前端原型中，静态 Mock 数据（`src/mocks/prototype-data.ts`）会导致页面永远处于 `Success` 状态。
我们在 Step 1 组件中植入基于开发环境控制的状态切换器：
```typescript
const showPrototypeDebug = import.meta.env.DEV
const prototypeState = ref<'loading' | 'empty' | 'error' | 'success'>('success')
```
在页面顶部渲染带有 `Prototype Debug` 标识的组件，让主管和讲师可以**物理点击按钮直接验证 4 种 UI 视图**。

### 1.4 `Verifier Subagent` 后台静默自测与进程树熔断
派遣 `.claude/agents/verifier.md` 后台子智能体（运行 `scripts/run-lesson-verifier.ps1 -Step 1`）：
* Student 模式默认调用 `scripts/verify-lesson-04-student.ps1`；
* 物理执行 60 秒超时控制（使用 `taskkill /F /T /PID` 递归销毁进程树，记录 `TIMEOUT_RECORDED`）；
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
- [ ] 成功在项目根目录下生成包含状态机字段的 `docs/LESSON_04_IMPLEMENTATION_PLAN.md` 文件。
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

### 任务 3：派遣 Verifier 自测与两提交归档 (Verify & Commit 阶段)

**目标**：调用 Verifier Subagent 跑通静默自测，下发两提交授权口令完成代码与状态归档。

**操作指令 1 (Verifier 自测)**：
```text
Step 1 代码已写完，请派遣 Verifier Subagent 在后台运行 scripts/run-lesson-verifier.ps1 -Step 1 进行校验。
```

**操作指令 2 (Commit A 源码提交)**：
```text
授权提交 Step 1 源码
```

**操作指令 3 (Commit B 状态推进提交)**：
```text
授权提交 Step 1 状态推进
```

**完成标准**：
- [ ] Verifier 接收到 `[PASS]`。
- [ ] Git Log 形成标准的 2 个提交：Commit A (`feat: step 1`) 与 Commit B (`docs(state): advance plan`)。
- [ ] `docs/LESSON_04_IMPLEMENTATION_PLAN.md` 中 `current_waiting_step` 成功更新为 2。

---

## 3. 课后退场自测 (Exit Ticket)

> **退出门禁题**：第四课 90 分钟课堂交付的核心成果是什么？两提交协议解决了什么问题？

* **参考答案**：
  课堂交付一份已批准的外部长期记忆计划 `docs/LESSON_04_IMPLEMENTATION_PLAN.md` + 一个经过 Verifier 验证的完整切片 (Step 1) + 2 个规范 Git Commit (Commit A 源码 + Commit B 状态推进)。两提交协议消除了“在 Commit 前回填 SHA 导致二次污染工作区”的死循环。

---

## 4. 常见卡点与排错 (FAQ)

| 卡点现象 | 根因分析 | 处理建议 |
| --- | --- | --- |
| 发送指令后 Agent 没有写文件 | 消息首行未严格匹配 `授权执行 Step N` | 检查发送的消息第一行是否精确等于 `授权执行 Step 1` |
| 点击调试切片界面无反应 | 误用了 `src/data/` 路径或变量未定义 | 确认使用了冻结路径 `src/mocks/prototype-data.ts` |
| Verifier 显示 FAIL | TS 类型错误、语法构建失败或计划文件丢失 | 查看 `local-backups/lesson-04-evidence/step-1-verification.log` 提取日志排错 |
