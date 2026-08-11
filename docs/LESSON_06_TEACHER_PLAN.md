# 第六课教师备课与控场指南 — 学会定位和修复问题：五层诊断卡、diagnosing-bugs Skill 与有界排错 Loop

> [!IMPORTANT]
> 本教案为 **8 大执教模块精简标准版**，按讲师执教动线深度整合，严格对齐 `COURSE_ROADMAP.md`、Matt Pocock `diagnosing-bugs` 技能规范与预置故障沙箱。已完成五层诊断卡口语化降解与控制台解焦虑增强。

---

## 一、 课程元数据与定位

### 1.1 课程元数据
- **课程名称**：AI 业务原型开发训练营·第六课
- **主讲主题**：学会定位和修复问题：五层诊断卡、diagnosing-bugs Skill 与有界排错 Loop
- **授课对象**：非技术背景业务主管 / 产品经理 / 业务专家 (10–30人)
- **课时时长**：90 分钟 (极客控场 + 5 个固定 Pause Points)
- **授课模式**：18 分钟极客示范 ➔ 10 分钟概念核对 ➔ 45 分钟学员分步实操 ➔ 10 分钟验证归档
- **前置依赖**：学员已完成第五课并掌握 `CLAUDE.md` 工程护栏与三分记忆模型。
- **教学验证状态**：PILOT_READY (包含故障预置包、诊断报告落盘与口语化降解 / 待试讲)
- **课程负责人**：训练营教研组

### 1.2 本课定位与背景痛点
- **在全套课程中的位置**：承接第五课《工程 Harness 护栏与记忆机制》，进入“三、防崩与排错”阶段的关键闭环课。
- **解决的核心痛点**：遇到 Bug 或界面异常时，学员容易陷入“凭感觉瞎猜”、“让 AI 盲改代码”导致死循环，或者直接粘贴带密钥的报错造成数据外泄，亦或被 Console 控制台密密麻麻的红字吓住。
- **核心突破口**：
  1. 引入预置故障包 `course-fixtures/lesson-06-buggy-fixture/`，开箱即开排。
  2. 引入排错前无痛存档 `git commit -m "checkpoint: before lesson 6 debug"`，消除熔断回滚的抹杀恐惧。
  3. 引入五层诊断卡口语化降解（如“名字写错配不上”、“数据变了界面没动”），消除控制台恐惧感。
  4. 引入《Bug 诊断与熔断报告》`docs/LESSON_06_DEBUG_REPORT.md` 物理落盘，建立可审计排错证据链。

---

## 二、 逆向目标与四步概念卡

### 2.1 Bloom ABCD 学习目标
完成本课后，学员将能够：
1. **[Objective 1 - Apply (3)]**：在面对预置故障包 `course-fixtures/lesson-06-buggy-fixture/` 的渲染异常场景下 (**C**)，学员 (**A**) 能先下发无痛存档指令并唤醒 `diagnosing-bugs` Skill 构建物理可测的 PASS/FAIL 反馈闭环 (**B**)，确保 100% 拒绝无断言盲改 (**D**)。
2. **[Objective 2 - Analyze (4)]**：在分析复杂报错或日志时 (**C**)，学员 (**A**) 能使用五层诊断卡口语化模型 (**B**)，精准定位 Bug 所在层级并物理落盘写入 `docs/LESSON_06_DEBUG_REPORT.md` (**D**)。
3. **[Objective 3 - Evaluate (5)]**：当 Agent 自动排错达到 2 轮上限仍未 PASS 时 (**C**)，学员 (**A**) 能触发“2 轮硬熔断规则” (**B**)，一键执行 `git restore .` 安全回滚至 Checkpoint 状态并打上 `.patch` 补丁提交主管裁决 (**D**)。

### 2.2 核心概念四步解析卡集

#### 💡 概念卡 1：Five-Layer Diagnostic Map (五层诊断卡 / 口语化物理排错分层)
1. **硬核工程定义**：将 Web 应用排错物理拆解为环境、数据源、组件状态、日志与契约断言五层排查的诊断拓扑。
2. **底层运作机制**：五层口语化降解映射：
   - **Layer 1 环境层** ➔ `[物理服务] 网页跑不起来`
   - **Layer 2 数据源层** ➔ `[种子数据] 没数据或拿到了 null 空值`
   - **Layer 3 状态层** ➔ `[组件状态] 数据变了，但界面没跟着动`
   - **Layer 4 日志层** ➔ `[报错日志] 控制台第一行红字报错`
   - **Layer 5 契约层** ➔ `[契约断言] 名字写错了，界面配不上契约`
