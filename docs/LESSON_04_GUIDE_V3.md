# 第四课学员操作指南 (GUIDE V3 双模合一终极版) — 受控 Agent 循环与 Working Tree 物理状态机

> 💡 **本课的核心思想只有一句话：**  
> **不要让 Agent 一口气完成整个功能，而是先形成计划，每次只完成一个可验证的小切片。**

> **📖 本指南支持双模式使用**：
> - **【课堂极速模式】**：上课时只需关注加粗的 **指令与操作步骤**，1 秒定位完成实操。
> - **【课后无痛自学模式】**：若未参加课堂听讲，请阅读每个任务下的 `💡 独立自学原理解析` 与 `🔍 代码 Before/After 对比`，无需讲师也可 100% 独立看懂。

---

## 💡 IT 跨界沟通术语卡：Working Tree (工作区 / 工作树)

- **标准 IT 术语**：`Working Tree` (工作区 / 工作树)
- **生活化通俗比喻**：**厨师切菜的砧板** 🔪
  - 砧板上有刚切好的菜（修改代码），此时砧板状态是 **Dirty（未打扫/有脏数据）**。
  - 菜切好装盘并盖章入库（Commit）后，砧板被洗干净，恢复 **100% Clean（干净状态）**。
  - 如果菜切坏了，把脏菜倒进垃圾桶冲洗砧板（Restore），也能立马恢复 **100% Clean**。
- **IT 沟通场景**：“请确保提交前 Working Tree 处于 Clean 干净状态，避免脏代码混入开发主干。”

---

## 🔄 薄切片受控流转模型与物理状态

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
  [ ➔ Working Tree 物理恢复 100% Clean 干净状态 ]       [ ➔ 同意记录 Step 1 问题 ➔ 回退还原 Clean ]

===================================================================================
【模式 C：页面技术状态调试器】(解决技术与业务解耦)

  ┌────────────────────────────────────────────────────────────────────────┐
  │ [prototypeState Debug] 状态切换: (◯ Loading  ◯ Empty  ◯ Error  ● Success)│
  │ 1. Loading: 骨架屏  2. Empty: 空数据  3. Error: 报错重试  4. Success: 列表数据 │
  └────────────────────────────────────────────────────────────────────────┘
===================================================================================
```

---

## 🛠️ 课堂实操与自学导引任务清单

### Task 0: 启动工程与干净状态检查

#### ⚡ 极速操作步骤 (课堂看这里)
1. 打开 VS Code 终端，启动本地开发服务器：
   ```powershell
   npm run dev
   ```
2. 确认 Working Tree 处于 Clean 干净状态：
   ```powershell
   git status
   ```
   *预期输出*：`nothing to commit, working tree clean`

#### 💡 独立自学原理解析 (自学看这里)
> **为什么这一步至关重要？**  
> 如果 Working Tree 在开工前就是 `Dirty`（有上次遗留未提交的修改），AI 生成代码时就会将新旧代码混在一起。开工前检查 `git status` 确保 `working tree clean`，相当于厨师做菜前先把砧板冲洗干净。

---

### Task 1: 唤醒增量实施 Skill 并落盘实施计划

#### ⚡ 极速操作步骤 (课堂看这里)
1. 在 Claude Code CLI 窗口中输入：
   ```text
   /incremental-implementation
   ```
2. 检查 AI 在窗口中输出的 3 步增量计划预览，确认无误后下发自然授权口令：
   ```text
   同意保存实施计划
   ```
3. **验证产物**：工程中将自动落盘 [`docs/LESSON_04_IMPLEMENTATION_PLAN.md`](file:///d:/AILearning/docs/LESSON_04_IMPLEMENTATION_PLAN.md)，初始 Step 1 为 `READY`。

#### 💡 独立自学原理解析 (自学看这里)
> **为什么不能直接让 AI 开始写代码？**  
> 野生 AI 的习惯是“抬手就写 500 行代码”，一旦中途某个函数报错，很难追踪是哪一步写错的。`/incremental-implementation` 强制 AI 在写入代码前，必须先把复杂需求切成 3 个互相独立的“薄切片 (Thin Slices)”，并将计划落盘为磁盘状态机。只有主管回复 `同意保存实施计划` 后，AI 才被许可创建计划文件。

---

### Task 2: 授权执行 Step 1 薄切片编码

#### ⚡ 极速操作步骤 (课堂看这里)
1. 在聊天窗口下发授权解锁口令：
   ```text
   确认完成 Step 1
   ```
2. AI 将在受控目录 `src/components/WorkOrderBoard.vue` 中写入 Step 1 薄切片代码， Working Tree 状态变为 `Dirty`。
3. 打开浏览器页面 `http://localhost:5173/`，验证 `prototypeState` 调试按钮：
   - 点击 `Loading`：展示加载骨架屏。
   - 点击 `Empty`：展示空数据占位。
   - 点击 `Error`：展示网络报错提示。
   - 点击 `Success`：展示正常工单列表。

#### 🔍 代码 Before vs After 视觉对比 (自学看这里)
```diff
  // src/components/WorkOrderBoard.vue
+ const showPrototypeDebug = import.meta.env.DEV
+ const prototypeState = ref<'loading' | 'empty' | 'error' | 'success'>('success')
+ 
+ // Step 1 薄切片仅绑定界面调试器，技术状态与业务状态物理解耦
```

