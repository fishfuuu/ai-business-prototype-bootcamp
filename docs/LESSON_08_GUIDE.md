# 第八课学员操作指南 — Codex 独立审查与上下文隔离：多 Agent 协作拓扑全景与交叉验证

> 💡 **本课的核心思想只有一句话：**  
> **开发归开发，审计归审计；多 Agent 拓扑全景在心，背靠背盲审终局裁决。**

---

## 一、 本课背景、底层原理与学习目标

### 1.1 业务背景与真实痛点
在原型开发进入尾声时，最隐蔽的风险莫过于：**单个 AI“既当运动员又当裁判员”**。
1. **上下文记忆污染**：开发 Agent 在经历了多轮修改后，聊天窗口记录了大量临时推演，容易“自卖自夸”，无视自己引入的隐蔽 Bug。
2. **缺乏多 Agent 拓扑全景**：缺乏对 Agent 架构范式的系统理解，不知道什么时候该用主从沙箱、什么时候该用并行并发、什么时候该用背靠背盲审。

### 1.2 宏观受控闭环与 6 大多 Agent 拓扑全景
本课将串联 **多 Agent 6 大协作拓扑范式**，并调度 **Codex Auditor (`.claude/agents/codex-auditor.md`)**，将审查纳入一条**“拓扑选型 ➔ 独立只读盲审 ➔ 证据总卡与 Diff 比对 ➔ 落盘 AUDIT_REPORT ➔ HITL 终局裁决”**的受控闭环中：

```text
┌─────────────────────────────────────────────────────────────────────────────────┐
│                    多 Agent 协作拓扑架构全景矩阵 (Multi-Agent Topologies)         │
├───────────────────┬───────────────────┬───────────────────┬─────────────────────┤
│ 1. 主从星型拓扑   │ 2. 并行扇出-扇入 │ 3. 顺序管线拓扑   │ 4. 背靠背盲审拓扑   │
│ (Orchestrator)    │ (Parallel Fan-Out)│ (Pipeline)        │ (Debate / Auditor)  │
│ 主Agent调度沙箱   │ 多个Subagents并发 │ 需求➔开发➔QA➔Codex│ 开发Agent vs 只读盲审│
├───────────────────┴───────────────────┴───────────────────┴─────────────────────┤
│ 5. 网状对等拓扑 (P2P Swarm)   │ 6. 人在回路三角色仲裁 (HITL Arbitration: 开发+审计+CEO) │
└───────────────────────────────┴─────────────────────────────────────────────────┘
```

### 1.3 核心学习目标
完成本课实操后，你将能够：
1. 掌握多 Agent 6 大协作拓扑范式（主从、并行、管线、盲审、对等、人在回路仲裁）的区别与选型场景。
2. 掌握调度 Codex Auditor 开启上下文隔离只读盲审，物理落盘 `docs/LESSON_08_AUDIT_REPORT.md`。
3. 掌握基于 Codex 审计报告行使人在回路 (HITL) 裁决盖章，完成 Candidate Commit 归档。

---

## 二、 💡 本课核心工程概念卡 (Core Concepts)

### 核心概念 1：Multi-Agent Collaboration Topologies (多 Agent 协作拓扑全景与 6 种范式)
- **硬核工程定义**：由多个专门化 AI Agent 按照特定控制流与信息传递结构组合而成的系统架构全景，包含 6 种公认拓扑范式。
- **底层运作机制**：
  - **拓扑 1 主从星型 (Orchestrator-Workers)**：主 Agent 掌控全局，调度只读 Subagents 在独立沙箱中跑测试，完结即销毁。
  - **拓扑 2 并行扇出-扇入 (Parallel Fan-Out/Fan-In)**：同时唤醒多个 Subagents 并发处理 UI 测试、网络审计与类型检查，最后汇总。
  - **拓扑 3 顺序管线 (Sequential Pipeline)**：上游输出作为下游输入（L03 需求 ➔ L04 开发 ➔ L07 QA ➔ L08 Codex）。
  - **拓扑 4 背靠背盲审 (Debate / Auditor)**：开发 Agent 与 Codex 在物理隔离的只读上下文中盲审和博弈。
  - **拓扑 5 网状对等 (Peer-to-Peer Swarm)**：去中心化广播与协同。
  - **拓扑 6 人在回路三角色仲裁 (HITL Arbitration)**：开发 Agent + 审计 Agent + CEO 主管终局裁决。
