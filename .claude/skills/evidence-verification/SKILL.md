---
name: evidence-verification
description: Automate end-to-end evidence collection using QA Subagent equipped with Playwright MCP and Chrome DevTools MCP. Extract four categories of evidence and generate docs/LESSON_07_EVIDENCE_INDEX.md with minimal YAML frontmatter.
---

# Evidence Verification Skill (QA Subagent 双 MCP 证据链落盘护栏)

唤醒自动化证据链验收护栏，通过 **QA Subagent** 协同 **Playwright MCP** 与 **Chrome DevTools MCP**，驱动浏览器完成端到端测试，落盘四类证据与 `LESSON_07_EVIDENCE_INDEX.md`。

---

## 最小受控护栏与规则 (Minimal Rules)

1. **端口自适应与视窗提示**：自动识别 Vite 实际端口 (`5173`/`5174`)。Task 1 运行 Headed 模式时提示：“💡 若未自动弹窗，请检查任务栏或防火墙拦截”。
2. **日志上限截断 (Max 50 Lines)**：Chrome DevTools MCP 提取 Console 日志时仅保留最后 50 条关键轨迹，打码 `<REDACTED>`，防止上下文爆满。
3. **FAIL 自动转接 L06**：测试未 PASS 时，QA Subagent 自动提示：“回复‘唤醒 diagnosing-bugs’即可无缝修复阻断点”。

---

## 《四类证据链验收总卡》极简模板 (`docs/LESSON_07_EVIDENCE_INDEX.md`)

落盘文件顶部必须包含 4 行标准 YAML Frontmatter，供第 8 课 Codex 独立审查读取：

```markdown
---
status: PASS
test_scenario: Given-When-Then
executor: qa-tester
evidence_count: 4
---

# 第 7 课四类证据链验收总卡 (LESSON_07_EVIDENCE_INDEX.md)

## 1. 四类证据链物理落盘索引
- [x] 视觉证据：docs/assets/lesson-07/screenshot.png (UI 渲染正常)
- [x] 行为证据：docs/assets/lesson-07/action.log (DevTools 0 报错, 仅限 127.0.0.1)
- [x] 工程证据：docs/assets/lesson-07/typecheck.log (verify-project.ps1 PASS)
- [x] 范围证据：docs/assets/lesson-07/diff.patch (Working Tree Clean)

## 2. 人在回路 (HITL) 签署
- **签署口令**：复核四类证据链无误，同意签署第 7 课验收盖章
```
