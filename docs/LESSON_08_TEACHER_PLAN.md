# 第八课教师备课与控场指南 — Codex 独立审查与上下文隔离：多 Agent 协作拓扑全景与交叉验证

> [!IMPORTANT]
> 本教案为 **8 大执教模块精简标准版**，按讲师执教动线深度整合，严格对齐 `COURSE_ROADMAP.md`、多 Agent 6 大协作拓扑范式、Codex Auditor (`.claude/agents/codex-auditor.md`) 与审计报告物理落盘规范。

---

## 一、 课程元数据与定位

### 1.1 课程元数据
- **课程名称**：AI 业务原型开发训练营·第八课
- **主讲主题**：Codex 独立审查与上下文隔离：多 Agent 协作拓扑全景与交叉验证
- **授课对象**：非技术背景业务主管 / 产品经理 / 业务专家 (10–30人)
- **课时时长**：90 分钟 (极客控场 + 5 个固定 Pause Points)
- **授课模式**：18 分钟极客示范 ➔ 10 分钟概念核对 ➔ 45 分钟学员分步实操 ➔ 10 分钟验证归档
- **前置依赖**：学员已完成第七课并掌握 QA Subagent、双 MCP 与四类证据链落盘。
- **教学验证状态**：PILOT_READY (包含 6 大多 Agent 拓扑全景串联、Codex 独立盲审示范与 AUDIT_REPORT 落盘 / 待试讲)
- **课程负责人**：训练营教研组

### 1.2 本课定位与背景痛点
- **在全套课程中的位置**：“四、双 Agent 验收”阶段的收官课，串联全套课程的多 Agent 演进脉络，为第五阶段《受控 AI 闭环与 IT 交接包》提供经过 Codex 独立只读盲审认证的稳定工程版本。
- **解决的核心痛点**：单个 AI“既当运动员又当裁判员”自卖自夸；上下文过长导致 AI 遗忘初始规约；缺乏多 Agent 协作架构全景导致学员无法选型应用。
- **核心突破口**：
  1. 串联 **多 Agent 6 大协作拓扑全景 (Multi-Agent Collaboration Topologies)**：主从拓扑、并行拓扑、管线拓扑、背靠背盲审拓扑、对等拓扑与人在回路仲裁拓扑。
  2. **上下文彻底隔离 (Context Isolation)**：Codex 开启独立只读进程，无开发历史记忆干扰，凭客观证据与 `git diff` 盲审。
  3. **落盘《Codex 独立审查报告》 (`docs/LESSON_08_AUDIT_REPORT.md`)**：输出带 Frontmatter 的判定结果，由业务主管 (CEO) 行使终局裁决。

---

## 二、 逆向目标与四步概念卡

### 2.1 Bloom ABCD 学习目标
完成本课后，学员将能够：
1. **[Objective 1 - Apply (3)]**：在 Candidate Commit 准备就绪后 (**C**)，学员 (**A**) 能理解并运用多 Agent 协作拓扑全景 (**B**)，唤醒 Codex Auditor (`.claude/agents/codex-auditor.md`) 开启物理隔离只读会话执行交叉盲审 (**D**)。
2. **[Objective 2 - Analyze (4)]**：在 Codex 盲审完成后 (**C**)，学员 (**A**) 能分析 6 种多 Agent 拓扑的控制权与 Token 开销差异 (**B**)，并物理落盘 `docs/LESSON_08_AUDIT_REPORT.md` (**D**)。
3. **[Objective 3 - Evaluate (5)]**：在向 IT 部门最终交接前 (**C**)，学员 (**A**) 能基于 Codex 审计结论行使人在回路 (HITL) 裁决盖章 (**B**)，决定批准合并或驳回修改 (**D**)。

### 2.2 核心概念四步解析卡集