- **具象业务比喻**：**现代企业多工位协作与部门组织架构图** 👔👷‍♂️🕵️‍♀️。包含项目经理、专业外包团队、流水线工人、第三方审计师与 CEO 董事会。
- **IT 沟通场景**：“我们的 AI 架构根据场景选用了背靠背盲审与主从并行相结合的多 Agent 拓扑，兼顾了并行速度与安全隔离。”

### 核心概念 2：Context-Isolated Read-Only Auditor (上下文隔离只读审计者)
- **硬核工程定义**：运行在独立会话中、绝不出手修改源码，仅读取证据索引与 Git Diff 进行盲审的只读 AI 角色。
- **底层运作机制**：Codex 独立开启只读进程，无主 Agent 聊天历史记忆干预；仅解析 `LESSON_07_EVIDENCE_INDEX.md` 的 YAML Header 与 `git diff`，输出客观公正评级。
- **具象业务比喻**：**背靠背独立打分的专业第三方审计会计师** ⚖️。不参与财务报表制作，只看凭证与账目物理存根，独立出具审计意见。
- **IT 沟通场景**：“我们引入了上下文隔离的 Codex 只读审计 Agent，排除了单个 AI 自卖自夸的盲区。”

### 核心概念 3：Audit Report Persistence & HITL Arbitration (审计报告落盘与主管终局裁决)
- **硬核工程定义**：将盲审判定结构化落盘写入 `docs/LESSON_08_AUDIT_REPORT.md`，由业务主管 (CEO) 最终下发 `git merge` 或 `git restore` 的裁决范式。
- **底层运作机制**：Codex 输出包含 `audit_status: PASS/REJECT` 的 Frontmatter 报告；主管核对后下发签署口令，行使最终合并或驳回。
- **具象业务比喻**：**董事会终局签字盖章** 🖋️。听取开发部门与审计部门的双向汇报后，CEO 亲自落笔批准合并。
- **IT 沟通场景**：“最终 Candidate Commit 经过了 Codex 盲审报告落盘与主管 HITL 终局签署。”

---

## 三、 🧠 6 大多 Agent 拓扑范式对比表

| 拓扑范式 | 控制权归属 | 上下文隔离度 | Token 开销 | 本课程应用案例 |
| :--- | :--- | :--- | :--- | :--- |
| **1. 主从星型拓扑** | 主 Agent 统一调度 | 高 (只读沙箱销毁) | 低 (极简单行回报) | L04 Verifier Subagent / L07 QA Subagent |
| **2. 并行扇出-扇入拓扑** | 主 Agent 并发分发 | 极高 (多沙箱并发) | 中 (并发任务并行) | L07 双 MCP 并行抓取截图与 DevTools 日志 |
| **3. 顺序管线拓扑** | 上游传递至下游 | 中 (链式顺序传递) | 中 (累加传递) | L03 需求 ➔ L04 开发 ➔ L07 QA ➔ L08 Codex |
| **4. 背靠背盲审拓扑** | 独立只读 Auditor | 极高 (物理隔断记忆) | 低 (仅读取 Diff/Index) | L08 Codex Auditor 只读盲审 |
| **5. 网状对等拓扑** | 去中心化 P2P 协商 | 低 (全员广播) | 高 (消息广播膨胀) | 大型分布式协同 |
| **6. 人在回路仲裁拓扑** | 人类主管 (CEO) 最高裁决 | 最高 (人在回路) | 最受控 | L08 开发 Agent + Codex + 主管终局合并 |

---

## 四、 🛠️ 课堂实操与自学导引任务清单

### Task 1: 唤醒 Codex 独立审计 Agent 开展物理隔离盲审

#### ⚡ 极速操作步骤
1. 打开 CLI 窗口，下发口令唤醒 Codex 只读盲审：
   ```text
   唤醒 codex-audit 技能，开启独立只读盲审
   ```
2. AI 将自动启动 `.claude/agents/codex-auditor.md` 只读进程，无任何开发历史记忆干扰。

#### 💡 独立自学原理解析
> **为什么要进行“上下文隔离 (Context Isolation)”？**  
> 主开发 Agent 在多轮对话后，内存中积累了大量调试细节，容易对自己的代码产生“既定印象”。Codex 开启全新只读进程盲审，就像换了一个没参加过开发会议的资深架构师来验看代码，能最客观地指出隐患。

---

### Task 2: 独立解析证据索引与 Git Diff，物理落盘《Codex 独立审查报告》

#### ⚡ 极速操作步骤
1. 在聊天窗口下发盲审报告落盘口令：
   ```text
   同意执行 Codex 独立盲审，落盘 AUDIT_REPORT
   ```