#### 💡 独立自学原理解析 (自学看这里)
> **界面技术状态 vs 业务状态的解耦**  
> 非技术主管常把“页面报错/加载中”和“业务上的工单待处理”混为一谈。Step 1 切片引入 `prototypeState` 可视化调试按钮，让主管可以在真实接口未对接前，自由切换 Loading / Empty / Error / Success 四种界面形态，验证 UI 交互在各种极限网络情况下的容错表现。

---

### Task 3: 三层验收与双 Commit 物理归档

#### ⚡ 极速操作步骤 (课堂看这里)
1. 观察控制台日志与页面点击无报错。
2. AI 在后台通过 Verifier 静默自测后，自动执行双 Commit：
   - **Commit A**：提交源码修改 (`feat(code): ...`)。
   - **Commit B**：更新 `LESSON_04_IMPLEMENTATION_PLAN.md` 状态机（Step 1 变为 `COMPLETED`，Step 2 变为 `READY`）。
3. 运行 Git 检查：
   ```powershell
   git status
   ```
   *预期结果*：Working Tree 重新恢复为 `100% Clean` 干净状态！

#### 💡 独立自学原理解析 (自学看这里)
> **双 Commit 机制物理原理**  
> 为什么要做两次 Commit？因为“源码改动”和“进度状态更新”是两个维度的资产。Commit A 保护了纯净的代码库，Commit B 记录了项目管理进度。即使未来代码需要回滚，实施计划的进度的物理记录也不会丢失。

---

## 💡 常见概念误区与正确理解 (Mindset Transformation)

| 常见误区 (Misconception) | 正确硬核理解 (Correct Engineering Reality) | 如何纠偏与护栏防护 (Remedy & Guardrails) |
| :--- | :--- | :--- |
| **误区 1：“让 AI 一口气写完页面所有功能效率最高”** | 一口气修改 10 个文件会导致 Working Tree 一片狼藉，爆 Context 且报错时根本无法定位根因。 | 唤醒 `incremental-implementation` 护栏，强制按 3–5 步切片，每次仅授权执行 1 个切片。 |
| **误区 2：“只要静态编译通过 (Verifier PASS)，就代表切片做对了”** | Verifier 只是静态编译检查，无法替代人工物理点击页面以及主管对业务逻辑与交互美观度的裁决。 | 严格执行 **三层递进验收 (Verifier PASS -> 人工点击 PASS -> 主管业务验收 PASS)**，缺一不可。 |
| **误区 3：“混淆界面技术呈现状态与业务处理流程状态”** | 将 `Loading` 或 `Error` 误当成业务对象的状态，导致逻辑混乱与调试失败。 | 强制前端植入 `prototypeState` 调试器（`import.meta.env.DEV`），与业务处理流程状态标签物理解耦。 |
| **误区 4：“切片报错时直接多次下发指令让 AI 撞大运”** | 在 Working Tree 堆积坏代码重试会导致残渣残留，后续 Git 提交误将坏代码打包入库。 | 系统自动备份快照补丁并清扫 Working Tree 还原 Clean 干净源码，下发 `同意记录 Step 1 问题` 归档。 |

---

## ❓ 常见操作报错与 Troubleshooting 指南

| 报错/异常现象 | 物理原因 | 解决与纠偏方案 |
| :--- | :--- | :--- |
| 输入口令后 AI 提示 `CONTRACT_ASSET_MISMATCH` | 第三课的功能卡与 TS 数据字典字典字段不一致 | 回退到第三课，核对并修正 `BUSINESS_FEATURE_CARD.md` 字段。 |
| AI 生成代码后 Working Tree 一直是 Dirty | 静默自测失败，未跑 Commit 归档 | 在聊天窗口下发 `同意记录 Step 1 问题`，AI 会导出 `.patch` 快照并还原干净工程。 |

---

## 📝 巩固与退场测试题库

### 阶段 1：课堂 5 分钟退场测试 (Exit Ticket - 课堂盖章)
1. **[填空题]** 在增量实施范式中，当切片报错或主管拒绝时，系统会自动导出 `.patch` 快照补丁，并将 Working Tree 物理恢复为 ____________ 干净状态。
2. **[IT 沟通场景题]** 当你需要向 IT 工程师解释为什么要分 Step 授权落盘时，你应该怎么说？
   - **参考回答**：“我们采用了 Step 级状态机与薄切片范式，每次授权一个可独立测试的增量切片，配合双 Commit 物理归档，确保 Working Tree 随时可退回 100% 干净状态。”

---

### 阶段 2：课后自学拓展复习题库 (Self-Study Extension)
3. **[原理思考题]** 为什么我们在 Step 1 中要专门引入 `prototypeState` 调试器？它和真正的业务数据处理有什么区别？
   - **自学提示**：界面技术状态（Loading/Error）属于前端展示容错，业务状态（待处理/已关单）属于领域数据流。将两者解耦可在无后端支撑时全量测试前端交互。
4. **[实操演练题]** 尝试故意在代码中改错一个变量名，然后向 AI 下发口令 `同意记录 Step 1 问题`，观察本地 `local-backups/` 目录中是否生成了补丁文件，并使用 `git status` 验证 Working Tree 是否自动恢复为 Clean。
