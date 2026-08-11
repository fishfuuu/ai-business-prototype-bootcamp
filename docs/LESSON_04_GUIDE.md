# 第四课学员操作指南 — 把大需求拆成连续的小成功：受控 Agent 循环与 Working Tree 物理状态机

> 💡 **本课的核心思想只有一句话：**  
> **不要让 Agent 一口气完成整个功能，而是先形成计划，每次只完成一个可验证的小切片。**

---

## 一、 本课背景、底层原理与学习目标

### 1.1 业务背景与真实痛点
在实际 AI 编程中，非技术主管最常踩的坑就是“让 AI 一口气写完全部功能”。结果往往是 AI 抬手修改 10 个文件、生成 1000 行代码，中途一旦报错，整个页面直接白屏崩溃。由于代码量巨大，主管既无法审查改动，也无法精准回退，最终只能“大失血式重头再来”。

### 1.2 宏观受控流水线闭环
本课的核心工程机制，是将 AI 编程的随机性纳入一条**“契约约束 ➔ 磁盘计划 ➔ 单步授权 ➔ 三层门禁 ➔ 干净还原”**的受控流水线中：
1. **契约校验与计划落盘**：编码前强制校验第三课产出的 [`src/mocks/prototype-data.ts`](file:///d:/AILearning/src/mocks/prototype-data.ts) 数据契约，唤醒 `/incremental-implementation` Skill，AI 必须先将大块需求切割为独立切片并写入磁盘状态机 [`docs/LESSON_04_IMPLEMENTATION_PLAN.md`](file:///d:/AILearning/docs/LESSON_04_IMPLEMENTATION_PLAN.md)。
2. **单步授权门禁**：未经主管输入口令授权（下发“授权执行 Step N”），AI 物理上被禁止修改任何代码；授权后仅解锁当前 Step 的受控文件。
3. **闭环验收与双分支流转**：写完代码后在后台通过 Verifier Subagent 静默自测，若 PASS 则跑 `git add --` 选择性暂存双 Commit 归档（Commit A 源码 + Commit B 状态）并恢复 Clean；若 FAIL 则自动导出 `.patch` 快照补丁并清扫工作区还原 Clean。

### 1.3 核心学习目标
完成本课实操后，你将能够：
1. 学会使用自然授权口令 (`同意保存实施计划` / `确认完成 Step 1` / `授权执行 Step 1`) 控制 Agent 编码节奏。
2. 掌握使用 `prototypeState` 可视化调试器，将界面技术呈现状态与业务处理流程状态物理解耦。
3. 理解“买房交房 vs 房管局确权”的双 Commit 物理归档原理，掌控版本落盘节奏。
4. 掌握代码切片报错时的“补丁快照备份 + Working Tree 干净无损还原”机制。

---

## 二、 💡 本课核心工程概念卡 (Core Concepts)

### 核心概念 1：Working Tree (工作区 / 工作树)
- **硬核工程定义**：Git 版本控制系统中，当前物理磁盘上记录代码修改与暂存的工作镜像。
- **底层运作机制**：代码修改标记为 `Dirty`，执行 `git commit` 或 `git restore` 后恢复 `100% Clean` 干净状态。
- **具象业务比喻**：**厨师切菜的砧板** 🔪。砧板上有脏菜是 Dirty，菜切好装盘（Commit）或冲洗砧板（Restore）后恢复 Clean。
- **IT 沟通场景**：“请确保提交前 Working Tree 处于 Clean 干净状态，避免脏代码混入开发主干。”

### 核心概念 2：增量实施与薄切片范式 (Incremental Thin Slices)
- **硬核工程定义**：将大块复杂需求拆解为多个独立可编译、可测试的最小粒度切片（Thin Slice）逐个构建的软件工程范式。
- **底层运作机制**：通过 `IMPLEMENTATION_PLAN.md` 磁盘状态机驱动步骤按 `PENDING` ➔ `READY` ➔ `COMPLETED` 受控流转。
- **具象业务比喻**：**预制件搭积木** 🧩。不一口气砌整面墙，而是一块一块榫卯积木搭接，随时能单独替换。
- **IT 沟通场景**：“我们采用薄切片范式开发，每次只授权落盘 1 个可验证的切片，拒绝盲开大块代码。”
> 💡 **伏笔小贴士**：先将需求拆解为薄切片计划书再逐步动工的受控范式，在 AI 工程中被称为 **Plan-and-Execute (规划与执行分离) 范式**，我们将在第 5 课为您系统梳理 Agent 3 大控制流全景矩阵。

### 核心概念 3：技术呈现状态与业务处理流程状态解耦 (prototypeState Decoupling)
- **硬核工程定义**：将前端界面的技术容错与加载状态（Loading/Empty/Error/Success）与数据对象的业务生命周期状态物理隔离的设计。
- **底层运作机制**：在组件内植入 `prototypeState` 开发期变量与可视化按钮，自由切换静态渲染形态。
- **具象业务比喻**：**新车风洞测试** 🚗。在不点火上路前，静态测试车门、灯光在暴风雪中的容错表现。
- **IT 沟通场景**：“前端引入了 `prototypeState` 可视化调试器，实现了界面技术状态与业务流程状态的物理解耦。”

### 核心概念 4：双 Commit 物理归档与房产过户双节点比喻 (Dual-Commit Archiving)
- **硬核工程定义**：在一个 Step 完成后，通过选择性暂存 (`git add --`) 将“源码工程变动”与“计划状态机更新”物理隔离为两次独立 Git 提交的规范。
- **底层运作机制**：Commit A 仅暂存 `src/` 下的代码修改；Commit B 仅暂存 `docs/LESSON_04_IMPLEMENTATION_PLAN.md` 状态变动（将 Step 1 从 `READY` 改为 `COMPLETED`）。
- **具象业务比喻**：**买房入住与去房管局过户登记 (House Purchase & Deed Transfer)** 🏠：
  - **Commit A (源码落盘)** 相当于 **【拿到钥匙入住新房 (交房)】**：房屋建设完毕并物理通过验收；
  - **Commit B (状态更新)** 相当于 **【去房管局做过户登记 (落盘确权)】**：在房产证上记录产权流转！只有交房验房无误（Commit A PASS），才去房管局盖章落盘确权（Commit B）。
- **IT 沟通场景**：“项目采用双 Commit 隔离提交，源码资产与项目管理进度解耦，支持独立的差异审计与版本回滚。”

---

## 三、 🔄 薄切片受控流转模型与物理状态

```text
===================================================================================
【模式 A：一次性巨石盲开】(反面案例：无步骤约束，一口气修改全套逻辑 ➔ 白屏/崩塌)

  [复杂需求卡] ───> ( AI 一口气生成 1000 行代码 ) ───> [ 页面白屏 / 代码冲突 / 砧板废弃 ]

===================================================================================
【模式 B：受控薄切片 + Working Tree 物理状态机】(本课标准范式)

  [起始状态: Working Tree 100% Clean (干净砧板)]
                        │
                        ▼
  [三份需求契约] ───> [ Pre-Plan 检查 ] ───> [ 预览切片计划 ] ───> [ 同意保存实施计划 ]
                                                                          │ (落盘 IMPLEMENTATION_PLAN.md)
                                                                          ▼
                                                              ┌───────────────────────────┐
                                                              │ Workflow 门禁: 确认完成 Step 1│
                                                              └───────────────────────────┘
                                                                          │
                                                                          ▼
                                                       ( 编码修改 ➔ Working Tree 变为 Dirty )
                                                                          │
                                                                          ▼
  [ 三层验收: Verifier 自测 ➔ 界面调试 ➔ 主管盖章 ]
                             │
                             ├─────────────────────────────────────────┐
                             ▼                                         ▼
  [ PASS: 确认完成 Step 1 ➔ 跑 Commit A/B 双提交 ]      [ FAIL: 备份 .patch 补丁 ➔ 冲洗 Working Tree ]
  (Commit A 源码交房 + Commit B 状态确权登记)            [ ➔ 同意记录 Step 1 问题 ➔ 回退还原 Clean ]
  [ ➔ Working Tree 物理恢复 100% Clean 干净状态 ]       
===================================================================================
【模式 C：页面技术状态调试器】(解决技术与业务解耦)

  ┌────────────────────────────────────────────────────────────────────────┐
  │ [prototypeState Debug] 状态切换: (◯ Loading  ◯ Empty  ◯ Error  ● Success)│
  │ 1. Loading: 骨架屏  2. Empty: 空数据  3. Error: 报错重试  4. Success: 列表数据 │
  └────────────────────────────────────────────────────────────────────────┘
===================================================================================
```

---

## 四、 🛠️ 课堂实操与自学导引任务清单

### Task 0: 启动工程与干净状态检查

#### ⚡ 极速操作步骤
1. 打开 VS Code 终端，启动本地开发服务器：
   ```powershell
   npm run dev
   ```
2. 确认 Working Tree 处于 Clean 干净状态：
   ```powershell
   git status
   ```
   *预期输出*：`nothing to commit, working tree clean`

#### 💡 独立自学原理解析
> **为什么这一步至关重要？**  
> 如果 Working Tree 在开工前就是 `Dirty`（有上次遗留未提交的修改），AI 生成代码时就会将新旧代码混在一起。开工前检查 `git status` 确保 `working tree clean`，相当于厨师做菜前先把砧板冲洗干净。

---

### Task 1: 唤醒增量实施 Skill 并落盘实施计划

#### ⚡ 极速操作步骤
1. 在 Claude Code CLI 窗口中输入：
   ```text
   /incremental-implementation
   ```
2. 检查 AI 在窗口中输出的 3 步增量计划预览，核对包含第三课的 [`src/mocks/prototype-data.ts`](file:///d:/AILearning/src/mocks/prototype-data.ts) 路径，确认无误后下发自然授权口令：
   ```text
   同意保存实施计划
   ```
3. **验证产物**：工程中将自动落盘 [`docs/LESSON_04_IMPLEMENTATION_PLAN.md`](file:///d:/AILearning/docs/LESSON_04_IMPLEMENTATION_PLAN.md)，初始 Step 1 为 `READY`。

#### 💡 独立自学原理解析
> **为什么不能直接让 AI 开始写代码？**  
> 野生 AI 的习惯是“抬手就写 500 行代码”，一旦中途某个函数报错，很难追踪是哪一步写错的。`/incremental-implementation` 强制 AI 在写入代码前，必须先把复杂需求切成 3 个互相独立的“薄切片 (Thin Slices)”，并将计划落盘为磁盘状态机。只有主管回复 `同意保存实施计划` 后，AI 才被许可创建计划文件。

---

### Task 2: 授权执行 Step 1 薄切片编码

#### ⚡ 极速操作步骤
1. 在聊天窗口下发授权执行口令（`授权执行 Step 1` 或自然口令）：
   ```text
   确认完成 Step 1
   ```
2. AI 将在受控目录 `src/components/WorkOrderBoard.vue` 中写入 Step 1 薄切片代码， Working Tree 状态变为 `Dirty`。
3. 打开浏览器页面 `http://127.0.0.1:5173/`，验证 `prototypeState` 调试按钮：
   - 点击 `Loading`：展示加载骨架屏。
   - 点击 `Empty`：展示空数据占位。
   - 点击 `Error`：展示网络报错提示。
   - 点击 `Success`：展示正常工单列表。

#### 🔍 代码 Before vs After 视觉对比
```diff
  // src/components/WorkOrderBoard.vue
+ const showPrototypeDebug = import.meta.env.DEV
+ const prototypeState = ref<'loading' | 'empty' | 'error' | 'success'>('success')
+ 
+ // Step 1 薄切片仅绑定界面调试器，技术状态与业务状态物理解耦
```

#### 💡 独立自学原理解析
> **界面技术状态 vs 业务状态的解耦**  
> 非技术主管常把“页面报错/加载中”和“业务上的工单待处理”混为一谈。Step 1 切片引入 `prototypeState` 可视化调试按钮，让主管可以在真实接口未对接前，自由切换 Loading / Empty / Error / Success 四种界面形态，验证 UI 交互在各种极限网络情况下的容错表现。

---

### Task 3: 三层验收与双 Commit 物理归档 (房产过户双节点比喻)

#### ⚡ 极速操作步骤
1. 观察控制台日志与页面点击无报错。
2. AI 在后台通过 Verifier Subagent 静默自测后，使用选择性暂存 (`git add --`) 自动执行双 Commit 归档：
   - **Commit A (源码落盘)**：提交源码修改 (`feat(code): ...`)，代表**【买房验房拿到钥匙入住 (交房)】**。
   - **Commit B (状态确权)**：更新 `LESSON_04_IMPLEMENTATION_PLAN.md` 状态机（Step 1 变为 `COMPLETED`，Step 2 变为 `READY`），代表**【去房管局做过户登记 (落盘确权)】**。
3. 运行 Git 检查：
   ```powershell
   git status
   ```
   *预期结果*：Working Tree 重新恢复为 `100% Clean` 干净状态！

#### 💡 独立自学原理解析
> **双 Commit 机制的房产买卖比喻物理原理**  
> 为什么要拆成两次 Commit？因为“源码修改”与“项目管理进度”是两个完全不同维度的资产。就像买房一样，Commit A 保护的是你住进去的物理房子（源码）；Commit B 保护的是房产证上的产权名下登记（进度状态）。只有房子验收通过（Commit A PASS），你才会去房管局盖章落盘确权（Commit B）。这样即使将来代码需要回滚，实施计划的进度记录也不会被误删！

---

## 五、 💡 常见概念误区与正确理解 (Mindset Transformation)

| 常见误区 (Misconception) | 正确硬核理解 (Correct Engineering Reality) | 如何纠偏与护栏防护 (Remedy & Guardrails) |
| :--- | :--- | :--- |
| **误区 1：“让 AI 一口气写完页面所有功能效率最高”** | 一口气修改 10 个文件会导致 Working Tree 一片狼藉，爆 Context 且报错时根本无法定位根因。 | 唤醒 `incremental-implementation` 护栏，强制按 3–5 步切片，每次仅授权执行 1 个切片。 |
| **误区 2：“只要静态编译通过 (Verifier PASS)，就代表切片做对了”** | Verifier 只是静态编译检查，无法替代人工物理点击页面以及主管对业务逻辑与交互美观度的裁决。 | 严格执行 **三层递进验收 (Verifier PASS -> 人工点击 PASS -> 主管业务验收 PASS)**，缺一不可。 |
| **误区 3：“混淆界面技术呈现状态与业务处理流程状态”** | 将 `Loading` 或 `Error` 误当成业务对象的状态，导致逻辑混乱与调试失败。 | 强制前端植入 `prototypeState` 调试器（`import.meta.env.DEV`），与业务处理流程状态标签物理解耦。 |
| **误区 4：“混淆源码 Commit A 与 状态 Commit B”** | 误以为一次 Commit 可以同时包办源码与项目状态。 | 掌握房产过户双节点比喻，用 `git add --` 独立暂存，先验房交房 (Commit A) 再过户确权 (Commit B)。 |

---

## 六、 ❓ 常见操作报错与 Troubleshooting 指南

| 报错/异常现象 | 物理原因 | 解决与纠偏方案 |
| :--- | :--- | :--- |
| 输入口令后 AI 提示 `CONTRACT_ASSET_MISMATCH` | 第三课的功能卡与 TS 数据字典字段不一致 | 回退到第三课，核对并修正 `BUSINESS_FEATURE_CARD.md` 字段。 |
| AI 生成代码后 Working Tree 一直是 Dirty | 静默自测失败，未跑 Commit 归档 | 在聊天窗口下发 `同意记录 Step 1 问题`，AI 会导出 `.patch` 快照并还原干净工程。 |

---

## 七、 📝 巩固与退场测试题库 (5 题精选)

### 阶段 1：课堂退场盖章测试 (Exit Ticket)
1. **[概念填空题]** 在双 Commit 物理归档机制中，Commit A 代表的是 ____________（相当于买房拿钥匙入住），而 Commit B 代表的是 ____________（相当于去房管局过户登记）。
2. **[状态机辨析题]** 在实施计划文件 `IMPLEMENTATION_PLAN.md` 中，一个步骤在等待主管输入授权口令前，其物理状态枚举应当是 ____________。
   - A. `PENDING`
   - B. `READY`
   - C. `IN_PROGRESS`
   - D. `COMPLETED`
3. **[IT 沟通场景题]** 当你需要向 IT 工程师解释为什么要采取双 Commit 隔离提交时，你应该怎么说？
   - **参考回答**：“我们采用了双 Commit 隔离提交，将源码资产与项目管理进度解耦，先做源码落盘再做状态确权登记，确保 Working Tree 随时可无损退回 Clean 状态。”

---

### 阶段 2：课后自学拓展思考题 (Self-Study Extension)
4. **[原理思考题]** 为什么我们在 Step 1 中要专门引入 `prototypeState` 调试器？它和真正的业务数据处理有什么区别？
5. **[实操演练题]** 尝试故意在代码中改错一个变量名，然后向 AI 下发口令 `同意记录 Step 1 问题`，观察本地 `local-backups/` 目录中是否生成了补丁文件，并使用 `git status` 验证 Working Tree 是否自动恢复为 Clean。