2. 确认物理磁盘生成 [`docs/LESSON_08_AUDIT_REPORT.md`](file:///d:/AILearning/docs/LESSON_08_AUDIT_REPORT.md)。

#### 🔍 《Codex 独立审查报告》物理落盘预览
```markdown
---
audit_status: PASS
auditor: codex-auditor
candidate_sha: a1b2c3d4
audit_timestamp: 2026-08-10T16:45:00Z
---

# 第 8 课 Codex 独立审查报告 (LESSON_08_AUDIT_REPORT.md)

## 1. 独立审查判定
- **审查结论**：PASS (批准合并)
- **风险等级**：LOW (低风险)

## 2. 审计项核对表
- [x] 四类证据链总卡 Frontmatter 校验：PASS
- [x] 代码修改范围边界比对：Clean (修改仅限 allowed_files)
- [x] TypeScript 类型契约匹配：PASS (0 any, 0 断裂)
```

---

### Task 3: 主管行使终局裁决 (HITL Arbitration) 与合并归档

#### ⚡ 极速操作步骤
1. 打开物理落盘的 `docs/LESSON_08_AUDIT_REPORT.md`，确认 `audit_status: PASS`。
2. 在 CLI 中下发终局合并口令：
   ```text
   复核 Codex 审查报告无误，同意签署第 8 课终局裁决合并
   ```
3. AI 将自动更新 [`docs/PROJECT_STATE.md`](file:///d:/AILearning/docs/PROJECT_STATE.md)，标记第 8 课为 Complete。

---

## 五、 💡 常见概念误区与正确理解 (Mindset Transformation)

| 常见误区 (Misconception) | 正确硬核理解 (Correct Engineering Reality) | 如何纠偏与护栏防护 (Remedy & Guardrails) |
| :--- | :--- | :--- |
| **误区 1：“一个 AI 既负责写代码，又负责做审计，效率最高”** | 单个 AI 会产生记忆污染与自卖自夸盲区，隐蔽 Bug 无法被识别。 | 建立多 Agent 架构，引入 Codex Auditor 开展独立盲审。 |
| **误区 2：“Codex 发现报错时，直接让 Codex 在现场把源码改了”** | 审计 Agent 如果擅自改源码，就失去了独立审计的物理隔离中立性。 | 强制 Codex “只读只审，绝不改码”，修改退回主 Agent。 |
| **误区 3：“Codex 判定 PASS 后，系统就自动合并上线了”** | 最高决策权永远属于人类主管 (CEO)，AI 不能替人下发 Merge。 | 引入 HITL 终局裁决，由主管人工确认后再合并。 |

---

## 六、 ❓ 常见操作报错与 Troubleshooting 指南

| 报错/异常现象 | 物理原因 | 解决与纠偏方案 |
| :--- | :--- | :--- |
| Codex 提示 `EVIDENCE_INDEX.md` 不存在 | 第 7 课四类证据总卡未成功物理落盘 | 退回第 7 课唤醒 QA Subagent 重新落盘。 |
| Codex 在报告中标记 `REJECT` | 存在未允许的文件修改或契约断裂 | 回复 `唤醒 diagnosing-bugs` 修复后重新下发盲审口令。 |
| 无法唤醒 `codex-auditor` 角色 | `.claude/agents/codex-auditor.md` 丢失 | 运行 `verify-project.ps1` 预检脚本自动恢复 Agent 文件。 |

---

## 七、 📝 巩固与退场测试题库 (4 题精选)

### 阶段 1：课堂退场盖章测试 (Exit Ticket)
1. **[拓扑选择题]** 在多 Agent 架构中，主 Agent 负责调度，只读子 Agent 在隔离沙箱中跑测试完结即销毁，属于哪种拓扑？ ____________。
   - A. 主从星型拓扑 (Orchestrator-Workers)
   - B. 网状对等拓扑 (Peer-to-Peer Swarm)
2. **[角色选择题]** 关于 Codex Auditor 独立审计 Agent 的行为边界，下列说法正确的是？ ____________。
   - A. Codex 可以一边审计一边直接修改源代码
   - B. Codex 只能只读盲审，绝不出手修改任何源码
3. **[IT 沟通场景题]** 当 IT 部门质疑非技术主管制作的 AI 原型可能会有“开发 AI 自卖自夸隐瞒 Bug”时，你应该如何向他们汇报？
   - **参考回答**：“我们采用了主从多 Agent 并行与上下文隔离拓扑架构。主 Agent 负责开发，独立只读的 Codex Auditor 在完全隔离的会话中开展背靠背盲审，物理落盘输出了带有 Frontmatter 判定的 `LESSON_08_AUDIT_REPORT.md`，最后由主管人工行使终局裁决，确保交付质量 100% 受控。”