#### 💡 概念卡 1：Multi-Agent Collaboration Topologies (多 Agent 协作拓扑全景与 6 种范式)
1. **硬核工程定义**：由多个专门化 AI Agent 按照特定控制流与信息传递结构组合而成的系统架构全景，包含 6 种公认拓扑范式。
2. **底层运作机制与 6 大拓扑物理降解**：
   - **拓扑 1 主从星型 (Orchestrator-Workers)**：主 Agent 调度只读沙箱。
   - **拓扑 2 并行扇出-扇入 (Parallel Fan-Out/Fan-In)**：多 Subagents 并发跑测试。
   - **拓扑 3 顺序管线 (Sequential Pipeline)**：需求 ➔ 开发 ➔ QA ➔ Codex 流水线。
   - **拓扑 4 背靠背盲审 (Debate / Auditor)**：开发 Agent vs Codex 独立只读盲审。
   - **拓扑 5 网状对等 (Peer-to-Peer Swarm)**：去中心化广播协商。
   - **拓扑 6 人在回路三角色仲裁 (HITL Arbitration)**：开发 + 审计 + 主管 CEO 终局裁决。
3. **具象业务比喻**：**现代企业多工位协作与部门组织架构图** 👔👷‍♂️🕵️‍♀️。包含项目经理、专业外包团队、流水线工人、第三方审计师与 CEO 董事会。
4. **IT 沟通场景**：“我们的 AI 架构根据场景选用了背靠背盲审与主从并行相结合的多 Agent 拓扑，兼顾了并行速度与安全隔离。”

#### 💡 概念卡 2：Context-Isolated Read-Only Auditor (上下文隔离只读审计者)
1. **硬核工程定义**：运行在独立会话中、绝不出手修改源码，仅读取证据索引与 Git Diff 进行盲审的只读 AI 角色。
2. **底层运作机制**：Codex 独立开启只读进程，无主 Agent 聊天历史记忆干预；仅解析 `LESSON_07_EVIDENCE_INDEX.md` 的 YAML Header 与 `git diff`，输出客观公正评级。
3. **具象业务比喻**：**背靠背独立打分的专业第三方审计会计师** ⚖️。不参与财务报表制作，只看凭证与账目物理存根，独立出具审计意见。
4. **IT 沟通场景**：“我们引入了上下文隔离的 Codex 只读审计 Agent，排除了单个 AI 自卖自夸的盲区。”

#### 💡 概念卡 3：Audit Report Persistence & HITL Arbitration (审计报告落盘与主管终局裁决)
1. **硬核工程定义**：将盲审判定结构化落盘写入 `docs/LESSON_08_AUDIT_REPORT.md`，由业务主管 (CEO) 最终下发 `git merge` 或 `git restore` 的裁决范式。
2. **底层运作机制**：Codex 输出包含 `audit_status: PASS/REJECT` 的 Frontmatter 报告；主管核对后下发签署口令，行使最终合并或驳回。
3. **具象业务比喻**：**董事会终局签字盖章** 🖋️。听取开发部门与审计部门的双向汇报后，CEO 亲自落笔批准合并。
4. **IT 沟通场景**：“最终 Candidate Commit 经过了 Codex 盲审报告落盘与主管 HITL 终局签署。”

---

## 三、 教学准备与沙箱隔离

- **角色与 Skill 准备**：确认 `.claude/agents/codex-auditor.md` 与 `.claude/skills/codex-audit/SKILL.md` 存在。
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
| 00-08 分 | 成果展示 | **W** | 展示单 AI 自卖自夸 vs 6 大多 Agent 协作拓扑全景与背靠背盲审。<br>**Pause Point 1**：“为什么单个 Agent 既当程序员又当测试员会导致质量隐患？” | 观看对齐交付物 |
| 08-25 分 | 极客示范 | **H & E** | 示范多 Agent 6 大拓扑全景、唤醒 Codex 盲审与落盘 AUDIT_REPORT。<br>**Pause Point 2**：“多 Agent 架构中的‘上下文隔离’解决了什么关键问题？”<br>**Pause Point 3**：“主从星型拓扑与背靠背盲审拓扑的核心区别是什么？” | 记录关键指令 |
| 25-35 分 | 概念核对 | **R** | 提问核对 6 大多 Agent 拓扑范式、上下文隔离审计者与 HITL 终局裁决。<br>**Pause Point 4**：“如果 Codex 在审计报告中标记了 REJECT，主管应当如何操作？” | 口头回答卡片 |
| 35-80 分 | 学员实操 | **E & T** | 巡视指导，监控学员体验拓扑切换并物理落盘 `LESSON_08_AUDIT_REPORT.md`。<br>**Pause Point 5**：“如何确认 Codex 审计过程中 Working Tree 保持干净？” | 分 Task 独立实操 |
| 80-90 分 | 总结验证 | **O** | 运行 `verify-project.ps1` 全量校验。 | 填退场卡，提交日志 |

