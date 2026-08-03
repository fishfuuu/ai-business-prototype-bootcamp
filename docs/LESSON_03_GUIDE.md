# 第三课学员指南：让 Agent 帮助自己想清楚需求（合一卡）

> **课次**：第 3 课  
> **明线主题**：让 Agent 帮助自己想清楚需求  
> **暗线核心**：Skill Harness 追问、数据契约卡与前置 Goal / Boundary / Risk / Stop 4 大要素  
> **建议时长**：90 分钟（教师导学与演练 40 分钟，学员实操 50 分钟）  
> **对应路线图**：[docs/COURSE_ROADMAP.md](COURSE_ROADMAP.md) 第 3 课  

---

## 1. 开始前准备与前置检查

### 启动项目与读档检查
1. 打开 PowerShell 终端，进入项目根目录：
   ```powershell
   cd d:\AILearning
   ```
2. 运行一键验证脚本，确认第二课完成态没有红字报错：
   ```powershell
   powershell -ExecutionPolicy Bypass -File .\scripts\verify-project.ps1
   ```
3. 确认已打开 `docs/PROJECT_STATE.md`，检查上一课记录的稳定 Commit SHA。

---

## 2. 核心概念卡：从单次 Prompt 到 Skill 护栏与 4 大要素

### 💡 概念卡 1：第一层 Prompting vs. 第二层 Skill Harness
* **单次 Prompt (第一层)**：试图用一句模糊口头语（如“帮我做个退款功能”）一次性生成系统。AI 极易凭空脑补、遗漏边界，导致生成的页面与业务现实脱节。
* **Skill Harness (第二层)**：预先沉淀在工程里的“专业专家套路”。以 `grill-me` 为例，它是一个**追问技能护栏**——强制 Agent **一次只问 1 个最关键的业务问题**，绝不擅自改代码，直到把需求和数据扣清楚。

### 💡 概念卡 2：解锁自主 Loop 的 4 大前置要素
要想在后面的开发中放手让 Agent 自主去跑（Autonomous Loop），必须在需求阶段前置锁定 4 大要素：
1. **目标 (Goal)**：业务要解决什么具体痛点？做出什么功能？
2. **边界 (Boundaries)**：明确做什么，更要明确**不做什么 (Out of Scope)**。
3. **风险与红线 (Risks)**：数据的敏感等级是什么？哪些核心计算规则绝对不能动？
4. **停止条件 / 验收标准 (Stop Conditions)**：写代码前先定义**期望输入与输出**。何时算完成？如何自动校验 PASS？

---

## 3. Task 1：启动 `grill-me` 技能进行需求追问 (10 分钟)

### 目标
用一句话发起需求，唤醒 `grill-me` Skill，接受 Agent 3–5 轮结构化追问。

### 操作步骤
1. 打开 Claude Code 界面。
2. 复制并发送以下**需求发起口令**（根据自己选择的原型类型修改粗体部分）：

```text
请使用 grill-me 技能帮我梳理需求。

我的业务原型类型是：【A. 监控与决策型 / B. 任务与流程型 / C. 操作工具型】
我的业务痛点与一句话需求是：【例如：运营主管每天需要手动统计超时未履约的订单，效率低且容易漏单，希望能有一个自动预警和催单工作台】

请按照 grill-me 规范，每次只问我 1 个最关键的问题，帮我理清目标、边界与核心字段。
```

3. **回答追问**：认真回答 Agent 提出的 3–5 个问题（如：处理角色是谁？多久算超时？异常阈值是多少？）。
4. 当 Agent 提示“需求澄清完毕”时，准备进入 Task 2。

---

## 4. Task 2：数据契约卡梳理 (15 分钟)

### 💡 知识卡：为什么需要“数据契约”？
页面只是外壳，**数据才是业务的灵魂**。如果不定义数据契约，AI 就会凭空编造假字段、假类型（例如把金额写成字符串、把状态写成随机中文），导致后续接入真实后端时系统崩溃。

数据契约就是**主管与 IT/AI 约定的数据规范**。

