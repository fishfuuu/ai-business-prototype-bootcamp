# 第七课教师备课与控场指南 — 让 Agent 实际操作页面完成验收：QA Subagent、双 MCP 与四类证据链

> [!IMPORTANT]
> 本教案为 **8 大执教模块精简标准版**，按讲师执教动线深度整合，严格对齐 `COURSE_ROADMAP.md`、QA Subagent (`.claude/agents/qa-tester.md`)、Playwright MCP 与 Chrome DevTools MCP 证据链落盘规范。

---

## 一、 课程元数据与定位

### 1.1 课程元数据
- **课程名称**：AI 业务原型开发训练营·第七课
- **主讲主题**：让 Agent 实际操作页面完成验收：QA Subagent、双 MCP 与四类证据链
- **授课对象**：非技术背景业务主管 / 产品经理 / 业务专家 (10–30人)
- **课时时长**：90 分钟 (极客控场 + 5 个固定 Pause Points)
- **授课模式**：18 分钟极客示范 ➔ 10 分钟概念核对 ➔ 45 分钟学员分步实操 ➔ 10 分钟验证归档
- **前置依赖**：学员已完成第六课并掌握五层诊断卡与 `diagnosing-bugs` 闭环。
- **教学验证状态**：PILOT_READY (包含 QA Subagent、双 MCP 演示、视窗慢动作与证据总卡 Frontmatter 落盘 / 待试讲)
- **课程负责人**：训练营教研组

### 1.2 本课定位与背景痛点
- **在全套课程中的位置**：进入“四、双 Agent 验收”阶段的首课，为第八课《Codex 独立审查上下文隔离》提供经过 QA Subagent 与双 MCP 验证的 Candidate Commit 及带 Frontmatter 的结构化《四类证据链验收总卡》。
- **解决的核心痛点**：传统原型验收依赖“主管口头问、Agent 口头答”，或者只看静态截图，无法验证真实的动态交互、控制台 0 报错与工程文件修改边界。
- **最小化突破口**：
  1. 调度 **QA Subagent (`.claude/agents/qa-tester.md`)** 在只读沙箱中测试，完结自动销毁，不污染主 Context。
  2. 挂载 **Playwright MCP**（负责 DOM 交互与截图）与 **Chrome DevTools MCP**（截断最后 50 条 Log，负责 0 报错与 127.0.0.1 审计）。
  3. 提供 **Task 1 慢动作视窗 (Headed SlowMo)** 建立直观信任感，**Task 2 静默抓取 (Headless)** 批量落盘四类证据与带 YAML Frontmatter 的 `docs/LESSON_07_EVIDENCE_INDEX.md`。

---

## 二、 逆向目标与四步概念卡

### 2.1 Bloom ABCD 学习目标
完成本课后，学员将能够：
1. **[Objective 1 - Apply (3)]**：在给定的原型功能切片目录下 (**C**)，学员 (**A**) 能唤醒 QA Subagent (`.claude/agents/qa-tester.md`) 并挂载 Playwright MCP 与 Chrome DevTools MCP (**B**)，在 Headed 慢动作视窗中直观观看 Agent 自动点击演示 (**D**)。
2. **[Objective 2 - Analyze (4)]**：在 Headless 自动化测试完成后 (**C**)，学员 (**A**) 能物理落盘提取“视觉照片、行为脚印、工程体检、范围存根”四类文件及带 YAML Frontmatter 的 `docs/LESSON_07_EVIDENCE_INDEX.md` 总卡 (**B**)，构建 100% 可审计的证据链 (**D**)。
3. **[Objective 3 - Evaluate (5)]**：在向 IT 部门交接及第 8 课双 Agent 审查前 (**C**)，学员 (**A**) 能基于落盘的四类证据总卡进行业务审查与人在回路 (HITL) 签署盖章 (**B**)，销毁 QA 测试沙箱 (**D**)。

### 2.2 核心概念四步解析卡集

#### 💡 概念卡 1：QA Subagent & Dual MCP Tooling (QA 子智能体与双 MCP 工具链)
1. **硬核工程定义**：受主 Agent 调度的只读沙箱子进程，协同 Playwright MCP（UI 操作）与 Chrome DevTools MCP（Console/Network 审计）执行端到端质量验收。
2. **底层运作机制**：QA Subagent 独立运行在只读沙箱中，使用 Playwright 驱动 DOM 交互，使用 Chrome DevTools 抓取控制台第一行 Error Message 与 127.0.0.1 网络请求，完结后自动销毁沙箱。
3. **具象业务比喻**：**带专业仪器进场的外聘第三方 QA 审计员** 🕵️‍♂️。配备全套检测设备（双 MCP），入场检测并落盘报告后自动退场，不占用日常办公桌。
4. **IT 沟通场景**：“我们调度了 QA Subagent 挂载 Playwright 与 DevTools 双 MCP 进行了端到端自动化质量审计。”

