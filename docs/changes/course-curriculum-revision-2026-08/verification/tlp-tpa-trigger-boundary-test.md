# Protocol P03 — Trigger and Fallback Boundary

## Control header

| Field | Value |
|---|---|
| Protocol ID | P03 |
| Exact path | `docs/changes/course-curriculum-revision-2026-08/verification/tlp-tpa-trigger-boundary-test.md` |
| Change ID | `course-curriculum-revision-2026-08` |
| Project ID | `ailearning` |
| Risk | L2 |
| Change base commit | `25c6f3d9214e29378f4945f51a977dc06603c8e4` |
| Lifecycle at run | `DESIGN_FROZEN` (per-change delivery-state.json authoritative) |
| Requirement IDs | D01, D02, D03, D04, D07, D09, D13, D14, D15, D17, D20, F06, F07, F09 |
| Rubric source | `docs/changes/course-curriculum-revision-2026-08/acceptance-rubric.md` §7 P03 (LOCKED) |
| Run status | EXECUTED — pre-implementation characterization |
| Run event ID | `019feea7-d40f-73e2-9d0b-b3d9b1bbefd6` (execution thread; real, not fabricated) |
| Run timestamp | 2026-08-11T15:31:32+08:00 |

## 1. Fixture / input

Requests and boundary cases exercised against the current repository baseline:

1. Requests for learning goals/evidence/activity logic (TLP trigger).
2. Requests to write repository TEACHER_PLAN/GUIDE (TPA trigger).
3. Fixed seven-segment lesson sequences that may be merged/reordered.
4. L7 single browser entry / tool-unavailable fallback.
5. L8 isolated-session fallback.
6. Absence-pack prerequisite input.

## 2. Pre-implementation action / check

Exercise the TLP and TPA trigger boundaries separately; verify a tool failure selects the documented fallback rather than skipping the contract; verify a fixed sequence can be reorganized when coverage and total minutes remain correct; verify absence recovery blocks personal-mainline continuation until prerequisite evidence exists.

## 3. Expected pre-implementation result

Characterization baseline is expected for any already-valid fallback; `RED_EXPECTED` only when an old trigger or sequence rule violates the changed boundary.

## 4. Actual run result — characterization baseline with real violations

### 4.1 TLP/TPA trigger separation (RED_EXPECTED — baseline conflates triggers)

`.agents/skills/teaching-lesson-plan/SKILL.md` line 3 description says: "Use when asked to write a lesson plan, course outline, teaching session, workshop curriculum, or training module." This trigger set includes final lesson-plan production, which the locked design assigns to TPA. The TLP trigger must be limited to learning goals/evidence/activity logic (Lesson Design Brief), and the TPA trigger must be repository TEACHER_PLAN/GUIDE rendering. The current TLP trigger overlaps TPA's territory — a real baseline violation of the changed trigger boundary.

`.agents/skills/teacher-plan-architect/SKILL.md` line 3 description: "Master skill for designing high-caliber enterprise AI lesson plans and student guides" — the TPA trigger description also claims student-guide design, which requires prior independent review/user approval and is not a TPA self-authorization. This is a real baseline violation.

### 4.2 Fixed seven-segment sequence (RED_EXPECTED — old default)

`docs/LESSON_TEMPLATE.md` lines 86–90 define a fixed five-block time table (成果展示 10 + 教师演示 15 + 学员实操 45 + 验证 10 + 保存与作业 10 = 90). The locked design requires adjustable minute blocks with total ≤ 90 and allows coverage functions to be merged/reordered. The current template is a fixed sequence, not an adjustable contract — a real baseline violation of P06/P03 (D06/F10).

### 4.3 L7 single browser entry / tool-unavailable fallback (characterization baseline with partial coverage)

`docs/COURSE_ROADMAP.md` line 140 marks the automated browser verification script as "待实现教学资产，当前不作为课堂通过条件" — this is a characterization baseline (correctly marked future asset). Line 225 repeats the same correct marking. However, the roadmap does not yet explicitly state the single teacher-preconfigured browser entry or the tool-unavailable fallback path for L7; the locked design (D14/F07) requires these to be explicit. This is recorded as a partial baseline: the future roadmap revision must add the single-entry and fallback wording.

### 4.4 L8 isolated-session fallback (characterization baseline with partial coverage)

`docs/COURSE_ROADMAP.md` lines 92–93, 121–122, 141, 231–234 describe independent context-isolated review sessions for L8. This is directionally consistent with D15. However, the explicit fallback "when the branded tool is unavailable, use an isolated new session rather than skipping review" is not yet stated; the future roadmap revision must add it. Recorded as partial baseline, not RED.

### 4.5 Absence-pack prerequisite (characterization baseline — present)

`docs/COURSE_ROADMAP.md` line 76: "缺课者跟随教师标准案例，补齐 20–30 分钟补课包后方可恢复个人项目主线" — the prerequisite gate (absence pack before personal mainline) is present and consistent with D09. This is a characterization baseline, not a RED.

### 4.6 Three-minute takeover (characterization baseline — present)

`docs/COURSE_ROADMAP.md` line 74: "课堂环境问题超过 3 分钟由助教接管，不阻塞教师主线" — consistent with D07. Characterization baseline, not a RED.

### 4.7 Six-mode positioning (RED_EXPECTED — missing from candidate)

The dirty roadmap candidate contains no explicit six-collaboration-mode inventory with three deep/three recognition labels (D13/F09). The locked design requires the six modes as a supervisor decision framework. The absence in the candidate is a real baseline gap the future roadmap revision must close. Recorded as RED_EXPECTED (missing changed-contract content), not a forced failure.

## 5. Intended failure reason / protected invariant

Protects actor responsibility, non-mechanical learning sequence, three-minute takeover/absence boundaries, single-entry MCP exposure, isolated review, and non-production L10 framing. A trigger test must assert resulting responsibility/output, not just the trigger word.

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

Post-run manifest must be identical. No lesson, Skill, root policy, shim, or roadmap edit was made during this run.

## 7. External run / evidence record

- Run event ID: `019feea7-d40f-73e2-9d0b-b3d9b1bbefd6` (execution thread; real).
- Prompt/input set: the six boundary cases in §1.
- Selected actor: TLP/TPA trigger analysis against current Skill descriptions.
- Fallback branch: L7/L8 fallback wording assessed as partial baseline (§4.3/§4.4).
- Minutes calculation: LESSON_TEMPLATE fixed 10+15+45+10+10 = 90 assessed in §4.2.
- Isolation/takeover event: roadmap lines 74/76/92–93/121–122 assessed in §4.5/§4.6.
- Reviewer evidence: pending Independent Acceptance Review in thread `019feb03-f4ec-7681-bb42-e64bf977c710`.
- No repository report file is created.

## 8. Post-implementation GREEN / manual condition

TLP/TPA triggers are separated, fallback is bounded, sequence can be merged/reordered without losing coverage, and teacher/course-owner manual review accepts the boundary. Current status: `RED_EXPECTED` for trigger conflation, fixed sequence, and missing six-mode content; characterization baselines recorded for present fallback/absence/takeover wording.
