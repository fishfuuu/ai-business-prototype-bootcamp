# 第十课教师备课与控场指南 — 落地有限 AI 功能与 IT 交接：物理红线清册与《IT 原型交接包》

> [!IMPORTANT]
> 本教案为 **8 大执教模块精简标准版**，按讲师执教动线深度整合，严格对齐 `COURSE_ROADMAP.md`、部门不可 Agent 化物理红线清册 (`docs/DEPARTMENT_REDLINES.md`)、一键打包《IT 原型交接包》 (`dist/IT_HANDOVER_PACKAGE.zip`) 与 5 分钟结业极客汇报演练。

---

## 一、 课程元数据与定位

### 1.1 课程元数据
- **课程名称**：AI 业务原型开发训练营·第十课 (终局收官课)
- **主讲主题**：落地有限 AI 功能与 IT 交接：物理红线清册与《IT 原型交接包》
- **授课对象**：非技术背景业务主管 / 产品经理 / 业务专家 (10–30人)
- **课时时长**：90 分钟 (极客控场 + 5 个固定 Pause Points)
- **授课模式**：18 分钟极客示范 ➔ 10 分钟概念核对 ➔ 45 分钟学员分步实操 ➔ 10 分钟结业汇报归档
- **前置依赖**：学员已完成第九课并掌握确定性逻辑切割与 Mock 降级保护桥梁。
- **教学验证状态**：PILOT_READY (包含红线清册编制、交接包一键打包与 5 分钟结业极客汇报 / 待试讲)
- **课程负责人**：训练营教研组

### 1.2 本课定位与背景痛点
- **在全套课程中的位置**：全套 10 课训练营的终局收官课！完成受控 AI 功能闭环，编制部门不可 Agent 化物理红线清册，一键打包输出包含源码、数据契约、四类测试证据链与系统配置的《IT 原型交接包》。
- **解决的核心痛点**：
  1. **安全越权灾难**：未划分安全禁区，导致 AI 在生产环境中尝试自动打款或自动签署合同引发巨大风险。
  2. **IT 交接扯皮死穴**：向 IT 部门交接时只丢几个散乱的 `.html` 页面，缺少 TypeScript 数据契约与四类测试证据链，被 IT 部门当场拒绝退货。
- **核心突破口**：
  1. **部门不可 Agent 化物理红线清册 (`docs/DEPARTMENT_REDLINES.md`)**：明确划定资金划扣、法务合同、敏感数据导出等绝对禁止 AI 自动化的红线领地。
  2. **打包《IT 原型交接包》 (`dist/IT_HANDOVER_PACKAGE.zip`)**：通过 `scripts/package-it-handover.ps1` 一键生成包含源码、TS 契约、四证总卡 (`EVIDENCE_INDEX`) 与 Codex 盲审报告 (`AUDIT_REPORT`) 的交接大礼包。
  3. **5 分钟结业极客汇报演练**：总结学员从 L0 到 L5 的能力跨越，向老板与 IT 团队展现受控 AI 交付闭环。

---

## 二、 逆向目标与四步概念卡

### 2.1 Bloom ABCD 学习目标
完成本课后，学员将能够：
1. **[Objective 1 - Apply (3)]**：在原型项目交接前 (**C**)，学员 (**A**) 能编制并落盘 `docs/DEPARTMENT_REDLINES.md` 部门物理红线清册 (**B**)，锁定资金划扣与法务合同绝对禁止 AI 代理的红线领地 (**D**)。
2. **[Objective 2 - Analyze (4)]**：在向 IT 部门交接时 (**C**)，学员 (**A**) 能运行 `scripts/package-it-handover.ps1` 脚本 (**B**)，分析并一键打包输出 `dist/IT_HANDOVER_PACKAGE.zip` 标准交接大礼包 (**D**)。
3. **[Objective 3 - Evaluate (5)]**：在结业汇报演练中 (**C**)，学员 (**A**) 能基于 Agent L0-L5 能力演进矩阵与 HITL 裁决体系 (**B**)，完成 5 分钟极客结业汇报，向 IT 团队实现 100% 受控无缝交接 (**D**)。

