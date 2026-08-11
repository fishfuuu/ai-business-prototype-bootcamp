# Task Board
Version: 2.1

## Mission
course-curriculum-revision-2026-08

## Protocol State
- **Mode:** EXECUTE
- **Current Step:** A-RED-PROTOCOLS
- **Step Owner:** Codex execution task 019feea7-d40f-73e2-9d0b-b3d9b1bbefd6
- **Delivery Lifecycle:** DESIGN_FROZEN
- **Frozen Plan Version:** Gate A approved 2026-08-11; Gate A card at docs/changes/course-curriculum-revision-2026-08/gate-a-card.md
- **Acceptance Criteria:**
- S0 through S1F complete; A-RUBRIC-DRAFT approved by Independent Reviewer.
- Formal Independent Design Review: APPROVED.
- User Gate A: APPROVED 2026-08-11 by user in thread 019feb03-f4ec-7681-bb42-e64bf977c710.
- Lifecycle: DESIGN_FROZEN; UIC LOCKED; acceptance rubric LOCKED.
- 7 production files registered in delivery-state: docs/COURSE_ROADMAP.md, docs/LESSON_TEMPLATE.md, CLAUDE.md, .agents/skills/teaching-lesson-plan/SKILL.md, .agents/skills/teaching-lesson-plan/references/lesson-design-brief-template.md, .agents/skills/teacher-plan-architect/SKILL.md, .claude/skills/teacher-plan-architect/SKILL.md.
- 6 protocol paths defined in acceptance-rubric.md embedded RED Test Plan; not yet created or run.
- A-RED-PROTOCOLS: create and run the 6 protocol files with production zero-diff; record real pre-implementation failure evidence; do not modify any production file.
- docs/COURSE_ROADMAP.md remains PRESERVE_UNREVIEWED_DRAFT.
- **Open Decisions:**
- After A-RED-PROTOCOLS produces real RED evidence, Independent Acceptance Review is required before ACCEPTANCE_FROZEN.
- Production implementation only after ACCEPTANCE_FROZEN, in order: ROADMAP -> LESSON_TEMPLATE -> root CLAUDE -> TLP v2 + Brief contract -> canonical TPA v2 -> .claude shim.
- **Risks Blockers:**
- Global change-state.json mirror is missing; non-blocking governance follow-up.
- Runtime-sync l2-implement-loop/tm OUTDATED; observed, not repaired, not used as gate evidence.

## Active Tasks
| ID | Description | Assignee | Status | Priority |
| --- | --- | --- | --- | --- |
| S0 | Register L2 DRAFT state and capture User Intent Contract | Codex execution task | Complete | P0 |
| S1A-S1F | Draft design specification through focused design approval | Codex execution task | Complete | P0 |
| A-RUBRIC-DRAFT | Create DRAFT acceptance-rubric.md with D01-D20/F01-F10 mapping and embedded RED Test Plan | Codex execution task | Complete — approved by Independent Reviewer | P0 |
| DESIGN-REVIEW | Formal Independent Design Review | Codex Independent Reviewer | Complete — APPROVED | P0 |
| GATE-A | User Gate A approval | User | Complete — APPROVED 2026-08-11 | P0 |
| A-RED-PROTOCOLS | Create and run 6 protocol files with production zero-diff; record real RED evidence | Codex execution task | Complete — 6 protocols created and run; real RED evidence recorded; awaiting Independent Acceptance Review | P0 |
| A-ACCEPTANCE-REVIEW | Independent review of rubric/protocol semantics, failure causes, and run evidence | Independent Reviewer | Not yet authorized | P0 |
| IMPLEMENTATION | Modify 7 production files in order after ACCEPTANCE_FROZEN | Unassigned | Not authorized | P0 |

## Communication Log
- 2026-08-11T07:10:58Z — DESIGN_REVIEWED transition recorded; Formal Independent Design Review APPROVED.
- 2026-08-11T07:14:39Z — Production files registered (7 paths) via gate-a-card.md.
- 2026-08-11T07:17:09Z — DESIGN_FROZEN transition recorded; Gate A baseline captured (UIC/design/rubric SHA-256 + production files hash). UIC status changed to LOCKED.
- 2026-08-11T07:20:00Z — Task board updated to Version 2.0; A-RED-PROTOCOLS dispatched to execution task.
- 2026-08-11T07:31:32Z — A-RED-PROTOCOLS executed: 6 protocol files created under docs/changes/course-curriculum-revision-2026-08/verification/; each run recorded real pre-implementation evidence (RED_EXPECTED for changed-contract violations, characterization baseline for already-satisfied invariants); production manifest hash 60cda3bb2c8491e944cea105d5177820f760b1db1453e1b3ce7b1821d33303f9 unchanged pre/post; roadmap blob b42b49cc3b9eb02fb848951e180d29b6587c3bdf / numstat 67/53 preserved; staged area empty; no production/lifecycle/UIC/design/rubric write; no TESTS_RED transition recorded (reserved for Independent Acceptance Review).

## Shared Context
### Decisions
- Change ID: course-curriculum-revision-2026-08; project ID: ailearning; lifecycle: DESIGN_FROZEN.
- docs/COURSE_ROADMAP.md disposition: PRESERVE_UNREVIEWED_DRAFT.
- UIC v1.3, A01/A02, D01-D20 LOCKED.
- Acceptance rubric LOCKED; spec_lock LOCKED.
- Gate A card: docs/changes/course-curriculum-revision-2026-08/gate-a-card.md.
- 6 protocol paths in acceptance-rubric.md embedded RED Test Plan: tlp-tpa-forward-test.md, tlp-tpa-negative-test.md, tlp-tpa-trigger-boundary-test.md, tlp-tpa-schema-version-test.md, phase1-roadmap-conformance-test.md, phase1-teacher-plan-template-contract-test.md.
- Production implementation order after ACCEPTANCE_FROZEN: ROADMAP -> LESSON_TEMPLATE -> root CLAUDE -> TLP v2 + Brief contract -> canonical TPA v2 -> .claude shim.
- Phase 1 ACCEPTED does not reopen Phase 1 gates; later lesson/guide/asset/script changes need independent controlled changes.

### Conventions
- Lifecycle JSON managed only by delivery_gate.py; never hand-edit.
- Task board is coordination-only; cannot approve lifecycle transitions.
- Mirror absence does not authorize inference, transition, or scope expansion.

## Next Actor
- **Next:** Independent Reviewer (thread 019feb03-f4ec-7681-bb42-e64bf977c710)
- **Reason:** A-RED-PROTOCOLS complete — 6 protocol files created and run with real pre-implementation evidence; production zero-diff verified; perform A-ACCEPTANCE-REVIEW (rubric/protocol semantics, failure causes, run evidence) and decide whether to record TESTS_RED and enter ACCEPTANCE_FROZEN.
- **Last Updated:** 2026-08-11T07:31:32Z
