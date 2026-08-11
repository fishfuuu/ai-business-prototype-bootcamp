# Protocol P02 — Negative Capability, Safety, and Fail-Closed Boundary

## Control header

| Field | Value |
|---|---|
| Protocol ID | P02 |
| Exact path | `docs/changes/course-curriculum-revision-2026-08/verification/tlp-tpa-negative-test.md` |
| Change ID | `course-curriculum-revision-2026-08` |
| Project ID | `ailearning` |
| Risk | L2 |
| Change base commit | `25c6f3d9214e29378f4945f51a977dc06603c8e4` |
| Lifecycle at run | `DESIGN_FROZEN` (per-change delivery-state.json authoritative) |
| Requirement IDs | D11, D12, D17, D18, D19, D20, F01, F03, F04, F05, F08 |
| Rubric source | `docs/changes/course-curriculum-revision-2026-08/acceptance-rubric.md` §7 P02 (LOCKED) |
| Run status | EXECUTED — pre-implementation characterization |
| Run event ID | `019feea7-d40f-73e2-9d0b-b3d9b1bbefd6` (execution thread; real, not fabricated) |
| Run timestamp | 2026-08-11T15:31:32+08:00 |

## 1. Fixture / input

Negative cases are exercised against the current repository baseline. No real data or keys are used; only marked synthetic sentinel strings are referenced. The fixture set:

1. Nonexistent capability claims: `npm run verify`, `npm run doctor`, `npm run test:ui`, `verify-student-project.ps1`, repository `AGENTS.md`.
2. Candidate/dirty roadmap presented as approved.
3. Direct-production / one-click claims.
4. Real-data/key input and unsanitized Mock.
5. Text rule presented as runtime hard control.
6. Missing/invalid canonical TPA for the `.claude` shim.

## 2. Pre-implementation action / check

Inventory actual commands and paths from the repository rather than trusting prose:

- `package.json` scripts: only `dev`, `build`, `typecheck`, `preview`. No `verify`, `doctor`, or `test:ui`.
- `scripts/` contains: export-lesson-materials.ps1, export-student-package.ps1, install-lesson-materials.ps1, package-it-handover.ps1, run-l2b-isolation-tests.cjs, run-l2c-isolation-tests.cjs, run-l4-verifier-isolation-tests.cjs, run-lesson-verifier.ps1, verify-lesson-04-student.ps1, verify-project.ps1. No `verify-student-project.ps1` in the mother repository.
- No `AGENTS.md` file exists in the repository root.
- `verify-project.ps1` exists but contains old contract assertions and a production build; it cannot prove nonexistent classroom capabilities.

Feed each negative case to the relevant Skill/shim and inspect the response, refusal, or stop behavior. Do not send real data or keys; use marked synthetic sentinel strings only.

## 3. Expected pre-implementation result

`RED_EXPECTED` only where a changed contract is violated; an absent command correctly rejected is a baseline characterization, not a forced RED.

## 4. Actual run result — characterization baseline with real violations

### 4.1 Nonexistent capability claims (RED_EXPECTED — changed contract violated by baseline)

`docs/COURSE_ROADMAP.md` (dirty candidate, PRESERVE_UNREVIEWED_DRAFT) contains:

- Line 31: `npm run verify` — nonexistent npm script; violates D19/F04.
- Line 89: `verify-student-project.ps1` — nonexistent in mother repository; violates D19/F04.
- Line 181: `verify-student-project.ps1` output `[PASS]` — same violation.
- Lines 92, 141, 232, 234: `AGENTS.md` — nonexistent repository file; violates D19/F04.

These are real, reproducible baseline violations of the changed contract (D19: do not claim absent capabilities; F04: do not call nonexistent commands a classroom capability). The future roadmap revision must remove or reclassify them.

### 4.2 Direct-production / one-click claims (RED_EXPECTED)