#### 💡 概念卡 2：Four-Category Evidence Chain & Summary Index (四类证据链与带 Frontmatter 的验收总卡)
1. **硬核工程定义**：由视觉截图 (`screenshot.png`)、行为日志 (`action.log`)、工程类型 (`typecheck.log`)、范围补丁 (`diff.patch`) 及带 4 行 YAML Frontmatter 汇总索引 (`LESSON_07_EVIDENCE_INDEX.md`) 构成的全方位客观审计证据集合。
2. **底层运作机制**：四类证据物理降解映射：
   - **视觉证据** ➔ `[照片证据]` `docs/assets/lesson-07/screenshot.png` (渲染对比图)
   - **行为证据** ➔ `[脚印日志]` `docs/assets/lesson-07/action.log` (DevTools 截断最后 50 条 0 报错与网络白名单)
   - **工程证据** ➔ `[体检报告]` `docs/assets/lesson-07/typecheck.log` (verify 脚本 PASS)
   - **范围证据** ➔ `[存根 diff]` `docs/assets/lesson-07/diff.patch` (git 范围无超界)
3. **具象业务比喻**：**法庭举证的物证、足迹、体检报告与合同存根** ⚖️。四证合一，加上带 Header 的书面总卡，绝不凭口头主观凭空猜测。
4. **IT 沟通场景**：“我们落盘输出了包含四类证据链与带 Frontmatter 的 EVIDENCE_INDEX 验收总卡交付包，供 IT 部门与 Codex 100% 解析。”

#### 💡 概念卡 3：Headed SlowMo vs. Headless Sandbox Lifecycle (视窗慢动作与无头沙箱周期)
1. **硬核工程定义**：支持前端交互可视化慢动作展示 (`headed: true`) 与后台高效静默落盘 (`headless: true`)，并在任务完结后自动销毁子进程的资源管理范式。
2. **底层运作机制**：Task 1 开启 Headed 慢动作供人眼观察；Task 2 开启 Headless 批量抓取证据；测试结束自动 Kill Subagent 进程，主 Agent 仅接收单行 PASS 汇报与文件索引。
3. **具象业务比喻**：**无人驾驶车观摩演练 ➔ 封闭赛道高速全自动测试** 🏎️。先让人进车里看自动驾驶示范建立信任，然后再关上车门全自动跑性能抓数据。
4. **IT 沟通场景**：“测试过程在只读沙箱中完成，测试完即刻销毁，保证主开发环境 Context 干净隔离。”

---

## 三、 教学准备与沙箱隔离

- **角色与 Skill 准备**：确认 `.claude/agents/qa-tester.md` 与 `.claude/skills/evidence-verification/SKILL.md` 存在。
- **环境检查命令**：
  ```powershell
  git status
  powershell -ExecutionPolicy Bypass -File scripts/verify-project.ps1
  ```
- **示范区与实验区**：讲师示范窗口使用 Lesson 4 切片，学员窗口独立隔离。

---

## 四、 90分钟控场主线与 Pause Points

| 时间段 | 环节 | WHERETO | 教师动作与 Pause Points 提问 | 学员动作 |
| :--- | :--- | :--- | :--- | :--- |
| 00-08 分 | 成果展示 | **W** | 展示嘴巴口头验收 vs QA Subagent 双 MCP 慢动作演示与四类证据链落盘。<br>**Pause Point 1**：“为什么测试需要兼顾‘肉眼慢动作观察’与‘后台静默落盘’？” | 观看对齐交付物 |
| 08-25 分 | 极客示范 | **H & E** | 示范唤醒 QA Subagent、演示 Headed 慢动作自动点击、生成 DevTools 日志与落盘带 Frontmatter 的 EVIDENCE_INDEX。<br>**Pause Point 2**：“Chrome DevTools MCP 在行为证据中起到了什么不可替代的作用？”<br>**Pause Point 3**：“为什么测试 Subagent 完成任务后必须自动销毁沙箱？” | 记录关键指令 |
| 25-35 分 | 概念核对 | **R** | 提问核对 QA Subagent、双 MCP 工具分工、四类证据链与 EVIDENCE_INDEX。<br>**Pause Point 4**：“如果 `action.log` 中记录了非 127.0.0.1 的外部网络请求，是否能通过校验？” | 口头回答卡片 |
| 35-80 分 | 学员实操 | **E & T** | 巡视指导，监控学员调用 QA Subagent 演示慢动作并落盘 `LESSON_07_EVIDENCE_INDEX.md`。<br>**Pause Point 5**：“如何确认范围证据 `diff.patch` 中没有改到许可范围外的文件？” | 分 Task 独立实操 |
| 80-90 分 | 总结验证 | **O** | 运行 `verify-project.ps1` 全量校验。 | 填退场卡，提交日志 |

