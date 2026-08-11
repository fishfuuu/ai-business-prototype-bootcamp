# Protocol P04 — Schema and Contract-Version Boundary

## Control header

| Field | Value |
|---|---|
| Protocol ID | P04 |
| Exact path | `docs/changes/course-curriculum-revision-2026-08/verification/tlp-tpa-schema-version-test.md` |
| Change ID | `course-curriculum-revision-2026-08` |
| Project ID | `ailearning` |
| Risk | L2 |
| Change base commit | `25c6f3d9214e29378f4945f51a977dc06603c8e4` |
| Lifecycle at run | `DESIGN_FROZEN` (per-change delivery-state.json authoritative) |
| Requirement IDs | D03, D04, D11, D13, D14, D15, D16, D18, D20, F02, F07, F08 |
| Rubric source | `docs/changes/course-curriculum-revision-2026-08/acceptance-rubric.md` §7 P04 (LOCKED) |
| Run status | EXECUTED — pre-implementation characterization |
| Run event ID | `019feea7-d40f-73e2-9d0b-b3d9b1bbefd6` (execution thread; real, not fabricated) |
| Run timestamp | 2026-08-11T15:31:32+08:00 |

## 1. Fixture / input

One valid Brief contract fixture with exact `contract_version`, plus missing-field, wrong-version, wrong-lesson, stale-source, duplicate-schema, and invalid-readiness variants. Include the TLP reference exact path and canonical TPA consumer declaration.

For this pre-implementation run, the fixture is the current repository baseline:

- `.agents/skills/teaching-lesson-plan/references/lesson-design-brief-template.md` — **MISSING** (does not exist).
- `.agents/skills/teaching-lesson-plan/SKILL.md` — current content, blob `107e887941b2f04ece7121c1a52c5155c5c3aee9`.
- `.agents/skills/teacher-plan-architect/SKILL.md` — current content, blob `e4009075209e4c1e2fb23f96805b19447d0375ab`.
- `.claude/skills/teacher-plan-architect/SKILL.md` — current content, blob `e4009075209e4c1e2fb23f96805b19447d0375ab`.

No Brief schema exists yet; the future TLP v2 implementation creates the single reference and its `contract_version`.

## 2. Pre-implementation action / check

Validate that TLP reference is the sole schema owner; TPA accepts only the compatible version and required fields; `HANDOFF_READY` is completeness rather than approval; wrong lesson/source/ref stops; `.claude` resolves only the canonical Skill and does not carry a second schema.

## 3. Expected pre-implementation result

`RED_EXPECTED` for any missing/changed schema contract introduced by the future implementation; valid pre-existing fields receive characterization baseline, not fabricated RED.

## 4. Actual run result — characterization baseline with real violations

### 4.1 Missing Brief schema reference (RED_EXPECTED — changed contract not yet implemented)

`.agents/skills/teaching-lesson-plan/references/lesson-design-brief-template.md` does not exist. The locked design requires this exact path as the single Brief schema owner with a `contract_version` field. Its absence is a real baseline gap that the future TLP v2 implementation must close. This is `RED_EXPECTED` for the changed contract, not a forced failure.

### 4.2 No `contract_version` anywhere (RED_EXPECTED)

Neither TLP nor TPA current text declares a Brief `contract_version`. The locked design requires the TLP reference to own the contract version and TPA to declare consumption of that exact version. Current baseline: no version field exists. Real baseline gap for the future implementation.

### 4.3 Duplicate-schema risk (RED_EXPECTED — identical copies)

`.agents/skills/teacher-plan-architect/SKILL.md` and `.claude/skills/teacher-plan-architect/SKILL.md` are currently identical copies (same blob `e4009075...`). The locked design requires `.claude` to be a minimal compatibility shim that resolves only the canonical Skill and carries no second schema, defaults, or approval logic. The identical-copy state is a real duplicate-authority baseline violation (P04/M06).

### 4.4 `HANDOFF_READY` semantics (characterization baseline — absent, not violated)

No current Skill text defines `HANDOFF_READY`; the locked design requires it to mean completeness only, never approval. Absence is a baseline gap for the future implementation, recorded as `RED_EXPECTED` for the missing changed-contract field rather than a forced failure.

### 4.5 Wrong-lesson / stale-source / invalid-readiness stop behavior (characterization baseline — no current mechanism)

No current Skill text implements wrong-lesson, stale-source, or invalid-readiness stop behavior. The future implementation must add these fail-closed checks. Recorded as `RED_EXPECTED` for the missing changed-contract mechanism.

### 4.6 Already-conforming baseline items (characterization baseline, not RED)

- The locked design's one-way authority chain (UIC → frozen design → approved roadmap → lesson artifacts) is expressed in the design specification and UIC; the current Skill files do not contradict it textually beyond the violations already recorded in P01/P02.
- No current Skill file claims to own a second Brief schema; the duplicate-schema risk is the identical TPA copies, recorded in §4.3.

## 5. Intended failure reason / protected invariant

Prevents schema drift, duplicated authority, guessed refs, and accidental approval semantics. A schema check must include a malformed non-empty fixture and a version mismatch that demonstrably stops downstream consumption. The future implementation must demonstrate these with real fixtures; this pre-implementation run records the baseline gaps.

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

Post-run manifest must be identical. Schema fixtures are in-memory or external run inputs; no reference file was created in this slice.

## 7. External run / evidence record

- Run event ID: `019feea7-d40f-73e2-9d0b-b3d9b1bbefd6` (execution thread; real).
- Fixture version/hash: current repository baseline at HEAD `25c6f3d9214e29378f4945f51a977dc06603c8e4`; no Brief schema fixture exists yet.
- Validator output: baseline gap inventory in §4.
- Canonical-resolution trace: `.claude` and `.agents` TPA files identical (blob `e4009075...`); canonical v2 missing.
- Wrong-version stop evidence: not yet implementable; recorded as future requirement.
- Reviewer evidence: pending Independent Acceptance Review in thread `019feb03-f4ec-7681-bb42-e64bf977c710`.
- No fabricated approval ref; no repository report file.

## 8. Post-implementation GREEN / manual condition

Valid version is consumed once, invalid/missing versions stop, and an independent reviewer confirms one schema authority. Current status: `RED_EXPECTED` (missing schema reference, missing contract_version, duplicate TPA copies, missing HANDOFF_READY/stop mechanisms).