---

## 五、 逐 Task 极客示范与巡视指导

### Task 1: 理解多 Agent 6 大协作拓扑全景并唤醒 Codex 盲审
- **教师示范**：
  1. 打开 `lessons/0008-*.html` 课件，展示 6 大多 Agent 拓扑全景与选型矩阵。
  2. 在 CLI 中唤醒 Codex Auditor (`.claude/agents/codex-auditor.md`)，开启物理隔离只读盲审会话。
- **盖章口令**：`唤醒 codex-audit 技能，开启独立只读盲审`
- **巡视 Check**：确认 Codex 在独立进程中运行，未要求修改任何源码。

### Task 2: 独立解析证据索引与 Git Diff，物理落盘《Codex 独立审查报告》
- **教师示范**：
  1. Codex 自动解析 `LESSON_07_EVIDENCE_INDEX.md` 的 YAML Frontmatter。
  2. 比对 `git diff` 确认修改文件 100% 限定在许可列表中。
  3. 物理落盘写入 [`docs/LESSON_08_AUDIT_REPORT.md`](file:///d:/AILearning/docs/LESSON_08_AUDIT_REPORT.md)。
- **盖章口令**：`同意执行 Codex 独立盲审，落盘 AUDIT_REPORT`
- **巡视 Check**：工程根目录下成功生成带 `audit_status: PASS` 的 `docs/LESSON_08_AUDIT_REPORT.md`。

### Task 3: 主管行使终局裁决 (HITL Arbitration) 与合并归档
- **教师示范**：打开落盘的 `docs/LESSON_08_AUDIT_REPORT.md`，核对 Codex 审计结论 `PASS`，下发合并裁决口令，标记第 8 课完成。
- **盖章口令**：`复核 Codex 审查报告无误，同意签署第 8 课终局裁决合并`
- **巡视 Check**：学员能在 `PROJECT_STATE.md` 中更新稳定 Commit SHA，多 Agent 交叉验证闭环归档。

---

## 六、 现场 Debug 预案与自动化校验

### 6.1 常见错误现场 Troubleshooting
- **现象 1**：Codex 提示 `EVIDENCE_INDEX.md` 不存在 ➔ **预案**：退回第 7 课运行 QA Subagent 重新落盘总卡。
- **现象 2**：Codex 在报告中标记 `REJECT` ➔ **预案**：指导学员查看 AUDIT_REPORT 中的风险清单，回复 `唤醒 diagnosing-bugs` 修复后重新盲审。

### 6.2 自动化校验与证据提取
- **校验命令**：
  ```powershell
  powershell -ExecutionPolicy Bypass -File scripts/verify-project.ps1
  ```
- **预期证据**：显示 `[PASS] Required files are present and Teacher Plans match 8-module structure.`。

---

## 七、 退场测试与课后拓展作业

### 7.1 课堂退场测试卡 (Exit Ticket)
精选 4 道考查 6 大多 Agent 拓扑、上下文隔离、Codex 只读契约与 HITL 裁决机制的题目。

### 7.2 课后练习与巩固作业
指导学员对比主从星型拓扑与背靠背盲审拓扑在实际开发中的适用场景。

---

## 八、 教师备课质量自测 Checklist

- [ ] 100% 匹配 **8 大执教模块** 标题，包含 5 个固定 Pause Points。
- [ ] 包含了 6 大多 Agent 协作拓扑全景说明与选型矩阵。
- [ ] 包含了物理隔离只读盲审与 `docs/LESSON_08_AUDIT_REPORT.md` 落盘规范。
- [ ] 包含了 PowerShell 脚本自测与 HITL 终局裁决逻辑。
