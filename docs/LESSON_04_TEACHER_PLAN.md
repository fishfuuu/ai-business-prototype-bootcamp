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
- 本课学员 Skill 名称 | /incremental-implementation
- **前置依赖**：学员已完成第三课并落盘 3 份业务与数据契约 (包含 src/mocks/prototype-data.ts)。
- **教学验证状态**：草稿V2 / 待合入
- **课程负责人**：待指定

### 1.2 本课定位与背景痛点
- **在全套课程中的位置**：承接第三课《需求契约与数据冻结》，从需求澄清走向真正的受控代码增量实施。
- **解决的核心痛点**：巨石一口气盲开代码导致修改崩溃白屏、工作区 Dirty 混淆、技术呈现状态与业务流程状态缠绕、版本回滚破坏管理进度。
- **核心突破口**：唤醒 `/incremental-implementation` 实施计划落盘，引入 `prototypeState` 调试器解耦技术与业务状态，使用“买房交房 vs 房管局过户确权”的双 Commit 比喻降维双提交概念，在 Working Tree Clean 防护下完成薄切片增量交付。

---

## 二、 逆向目标与四步概念卡

### 2.1 Bloom ABCD 学习目标 (100% 原始权威对齐)
完成本课后，学员将能够：
1. **[Objective 1 - Apply (3)]**：在 CLI 环境下 (**C**)，学员 (**A**) 能唤醒 `/incremental-implementation` 增量实施 Skill (**B**)，将大需求拆解为 3–5 个受控薄切片计划 (**D**)。
2. **[Objective 2 - Analyze (4)]**：在组件开发中 (**C**)，学员 (**A**) 能植入 `prototypeState` 调试器 (**B**)，实现界面技术呈现状态与业务流程状态的物理解耦 (**D**)。
3. **[Objective 3 - Evaluate (5)]**：在切片代码落盘前 (**C**)，学员 (**A**) 能理解双 Commit 归档原理 (**B**)，完成源码交房与状态确权登记的双提交，恢复 Working Tree Clean 状态 (**D**)。

### 2.2 核心概念四步解析卡集

#### 💡 概念卡 1：Working Tree (工作区 / 工作树)
1. **硬核工程定义**：当前物理磁盘上记录代码修改与暂存的工作镜像。
2. **底层运作机制**：修改标记为 `Dirty`，执行 `git commit` 或 `restore` 恢复 `Clean`。
3. **具象业务比喻**：**厨师切菜的砧板** 🔪。
4. **IT 沟通场景**：“提交前确保 Working Tree 处于 Clean 干净状态。”

#### 💡 概念卡 2：增量实施与薄切片范式 (Incremental Thin Slices)
1. **硬核工程定义**：将大块需求拆解为独立可编译最小切片的软件工程范式。
2. **底层运作机制**：通过 `IMPLEMENTATION_PLAN.md` 驱动步骤按 PENDING➔READY➔COMPLETED 流转。
3. **具象业务比喻**：**预制件搭积木** 🧩。
4. **IT 沟通场景**：“我们采用薄切片范式开发，每次只授权落盘 1 个可验证切片。”

#### 💡 概念卡 3：技术呈现状态与业务流程状态解耦 (prototypeState Decoupling)
1. **硬核工程定义**：将界面技术容错 (Loading/Empty/Error/Success) 与业务生命周期状态物理隔离。
2. **底层运作机制**：组件内植入 `prototypeState` 开发期变量与可视化调试按钮。
3. **具象业务比喻**：**新车风洞测试** 🚗。
4. **IT 沟通场景**：“前端引入了 `prototypeState` 调试器，实现了界面技术状态与业务状态的解耦。”

#### 💡 概念卡 4：双 Commit 物理归档与房产过户双节点比喻 (Dual-Commit Archiving)
1. **硬核工程定义**：通过选择性暂存 (`git add --`) 将源码变动与计划状态更新物理隔离为两次 Git 提交。
2. **底层运作机制**：Commit A 暂存 `src/` 代码；Commit B 暂存 `IMPLEMENTATION_PLAN.md` 状态变动。
3. **具象业务比喻**：**买房入住与去房管局过户登记 (House Purchase & Deed Transfer)** 🏠：
   - **Commit A (源码落盘)** 相当于 **【拿到钥匙入住新房 (交房)】**；
   - **Commit B (状态更新)** 相当于 **【去房管局做过户登记 (落盘确权)】**。只有验房无误 (Commit A PASS)，才去房管局盖章落盘确权 (Commit B)。
