# Gate A Approval Card: course-curriculum-revision-2026-08

## Scope

课程级路线图修订、LESSON_TEMPLATE 对齐、TLP v2（含唯一 Brief contract）、TPA v2（canonical）、.claude shim 兼容入口、根 CLAUDE.md 维护规则更新。

Phase 1 边界：7 个 production 文件、6 个验收 protocol、0 个 report 文件。

## Non-goals

- L1-L10 单课教案、指南、派生资产（HTML/图片/学生包）——后续独立 change
- 脚本治理（doctor/test:ui/verify 等）——后续独立 change
- GLOSSARY.md——后续独立 change
- student-package/templates/CLAUDE.md——保持保护，不在本 Phase 1
- 任何课堂运行、试讲、真实教学证据——deferred programme evidence
- COURSE_ROADMAP.md 候选稿保持 PRESERVE_UNREVIEWED_DRAFT，本 Phase 1 不接受、不拒绝、不继续编辑

## Acceptance

- 7 个 production 对象在 ACCEPTANCE_FROZEN 后按顺序实施，须结构合规于 UIC D01-D20/F01-F10
- 6 个 protocol 在 DESIGN_FROZEN 后创建并运行，预期产生真实 RED 证据
- production zero-diff 在每次 protocol 运行前后验证
- 人工验收 M01-M08 由独立评审/课程负责人完成
- Gate A 语义不变时可直接进入 ACCEPTANCE_FROZEN；语义变化须重新 Gate A

## Files

Production file:
```
docs/COURSE_ROADMAP.md
docs/LESSON_TEMPLATE.md
CLAUDE.md
.agents/skills/teaching-lesson-plan/SKILL.md
.agents/skills/teaching-lesson-plan/references/lesson-design-brief-template.md
.agents/skills/teacher-plan-architect/SKILL.md
.claude/skills/teacher-plan-architect/SKILL.md
```

## Runtime

- 无运行时代码变更；纯文档/Skill 修订
- 不创建 doctor/test:ui/verify 脚本
- 不运行会写构建产物的测试
- runtime-sync l2-implement-loop/tm OUTDATED 为已知非阻断项，不作为 gate 证据

## Risk

- 概念过载风险：通过 D04 每课 2-3 概念限制和 D2a exposure ledger 缓解
- 术语漂移风险：通过 F01-F10 闭环和 authority chain 缓解
- 虚构能力风险：通过 D19/P02 negative test 缓解
- 安全风险：通过 D11/D12 Mock/脱敏/密钥边界缓解
- 下游反向漂移：通过 D20 单向 authority 链缓解

## User approval

Approved by: user
Date: 2026-08-11
Source thread: 019feb03-f4ec-7681-bb42-e64bf977c710
Decision: 批准 Gate A — Phase 1 可进入 DESIGN_FROZEN 及后续验收流程

## 4. Machine-readable canonical file set

machine_marker: canonical_file_set
```
docs/COURSE_ROADMAP.md
docs/LESSON_TEMPLATE.md
CLAUDE.md
.agents/skills/teaching-lesson-plan/SKILL.md
.agents/skills/teaching-lesson-plan/references/lesson-design-brief-template.md
.agents/skills/teacher-plan-architect/SKILL.md
.claude/skills/teacher-plan-architect/SKILL.md
```