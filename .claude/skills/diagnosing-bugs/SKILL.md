---
name: diagnosing-bugs
description: Diagnosis loop for hard bugs and unexpected behavior. Build tight feedback loops, anchor facts with 5-layer diagnostics, redact secrets, enforce contract isolation, save checkpoint commits, persist LESSON_06_DEBUG_REPORT.md, and apply 2-round circuit breaker.
---

# Diagnosing Bugs Skill (事实锚定、报告落盘与无痛有界排错护栏)

唤醒 Bug 诊断护栏，在 Agent 进行任何代码修改或 Bug 修复之前，强制执行标准的 4 阶段事实锚定、无痛存档、报告落盘与有界排错流程。

---

## 4 阶段事实锚定与排错范式

### Phase 1 — Checkpoint Save & Feedback Loop (无痛存档与反馈闭环)
1. **排错前无痛存档 (Checkpoint before Debug)**：
   在动手改动哪怕 1 行源码前，必须先下发指令执行无痛检查点存档：
   ```bash
   git commit -m "checkpoint: before lesson 6 debug"
   ```
   *物理价值*：确保后续若引发 2 轮硬熔断回滚，`git restore .` 只会扫除坏尝试，绝不抹杀过去积累的合法成果。
2. **物理构建反馈闭环 (Build Feedback Loop)**：
   没有确切可重复执行的验证手段（如 `powershell -File .\scripts\verify-project.ps1` / 控制台断言脚本），绝不盲改代码。
3. **隐私与脱敏前置红线**：
   `⚠️ 绝对禁止直接复制 DevTools Network 抓包原始文本或环境 Authorization Token/Key 输入对话框`。所有日志输出中，敏感 Key/Token 统一打码为 `<REDACTED>`。

### Phase 2 — Fact Anchoring & Report Generation (五层事实锚定与报告落盘)
1. **五层诊断卡物理排查 (Five-Layer Diagnostic Map)**：
   - **Layer 1 环境层**：Node/Vite 服务是否正常运行？有无网络阻断或依赖缺失？
   - **Layer 2 数据源层**：`prototype-data.ts` 种子数据是否正确装载？有无 `null` 空指针或拼写错误？
   - **Layer 3 状态层**：Vue 组件响应式状态 (`ref` / `reactive`) 与事件回调驱动流转是否断裂？
   - **Layer 4 日志层**：Browser Console / Terminal 真实 Error Trace（必须完整提取并打码 `<REDACTED>`）。
   - **Layer 5 契约断言层**：UI 呈现是否与 `prototype-contract.d.ts` 数据契约 100% 对齐？
2. **《Bug 诊断与熔断报告》物理落盘**：
   在分析完成后，必须落盘写入 `docs/LESSON_06_DEBUG_REPORT.md`，包含以下格式：
   ```markdown
   # 第 6 课 Bug 诊断与熔断报告 (LESSON_06_DEBUG_REPORT.md)

   ## 1. 现象与 PASS/FAIL 验证闭环
   - **异常现象**：[描述]
   - **验证命令**：powershell -File .\scripts\verify-project.ps1
   - **基线状态**：FAIL (Checkpoint commit SHA: [SHA])

   ## 2. 五层诊断结论
   - Layer 1 (环境): PASS
   - Layer 2 (数据源): PASS
   - Layer 3 (组件状态): FAIL (状态变量未流转)
   - Layer 4 (日志): PASS (含有脱敏日志 <REDACTED>)
   - Layer 5 (契约断言): FAIL (字段与 prototype-contract 不对齐)

   ## 3. 修补方案与熔断计数
   - **排错范围**：契约层最小化修补
   - **当前自修轮次**：1 / 2
   - **熔断状态**：NORMAL (未引发熔断)
   ```

### Phase 3 — Bisection & Contract Isolation (二分定位与契约隔离)
1. **契约排错防跑偏**：排错范围**严格限定**在“界面呈现与 `prototype-contract.d.ts` 契约不一致”的领域。
2. **严禁深挖底层**：禁止试图重构 Vue 响应式核心、Vite 编译插件或 node_modules。
3. **二分定位法**：通过控制台埋点准确定位数据在流转到 UI 之前的断裂层级。

### Phase 4 — Bounded Fix & 2-Round Circuit Breaker (最小化修补与 2 轮硬熔断)
1. **最小化补丁修补**：每次修改只做针对性修复，严禁捎带大面积重构。
2. **2 轮硬熔断规则 (Circuit Breaker)**：
   - 同一个 Bug 最多允许 Agent 自修尝试 **2 轮**。
   - 每轮修复后必须运行 Phase 1 建立的反馈闭环验证，并更新 `docs/LESSON_06_DEBUG_REPORT.md` 中的计数。
   - 若 2 轮修复后仍然 `FAIL`：**强制引发熔断暂停**，执行 `git restore .` 恢复到 Checkpoint Commit 状态，并将问题打上 `step-6-blocked.patch` 补丁，呈报主管裁决。