4. **IT 沟通场景**：“项目采用双 Commit 隔离提交，源码资产与管理进度解耦。”

---

## 三、 教学准备与沙箱隔离

- **代码仓库准备**：检查第三课产出的 `docs/BUSINESS_FEATURE_CARD.md` 与 `src/types/prototype-contract.d.ts`。
- **环境检查命令**：
  ```powershell
  git status
  ```
- **示范区与实验区**：讲师示范窗口与学员环境完全隔离。

---

## 四、 90分钟控场主线与 Pause Points

| 时间段 | 环节 | WHERETO | 教师动作与 Pause Points 提问 | 学员动作 |
| :--- | :--- | :--- | :--- | :--- |
| 00-08 分 | 成果展示 | **W** | 展示巨石一口气盲开崩溃 vs 薄切片受控流转。<br>**Pause Point 1**：“为什么一口气改 10 个文件极易导致项目失控？” | 观看对齐交付物 |
| 08-25 分 | 极客示范 | **H & E** | 示范 Task 1➔3，展示 `/incremental-implementation`、`prototypeState` 调试器与双 Commit 房产比喻。<br>**Pause Point 2**：“页面技术状态和业务状态为什么要解耦？”<br>**Pause Point 3**：“买房交房 vs 房管局确权比喻中，两次 Commit 分别提交什么？” | 记录关键口令 |
| 25-35 分 | 概念核对 | **R** | 提问核对 Working Tree Clean、薄切片与双 Commit 卡片。<br>**Pause Point 4**：“为什么要确保 Working Tree 100% Clean 才能开工？” | 口头回答卡片 |
| 35-80 分 | 学员实操 | **E & T** | 巡视指导，监控薄切片计划下发与界面调试器体验。<br>**Pause Point 5**：“如何验证切片提交后工作区已恢复 Clean？” | 分 Task 独立实操 |
| 80-90 分 | 总结验证 | **O** | 运行 `verify-project.ps1` 校验。 | 填退场卡，提交日志 |

---

## 五、 逐 Task 极客示范与巡视指导

### Task 1: 唤醒增量实施 Skill 并落盘实施计划
- **教师示范**：下发 `/incremental-implementation` 指令，展示 3 步薄切片计划，下发 `同意保存实施计划`。
- **盖章口令**：`同意保存实施计划`
- **巡视 Check**：确认学员工程成功落盘 `docs/LESSON_04_IMPLEMENTATION_PLAN.md`。

### Task 2: 授权执行 Step 1 薄切片编码
- **教师示范**：下发 `确认完成 Step 1`，展示页面 `prototypeState` 调试按钮切换 Loading / Empty / Error / Success 四形态。
- **盖章口令**：`确认完成 Step 1`
- **巡视 Check**：确认学员浏览器可点击调试按钮并实时响应技术状态。

### Task 3: 三层验收与双 Commit 物理归档
- **教师示范**：使用房产过户比喻讲解，演示先提交 Commit A (源码交房)，再提交 Commit B (状态确权)。
- **盖章口令**：`git commit -m "feat(code): ..."` 与 `git commit -m "docs(plan): ..."`
- **巡视 Check**：`git status` 输出 `working tree clean`。

---

## 六、 现场 Debug 预案与自动化校验

### 6.1 常见错误现场 Troubleshooting
- **现象 1**：提示契约不一致 ➔ **预案**：核对第三课落盘的 `BUSINESS_FEATURE_CARD.md`。
- **现象 2**：切片报错工作区 Dirty ➔ **预案**：下发 `同意记录 Step 1 问题`，导出 `.patch` 并恢复 Clean。

### 6.2 自动化校验与证据提取
- **校验命令**：
  ```powershell
  powershell -ExecutionPolicy Bypass -File scripts/verify-project.ps1
  ```

---

## 七、 退场测试与课后拓展作业

### 7.1 课堂退场测试卡 (Exit Ticket)
包含 5 道考查 Working Tree Clean、薄切片、`prototypeState` 解耦与房产过户双 Commit 比喻的题目。

### 7.2 课后练习与巩固作业
尝试为 Step 2 切片编写调试器状态。

---

## 八、 教师备课质量自测 Checklist

- [ ] 100% 匹配 **8 大执教模块** 标题，包含 5 个固定 Pause Points。
- [ ] 包含了 Working Tree、薄切片、调试器解耦与房产过户双 Commit 4 大核心概念卡。
- [ ] 包含了【四步解析卡】与手写授权口令及降维比喻。
- [ ] 包含了 PowerShell 脚本自测通过逻辑。