---

## 五、 逐 Task 极客示范与巡视指导

### Task 1: 唤醒 QA Subagent 并开启 Playwright 视窗慢动作演示
- **教师示范**：
  1. 唤醒 QA Subagent (`.claude/agents/qa-tester.md`)。
  2. 挂载 Playwright MCP，开启慢动作模式 (`headed: true, slowMo: 500`)。
  3. 自动检测 Vite 当前端口 (`5173`/`5174`)，提示“若未弹出窗口，请检查任务栏或防火墙拦截”。
- **盖章口令**：`唤醒 QA Subagent，开启 Headed 慢动作测试演示`
- **巡视 Check**：确认学员屏幕弹出了浏览器视窗并看到 Agent 自动点击过程。

### Task 2: 挂载 Chrome DevTools MCP 抓取日志并落盘四类证据与总卡
- **教师示范**：
  1. 切换为 Headless 静默模式。
  2. 挂载 Chrome DevTools MCP（截断最后 50 条日志），提取控制台 0 报错与 127.0.0.1 网络白名单日志。
  3. 物理落盘 `docs/assets/lesson-07/` 4 个证据文件及带有 Frontmatter 的 [`docs/LESSON_07_EVIDENCE_INDEX.md`](file:///d:/AILearning/docs/LESSON_07_EVIDENCE_INDEX.md)。
- **盖章口令**：`同意执行 Headless 双 MCP 测试，落盘四类证据与 EVIDENCE_INDEX`
- **巡视 Check**：工程根目录下成功生成带 Frontmatter 的 `docs/LESSON_07_EVIDENCE_INDEX.md`。

### Task 3: 证据链复核与人在回路 (HITL) 签署归档 (销毁沙箱)
- **教师示范**：打开落盘的 `LESSON_07_EVIDENCE_INDEX.md`，核对视觉、行为、工程与范围 4 项 PASS。若未 PASS，提示`回复“唤醒 diagnosing-bugs”即可无缝修复阻断点`。下发归档口令后销毁 QA Subagent 沙箱。
- **盖章口令**：`复核四类证据链无误，同意签署第 7 课验收盖章`
- **巡视 Check**：学员能在 `PROJECT_STATE.md` 中更新稳定 Commit SHA，测试 Subagent 沙箱自动销毁。

---

## 六、 现场 Debug 预案与自动化校验

### 6.1 常见错误现场 Troubleshooting
- **现象 1**：Playwright 提示浏览器二进制缺失 ➔ **预案**：提醒运行 PowerShell 环境预检，脚本会自动补全轻量 Chrome 驱动。
- **现象 2**：`action.log` 捕获到 DevTools Console 报错 ➔ **预案**：根据提示回复 `唤醒 diagnosing-bugs`，无缝转入第 6 课五层诊断卡修复。

### 6.2 自动化校验与证据提取
- **校验命令**：
  ```powershell
  powershell -ExecutionPolicy Bypass -File scripts/verify-project.ps1
  ```
- **预期证据**：显示 `[PASS] Required files are present and Teacher Plans match 8-module structure.`。

---

## 七、 退场测试与课后拓展作业

### 7.1 课堂退场测试卡 (Exit Ticket)
精选 4 道考查 QA Subagent 职责、双 MCP 分工、EVIDENCE_INDEX 落盘与沙箱销毁机制的题目。

### 7.2 课后练习与巩固作业
指导学员为其系统的另一个二级页面调度 QA Subagent 运行测试，并生成证据总卡。

---

## 八、 教师备课质量自测 Checklist

- [ ] 100% 匹配 **8 大执教模块** 标题，包含 5 个固定 Pause Points。
- [ ] 包含了 QA Subagent (`.claude/agents/qa-tester.md`) 与双 MCP 工具链说明。
- [ ] 包含了 Headed 慢动作与 Headless 静默落盘双模式规范。
- [ ] 包含了 `LESSON_07_EVIDENCE_INDEX.md` 物理落盘与 PowerShell 脚本自测逻辑。
