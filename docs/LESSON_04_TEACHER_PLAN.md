# 第四课教师备课与控场指南 — 把大需求拆成连续的小成功：受控 Agent 循环与 Working Tree 物理状态机

> [!IMPORTANT]
> 本教案为 **8 大执教模块精简标准版**，按讲师执教动线深度整合，删除了原 22 章的碎片冗余。

---

## 一、 课程元数据与定位

### 1.1 课程元数据
- **课程名称**：AI 业务原型开发训练营·第四课
- **主讲主题**：把大需求拆成连续的小成功：受控 Agent 循环与 Working Tree 物理状态机
- **授课对象**：非技术背景业务主管 / 产品经理 / 业务专家 (10–30人)
- **课时时长**：90 分钟 (极客控场 + 5 个固定 Pause Points)
- **授课模式**：18 分钟极客示范 ➔ 10 分钟概念核对 ➔ 45 分钟学员分步实操 ➔ 10 分钟验证归档
- **前置依赖**：学员已完成第三课并拥有 [`docs/BUSINESS_FEATURE_CARD.md`](file:///d:/AILearning/docs/BUSINESS_FEATURE_CARD.md)、[`src/types/prototype-contract.d.ts`](file:///d:/AILearning/src/types/prototype-contract.d.ts) 与 [`src/mocks/prototype-data.ts`](file:///d:/AILearning/src/mocks/prototype-data.ts) 三份契约资产。
- **教学验证状态**：PILOT_PENDING (草稿V2 / 待合入 / 待试讲)
- **课程负责人**：待指定

### 1.2 本课定位与背景痛点
- **在全套课程中的位置**：承接第三课《需求澄清与契约冻结》，开启真正的受控代码增量构建。
- **解决的核心痛点**：非技术主管直接让 AI 写全套代码导致“一改就崩”、“代码黑盒失控”、“大失血式重头再来”。
- **核心突破口**：引入“薄切片 (Thin Slices)”与“ Working Tree 砧板模型”，让 Agent 必须先出计划，每次只授权完成 1 个可验证的切片，并自动通过双 Commit 进行物理归档。

---

## 二、 逆向目标与四步概念卡

### 2.1 Bloom ABCD 学习目标
完成本课后，学员将能够：
1. **[Objective 1 - Apply (3)]**：在给定的项目 Working Tree 环境下 (**C**)，学员 (**A**) 能使用自然指令 `同意保存实施计划` 与 `确认完成 Step 1` (**B**)，解锁第一个薄切片并成功写入工程 (**D**)。
2. **[Objective 2 - Analyze (4)]**：在面对 Agent 生成的代码切片时 (**C**)，学员 (**A**) 能通过 `prototypeState` 页面技术状态调试器 (**B**)，准确判断 Loading / Empty / Error / Success 四种界面状态与业务状态的解耦情况 (**D**)。
3. **[Objective 3 - Evaluate (5)]**：在代码切片报错或出现验收冲突时 (**C**)，学员 (**A**) 能下发口令 `同意记录 Step N 问题` (**B**)，触发快照补丁导出与 Working Tree 100% Clean 自动恢复 (**D**)。

### 2.2 核心概念四步解析卡集

#### 💡 概念卡 1：Working Tree (工作区 / 工作树)
1. **硬核工程定义**：Git 版本控制系统中，物理磁盘上记录代码修改与暂存的工作镜像。
2. **底层运作机制**：代码修改标记为 `Dirty`，执行 `git commit` 或 `git restore` 后恢复 `100% Clean`。
3. **具象业务比喻**：**厨师切菜的砧板** 🔪。
4. **IT 沟通场景**：“请确保提交前 Working Tree 处于 Clean 干净状态。”

#### 💡 概念卡 2：增量实施与薄切片范式 (Incremental Thin Slices)
1. **硬核工程定义**：将大块复杂需求拆解为独立可测试的最小粒度切片逐个构建的范式。
2. **底层运作机制**：通过 `IMPLEMENTATION_PLAN.md` 磁盘状态机驱动 Step 进度流转。
3. **具象业务比喻**：**预制件搭积木** 🧩。
4. **IT 沟通场景**：“我们采用薄切片范式开发，每次只授权落盘 1 个可验证的切片。”

#### 💡 概念卡 3：界面技术呈现状态与业务处理流程状态解耦
1. **硬核工程定义**：将前端界面的技术容错与数据对象的业务生命周期状态物理隔离的设计。
2. **底层运作机制**：通过 `prototypeState` 开发期变量与可视化按钮，自由切换渲染形态。
3. **具象业务比喻**：**新车风洞测试** 🚗。
4. **IT 沟通场景**：“前端引入了 `prototypeState` 调试器，实现了技术状态与业务状态的解耦。”

---

## 三、 教学准备与沙箱隔离

- **代码仓库准备**：安装依赖并保证工程根目录下无未提交更改。
- **环境检查命令**：
  ```powershell
  git status
  npm run dev
  ```
  *预期输出*：`nothing to commit, working tree clean` 且 Vite 开发服务成功启动在 5173 端口。
- **演示区与实验区隔离**：讲师在示范窗口独立操作，学员在各自终端独立实践。

---

## 四、 90分钟控场主线与 Pause Points

| 时间段 | 环节 | WHERETO | 教师动作与 Pause Points 提问 | 学员动作 |
| :--- | :--- | :--- | :--- | :--- |
| 00-08 分 | 成果展示 | **W** | 展示巨石盲开崩塌 vs 薄切片受控流转。<br>**Pause Point 1**：“为什么不能让 AI 一口气生成全套代码？” | 观看对齐交付物 |
| 08-25 分 | 极客示范 | **H & E** | 示范 Task 0➔3，展示状态机与双 Commit。<br>**Pause Point 2**：“开工前为什么要检查 `git status` 确认 clean？”<br>**Pause Point 3**：“`prototypeState` 调试按钮有什么用？” | 记录关键口令 |
| 25-35 分 | 概念核对 | **R** | 提问核对 Working Tree 与状态机卡片。<br>**Pause Point 4**：“双 Commit 机制为什么要提交两次？” | 口头回答卡片 |
| 35-80 分 | 学员实操 | **E & T** | 巡视指导，监控授权与 Git 状态。<br>**Pause Point 5**：“当切片报错时如何无损还原？” | 分 Task 独立实操 |
| 80-90 分 | 总结验证 | **O** | 运行 `verify-project.ps1` 校验。 | 填退场卡，提交日志 |

---

## 五、 逐 Task 极客示范与巡视指导

### Task 0: 启动工程与 Working Tree 干净状态检查
- **教师示范**：运行 `git status`，讲解 Clean 与 Dirty 物理含义。
- **盖章口令**：`npm run dev`
- **巡视 Check**：确认学员控制台显示 `working tree clean`。

### Task 1: 唤醒 Skill 并落盘实施计划状态机
- **教师示范**：下发 `/incremental-implementation`，展示预览计划并下发 `同意保存实施计划`。
- **盖章口令**：`同意保存实施计划`
- **巡视 Check**：工程自动生成 `LESSON_04_IMPLEMENTATION_PLAN.md`。

### Task 2: 人在回路授权执行 Step 1 切片编码与解耦
- **教师示范**：强调“绝不许可 AI 自行修改代码”，下发自然口令 `确认完成 Step 1`。点击切换 `prototypeState` 4 种状态。
- **盖章口令**：`确认完成 Step 1`（或 `授权执行 Step 1`）
- **巡视 Check**：学员能在浏览器上成功点击切换 Loading/Empty/Error/Success。

### Task 3: 异常故障演练与双 Commit 物理归档
- **教师示范**：模拟切片报错，下发 `同意记录 Step 1 问题` 导出 `.patch` 补丁并恢复 Clean；成功则双 Commit 归档。
- **盖章口令**：`同意记录 Step 1 问题`
- **差异化辅导**：慢学员提供初始模板；快学员引导尝试添加第 5 种自定义界面状态（如 `Offline`）。

---

## 六、 现场 Debug 预案与自动化校验

### 6.1 常见错误现场 Troubleshooting
- **现象 1**：提示 `CONTRACT_ASSET_MISMATCH` ➔ **预案**：回退第三课，核对 `BUSINESS_FEATURE_CARD.md`。
- **现象 2**：Working Tree 一直是 Dirty ➔ **预案**：下发 `同意记录 Step 1 问题`，导出补丁后还原 Clean。

### 6.2 自动化校验与证据提取
- **校验命令**：
  ```powershell
  powershell -ExecutionPolicy Bypass -File scripts/verify-project.ps1
  ```
- **预期证据**：显示 `Verification completed successfully.`。

---

## 七、 退场测试与课后拓展作业

### 7.1 课堂退场测试卡 (Exit Ticket)
精选 5 道考查 Working Tree 干净度、状态机枚举、IT 沟通场景与补丁还原演练的题目。

### 7.2 课后练习与巩固作业
练习完整的受控切片与双 Commit 归档全过程。

---

## 八、 教师备课质量自测 Checklist

- [ ] 100% 匹配 **8 大执教模块** 标题，包含 5 个固定 Pause Points。
- [ ] 包含了【四步解析卡】与 HITL 授权盖章口令。
- [ ] 包含了按 Task 深度聚合的示范、口令与巡视指导。
- [ ] 包含了 PowerShell 脚本自测通过逻辑。
