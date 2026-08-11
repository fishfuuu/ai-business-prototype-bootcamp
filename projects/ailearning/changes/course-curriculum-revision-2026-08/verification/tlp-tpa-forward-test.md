# Protocol P01 — TLP→TPA Forward Boundary

## Control header

| Field | Value |
|---|---|
| Protocol ID | P01 |
| Exact path | `docs/changes/course-curriculum-revision-2026-08/verification/tlp-tpa-forward-test.md` |
| Change ID | `course-curriculum-revision-2026-08` |
| Project ID | `ailearning` |
| Risk | L2 |
| Change base commit | `25c6f3d9214e29378f4945f51a977dc06603c8e4` |
| Lifecycle at run | `DESIGN_FROZEN` (per-change delivery-state.json authoritative) |
| Requirement IDs | D01, D02, D03, D04, D10, D11, D13, D14, D15, D16, D20, F02, F07, F09 |
| Rubric source | `docs/changes/course-curriculum-revision-2026-08/acceptance-rubric.md` §7 P01 (LOCKED) |
| Run status | EXECUTED — pre-implementation characterization |
| Run event ID | `019feea7-d40f-73e2-9d0b-b3d9b1bbefd6` (execution thread; real, not fabricated) |
| Run timestamp | 2026-08-11T15:31:32+08:00 |

## 1. Fixture / input

Per rubric P01, the frozen single-lesson input manifest is supplied by the future run event and is not created in this slice. For this pre-implementation run, the input fixture is the **current repository baseline**:

- `.agents/skills/teaching-lesson-plan/SKILL.md` (current working-tree content, blob `107e887941b2f04ece7121c1a52c5155c5c3aee9`)
- `.agents/skills/teacher-plan-architect/SKILL.md` (current working-tree content, blob `e4009075209e4c1e2fb23f96805b19447d0375ab`)
- `.claude/skills/teacher-plan-architect/SKILL.md` (current working-tree content, blob `e4009075209e4c1e2fb23f96805b19447d0375ab`)
- `docs/changes/course-curriculum-revision-2026-08/user-intent-contract.md` (LOCKED, v1.3, A01/A02)
- `docs/changes/course-curriculum-revision-2026-08/design-specification.md` (LOCKED)
- `docs/changes/course-curriculum-revision-2026-08/acceptance-rubric.md` (LOCKED)

No frozen single-lesson Brief fixture exists yet; the future implementation slice supplies it. This run therefore characterizes the current Skill boundary against the locked contract.

## 2. Pre-implementation action / check

Read the current TLP and TPA Skill files and check whether the current text already conforms to the locked forward-boundary contract:

1. TLP must be a Lesson Design Brief generator/method only; it must not claim to produce a final TEACHER_PLAN or GUIDE.
2. TPA must be the sole full renderer of the eight-module teacher plan; it must consume a valid Brief and must not self-approve or silently generate a GUIDE.
3. No GUIDE, derived asset, invented capability, or changed acceptance meaning may be emitted by the Skill text itself.

## 3. Expected pre-implementation result

`RED_EXPECTED` for any baseline violation of the separation/authority contract; any already-conforming wording is a characterization baseline and must not be manufactured into RED.

## 4. Actual run result — characterization baseline with real violations

### 4.1 TLP boundary violation (RED_EXPECTED — changed contract violated by baseline)

`.agents/skills/teaching-lesson-plan/SKILL.md` line 8:

> "Produces a complete, highly structured lesson plan and student guide for any subject, audience, or corporate setting."

This directly violates the locked TLP boundary: TLP must produce only a Lesson Design Brief, not a complete lesson plan and student guide. The locked design (design-specification, TLP/TPA layering) requires TLP to be the Brief generator and TPA to be the sole final renderer. This is a real, reproducible baseline violation of a changed contract; the future TLP v2 implementation must remove it.

Additional TLP baseline items that conflict with the locked contract and must be corrected by TLP v2:

- Line 3 description: "Design a structured lesson plan ... V3 Dual-Mode Student Guide architecture" — implies final lesson plan/GUIDE production.
- Line 6 title: "Advanced Pedagogy Fused Version V3" — V3 Dual-Mode Student Guide framing is not the locked design.
- Line 20: "V3 Dual-Mode Student Guide (双模学员指南)" — GUIDE production is TPA territory after approval.
- Line 110: `verify-project.ps1` verification method — capability/verification claims are governed by D19/F04; script governance is a future change.
- Line 147: "100% Constructive Alignment" — 100% alignment is not a locked requirement.
- Line 152: assessment bank "3–5 questions (Max 5)" — conflicts with the 2-minute exit budget; locked design requires 1–2 mandatory exit prompts with optional after-class bank.

### 4.2 TPA boundary violations (RED_EXPECTED — changed contract violated by baseline)

Both `.agents/skills/teacher-plan-architect/SKILL.md` and `.claude/skills/teacher-plan-architect/SKILL.md` (identical blob `e4009075...`) contain:

- Line 3: "Master skill for designing high-caliber enterprise AI lesson plans and student guides" — TPA must render the eight-module teacher plan only; GUIDE production requires prior independent review/user approval and is not a TPA self-authorization.
- Line 25: "5 个固定暂停点（Pause Points）" — fixed five Pause Points is an old default, not a locked requirement.
- Line 53: "PASS 双提交归档 与 FAIL 补丁快照清扫还原 双分支" — dual-commit is only a two-stage version/manager-confirmation metaphor (D18); PASS/FAIL patch-sweep restore is not a locked contract.
- Line 69: "1 秒无损恢复干净工作区" — one-click/1-second lossless recovery is an unimplemented capability claim (F05/D19).
- Line 78: `verify-project.ps1` `[PASS]` engineering evidence — script governance is a future change; verify-project.ps1 contains old contract assertions and production build and cannot prove classroom capability (F04).
- Line 79: "Working Tree 恢复 100% Clean" — 100% clean working tree is not a locked requirement.
- Line 86: "100% 匹配 8 大执教模块 标题，包含 5 个固定 Pause Points" — fixed five Pause Points and 100% matching are old defaults.
- Line 90: "模式 A (反例) + 模式 B (PASS/FAIL双分支) + 模式 C (机制图)" — fixed three-diagram requirement is not a locked contract.
- Line 93: "PowerShell 自动化校验脚本的 [PASS] 验证闭环" — same script-governance issue.

### 4.3 Characterization baseline (already-conforming items, not forced RED)

- TPA line 16 four-step concept definition framework (Definition → Mechanism → Metaphor → Handoff Value) is directionally consistent with D03/F02, but the locked design requires the fourth step to reference the just-completed practical action and handoff value; the current wording is a partial baseline, not a full conformance.
- TPA line 25 eight-module teacher-plan structure is directionally consistent with the locked eight-module contract; the fixed five Pause Points attached to it are the violation.
- No current Skill text emits a GUIDE or derived asset as an executable output; the violations are textual claims of production authority, not observed artifact emission. This is recorded as baseline context, not a pass.

## 5. Intended failure reason / protected invariant

The boundary prevents a Skill from becoming an artifact owner, bypassing Brief authority, or producing a GUIDE before independent review/user approval. A filename or heading alone is insufficient; the output-type and forbidden-output assertions must be non-empty and fail on a deliberately cross-triggered input. The violations above are real text-level violations of the changed contract and are reproducible by reading the exact lines.

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

Post-run manifest is captured in the shared verification evidence section of the A-RED-PROTOCOLS report; it must be identical to the pre-run manifest. Only this protocol path and the coordination task-board may change.

## 7. External run / evidence record

- Run event ID: `019feea7-d40f-73e2-9d0b-b3d9b1bbefd6` (execution thread; real).
- Fixture version: current repository baseline at HEAD `25c6f3d9214e29378f4945f51a977dc06603c8e4`; no frozen single-lesson Brief fixture exists yet.
- Output manifest: line-level inventory of TLP/TPA Skill text recorded in §4.
- Reviewer evidence: pending Independent Acceptance Review in thread `019feb03-f4ec-7681-bb42-e64bf977c710`.
- No repository report file is created.

## 8. Post-implementation GREEN / manual condition

After approved TLP/TPA implementation, the same frozen fixture yields Brief-only then eight-module-plan-only outputs, with manual course-owner confirmation of scope and no GUIDE. Current status: `RED_EXPECTED` (real baseline violations recorded; not yet GREEN).