3. **具象业务比喻**：**汽车故障五级诊断仪** 🚗。从轮胎电压（环境）、汽油品质（数据）、仪表盘显示（状态）、故障码（日志）到行驶安全标准（契约）逐级检查。
4. **IT 沟通场景**：“我们通过五层诊断卡定位到了数据源层与组件状态层的绑定断裂，并非底层框架故障。”

#### 💡 概念卡 2：Fact-Anchored Feedback Loop & Debug Report (事实锚定与诊断报告落盘)
1. **硬核工程定义**：在修改任何代码前，必须先建立确切可重复执行的 PASS/FAIL 物理验证信号，并将诊断结论落盘写入 `LESSON_06_DEBUG_REPORT.md` 的排错范式。
2. **底层运作机制**：基于 `diagnosing-bugs` Skill，先捕获 Console 真实 Log 并脱敏敏感信息 (`<REDACTED>`)，写好断言脚本与诊断报告落盘后再下发修补指令。
3. **具象业务比喻**：**医生开处方前的验血报告与病例归档** 🩺。没拿到验血与 CT 视觉证据并填写病例表前，绝不盲目开药开刀。
4. **IT 沟通场景**：“我们在修改前先建立了自动化反馈闭环，并将五层诊断结论落盘生成了 DEBUG_REPORT 审计报告。”

#### 💡 概念卡 3：Bounded Debugging Loop & Checkpoint Breaker (无痛存档与 2 轮硬熔断)
1. **硬核工程定义**：在排错前先下发 Checkpoint 存档，限定 Agent 排错仅在 `prototype-contract.d.ts` 契约层，且设置最多 2 轮修补上限、失败安全回滚至 Checkpoint 状态的物理门禁。
2. **底层运作机制**：**存档与熔断一句话口诀**：`“进战场前存 Save Point (Checkpoint Commit)，打不过时只清扫本场坏试错 (git restore)，历史装备毫发无损。”`
3. **具象业务比喻**：**单机游戏 Boss 战前的 Save Point 与跳闸保鲜开关** 🎮⚡。进战场前先存个档，哪怕战斗失败也只损失本场尝试，历史通关进度稳如泰山。
4. **IT 沟通场景**：“项目设置了排错前 Checkpoint 存档与 2 轮硬熔断机制，一旦超过 2 轮自修未 PASS 即安全回滚至 Checkpoint，避免代码越改越崩。”

---

## 三、 教学准备与沙箱隔离

- **故障预置包准备**：确认 `course-fixtures/lesson-06-buggy-fixture/` 存在。
- **环境检查命令**：
  ```powershell
  git status
  powershell -ExecutionPolicy Bypass -File scripts/verify-project.ps1
  ```
- **示范区与实验区**：讲师示范窗口使用 `course-fixtures/lesson-06-buggy-fixture/` 演示，学员窗口独立隔离。

---

## 四、 90分钟控场主线与 Pause Points

| 时间段 | 环节 | WHERETO | 教师动作与 Pause Points 提问 | 学员动作 |
| :--- | :--- | :--- | :--- | :--- |
| 00-08 分 | 成果展示 | **W** | 展示野生盲猜排错越改越崩 vs diagnosing-bugs 无痛存档与有界熔断秒级恢复。<br>**Pause Point 1**：“为什么在排错前必须先执行 `git commit -m 'checkpoint: ...'` 无痛存档？” | 观看对齐交付物 |
| 08-25 分 | 极客示范 | **H & E** | 示范故障包装载、排错存档、口语化五层定位（如“数据变了界面没动”）、报告落盘与控制台解焦虑。<br>**Pause Point 2**：“看到控制台满屏红字时，非技术主管最关键的操作是什么？”<br>**Pause Point 3**：“`LESSON_06_DEBUG_REPORT.md` 落盘有什么物理工程价值？” | 记录关键指令 |
| 25-35 分 | 概念核对 | **R** | 提问核对五层诊断卡口语标签、诊断报告落盘与 Checkpoint 无痛熔断。<br>**Pause Point 4**：“如果 AI 排错尝试了 2 轮依然报错，`git restore .` 会抹杀之前的合法代码吗？为什么？” | 口头回答卡片 |
| 35-80 分 | 学员实操 | **E & T** | 巡视指导，监控学员装载故障包、生成 `LESSON_06_DEBUG_REPORT.md` 并演练安全回滚。<br>**Pause Point 5**：“如何验证你的修复方案是真的消除了 Bug，而不是掩盖了症状？” | 分 Task 独立实操 |
| 80-90 分 | 总结验证 | **O** | 运行 `verify-project.ps1` 全量校验。 | 填退场卡，提交日志 |

