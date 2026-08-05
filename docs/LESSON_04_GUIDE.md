# 第四课学员指南 (V2 重构版)：把大需求拆成连续的小成功

欢迎来到第四课！在前三课中，我们完成了界面搭建、视觉规则约束（`DESIGN.md`）以及需求与数据契约锁订（`grill-me`）。本节课我们将解决系统研发中最核心的崩溃点——**“巨石代码盲开与上下文失控”**。你将学习如何唤醒 `/incremental-implementation` 架构护栏，采用 **Plan & Execute 增量范式**，将大需求拆解为 3~5 步薄切片，并在前端显式植入 **4 种数据状态控制开关**，配合 **Verifier Subagent 静默自测** 与 Git 存档，实现不退化的连续交付。

---

## 0. 本课教学目标 (Learning Objectives)

完成本课学习后，你将能够：
1. **对比与阐述** 一次性巨石代码生成的退化风险，以及 **Plan & Execute 范式** 结合 `/incremental-implementation` 架构护栏物理收敛的优势。
2. **校验与断言** 第三课交付的前置 Git 基线 SHA 与强类型契约 `prototype-contract.d.ts`（Task 0 基线检查）。
3. **唤醒与驱动** `/incremental-implementation` 技能，通过 **HITL 精确授权口令（`授权执行 Step X`）** 控制 Agent 生成 3–5 步增量计划 (Plan) 并分步落盘。
4. **编写与实现** 带有 **`prototypeState` 调试切片（Loading 骨架屏、Empty 空数据、Error 报错重试、Success 正常呈现）** 可视化切换能力的 Vue 业务组件。
5. **派遣与调用** **`Verifier Subagent`（静默校验子智能体）** 跑通 `npm run build`，在不污染主上下文的前提下完成 **Atomic Git Commit 稳定存档**。

---

### 核心模式对比线框图 (巨石盲开 vs 增量切片 + Verifier 护栏)

