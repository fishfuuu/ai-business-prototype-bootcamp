---
name: codex-audit
description: Execute independent read-only audit using Codex Auditor. Validate evidence index frontmatter, code boundaries, and risk checklist, persisting docs/LESSON_08_AUDIT_REPORT.md.
---

# Codex Audit Skill (多 Agent 独立审查护栏)

唤醒独立只读审查护栏，通过 **Codex Auditor** (`.claude/agents/codex-auditor.md`) 对 Candidate Commit 进行物理隔离盲审，落盘 `docs/LESSON_08_AUDIT_REPORT.md`。

---

## 多 Agent 审查与落盘规则

1. **完全只读，禁止改码**：Codex 只能读取 `LESSON_07_EVIDENCE_INDEX.md`、`git diff` 与类型检查日志，绝不上手修改任何工程源码。
2. **三项死扣断言**：
   - 断言 1：`LESSON_07_EVIDENCE_INDEX.md` Frontmatter 必须为 `status: PASS`。
   - 断言 2：`git diff` 修改文件 100% 在 `allowed_files` 许可名单中。
   - 断言 3：代码无未捕获异常或 `any` 契约断裂。
3. **物理落盘审计报告 (`docs/LESSON_08_AUDIT_REPORT.md`)**：

```markdown
---
audit_status: PASS
auditor: codex-auditor
candidate_sha: [Candidate Commit SHA]
audit_timestamp: [ISO Timestamp]
---

# 第 8 课 Codex 独立审查报告 (LESSON_08_AUDIT_REPORT.md)

## 1. 独立审查判定
- **审查结论**：PASS (批准合并) / REJECT (驳回修改)
- **风险等级**：LOW / MEDIUM / HIGH

## 2. 审计项核对表
- [x] 四类证据链总卡 Frontmatter 校验：PASS
- [x] 代码修改范围边界比对：Clean (无超界文件)
- [x] TypeScript 类型契约匹配：PASS

## 3. 主管裁决 (HITL Arbitration)
- **主管裁决指令**：同意合并 Candidate Commit 至主分支
```