### 复制并发送给 Claude Code（数据契约生成指令）：

```text
基于刚才的对话，请帮我整理一份 Markdown 格式的《轻量数据契约卡》。

包含以下两部分：

1. 基础数据契约表：
   - 字段名称 (英文字段名)
   - 业务含义 (中文名称)
   - 数据类型 (文本/数字/布尔/日期/枚举)
   - 是否必填
   - 数据来源 (固定为 Mock 数据)
   - 示例值
   - 敏感等级 (公开 / 内部 / 严禁发送 AI)

2. 针对我的原型类型的专属扩展契约：
   - 【监控决策型】：指标口径/计算公式、对比基准、异常阈值、下钻维度
   - 【任务流程型】：发起/处理角色、业务状态机(草稿->待处理->已完成)、允许动作、驳回/撤销规则
   - 【操作工具型】：输入结构、校验规则、处理逻辑、输出结构、HITL 人工确认点

请生成表格并呈报给我确认。
```

---

## 5. Task 3：前置验收条件与《业务功能卡》输出 (15 分钟)

### 💡 知识卡：验收标准前置 (Stop Conditions)
在写一行代码之前，先定义好**“怎样才算做对了”**。
这不仅是第 3 课的总结，更是第 4 课增量推进、第 6 课排错回归、第 7 课自动化测试和第 8 课 Codex 审查的**唯一依据**！

### 复制并发送给 Claude Code（输出完整业务功能卡）：

```text
请将前面的讨论成果汇总，生成最终的 Markdown 文档《业务功能卡》，保存至 `docs/BUSINESS_FEATURE_CARD.md`。

包含以下 4 个部分：
1. 目标 (Goal)：业务背景与要解决的核心痛点
2. 边界 (Boundaries)：核心功能模块与明确不做的范围 (Out of Scope)
3. 风险与红线 (Risks)：数据敏感等级与禁止修改的规则
4. 前置验收标准 (Stop Conditions)：
   - [验收场景 1] 期望输入 -> 期望页面响应/状态改变 -> 期望输出
   - [验收场景 2] 异常情况输入 -> 期望预警/报错提示
   - [工程停止条件] 运行 `verify-project.ps1` 必须输出 [PASS]

生成后请自动将文件保存到 `docs/BUSINESS_FEATURE_CARD.md`。
```

---

## 6. Task 4：验证、状态更新与 Git 提交 (10 分钟)

### 目标
更新 `docs/PROJECT_STATE.md`，运行工程校验，并完成第三课稳定版本提交。

### 操作步骤
1. 打开 `docs/PROJECT_STATE.md`，更新以下内容：
   - 将 **L03 课程状态** 改为 `PASS`；
   - 在 **稳定 Git Commit SHA** 留空，待提交后填入；
   - 填写 **下一课输入**：“以 `BUSINESS_FEATURE_CARD.md` 为依据，开启第 4 课增量开发”。
2. 在 PowerShell 中运行项目验证：
   ```powershell
   powershell -ExecutionPolicy Bypass -File .\scripts\verify-project.ps1
   ```
3. 在 PowerShell 中依次运行以下安全 Git 提交指令：
   ```powershell
   git status
   git add .
   git diff --cached
   git commit -m "feat: complete lesson 3 requirement and data contract cards"
   git log --oneline -5
   ```
4. 将最新的 Commit SHA（如前 7 位 `a1b2c3d`）填回 `docs/PROJECT_STATE.md` L03 行。

---

## 7. 极简记忆卡（下课复盘）

1. **Prompt vs. Skill**：口头 Prompt 容易漂移；Skill (`grill-me`) 是有约束的专业追问护栏。
2. **4 大要素**：目标 (Goal)、边界 (Boundaries)、风险 (Risks)、停止条件 (Stop Conditions)。
3. **数据契约**：数据是业务灵魂；明确字段、类型、口径与敏感度，不让 AI 凭空编造。
4. **验收前置**：先定义停止条件，才能在后续放手让 Agent 自主循环去跑。