### 2.2 核心概念四步解析卡集

#### 💡 概念卡 1：Departmental Automation Redlines (部门不可 Agent 化物理红线清册)
1. **硬核工程定义**：在系统交付文件中显式开列并落盘为 `docs/DEPARTMENT_REDLINES.md` 的强制性安全约束规范，明确划定绝不允许 AI 自动化代理、必须由人类全流程审批的绝对物理红线领地（如资金划扣、法律合同盖章、敏感隐私开矿）。
2. **底层运作机制**：作为 `CLAUDE.md` 与 API 权限层的底层基石规则，在代码库和运行代理中预先嵌入校验防火墙，违规 Tool Call 直接被系统物理拒止。
3. **具象业务比喻**：**军事禁区红线与核按钮双人保险箱** ⛔。无论 AI 智商多高，绝不允许独自触碰核按钮（资金与法务）。
4. **IT 沟通场景**：“我们在交接包中物理落盘了《部门物理红线清册》，明确划定了 AI 不可代理的绝对安全禁区。”

#### 💡 概念卡 2：IT Prototype Handover Package (IT 原型交接包与契约打包范式)
1. **硬核工程定义**：包含完整前端原型源码、TypeScript 结构化数据契约、四类可复核测试证据链 (`EVIDENCE_INDEX`)、Codex 独立盲审报告 (`AUDIT_REPORT`) 及部门红线清册的标准归档 ZIP 交付物。
2. **底层运作机制**：运行物理打包脚本 `scripts/package-it-handover.ps1`，将静态源码、契约文件与测试证据无损归档为 `dist/IT_HANDOVER_PACKAGE.zip`。
3. **具象业务比喻**：**带竣工图、物证卷宗与交接清册的房屋交房大礼包** 🎁。IT 部门拿到后可直接解析 TypeScript 契约并启动后端开发。
4. **IT 沟通场景**：“我们交付的是包含源码、TS 数据契约与四证盲审报告的《IT 原型交接包》，IT 团队可 100% 无缝接入。”

#### 💡 概念卡 3：Agent Capability Progression Matrix (Agent L0-L5 能力演进矩阵)
1. **硬核工程定义**：从 L0 (无工具聊天) ➔ L1/L2 (单/多工具调用) ➔ L3 (多步骤薄切片) ➔ L4 (自主反思与熔断) ➔ L5 (多 Agent 协作盲审与 HITL 仲裁) 的 Agent 系统演进评估体系。
2. **底层运作机制**：通过在开发全周期中逐步叠加 Tooling、State Machine、Subagent Sandbox 与 Read-Only Auditor，实现从单点对话到企业级受控 AI 劳动力的跨越。
3. **具象业务比喻**：**从实习打字员到带专业外包团队的部门总监** 📈。一步步建立规则、工具箱、审计官与董事会裁决。
4. **IT 沟通场景**：“我们的原型开发完整穿透了从 L1 到 L5 的受控 Agent 架构，具备企业级落地的合规性。”

---

## 三、 教学准备与沙箱隔离

- **代码仓库准备**：确认 `CLAUDE.md`、`src/mocks/prototype-data.ts`、`LESSON_07_EVIDENCE_INDEX.md` 与 `LESSON_08_AUDIT_REPORT.md` 存在。
- **环境检查命令**：
  ```powershell
  git status
  powershell -ExecutionPolicy Bypass -File scripts/verify-project.ps1
  ```
- **示范区与实验区**：讲师示范窗口与学员实操窗口相互隔离。

---

## 四、 90分钟控场主线与 Pause Points