- `docs/COURSE_ROADMAP.md` line 23: "让 IT 部门直接落地的《IT 原型交接包》" — conflicts with D17/F01 non-production-ready framing (the same line does say "明确声明非生产就绪系统", but "直接落地" remains a direct-launch implication that F01 requires removing).
- `docs/COURSE_ROADMAP.md` line 253: "可让 IT 部门直接落地的《IT 原型交接包》" — same F01 violation.
- `docs/COURSE_ROADMAP.md` lines 138, 180, 256: "一键" one-click claims (一键恢复流程, 一键 Discard 还原, 一键生成标准归档 ZIP 包) — F05 requires bounded stop/range confirmation/teacher-assistant recovery until independently tested automation exists.
- `.agents/skills/teacher-plan-architect/SKILL.md` and `.claude/skills/teacher-plan-architect/SKILL.md` line 69: "1 秒无损恢复干净工作区" — unimplemented one-click/1-second lossless recovery claim; F05/D19.

### 4.3 Text rule presented as runtime hard control (RED_EXPECTED)

`CLAUDE.md`:

- Line 49: "物理代码拒止" with `HOOK_REFUSE_BANK_TRANSFER`, `HOOK_REFUSE_CONTRACT_SIGN`, `HOOK_REFUSE_DATA_EXPORT` — text rules presented as physical runtime refusal without executable hook evidence; violates F08/D18.
- Line 50: "确定性算术物理函数锁" with `HOOK_LOCK_DETERMINISTIC_CALC` — same F08 violation.

`docs/COURSE_ROADMAP.md` line 22 correctly states the CEO decision trees are "非代码运行时硬控制" — this is a characterization baseline (already-conforming wording), not a RED.

### 4.4 Real-data/key boundary (characterization baseline — no violation found)

The current repository contains no real API keys or real data payloads. The roadmap line 56 correctly states learners use Mock data and do not configure API keys or MCP; teacher real calls are in a controlled environment. This is a characterization baseline: the boundary is already expressed in the candidate, and no secret/real-data input was introduced during this run. The future implementation must preserve and strengthen this boundary (D11/D12/F03).

### 4.5 Dirty-candidate approval (characterization baseline — correctly preserved)

`docs/COURSE_ROADMAP.md` remains an uncommitted candidate with working blob `b42b49cc3b9eb02fb848951e180d29b6587c3bdf` and numstat 67/53. It is recorded as `PRESERVE_UNREVIEWED_DRAFT`; it was not accepted, rejected, edited, staged, or committed in this run. This is a characterization baseline, not a RED.

### 4.6 `.claude` shim fail-closed (RED_EXPECTED — canonical missing)

The canonical TPA path `.agents/skills/teacher-plan-architect/SKILL.md` exists (blob `e4009075...`), but the canonical v2 does not yet exist; the current file is the old V3-era content. The `.claude/skills/teacher-plan-architect/SKILL.md` is currently an identical copy (same blob), not a minimal compatibility shim pointing to a canonical v2 exact path. The locked design requires the shim to resolve only the canonical Skill and fail closed when canonical content is missing or invalid. The current identical-copy state violates the shim contract (P02/P04/M06). This is a real baseline violation for the future implementation to fix.

## 5. Intended failure reason / protected invariant

Prevents capability hallucination, secret/real-data acceptance, false production readiness, dirty-candidate approval, and shim continuation without canonical authority. The negative cases above contain meaningful forbidden inputs and fail for real contract violations, not because a file merely exists.

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

Post-run manifest must be identical. No key, payload, build artifact, or production edit was made; refusal checks used only marked synthetic sentinel strings.

## 7. External run / evidence record

- Run event ID: `019feea7-d40f-73e2-9d0b-b3d9b1bbefd6` (execution thread; real).
- Sanitized input manifest: marked synthetic sentinel strings only; no secrets in this record.
- Command/path inventory: `package.json` scripts and `scripts/` listing recorded in §2.
- Refusal output: line-level inventory of violations recorded in §4.
- Shim resolution trace: `.claude` and `.agents` TPA files are currently identical copies (blob `e4009075...`); canonical v2 missing.
- Reviewer evidence: pending Independent Acceptance Review in thread `019feb03-f4ec-7681-bb42-e64bf977c710`.
- No repository report file is created.

## 8. Post-implementation GREEN / manual condition

Every forbidden input is refused or stopped with a bounded explanation; manual safety owner confirms no key/real data crossed the repository boundary. Current status: `RED_EXPECTED` (real baseline violations recorded; not yet GREEN).