---

## 五、 逐 Task 极客示范与巡视指导

### Task 1: 装载故障包、排错前无痛存档并建立 PASS/FAIL 反馈闭环
- **教师示范**：
  1. 引入 `course-fixtures/lesson-06-buggy-fixture/` 组件。
  2. 下发排错前无痛存档指令：`git commit -m "checkpoint: before lesson 6 debug"`。
  3. 唤醒 `diagnosing-bugs` Skill，建立 PASS/FAIL 反馈闭环。
- **盖章口令**：`执行排错前 Checkpoint 存档，并唤醒 diagnosing-bugs 建立验证闭环`
- **巡视 Check**：确认学员先执行了 Checkpoint 存档，且未直接下发盲改代码指令。

### Task 2: 口语化五层诊断排查与控制台解焦虑
- **教师示范**：
  1. 强调**控制台解焦虑口诀**：*“只看第一行 Error Message，长堆栈留给 AI 看。”*
  2. 使用口语标签定位： Layer 3 (`数据变了界面没动`) 与 Layer 5 (`名字写错配不上`)。
  3. 将敏感 Key 替换为 `<REDACTED>`，要求 AI 自动落盘 `docs/LESSON_06_DEBUG_REPORT.md`。
- **盖章口令**：`按五层诊断卡口语标签定位 Bug，脱敏日志并落盘 DEBUG_REPORT`
- **巡视 Check**：工程根目录下成功生成 `docs/LESSON_06_DEBUG_REPORT.md` 且包含 5 层诊断结论。

### Task 3: 契约修补与 2 轮硬熔断演练
- **教师示范**：下发针对契约层的最小化修补。示范若故意修失败 2 轮，AI 自动触发 `git restore .` 安全恢复至 Checkpoint 状态，打上 `step-6-blocked.patch` 呈报主管。
- **盖章口令**：`同意执行契约层最小化修补` / `触发 2 轮硬熔断，安全恢复 Checkpoint 状态`
- **巡视 Check**：学员能在修补成功后得到 `[PASS]`；若熔断， Working Tree 能安全恢复至 Checkpoint 状态。

---

## 六、 现场 Debug 预案与自动化校验

### 6.1 常见错误现场 Troubleshooting
- **现象 1**：学员看到 DevTools 控制台密密麻麻的红字产生焦虑恐慌 ➔ **预案**：安抚学员，重复解焦虑提示：“只需复制第一行 Error Message，后面的长堆栈是给 AI 读的”。
- **现象 2**：AI 连续排错 3 轮还在盲目尝试 ➔ **预案**：下发硬命令 `git restore .` 强制恢复 Checkpoint，并要求重新读取 `CLAUDE.md` 熔断规则。

### 6.2 自动化校验与证据提取
- **校验命令**：
  ```powershell
  powershell -ExecutionPolicy Bypass -File scripts/verify-project.ps1
  ```
- **预期证据**：显示 `[PASS] Required files are present and Teacher Plans match 8-module structure.`。

---

## 七、 退场测试与课后拓展作业

### 7.1 课堂退场测试卡 (Exit Ticket)
精选 4 道考查 Checkpoint 无痛存档、`diagnosing-bugs` 闭环、五层口语标签与 2 轮硬熔断机制的题目。

### 7.2 课后练习与巩固作业
指导学员在 `course-fixtures/lesson-06-buggy-fixture/` 中尝试解决场景 B 与场景 C 的故障，并更新 `LESSON_06_DEBUG_REPORT.md`。

---

## 八、 教师备课质量自测 Checklist

- [ ] 100% 匹配 **8 大执教模块** 标题，包含 5 个固定 Pause Points。
- [ ] 包含了 Checkpoint 无痛存档、控制台解焦虑提示与 `LESSON_06_DEBUG_REPORT.md` 落盘规范。
- [ ] 包含了五层诊断卡口语化降解标签。
- [ ] 包含了按 Task 深度聚合的示范、口令与巡视指导。
- [ ] 包含了 PowerShell 脚本自测通过逻辑与故障预置包说明。