| 时间段 | 环节 | WHERETO | 教师动作与 Pause Points 提问 | 学员动作 |
| :--- | :--- | :--- | :--- | :--- |
| 00-08 分 | 成果展示 | **W** | 展示无红线越权灾难 vs IT 原型交接包一键生成与极客汇报。<br>**Pause Point 1**：“为什么绝不能让 AI 擅自自动打款或自动盖章签署合同？” | 观看对齐交付物 |
| 08-25 分 | 极客示范 | **H & E** | 示范编制物理红线清册、运行打包脚本与 5 分钟极客汇报框架。<br>**Pause Point 2**：“《IT 原型交接包》包含了哪 5 大核心资产？”<br>**Pause Point 3**：“从 L1 到 L5，Agent 能力演进的核心标志是什么？” | 记录关键指令 |
| 25-35 分 | 概念核对 | **R** | 提问核对部门红线清册、交接包 ZIP 与 L0-L5 演进矩阵。<br>**Pause Point 4**：“为什么 IT 部门拿到了 TS 数据契约和四证总卡后就能 100% 信任交接包？” | 口头回答卡片 |
| 35-80 分 | 学员实操 | **E & T** | 巡视指导，监控学员生成 `IT_HANDOVER_PACKAGE.zip` 并做 5 分钟极客演练。<br>**Pause Point 5**：“如何确认 `dist/IT_HANDOVER_PACKAGE.zip` 已成功在物理磁盘生成？” | 分 Task 独立实操 |
| 80-90 分 | 结业归档 | **O** | 运行 `verify-project.ps1`，学员领取训练营结业证书。 | 填退场卡，提交打包 ZIP |

---

## 五、 逐 Task 极客示范与巡视指导

### Task 1: 编制与落盘《部门不可 Agent 化物理红线清册》
- **教师示范**：在工程根目录下开列 `docs/DEPARTMENT_REDLINES.md`，明确把资金划扣、法务合同与敏感数据导出划为绝对红线。
- **盖章口令**：`同意保存部门物理红线清册`
- **巡视 Check**：工程根目录下成功生成 `docs/DEPARTMENT_REDLINES.md`。

### Task 2: 一键运行 `package-it-handover.ps1` 生成《IT 原型交接包》
- **教师示范**：在 PowerShell 中运行打包命令，展示一键把源码、TS 契约、四证总卡、Codex 报告与红线清册无损打包为 ZIP 的过程。
- **盖章口令**：`运行一键打包脚本，生成 IT_HANDOVER_PACKAGE.zip`
- **巡视 Check**：确认 `dist/IT_HANDOVER_PACKAGE.zip` 物理落盘。

### Task 3: 5 分钟结业极客汇报演练与受控 AI 归档
- **教师示范**：展示 5 分钟结业汇报框架（问题背景 ➔ 薄切片代码 ➔ 双 MCP 证据 ➔ Codex 盲审 ➔ 红线交接包），向老板和 IT 团队汇报。
- **盖章口令**：`全套 10 课原型开发完成，同意终局签署结业归档`
- **巡视 Check**：学员能在 `PROJECT_STATE.md` 中标注全套 10 课 Complete，完成从业务主管到超级业务 PM 的跨越。

---

## 六、 现场 Debug 预案与自动化校验

### 6.1 常见错误现场 Troubleshooting
- **现象 1**：打包脚本提示缺少文件 ➔ **预案**：确认 L07 和 L08 的证据总卡与盲审报告已被保存。
- **现象 2**：生成的 ZIP 解压后文件名乱码 ➔ **预案**：脚本内置 `System.IO.Compression` UTF-8 编码，确保无乱码。

### 6.2 自动化校验与证据提取
- **校验命令**：
  ```powershell
  powershell -ExecutionPolicy Bypass -File scripts/verify-project.ps1
  ```
- **预期证据**：显示 `Verification completed successfully.`。

---

## 七、 退场测试与课后拓展作业

### 7.1 课堂退场测试卡 (Exit Ticket)
精选 4 道考查物理红线清册、IT 交接包资产、L0-L5 演进矩阵与 HITL 最高裁决权的题目。

### 7.2 课后练习与结业行动项
指导学员在下周一向公司 IT 部门提交《IT 原型交接包》ZIP 文件，启动后端真实开发对接。

---

## 八、 教师备课质量自测 Checklist

- [ ] 100% 匹配 **8 大执教模块** 标题，包含 5 个固定 Pause Points。
- [ ] 包含了【四步解析卡】与授权盖章口令。
- [ ] 包含了红线清册、一键打包脚本与 5 分钟极客汇报演练。
- [ ] 包含了全套 10 课 PowerShell 自动化校验通过逻辑。
