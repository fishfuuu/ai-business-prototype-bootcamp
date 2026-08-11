# 第七课学员操作指南 — 让 Agent 实际操作页面完成验收：MCP 扩展协议、QA Subagent 与四类证据链

> 💡 **本课的核心思想只有一句话：**  
> **口说无凭，证据落盘；MCP 插座齐发力，四证总卡放心交接。**

---

## 一、 本课背景、底层原理与学习目标

### 1.1 业务背景与真实痛点
在原型制作完成后，最尴尬的场景莫过于：**主管觉得已经好了，但向 IT 部门汇报或上线交接时却屡屡被打回**。原因在于：
1. **口头凭空猜测**：仅靠主管口头问“页面做好了吗”，AI 回答“做好了”，但实际上很多隐蔽的点击逻辑并未经过测试。
2. **缺乏客观证据与黑盒焦虑**：静态截图无法证明真实点击、控制台 0 报错与网络未外泄；而后台静默测试又让非技术主管看不见过程、心里发虚。

### 1.2 宏观受控闭环与 MCP 双插座证据链流转
本课将引入 **Model Context Protocol (MCP 开放扩展协议插座)** 与 **QA Subagent (`.claude/agents/qa-tester.md`)**，协同 **Playwright MCP** 与 **Chrome DevTools MCP**，将验收纳入一条**“视窗慢动作观摩 ➔ 静默双 MCP 测试 ➔ 物理落盘四类证据与总卡 ➔ HITL 签署销毁沙箱”**的受控闭环中：
1. **MCP 扩展协议插座 (Model Context Protocol)**：开放的标准协议，为 Agent 提供即插即用连接外部工具（如 Playwright 浏览器控制、Chrome DevTools 审计、后端 API）的通用接口。
2. **QA Subagent 独立只读沙箱**：主 Agent 唤醒 QA Subagent 在隔离进程中运行测试，完结后自动销毁沙箱，保持主会话 Context 干净。
3. **双 MCP 分工协作 (Playwright + Chrome DevTools)**：
   - **Playwright MCP**：负责 UI 端到端交互。Task 1 提供 **Headed 慢动作视窗 (`headed: true, slowMo: 500`)** 演示，让主管亲眼看到 Agent 自动点击；Task 2 抓取高分辨率截图 `screenshot.png`。
   - **Chrome DevTools MCP**：负责 Console 与 Network 深度审计。提取第一行 Error Message、127.0.0.1 域名白名单与 0 报错日志（截断最后 50 条），打码 `<REDACTED>` 落盘 `action.log`。
4. **《四类证据链验收总卡》落盘 (`docs/LESSON_07_EVIDENCE_INDEX.md`)**：测试完结时，物理生成带 4 行 YAML Header 的结构化文本索引卡，专门为第 8 课 Codex 独立审查提供可解析的文本输入。

### 1.3 核心学习目标
完成本课实操后，你将能够：
1. 理解 Model Context Protocol (MCP 模型上下文协议 / 智能体扩展插座) 的物理定义与运作机制。
2. 掌握调度 QA Subagent (`.claude/agents/qa-tester.md`) 运行 Playwright MCP 慢动作测试演示。
3. 掌握使用 Chrome DevTools MCP 审计控制台 0 报错与 127.0.0.1 网络请求。
4. 掌握物理提取并落盘“视觉、行为、工程、范围”四类证据及 `docs/LESSON_07_EVIDENCE_INDEX.md` 总卡，完成 HITL 签署归档。

---

## 二、 💡 本课核心工程概念卡 (Core Concepts)

### 核心概念 1：Model Context Protocol (MCP 模型上下文协议 / 智能体扩展插座)
- **硬核工程定义**：Anthropic 与开源社区发起的 Open Standard 开放协议，为 AI Agent 提供标准化连接外部工具、数据源与浏览器控制环境（如 Playwright MCP、Chrome DevTools MCP）的统一扩展插座。
- **底层运作机制**：通过 JSON-RPC 2.0 协议在 Agent 主进程与外部 MCP Server 之间通信。Agent 下发 Tool Call，MCP Server 操控外部资源（如控制 Headless 浏览器或审计 DevTools）并将结果格式化为上下文文本返回。
- **具象业务比喻**：**USB 物理扩展接口与标准电源插座** 🔌。Agent 是主板，MCP 是通用 USB 接口。只要插入 Playwright 或 DevTools 插座，主板就能即插即用操控浏览器。
- **IT 沟通场景**：“我们的 AI 原型通过标准 MCP 协议挂载了 Playwright 与 DevTools 插座，保证了工具链的标准与安全隔离。”

