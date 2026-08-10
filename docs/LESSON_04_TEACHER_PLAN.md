# 第四课教师备课与控场指南 — 把大需求拆成连续的小成功：受控 Agent 循环与 Working Tree 物理状态机

> [!IMPORTANT]
> 本教案为 **正式采用版**，完整集成了 `teaching-lesson-plan`（逆向设计、建构性对齐、Bloom ABCD、WHERETO）与 `teacher-plan-architect`（22 章节物理硬约束、四步概念卡、HITL 授权盖章口令与 PowerShell 自动化校验）。

---

## 1. 课程元数据
- **课程名称**：AI 业务原型开发训练营·第四课
- **主讲主题**：把大需求拆成连续的小成功：受控 Agent 循环与 Working Tree 物理状态机
- **授课对象**：非技术背景业务主管 / 产品经理 / 业务专家 (10–30人)
- **课时时长**：90 分钟 (极客控场 + 5 个固定 Pause Points)
- **授课模式**：18 分钟极客示范 ➔ 10 分钟概念核对 ➔ 45 分钟学员分步实操 ➔ 10 分钟验证归档
- **前置依赖**：学员已完成第三课并拥有 [`docs/BUSINESS_FEATURE_CARD.md`](file:///d:/AILearning/docs/BUSINESS_FEATURE_CARD.md)、[`src/types/prototype-contract.d.ts`](file:///d:/AILearning/src/types/prototype-contract.d.ts) 与 [`src/mocks/prototype-data.ts`](file:///d:/AILearning/src/mocks/prototype-data.ts) 三份契约资产。
- **教学验证状态 (Teaching Status)**：PILOT_PENDING (草稿V2 / 待合入 / 待试讲)
- **课程负责人**：待指定

---

## 2. 本课定位
- **在全套课程中的位置**：承接第三课《需求澄清与契约冻结》，开启真正的受控代码增量构建。
- **解决的核心痛点**：非技术主管直接让 AI 写全套代码导致“一改就崩”、“代码黑盒失控”、“大失血式重头再来”。
- **核心突破口**：引入“薄切片 (Thin Slices)”与“ Working Tree 砧板模型”，让 Agent 必须先出计划，每次只授权完成 1 个可验证的切片，并自动通过双 Commit 进行物理归档。

---

## 3. 核心目标与 Bloom ABCD 能力矩阵

### 3.1 核心大观与本质提问 (Backward Design Stage 1)
- **核心大观 (Big Idea)**：真正的受控 AI 编程不是“一次性生成 500 行代码”，而是“一次只做一个切片，通过干净 Working Tree 与双 Commit 实现无损存档与回退”。
- **本质提问 (Essential Question)**：当 Agent 写出的代码报错或超出预期时，业务主管如何做到 1 秒钟无损还原，并保证未污染的代码安全归档？

### 3.2 Bloom ABCD 学习目标
完成本课后，学员将能够：
1. **[Objective 1 - Apply (3)]**：在给定的项目 Working Tree 环境下 (**C**)，学员 (**A**) 能使用自然指令 `同意保存实施计划` 与 `确认完成 Step 1` (**B**)，解锁第一个薄切片并成功写入工程 (**D**)。
2. **[Objective 2 - Analyze (4)]**：在面对 Agent 生成的代码切片时 (**C**)，学员 (**A**) 能通过 `prototypeState` 页面技术状态调试器 (**B**)，准确判断 Loading / Empty / Error / Success 四种界面状态与业务状态的解耦情况 (**D**)。
3. **[Objective 3 - Evaluate (5)]**：在代码切片报错或出现验收冲突时 (**C**)，学员 (**A**) 能下发口令 `同意记录 Step N 问题` (**B**)，触发快照补丁导出与 Working Tree 100% Clean 自动恢复 (**D**)。

### 3.3 建构性对齐审计表 (Constructive Alignment Audit)
| 学习目标 | Bloom's 认知层级 | 课堂教学活动 (WHERETO) | 考核手段与证据 | 对齐校验 |
| :--- | :--- | :--- | :--- | :--- |
| Objective 1: 计划落盘与授权执行 | Apply (3) | 教师演示 Task 1-2 & 学员独立操作 Task 2 | 检查 `LESSON_04_IMPLEMENTATION_PLAN.md` 状态机转为 READY | ✅ 100% 对齐 |
| Objective 2: 界面技术状态解耦 | Analyze (4) | 教师演示 Task 3 & 页面点击切换状态 | 点击页面切换 4 种 `prototypeState` | ✅ 100% 对齐 |
| Objective 3: 异常快照与干净还原 | Evaluate (5) | 学员故障演练 Task 4 | 检查 `local-backups/*.patch` 产物与 Clean 状态 | ✅ 100% 对齐 |

---

## 4. 必备教学资源与环境准备
- **代码仓库准备**：安装依赖并保证工程根目录下无未提交更改。
- **环境检查命令**：
  ```powershell
  git status
  npm run dev
  ```
  *预期输出*：`nothing to commit, working tree clean` 且 Vite 开发服务成功启动在 5173 端口。

---

## 5. 课堂 90 分钟控场时间分配表 (WHERETO 序列)

| 时间段 | 环节 | WHERETO | 教师动作 | 学员动作 | 关键暂停点 (Pause Point) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 00-08 分 | 成果展示 | **W** | 展示巨石盲开崩塌 vs 薄切片受控流转 | 观看并对齐本课交付物 | **Pause Point 1**：明确受控切片目标 |
| 08-25 分 | 极客示范 | **H & E** | 示范 Task 0➔3，展示状态机与双 Commit | 记录命令与盖章口令 | **Pause Point 2 & 3**：概念拆解与安全存档 |
| 25-35 分 | 概念核对 | **R** | 提问核对 Working Tree 与状态机 | 口头回答四步概念卡 | **Pause Point 4**：确认逻辑冻结线 |
| 35-80 分 | 学员实操 | **E & T** | 巡视指导，监控授权与 Git 状态 | 分 Task 独立实操 | **Pause Point 5**：人在回路盖章授权 |
| 80-90 分 | 总结验证 | **O** | 运行 `verify-project.ps1` 校验 | 填退场卡，提交日志 | 证据归档 |

---

## 6. 演示区与实验区隔离规则
- **教师示范区**：在讲台独立示范窗口执行，不影响学员的工作区。
- **学员实验区**：学员在各自的 VS Code 终端与 Claude Code CLI 中操作。

---

## 7. Task 0: 启动工程与 Working Tree 干净状态检查
- **教师示范**：运行 `git status`，讲解 Working Tree 的 Clean 与 Dirty 物理含义。
- **学员动作**：启动开发服务器 `npm run dev`，确认 Working Tree clean。

---

## 8. Task 1: 唤醒 Skill 并落盘实施计划状态机
- **教师示范**：在 CLI 中下发 `/incremental-implementation`，展示预览计划，并下发 `同意保存实施计划` 口令。
- **学员动作**：下发指令并验证 `LESSON_04_IMPLEMENTATION_PLAN.md` 生成。

---

## 9. Task 2: 人在回路授权执行 Step 1 切片编码
- **教师示范**：强调“绝不许可 AI 自行修改代码”，下发自然口令 `确认完成 Step 1`。
- **学员动作**：授权编码，观察受控修改 `src/components/WorkOrderBoard.vue`。

---

## 10. Task 3: 界面技术状态与业务状态的物理解耦
- **教师示范**：点击页面顶部的 `prototypeState` 调试按钮（Loading/Empty/Error/Success），演示与后端解耦的界面交互测试。
- **学员动作**：在浏览器上逐一点击验证 4 种技术呈现状态。

---

## 11. Task 4: 异常故障演练与无损 Working Tree 还原
- **教师示范**：模拟切片报错场景，下发口令 `同意记录 Step 1 问题`，展示自动导出的 `.patch` 补丁文件并验证 Working Tree 恢复 Clean。
- **学员动作**：演练熔断与快照恢复。

---

## 12. 人在回路 (HITL) 授权盖章口令集
- **计划保存口令**：`同意保存实施计划`
- **Step 授权口令**：`确认完成 Step 1`（或 `授权执行 Step 1`）
- **异常熔断口令**：`同意记录 Step 1 问题`

---

## 13. 核心概念四步解析卡集

### 💡 概念卡 1：Working Tree (工作区 / 工作树)
1. **硬核工程定义**：Git 版本控制系统中，物理磁盘上记录代码修改与暂存的工作镜像。
2. **底层运作机制**：代码修改标记为 `Dirty`，执行 `git commit` 或 `git restore` 后恢复 `100% Clean`。
3. **具象业务比喻**：**厨师切菜的砧板** 🔪。
4. **IT 沟通场景**：“请确保提交前 Working Tree 处于 Clean 干净状态。”

### 💡 概念卡 2：增量实施与薄切片范式 (Incremental Thin Slices)
1. **硬核工程定义**：将大块复杂需求拆解为独立可测试的最小粒度切片逐个构建的范式。
2. **底层运作机制**：通过 `IMPLEMENTATION_PLAN.md` 磁盘状态机驱动 Step 进度流转。
3. **具象业务比喻**：**预制件搭积木** 🧩。
4. **IT 沟通场景**：“我们采用薄切片范式开发，每次只授权落盘 1 个可验证的切片。”

### 💡 概念卡 3：界面技术呈现状态与业务处理流程状态解耦
1. **硬核工程定义**：将前端界面的技术容错与数据对象的业务生命周期状态物理隔离的设计。
2. **底层运作机制**：通过 `prototypeState` 开发期变量与可视化按钮，自由切换渲染形态。
3. **具象业务比喻**：**新车风洞测试** 🚗。
4. **IT 沟通场景**：“前端引入了 `prototypeState` 调试器，实现了技术状态与业务状态的解耦。”

---

## 14. 5 个固定 Pause Points 控场问答指南
- **Pause Point 1 (08分)**：问：“为什么不能让 AI 一口气生成全套 1000 行代码？” ➔ 答：“会导致 Working Tree 一片狼藉，中途报错无法回退。”
- **Pause Point 2 (18分)**：问：“开工前为什么要检查 `git status` 确认 clean？” ➔ 答：“确保砧板干净，避免脏代码混入开发主干。”
- **Pause Point 3 (25分)**：问：“`prototypeState` 调试按钮有什么用？” ➔ 答：“无后端接口时，全量测试 Loading/Empty/Error 界面容错。”
- **Pause Point 4 (35分)**：问：“双 Commit 机制为什么要提交两次？” ➔ 答：“Commit A 保护纯净代码，Commit B 记录项目管理进度。”
- **Pause Point 5 (80分)**：问：“当切片报错时如何无损还原？” ➔ 答：“导出 `.patch` 快照补丁后，冲洗 Working Tree 恢复 Clean。”

---

## 15. 学员实操分步巡视 Checklist
- [ ] 检查学员 `git status` 输出 `nothing to commit, working tree clean`。
- [ ] 检查学员工程生成了 `docs/LESSON_04_IMPLEMENTATION_PLAN.md`。
- [ ] 检查学员浏览器能成功点击切换 `prototypeState` 4 种状态。
- [ ] 检查学员提交后 Working Tree 重新恢复 Clean。

---

## 16. 差异化分层辅导策略
- **对进度偏慢的学员**：提供已写好初始状态的模板，指导输入授权口令。
- **对进度偏快的学员**：引导其尝试添加第 5 种自定义界面状态（如 `Offline` 断网模式）。

---

## 17. 自动化校验与证据提取 (`verify-project.ps1`)
- **执行校验命令**：
  ```powershell
  powershell -ExecutionPolicy Bypass -File scripts/verify-project.ps1
  ```
- **预期证据输出**：控制台最后显示 `======================================== Verification completed successfully. ========================================`。

---

## 18. 常见错误现场 Debug 预案 (Troubleshooting)
- **现象 1**：提示 `CONTRACT_ASSET_MISMATCH` ➔ **预案**：回退第三课，核对 `BUSINESS_FEATURE_CARD.md`。
- **现象 2**：Working Tree 一直是 Dirty ➔ **预案**：下发 `同意记录 Step 1 问题`，导出补丁后还原 Clean。

---

## 19. 课堂退场测试与评估 (Exit Ticket)
包含 5 道精准题目，考查 Working Tree 干净度、状态机枚举、IT 沟通场景与补丁还原演练。

---

## 20. 课后练习与巩固作业
指导学员在课后尝试向 AI 提出修改请求，练习完整受控切片与双 Commit 归档全过程。

---

## 21. 教师备课自测 Checklist (Self-Audit)
- [ ] 22 章节标题完整，包含 5 个 Pause Points。
- [ ] 包含了【四步解析卡】与 HITL 授权盖章口令。
- [ ] 包含了 PowerShell 脚本自测通过逻辑。

---

## 22. 版本演进与变更记录
- **V1 版**：初始教案。
- **V2/V3 采用版**：整合逆向设计、22 章节物理硬约束、V3 双模学员指南、4 步概念卡与自动化校验闭环。
