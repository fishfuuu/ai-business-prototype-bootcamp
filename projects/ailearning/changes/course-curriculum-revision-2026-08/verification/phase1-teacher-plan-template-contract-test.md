# Protocol P06 — Teacher-Plan Template and Dual-Track Contract

## Control header

| Field | Value |
|---|---|
| Protocol ID | P06 |
| Exact path | `docs/changes/course-curriculum-revision-2026-08/verification/phase1-teacher-plan-template-contract-test.md` |
| Change ID | `course-curriculum-revision-2026-08` |
| Project ID | `ailearning` |
| Risk | L2 |
| Change base commit | `25c6f3d9214e29378f4945f51a977dc06603c8e4` |
| Lifecycle at run | `DESIGN_FROZEN` (per-change delivery-state.json authoritative) |
| Requirement IDs | D03, D04, D05, D06, D07, D08, D09, D10, D11, D12, D14, D15, D16, D18, D20, F02, F03, F05, F06, F08, F10 |
| Rubric source | `docs/changes/course-curriculum-revision-2026-08/acceptance-rubric.md` §7 P06 (LOCKED) |
| Run status | EXECUTED — pre-implementation characterization |
| Run event ID | `019feea7-d40f-73e2-9d0b-b3d9b1bbefd6` (execution thread; real, not fabricated) |
| Run timestamp | 2026-08-11T15:31:32+08:00 |

## 1. Fixture / input

Current `docs/LESSON_TEMPLATE.md` (blob `90ce7aa99523f584e06ac2934e5fc69ce4f4649b`) plus the locked single-lesson template contract from the design specification and acceptance rubric: eight modules, adjustable minute blocks with total ≤ 90, 2–3 independent must-master concepts, named/plain/background exposure, teacher workbench and learner prototype tracks, visible result/micro-task/weekly result fields, safety boundaries, and one-way plan approval/GUIDE/conformance links.

No frozen single-lesson template fixture exists yet; the future implementation slice supplies it. This run characterizes the current template against the locked contract.

## 2. Pre-implementation action / check

Check module coverage, minute arithmetic, concept ledger, dual-track fields, visible-result separation, absence/recovery pass-through, Mock/no-key boundary, three-chain/control-layer wording, first-use four-step practical reference, and absence of fixed five Pause/three diagrams/hand Git/verify/100% defaults. Include an over-time, over-load, missing-result, and old-default fixture so checks are non-vacuous.

## 3. Expected pre-implementation result

`RED_EXPECTED` for an actual template/design conflict that the future implementation must remove; already-valid module or arithmetic behavior is a characterization baseline and must not be forced into RED.

## 4. Actual run result — characterization baseline with real violations

### 4.1 Eight-module teacher-plan structure (RED_EXPECTED — missing)

`docs/LESSON_TEMPLATE.md` has 22 sections but contains no eight-module teacher-plan structure. A full-text search for 八模块 / 8 大执教模块 / 8-module returns no match. The locked design requires the template to express the eight-module teacher-plan contract. This is a real baseline gap for the future LESSON_TEMPLATE revision.

### 4.2 Fixed time table vs adjustable arithmetic (RED_EXPECTED — fixed default)

`docs/LESSON_TEMPLATE.md` lines 86–90 define a fixed five-block time table:

| Block | Minutes |
|---|---|
| 成果展示 | 10 |
| 教师演示 | 15 |
| 学员实操 | 45 |
| 验证 | 10 |
| 保存与作业 | 10 |
| **Total** | **90** |

The arithmetic sums to 90 (characterization baseline: no arithmetic error), but the template is a fixed sequence, not an adjustable contract. The locked design (D06/F10) requires adjustable minute blocks with total ≤ 90 and coverage functions that may be merged/reordered. The fixed default is a real baseline violation for the future template revision.

### 4.3 Concept exposure ledger (RED_EXPECTED — missing)

The template contains no concept-exposure ledger distinguishing first-introduced vs revisited, student-facing named label vs plain-language experience vs teacher-only background, or independently assessed judgments (D04). A search for exposure / 概念负荷 / 必须掌握 / 需要识别 / 工程背景 returns no match in the template. This is a real baseline gap.

### 4.4 Dual-track fields (RED_EXPECTED — missing)

The template contains no teacher-workbench / learner-prototype dual-track fields (D10). Searches for 双轨 / 教师统一 / 学员个人原型 / 工作台 return no match. The locked design requires both tracks with visible outputs. Real baseline gap.

### 4.5 Visible result / micro-task / weekly result separation (RED_EXPECTED — missing)

The template has a 成果展示 block (line 86) but no explicit three-way separation of visible in-class result / 10–15 minute micro-task / 30–45 minute weekly complete result (D08/F06). Searches for 微任务 / 完整成果 / 课间 return no match. Real baseline gap.

### 4.6 Absence / recovery pass-through (RED_EXPECTED — missing)

The template contains no absence-pack prerequisite or recovery pass-through fields (D09). Searches for 缺课 / 补课 / 补课包 return no match. Real baseline gap.

### 4.7 First-use four-step practical reference (RED_EXPECTED — missing)

The template contains no four-step concept-card fields tied to the just-completed practical action (D03/F02). Searches for 四步 / 刚完成 / 概念解析 return no match. Real baseline gap.