### 核心概念 2：QA Subagent & Dual MCP Tooling (QA 子智能体与双 MCP 工具链)
- **硬核工程定义**：受主 Agent 调度的只读沙箱子进程，协同 Playwright MCP（UI 操作）与 Chrome DevTools MCP（Console/Network 审计）执行端到端质量验收。
- **底层运作机制**：QA Subagent 独立运行在只读沙箱中，使用 Playwright 驱动 DOM 交互，使用 Chrome DevTools 抓取控制台第一行 Error Message 与 127.0.0.1 网络请求，完结后自动销毁沙箱。
- **具象业务比喻**：**带专业仪器进场的外聘第三方 QA 审计员** 🕵️‍♂️。配备全套检测设备（双 MCP），入场检测并落盘报告后自动退场，不占用日常办公桌。
- **IT 沟通场景**：“我们调度了 QA Subagent 挂载 Playwright 与 DevTools 双 MCP 进行了端到端自动化质量审计。”

### 核心概念 3：Four-Category Evidence Chain & Summary Index (四类证据链与验收总卡)
- **硬核工程定义**：由视觉截图 (`screenshot.png`)、行为日志 (`action.log`)、工程类型 (`typecheck.log`)、范围补丁 (`diff.patch`) 及带 YAML Frontmatter 汇总索引 (`LESSON_07_EVIDENCE_INDEX.md`) 构成的全方位客观审计证据集合。
- **底层运作机制与口语化标签**：
  - **视觉证据** ➔ `[照片证据]` `docs/assets/lesson-07/screenshot.png` (渲染对比图)
  - **行为证据** ➔ `[脚印日志]` `docs/assets/lesson-07/action.log` (DevTools 0 报错与网络白名单)
  - **工程证据** ➔ `[体检报告]` `docs/assets/lesson-07/typecheck.log` (verify 脚本 PASS)
  - **范围证据** ➔ `[存根 diff]` `docs/assets/lesson-07/diff.patch` (git 范围无超界)
- **具象业务比喻**：**法庭举证的物证、足迹、体检报告与合同存根** ⚖️。四证合一，加上书面总卡，绝不凭口头主观凭空猜测。
- **IT 沟通场景**：“我们落盘输出了包含四类证据链与 EVIDENCE_INDEX 验收总卡的交付包，可供 IT 部门 100% 物理复核。”

---

## 三、 🧠 流程图三层元模式 (Diagram Meta-Pattern)

### 模式 A (痛点反例)：嘴巴口头凭空猜测验收导致的上线被打回灾难
```text
┌─────────────────────────────────────────────────────────────┐
│ ❌ 痛点反例：嘴巴口头验收                                   │
│ 问“好了吗” ➔ AI 答“好了” ➔ 无 MCP 插座 ➔ 无落盘证据         │
│ ➔ 向 IT 部门汇报时控制台抛错、文件超界被惨痛打回 💥          │
└─────────────────────────────────────────────────────────────┘
```

### 模式 B (受控流转图)：MCP 插座与 QA Subagent 自动化测试分支
```text
                  ┌──────────────────────────────┐
                  │ 1. 挂载 Playwright/DevTools  │
                  │    MCP 扩展协议插座          │
                  └──────────────┬───────────────┘
                                 │
                  ┌──────────────▼───────────────┐
                  │ 2. 唤醒 QA Subagent 只读沙箱 │
                  │    .claude/agents/qa-tester  │
                  └──────────────┬───────────────┘
                                 │
                  ┌──────────────▼───────────────┐
                  │ 3. Playwright Headed 慢动作   │
                  │    (Task 1 人眼肉眼观看演示)  │
                  └──────────────┬───────────────┘
                                 │
                  ┌──────────────▼───────────────┐
                  │ 4. 双 MCP 静默自动化测试      │
                  │    Chrome DevTools 审计 Console│
                  └──────────────┬───────────────┘
                                 │
                  ┌──────────────▼───────────────┐
                  │ 5. 物理抓取并落盘四类证据与   │
                  │    docs/LESSON_07_EVIDENCE_INDEX│
                  └──────────────┬───────────────┘
                                 │
                  ┌──────────────┴───────────────┐
                  ▼                              ▼
          【四证与总卡全 PASS】           【任意一证 FAIL】
                  │                              │
                  ▼                              ▼
        主管 HITL 签署盖章              退回 L06 进行五层诊断修复
        销毁 QA Subagent 沙箱
```

---

## 四、 🛠️ 课堂实操与自学导引任务清单

### Task 1: 唤醒 QA Subagent 并开启 Playwright 视窗慢动作演示
- **极速口令**：`唤醒 QA Subagent，开启 Headed 慢动作测试演示`

### Task 2: 挂载 Chrome DevTools MCP 静默抓取并落盘四类证据与总卡
- **极速口令**：`同意执行 Headless 双 MCP 测试，落盘四类证据与 EVIDENCE_INDEX`

### Task 3: 证据链复核与人在回路 (HITL) 签署归档 (销毁沙箱)
- **极速口令**：`复核四类证据链无误，同意签署第 7 课验收盖章`

---

## 五、 📝 退场测试题库 (Exit Ticket)
1. **[概念填空题]** 为 AI Agent 提供标准化连接外部工具（如 Playwright、DevTools、API）的通用扩展插座协议是 ____________。
2. **[参考答案]** Model Context Protocol (MCP 开放扩展协议)。
