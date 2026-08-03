# 主管 AI 原型制作训练营（历史课程设计原稿）

> **文档定位说明**：  
> 本文档保留为训练营的**历史课程设计来源与背景文案原稿（Historical Design Manuscript）**。  
> 结合当前仓库状态、超级业务 PM 定位与 AI 工程体系整理后的**唯一权威执行版（Authoritative Execution Plan）**请参阅：[docs/COURSE_ROADMAP.md](COURSE_ROADMAP.md)。

---

## 一、课程目标

课程目标不是培养程序员，而是让运营主管成为“超级业务 PM”，能够：

1. 使用 Claude Code 从零创造业务系统页面。
2. 用参考截图、设计规则和规范控制页面效果。
3. 掌握预制 Skills 提高需求澄清、设计与验证的稳定性。
4. 建立工程护栏意识与安全离线习惯（Git 版本证据、`CLAUDE.md` 护栏、三分记忆模型与有界排错）。
5. 使用 Codex 在独立审查上下文隔离下审计 Claude Code 的代码。
6. 准确切割确定性业务逻辑与概率性 AI 能力（坚持人在回路 HITL 人工确认）。
7. 完成一个受控 AI 功能闭环 Demo。
8. 将整理好的长期资产导出为《IT 原型交接包》，交付 IT 部门。

---

## 二、课程工具与角色契约

### Claude Code（主要实施者）
- 理解业务需求并复述方案
- 从零创建与修改页面
- 实现业务逻辑与增量修改
- 定位和修复问题，运行工程自测

### Codex（独立审查者）
- 从第 8 课开始引入（基于 `AGENTS.md` 规范）
- 在独立审查上下文隔离下只读审计 Candidate Commit 到稳定 Commit 的 Diff
- 检查隐患与逻辑越界，提出审查意见（不修改代码）

### 运营主管（最终裁决者 / 人在回路盖章官）
- 掌控 Workflow 推进阶段
- 行使 Keep / Omit / Remove / Modify 裁决权
- 对 Codex 审查意见做 4 种决定：接受、拒绝、延期、超出范围
- 行使人在回路 (HITL) 人工确认盖章与最终业务验收

---

## 三、三层能力成熟度模型

课程引导主管完成三层 AI 协作能力跨越：
1. **第一层：Prompting (单次指令)** —— 了解裸 Prompt 局限。
2. **第二层：Harness Engineering (工程护栏)** —— 用规则文件 (`CLAUDE.md`)、格式文件 (`PROJECT_STATE.md`)、Skills (`grill-me`) 和测试约束 AI。
3. **第三层：Bounded Agent Loop (受控 Agent 循环)** —— 前置锁定 Goal/Boundary/Risk/Stop 4 大要素，放手让 Agent 在受控轨道内闭环工作，主管在关口盖章。

---

## 四、10 课演进总览与演进表

详细的演进总览、分层概念矩阵与暗线能力表，请详见唯一权威执行版：[docs/COURSE_ROADMAP.md](COURSE_ROADMAP.md)。

### 每课结束固定动作
从第二课起，每节课结束前必须固定执行以下 5 个管理动作：
1. 更新 `docs/PROJECT_STATE.md`
2. 运行本课验证 (`verify-project.ps1`)
3. 查看 `git diff` 确认修改范围
4. 提交本课稳定版本 (`git commit`)
5. 记录下一课的明确输入

---

## 五、详细课程路线

### 第1课：从业务问题创建第一个系统页面
- **重点**：识别工作记忆（Context 对讲机）、Tools 权限授权沙箱、模拟数据红线与人在回路，初始化 `docs/PROJECT_STATE.md`。

### 第2课：用参考图与设计规则做出像样的页面
- **重点**：事实锚定 (Grounding)、视觉 Harness (`DESIGN.md`)，安全的 Git 本地提交流程（`git status` -> `git add .` -> `git diff --cached` -> `git commit`），保存首个版本证据。

### 第3课：让 Agent 帮助自己想清楚需求
- **重点**：Prompt vs Skill Harness (`grill-me`)；前置 Goal / Boundary / Risk / Stop 4 大要素；生成《业务功能卡》与《数据契约卡》。

### 第4课：把大需求拆成连续的小成功
- **重点**：架构 Harness 驱动增量 Loop；数据接口意识（4 种状态）；可重复执行与回归风险防范（小步 Commit 保护 Context）。

### 第5课：建立不会轻易失控的项目
- **重点**：外部长期记忆、`CLAUDE.md` 工程护栏；剖析 Context 衰减机制；存档后重置窗口 (`/clear`)；`git restore <文件>` 恢复。

### 第6课：学会定位和修复问题
- **重点**：日志事实锚定；五层诊断卡；有界排错 Loop（最多 2 轮修复，不得改断言，未过呈交证据由主管裁决）。

### 第7课：让 Agent 实际操作页面完成验收
- **重点**：断言 Harness 自动化（Playwright）；生成视觉、行为、工程、范围四类可复核证据链。

### 第8课：Claude Code 开发，Codex 独立审查
- **重点**：独立审查上下文隔离（新建会话，只读）；审查 Candidate Commit 区间 Diff；主管 4 种裁决。

### 第9课：业务 Agent 场景判断与产品设计
- **重点**：确定性业务逻辑（代码/规则） vs. 概率性 AI 能力（生成/草稿）切割；AI 隐私边界与 HITL 人工确认门禁（禁止自动写库）。

### 第10课：落地有限 AI 功能与 IT 交接
- **重点**：落地受控 AI 功能闭环（输入 -> AI 草稿 -> HITL 人工确认 -> 生效）；可选 Skill 扩展；导出《IT 原型交接包》。