```text
===================================================================================
【第一层：一次性巨石盲开】 (无步骤约束，AI 一口气改 10 个文件，爆 Token 且无法定位错误)

  [复杂需求卡] ───> ( LLM 盲开输出 1000 行代码 ) ───> [ 样式崩溃 / 白屏 / 找不到原因 ]
                       (一次性修改全套逻辑)

===================================================================================
【第二层：/incremental-implementation + HITL 授权口令】 (本课实操：施工图 + 精确落盘)

  [Task 0 基线断言] ───> [ 唤醒 /incremental-implementation ]
                                 │ (只读输出 Plan)
                                 ▼
                     ┌────────────────────────┐
                     │ HITL 门禁: "授权执行Step 1" │
                     └────────────────────────┘
                                 │
                                 ▼
                        ( 步骤 1: 契约与4状态UI ) 
                                 │
                                 ▼
                     [ Verifier Subagent 静默自测 ] ───> [ PASS: Atomic Git Commit ]

===================================================================================
【第三层：4 种数据状态物理切换器】 (可视化调试，彻底消除交接死角)

   ┌────────────────────────────────────────────────────────────────────────┐
   │ [调试切片] 数据状态切换: (◯ Loading  ◯ Empty  ◯ Error  ● Success)      │
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

### 1.1 什么是 Plan & Execute 范式？
在以前的 ReAct 范式中，Agent 边想边做（Thought-Action-Observation），适合单步排错。但在面对复杂多文件需求时，ReAct 会导致 Agent 不断试错，爆掉上下文记忆窗口。

**Plan & Execute 范式** 强制分为两阶段：
- **Plan（规划阶段）**：Agent 只读分析需求，输出 3–5 步增量计划，**此阶段绝对不修改代码**。
- **Execute（执行阶段）**：人类下发 **`授权执行 Step X`** 精确口令后，Agent 才被解除锁定，落地代码。

### 1.2 物理解药 1：`/incremental-implementation` 与 HITL 口令契约
为了防止 Agent “口头答应拆计划，手下却冲动改代码”，物理 Skill `.claude/skills/incremental-implementation/SKILL.md` 设置了严格门禁：
* 唤醒后只输出 Plan 文本；
* 必须在 CLI 中输入物理口令 **`授权执行 Step X`**，AI 才会开始动手编写该 Step 的代码。

### 1.3 物理解药 2：`prototypeState` 可视化切换器
在纯前端原型中，静态 Mock 数据会导致页面永远处于 `Success` 状态，无法测试其他分支。
我们要求在组件中引入响应式调试切片：
```typescript
const prototypeState = ref<'loading' | 'empty' | 'error' | 'success'>('success');
```
并在页面顶部渲染轻量单选切片，让主管和讲师可以**物理点击按钮直接验证 4 种 UI 视图**。

### 1.4 物理解药 3：`Verifier Subagent` 静默自测
如果在主聊天窗口中跑 `npm run build`，编译日志会瞬间挤爆 Context 记忆。
我们通过派遣 **`Verifier Subagent`**：
* 在子会话中静默执行 `npm run build` 和 `verify-student-project.ps1`；
* 过滤掉冗长输出，只给主 Agent 返回 1 行精炼断言结果：`[PASS] Step 1 构建与类型校验通过`。

---

## 2. 学员实操任务

### 任务 0：前置基线 SHA 与契约检查 (Baseline Check)

**目标**：确保起点代码处于稳定 Commit，检查 L3 资产 `BUSINESS_FEATURE_CARD.md` 与 `prototype-contract.d.ts` 存在。

**操作指令**：
在 Claude Code CLI 中输入：
```text
请检查当前 Git Commit 状态，并确认 docs/BUSINESS_FEATURE_CARD.md 与 src/types/prototype-contract.d.ts 是否正常存在。若有未提交的脏代码，请提示我处理。
```

**完成标准**：
- [ ] 确认基线处于干净状态（`working tree clean`）。

---

### 任务 1：唤醒架构护栏，生成 3-5 步拆解图纸 (Plan 阶段)

**目标**：使用 `/incremental-implementation` 技能，生成增量拆解计划。

**操作指令**：
```text
/incremental-implementation
请读取 docs/BUSINESS_FEATURE_CARD.md 与 src/types/prototype-contract.d.ts，为我生成 3-5 步 Contract-First 增量开发计划。
注意：现在只输出 Plan 施工图与每步验收条件，绝不要修改任何代码文件！
```

**完成标准**：
- [ ] Agent 输出 Step 1 到 Step 4 计划，末尾附带：`Plan 制定完毕。请输入 "授权执行 Step 1" 以开始编码。`
- [ ] 物理源码零修改。

---

### 任务 2：下发授权口令，植入 4 状态与调试切片 (Execute 阶段)

**目标**：下发 HITL 授权口令，完成 Step 1 编码，并在 Vue 原型中植入 `prototypeState` 调试切换器。

**操作指令**：
```text
授权执行 Step 1：请创建目标业务组件，物理植入 prototypeState ('loading' | 'empty' | 'error' | 'success') 响应式状态控制，并在组件顶部渲染状态切换调试按钮，物理实现 4 种 UI 视图。
```

**完成标准**：
- [ ] 打开浏览器页面，物理点击顶部调试切片按钮（Loading / Empty / Error / Success），界面流畅切换 4 种不同 UI。
- [ ] 代码通过 TypeScript 类型检查。

---

### 任务 3：派遣 Verifier Subagent 静默自测与 Git 提交 (Verify 阶段)

**目标**：调用 Verifier Subagent 跑通构建静默断言，完成 Atomic Git Commit。

**操作指令**：
```text
Step 1 代码已写完，请派遣 Verifier Subagent 在后台静默运行 npm run build 进行校验。确认 PASS 后提示我生成 Git Commit。
```

**完成标准**：
- [ ] Verifier Subagent 干净返回 `[PASS]`，主 Context 未被编译日志污染。
- [ ] 成功执行 `git commit`，日志格式为 `feat(prototype): step 1 - add skeleton with 4-state debug toggle`。

---

## 3. 课后退场自测 (Exit Ticket)

> **退出门禁题**：为什么我们在第四课中强调“必须使用 `prototypeState` 切换器”和“必须使用 `Verifier Subagent`”？

* **参考答案**：
  1. `prototypeState` 切换器消除了静态 Mock 数据下无法物理验证 Loading/Empty/Error 边界的死角；
  2. `Verifier Subagent` 防止了构建日志堵塞主 Context 记忆窗口，确保大型项目迭代中 Agent 不发生“规则遗忘”。

---

## 4. 常见卡点与排错 (FAQ)

| 卡点现象 | 根因分析 | 处理建议 |
| --- | --- | --- |
| 唤醒 Skill 后 Agent 直接动手改了文件 | 未强调“只读”或 Prompt 中缺少限制 | 提醒 Agent：“遵循 /incremental-implementation 门禁，先撤销修改，只输出 Plan 并等待『授权执行』口令！” |
| 物理点击状态切换按钮，界面没反应 | `prototypeState` 未使用 `ref()` 或 `v-if` 条件写错 | 检查组件中是否使用了响应式 `ref` 以及模板是否对应 `v-if="prototypeState === 'loading'"` |
| Verifier Subagent 报 TS 类型错误 | 新代码字段不符合 `prototype-contract.d.ts` 规范 | 物理对比 TS 接口草稿中的字段定义与类型 |
