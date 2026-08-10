---
name: teacher-plan-architect
description: Master skill for designing high-caliber enterprise AI lesson plans and teaching guides. Enforces the 4-step concept definition framework (Definition -> Mechanism -> Metaphor -> Handoff Value), 5-pause-point time allocation, and evidence-driven verification.
---

# Teacher Plan Architect (企业级 AI 课程教案设计高手 Skill)

当需要编写或重构《教师备课与控场指南 (TEACHER_PLAN)》或《学员操作卡 (GUIDE)》时，严格遵守以下 5 维硬核教学设计架构。

---

## 1. 核心概念【四步解析公式】(Mandatory Concept Formula)

拒绝任何“只给比喻不给原理”的浅薄解释。教案中出现的每一个专业概念（如 Git, Token, MCP, Linter, Harness, Assertion），必须按以下 4 步递进解析：

1. **硬核工程定义 (Engineering Definition)**：使用标准的 IT/软件工程术语，不作修饰，讲清物理本质。
2. **底层运作机制 (Underlying Mechanism)**：解释代码、内存、接口或数据在底层到底是如何流转与执行的。
3. **具象业务比喻 (Business Metaphor)**：抛出形象比喻，帮助非技术主管建立大脑记忆锚点。
4. **IT 沟通与交接价值 (Handoff Value)**：明确主管学完后在业务落地与向 IT 交接时的具体表达与产出。

---

## 2. 课堂时间与控场节奏 (90 分钟极客控场)

标准教案必须精确拆解为 5 大环节与 5 个固定暂停点（Pause Points）：

| 阶段 | 建议时长 | 教师动作 | 学员动作 | 关键暂停点 (Pause Point) |
| :--- | :--- | :--- | :--- | :--- |
| **1. 成果展示** | 8 分钟 | 展示重构前后试衣镜对比 | 观看并对齐终局目标 | **暂停点 1**：明确本课核心交付物 |
| **2. 连续微型演示** | 17 分钟 | 连续示范 4 个 Task，展示底层逻辑 | 记录关键提示词与盖章口令 | **暂停点 2 & 3**：概念硬核拆解与安全存档 |
| **3. 概念核对** | 10 分钟 | 提问并核对【四步概念卡】 | 口头回答原理与业务价值 | **暂停点 4**：确认逻辑冻结线 |
| **4. 学员实操** | 45 分钟 | 巡视并解答卡点，监控授权 | 分 Task 独立实操与 Git 存档 | **暂停点 5**：人在回路盖章 |
| **5. 总结验证** | 10 分钟 | 运行 `verify-project.ps1` 校验 | 填记卡，提交日志 | 成果证据归档 |

---

## 3. 人在回路 (HITL) 授权与安全防护线

教案中必须显式标明**安全隔离防护墙**：
* **改前必存档**：在下达修改指令前，必须执行节点手动存档 `git commit -m "baseline: ..."`。
* **修改须授权**：明确绝不允许 Agent 自行修改代码，必须等待主管输入明确盖章口令（如 `同意方案，请开始修改代码`）。
* **越界一键撤销**：指导主管监视 Diff 红绿视图，一旦改崩，通过 `Discard Changes` 1 秒无损还原。

---

## 4. 四类可复核证据链 (Evidence-Driven Validation)

教案结尾必须包含明确的证据验收机制：
1. **视觉证据**：试衣镜页面对比截图。
2. **行为证据**：交互点击无报错日志。
3. **工程证据**：`powershell -File .\scripts\verify-project.ps1` 输出 `[PASS]`。
4. **范围证据**：`git diff` 确认未修改超出许可范围的文件。

---

## 5. 教师教案质量自我审计 Checklist

在生成或重构教案后，自我审计是否满足：
- [ ] 所有核心概念均包含了【硬核定义 + 底层机制 + 业务比喻 + IT交接】4 步。
- [ ] 包含了精确到分钟的时间分配表与 5 个固定暂停提问点。
- [ ] 包含了明显的“人在回路 (HITL) 盖章口令”与 Git 防护动作。
- [ ] 包含了 PowerShell 自动化校验脚本的 `[PASS]` 验证闭环。
