---
name: diagnose
description: 6-phase facts-anchored debugging skill. Build reproducible PASS/FAIL feedback loops, checkpoint before edits, reproduce facts without guessing, run the 5-layer diagnostic to form falsifiable hypotheses, read minimal evidence, apply bounded fixes with a 2-round circuit breaker, and persist a 6-item evidence package to LESSON_06_DEBUG_REPORT.md with secrets redacted.
---

# Diagnose Skill（$diagnose：事实锚定、有界排错与证据落盘护栏）

> **来源致谢 / Source**: 本 Skill 改编自 [mattpocock/skills](https://github.com/mattpocock/skills)（MIT License，© Matt Pocock），并按本课程“业务主管制作原型”场景做教学化改造。

唤醒 $diagnose 排错护栏，在 Agent 进行任何代码修改或 Bug 修复之前，强制执行 6 阶段事实锚定、有界排错与证据落盘流程。主管在 Task 1 激活本 Skill 后全程运行：Agent 执行全部技术诊断，主管在每个 Phase 边界做审查与决策（审事实报告、选主假设、核对范围、验证结果、记录证据），不做机械操作。

---

## 6 阶段排错范式（Phase 1—6）

### Phase 1 — 构建反馈循环与无痛存档 (Feedback Loop & Checkpoint)

1. **排错前无痛存档 (Checkpoint before Debug)**：动任何源码前，先执行：
   ```bash
   git commit -m "checkpoint: before lesson 6 debug"
   ```
   *物理价值*：确保后续 2 轮硬熔断回滚时，`git restore .` 只扫除坏尝试，绝不抹杀过去积累的合法成果。
2. **可重复的 PASS/FAIL 信号**：先建立可重复执行的验证手段（物理刷新试衣镜观察页面行为 / 控制台真实断言），没有验证信号绝不盲改代码。
3. **隐私与脱敏前置红线**：
   `⚠️ 绝对禁止直接复制 DevTools Network 抓包原始文本或环境 Authorization Token/Key 输入对话框`。所有日志输出中，敏感 Key/Token 统一打码为 `<REDACTED>`。

### Phase 2 — 复现与事实卡 (Reproduce & Fact Card)

1. 复现预置故障，只记录**可观察事实**，禁止写入猜测：
   - 故障现象：（只写看到什么）
   - 复现步骤：（怎样触发）
   - 控制台信息：（脱敏后第一行报错，如有）
   - 数据状态：（字段值是什么）
2. **事实与假设分开记录**：事实是看到的，假设是想到的；不得把猜测写进事实卡。

### Phase 3 — 五层诊断与可证伪假设 (Five-Layer Diagnosis & Hypotheses)

1. **五层诊断卡**，从 Layer 1 开始逐层排除，禁止跳层：
   - **Layer 1 环境层**：Node/Vite 服务是否正常运行？有无网络阻断或依赖缺失？
   - **Layer 2 数据源层**：`prototype-data.ts` 种子数据是否正确装载？有无 `null` 空指针或拼写错误？
   - **Layer 3 状态层**：Vue 组件响应式状态 (`ref` / `reactive`) 与事件回调驱动流转是否断裂？
   - **Layer 4 日志层**：Browser Console / Terminal 真实 Error Trace（必须完整提取并打码 `<REDACTED>`）。
   - **Layer 5 契约断言层**：UI 呈现是否与 `prototype-contract.d.ts` 数据契约 100% 对齐？
2. 输出每层结论（PASS / FAIL / 不适用），定位到**最可能的一层**（只选一层）。
3. 生成 **3—5 个可证伪假设并排序**，标明唯一主假设。不要同时提多个主假设。

### Phase 4 — 插桩确认与最小证据 (Instrument & Minimal Evidence)

1. **最小证据读取**：只读契约文件（`src/types/prototype-contract.d.ts` / `docs/BUSINESS_FEATURE_CARD.md`）与故障相关的页面代码，不读取无关文件。
2. 确认主假设后提出**修复方案**：改什么文件、改什么字段、改几处，等待主管核对范围后才执行修改。
3. 排错范围严格限定在“界面呈现与 `prototype-contract.d.ts` 契约不一致”等领域；**严禁深挖底层**（禁止重构 Vue 响应式核心、Vite 编译插件或 node_modules）。

### Phase 5 — 最小化修复、回归验证与 2 轮硬熔断 (Bounded Fix & Circuit Breaker)

1. **最小化补丁修补**：每次修改只做针对性修复，严禁捎带大面积重构。
2. **实际回归验证**：修复后物理刷新试衣镜，基于可观察结果判断（不是 AI 自称“已修复”）：
   - 通过 → 进入 Phase 6 记录；
   - 不通过 → 调整假设进行第二轮（仍限定范围）；
3. **2 轮硬熔断规则 (Circuit Breaker)**：同一 Bug 最多允许 Agent 自修 **2 轮**；每轮修复后必须基于 Phase 1 建立的反馈信号验证。
   - 若 2 轮修复后仍然 FAIL：**强制引发熔断暂停**，执行 `git restore .` 恢复到 Checkpoint Commit 状态，将问题打上 `step-6-blocked.patch` 补丁，呈报主管裁决（停止/升级），不得尝试第三轮。

### Phase 6 — 清理复盘与证据包落盘 (Cleanup & Evidence Package)

1. **清理**：清理调试日志与临时文件。
2. **证据包落盘** `docs/LESSON_06_DEBUG_REPORT.md`，必须包含以下 6 项：
   ```markdown
   # 第 6 课 Bug 诊断与熔断报告 (LESSON_06_DEBUG_REPORT.md)

   1. 事实卡：（Phase 2 的可观察现象）
   2. 主假设：（Phase 3 的可证伪主假设）
   3. 诊断过程：（五层排查结论，定位到哪一层）
   4. 修复结果：（改了什么，验证是否通过）或 停止原因：（两轮无进展 / 证据不足 / 风险越界）
   5. 新证据需求：（如果停止，需要什么新证据才能继续）
   6. 恢复责任人：（谁来接手，名字和角色）
   ```
3. 更新 `docs/PROJECT_STATE.md`，记录诊断/恢复记录与下一课输入说明。