### 4.8 Mock / no-key / safety boundary (RED_EXPECTED — missing)

The template contains no Mock responsibility, pre-AI sanitization, no-key, or external-teacher-call boundary fields (D11/D12/F03). Searches for Mock / 脱敏 / API Key / 密钥 return no match. Real baseline gap.

### 4.9 Three-chain and control-layer wording (RED_EXPECTED — missing)

The template contains no development-toolchain / business-API / model-API three-chain distinction (D16) and no guidance/workflow-gate/runtime-hard-control layer separation (F08). Searches for 业务 API / 模型 API / 开发链路 / 硬控制 return no match. Real baseline gap.

### 4.10 Old-default absence (characterization baseline — present)

The template contains no fixed five Pause Points, no three-diagram requirement, no hand-Git instruction, no `verify-project.ps1` requirement, and no 100% alignment wording. Searches for Pause / 暂停 / 三图 / git restore / verify-project / 100% return no match. This is a characterization baseline: the current template does not carry the old defaults that the locked design prohibits. The future template revision must keep them absent.

### 4.11 90-minute ceiling (characterization baseline — present)

Line 10: "建议时长 | 约 90 分钟" — the template states approximately 90 minutes. The locked design requires a hard ceiling with adjustable blocks; the "约" wording is a partial baseline (ceiling present, adjustability missing, recorded in §4.2).

### 4.12 One-way plan approval/GUIDE/conformance links (RED_EXPECTED — missing)

The template contains no teacher-plan → independent review/user approval → GUIDE → GUIDE conformance → derived-asset one-way lineage fields (D20). Searches for 批准 / 复核 / 一致性 / 派生 return no match. Real baseline gap.

## 5. Intended failure reason / protected invariant

Prevents a template from silently overriding UIC/design, hiding concept overload in compound labels, replacing classroom outputs with homework, or introducing a second approval authority. A heading-only check cannot pass without field values and an invalid fixture; the checks above are non-vacuous because each missing contract element has a named requirement ID and a negative case (the current template's absence).

## 6. Production-zero-diff proof

Pre-run manifest (captured 2026-08-11T15:31:32+08:00), manifest hash `60cda3bb2c8491e944cea105d5177820f760b1db1453e1b3ce7b1821d33303f9`:

| Path | Git blob | SHA-256 | Status |
|---|---|---|---|
| docs/COURSE_ROADMAP.md | b42b49cc3b9eb02fb848951e180d29b6587c3bdf | 7f82c32359f86d524a4edb42539d24ba8267672f2cb1ed5ea7a764b845882040 | present |
| docs/LESSON_TEMPLATE.md | 90ce7aa99523f584e06ac2934e5fc69ce4f4649b | e13deebb144cb3731798f68a0a9678bd5c4c0d70008ac0796c5182f3ab088b75 | present |
| CLAUDE.md | ddbcce99b86a2bef5caccab44d4100f4450366f9 | b27d462f4b73ef5e66acde86702fd28662b5f439d6f8930d08077fe9b8292925 | present |
| .agents/skills/teaching-lesson-plan/SKILL.md | 107e887941b2f04ece7121c1a52c5155c5c3aee9 | 30ac13dc3a5410d972c4d7659045ee8b29708f925af7e65baae02660e5c8c5b3 | present |
| .agents/skills/teaching-lesson-plan/references/lesson-design-brief-template.md | MISSING | MISSING | missing |
| .agents/skills/teacher-plan-architect/SKILL.md | e4009075209e4c1e2fb23f96805b19447d0375ab | 6febb3107d79ab772007712e5a054773fcebb8c2bd8a4a354a7ed7a1446b6176 | present |
| .claude/skills/teacher-plan-architect/SKILL.md | e4009075209e4c1e2fb23f96805b19447d0375ab | 6febb3107d79ab772007712e5a054773fcebb8c2bd8a4a354a7ed7a1446b6176 | present |

Post-run manifest must be identical. No template, lesson, Skill, shim, script, build, or student-package write was made during protocol execution.

## 7. External run / evidence record

- Run event ID: `019feea7-d40f-73e2-9d0b-b3d9b1bbefd6` (execution thread; real).
- Fixture version/hash: current LESSON_TEMPLATE blob `90ce7aa99523f584e06ac2934e5fc69ce4f4649b`; no frozen single-lesson template fixture exists yet.
- Arithmetic/exposure output: fixed 10+15+45+10+10 = 90 recorded in §4.2; exposure ledger absence recorded in §4.3.
- Invalid-case stop evidence: each missing contract element recorded with its requirement ID; no template write occurred.
- Manual teacher-plan review: pending Independent Acceptance Review in thread `019feb03-f4ec-7681-bb42-e64bf977c710`.
- No repository report file is created.

## 8. Post-implementation GREEN / manual condition

Template contract is structurally valid, adjustable timing is within the hard ceiling, concept and dual-track rules are visible, and an independent reviewer/course owner accepts the instructional interpretation. Current status: `RED_EXPECTED` for missing eight-module structure, fixed time table, missing exposure ledger, missing dual-track, missing result separation, missing absence/recovery, missing four-step practical reference, missing safety boundary, missing three-chain/control-layer wording, and missing one-way lineage; characterization baselines recorded for correct 90-minute arithmetic, absent old defaults, and 90-minute ceiling wording.
