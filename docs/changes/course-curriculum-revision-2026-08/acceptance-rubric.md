# Acceptance Rubric — course-curriculum-revision-2026-08

Status: DRAFT

> This document is the single acceptance-plan specification for the current A-RUBRIC-DRAFT slice. It is not Gate A, `DESIGN_FROZEN`, `TESTS_RED`, `ACCEPTANCE_FROZEN`, or implementation authorization. No protocol has been created or run; every current result is `PLANNED` or `NOT_RUN`.

## 1. Control header and gate position

| Field | Value |
|---|---|
| Project ID | `ailearning` |
| Change ID | `course-curriculum-revision-2026-08` |
| Risk | L2 |
| Change base commit | `25c6f3d9214e29378f4945f51a977dc06603c8e4` |
| User Intent Contract | `docs/changes/course-curriculum-revision-2026-08/user-intent-contract.md`, v1.3, amendments A01/A02; D01–D20 unchanged |
| Design specification | `docs/changes/course-curriculum-revision-2026-08/design-specification.md`, DRAFT design authority candidate |
| Formal design review | `Formal Independent Design Review: APPROVED`, source thread `019feb03-f4ec-7681-bb42-e64bf977c710`, no message item ID fabricated |
| Current lifecycle | L2 / `DRAFT`; per-change delivery state is authoritative |
| Current slice | A-RUBRIC-DRAFT: prepare this DRAFT rubric and its embedded RED Test Plan only |
| Gate position | Formal design review is approved; user Gate A has not been granted; no design or acceptance freeze has occurred |

The A-RUBRIC-DRAFT precondition is the recorded Formal Independent Design Review approval above. This slice may create or update only the exact spec path `docs/changes/course-curriculum-revision-2026-08/acceptance-rubric.md` and the coordination summary in `.agent-workflow/task-board.md`. The embedded RED Test Plan below is a fixed chapter of this file, not a separate file or path and not one of the six protocols.

All rubric, mapping, manual-check, protocol-plan, and evidence fields in this DRAFT use only these current statuses:

- `PLANNED`: the check or evidence shape is specified but not executed;
- `NOT_RUN`: no run, review, failure record, or approval record exists in this slice.

No `PASS`, `FAIL`, `RED`, `GREEN`, `TESTS_RED`, or `ACCEPTANCE_FROZEN` result is recorded here. “Expected RED” below is a plan expectation for a future pre-implementation run, not evidence that has occurred.

## 2. Exact Phase 1 boundary

### 2.1 Candidate production files — exactly seven

These are future implementation candidates only. They are not modified or registered by A-RUBRIC-DRAFT.

1. `docs/COURSE_ROADMAP.md`
2. `docs/LESSON_TEMPLATE.md`
3. `CLAUDE.md`
4. `.agents/skills/teaching-lesson-plan/SKILL.md`
5. `.agents/skills/teaching-lesson-plan/references/lesson-design-brief-template.md`
6. `.agents/skills/teacher-plan-architect/SKILL.md`
7. `.claude/skills/teacher-plan-architect/SKILL.md`

`docs/COURSE_ROADMAP.md` remains the dirty `PRESERVE_UNREVIEWED_DRAFT` candidate. Its current working-tree blob is process evidence only; it is not an approved roadmap baseline.

### 2.2 Candidate acceptance protocols — exactly six

These paths are defined in the embedded RED Test Plan but do not exist and are not created in A-RUBRIC-DRAFT.

1. `docs/changes/course-curriculum-revision-2026-08/verification/tlp-tpa-forward-test.md`
2. `docs/changes/course-curriculum-revision-2026-08/verification/tlp-tpa-negative-test.md`
3. `docs/changes/course-curriculum-revision-2026-08/verification/tlp-tpa-trigger-boundary-test.md`
4. `docs/changes/course-curriculum-revision-2026-08/verification/tlp-tpa-schema-version-test.md`
5. `docs/changes/course-curriculum-revision-2026-08/verification/phase1-roadmap-conformance-test.md`
6. `docs/changes/course-curriculum-revision-2026-08/verification/phase1-teacher-plan-template-contract-test.md`

### 2.3 Candidate report files — exactly zero

There is no report-file path in this Phase 1 boundary. External run/event/evidence records may be referenced by a future acceptance rubric update or workflow record; they must not be fabricated and do not authorize a repository report file.

### 2.4 Explicitly out of scope

`student-package/templates/CLAUDE.md`, `GLOSSARY.md`, all L1–L10 lesson files, all V2/V3 history, lesson briefs, TEACHER_PLAN/GUIDE artifacts, HTML/images, `scripts/`, `src/`, package/build artifacts, future TPA references, and all other files not in the seven-path list remain outside this active Phase 1 boundary. Teacher real model/API calls remain completely outside the repository in a controlled teacher environment; repository, course materials, and learner packages contain only marked Mock or sanitized outputs and no keys.

## 3. Acceptance semantics and evidence separation

Phase 1 acceptance can prove that the seven candidate objects and their interfaces express the locked UIC and repository facts. It cannot prove that a class has been taught, a learner has completed a task, a teacher has safely performed a real external call, or an L1–L10 lesson/guide/asset exists. Such proof is deferred programme evidence owned by later controlled changes and does not block a future Phase 1 `ACCEPTED` decision.

Structural checks are not business proof by themselves. A file path, heading, string, or frontmatter check is valid only when it protects a named contract, has a non-empty input fixture, and has an invalid/negative case that would fail for a meaningful contract violation. Human decisions about business boundaries, risk, safety, and instructional suitability cannot be delegated to automatic scoring.

The current rubric contains no approval, freeze, test-run, or failure record. A future protocol writer must keep protocol semantics fixed while recording a real external run/event/evidence reference. If a rubric change alters scope, non-goals, acceptance meaning, or a user decision, the work returns to DRAFT/design review instead of silently changing the test.

## 4. Seven production-object coverage

| Candidate object | Phase 1 contract covered | Planned owner / writer boundary | Planned verification | Current result |
|---|---|---|---|---|
| `docs/COURSE_ROADMAP.md` | Course-level baseline must express D01–D20/F01–F10, preserve the dirty candidate disposition, and make no nonexistent capability or production-readiness claim | Course design owner; authorized roadmap Slice writer only | P05 roadmap conformance plus manual wording review; preserve working blob before/after | NOT_RUN |
| `docs/LESSON_TEMPLATE.md` | Eight-module teacher-plan contract, adjustable time arithmetic under 90 minutes, concept-exposure ledger, dual track, visible outputs, and teacher-plan → approval → GUIDE → conformance order | Course design owner; authorized template Slice writer | P06 template contract plus manual instructional review | NOT_RUN |
| `CLAUDE.md` | Mother-repository Agent maintenance rules defer course parameters to locked/frozen/approved authority; no old fixed defaults, false runtime hard-control claims, or classroom capability claims; learner template remains untouched | Repository/course owner; authorized root-policy writer | P05/P06 negative inventory plus M05 root-policy review | NOT_RUN |
| `.agents/skills/teaching-lesson-plan/SKILL.md` | TLP is a Lesson Design Brief generator/method, uses the single Brief contract, respects upstream constraints, and does not render final GUIDE/TEACHER_PLAN | Course design owner; authorized TLP writer | P01/P02/P03/P04 plus M01–M04 | NOT_RUN |
| `.agents/skills/teaching-lesson-plan/references/lesson-design-brief-template.md` | One exact Brief schema owner and `contract_version`; progressive disclosure; readiness is completeness, not approval | Course design owner; authorized reference writer | P01/P04 schema/forward checks plus manual schema ownership review | NOT_RUN |
| `.agents/skills/teacher-plan-architect/SKILL.md` | Canonical TPA is the sole full renderer of the eight-module teacher plan; consumes a valid Brief and cannot self-approve or silently generate GUIDE | Course owner; authorized TPA writer | P01/P02/P03/P04 plus M05/M06 | NOT_RUN |
| `.claude/skills/teacher-plan-architect/SKILL.md` | Minimal legal compatibility shim points to canonical TPA exact path, duplicates no schema/default/approval logic, and fails closed when canonical content is missing or invalid | Repository/course owner; authorized shim writer | P02/P03/P04 plus M06 shim-authority review | NOT_RUN |

## 5. D01–D20 acceptance mapping

`Contract-blocking` identifies a mismatch that must stop Gate A or return the design to DRAFT. `Deferred programme evidence` is explicitly not a Phase 1 gate.

| ID | Phase 1 requirement | Contract-blocking? | Mode | Protocol / manual check | Expected evidence (future; current result) | Failure判定 | Deferred programme evidence |
|---|---|---|---|---|---|---|---|
| D01 | State that learners are department business managers with no assumed code/Git/MCP/terminal foundation; do not turn the course into engineering training | Yes | Mixed | P05/P06; M01 audience/wording review | Baseline and candidate text inventory plus reviewer decision; NOT_RUN | Any default requires technical setup or changes learner role | L1 preflight and observation of real learner entry; not a Phase 1 proof |
| D02 | Preserve ten lessons and the spiral sequence: practical local understanding, first-use explanation, later transfer, L5 system integration; do not delay first definitions to L5 | Yes | Mixed | P05; M02 sequence review | Ten-lesson first/revisit/integrate map and negative candidate case; NOT_RUN | Missing lesson role, late first concept, or batch rewrite that loses accumulation | Cross-lesson artefact and teaching observation; not a Phase 1 proof |
| D03 | First-use concept explanation is 3–5 minutes and includes what/not, mechanism, business analogy and counterexample, and handoff value tied to the just-completed practical step | Yes | Mixed | P06; M03 concept-card review | Template fields and one non-empty mapping fixture; NOT_RUN | Missing practical reference, boundary, mechanism, or handoff value | Teacher plan and classroom timing evidence per lesson |
| D04 | Each lesson has at most 2–3 independently mastered concepts; recognition and engineering-background labels are not assessed as equal mastery and compound labels do not hide load | Yes | Mixed | P06; M02 cognitive-load review | Exposure ledger with named/plain/background/judgment distinction; NOT_RUN | More than 2–3 independent judgments or terminology used as mastery proxy | Trial Exit Ticket and teacher judgment per lesson |
| D05 | Standard cohort is 10–15 with one teacher and one assistant | Yes | Auto + Manual | P05/P06; M01 | Explicit fields and ownership text; NOT_RUN | Other default or missing assistant takeover role | Roster, staffing and delivery record |
| D06 | Five weeks, two lessons per week, 2–3 day spacing, and a hard 90-minute lesson ceiling | Yes | Mixed | P05/P06; M04 time arithmetic review | Arithmetic fixture and upper-bound rule; NOT_RUN | Over-90 default, hidden extension, or impossible spacing claimed as settled | Real schedule/pilot log and timing data |
| D07 | 30–45 minute L1 environment precheck; assistant takes over an individual block after more than three minutes | Yes | Mixed | P05/P06; M04 operations review | Boundary wording and takeover decision path; NOT_RUN | Class waits for individual troubleshooting or no precheck path | Actual precheck/takeover event records |
| D08 | Every lesson has a visible in-class result; each gap has a 10–15 minute micro-task; each week has one 30–45 minute complete result after lesson two; these are distinct | Yes | Mixed | P05/P06; M04 | Three separate fields and a non-empty example; NOT_RUN | Any category deleted, merged, or replaced by another | Learner artefact completion and weekly submission data |
| D09 | A missed learner completes the standard teacher-case absence pack and 20–30 minute evidence check before returning to the personal mainline | Yes | Manual + Evidence | P05/P06; M04 | Wording preserves prerequisite gate; NOT_RUN | Direct return to personal mainline without prerequisite evidence | Real absence-pack completion record |
| D10 | Teacher uses one anomaly-warning/closed-loop workbench; each learner continuously builds a department prototype from L1 | Yes | Mixed | P01/P05/P06; M01 | Dual-track mapping and no per-lesson project reset; NOT_RUN | Teacher/learner tracks collapse or learner project resets every lesson | Ten-lesson prototype continuity evidence |
| D11 | Learner prototype uses marked Mock; teacher real model/API calls stay in a controlled environment outside the repository; four-party Mock responsibility is explicit; no real key or self-configured MCP | Yes | Mixed | P02/P03/P05/P06; M04 | Negative cases, Mock responsibility map, and external-call boundary; NOT_RUN | Secret, real data, key, or learner MCP setup enters repo/material/package | Controlled teacher run record and Mock review |
| D12 | Sanitize before AI; no keys/config/unsanitized data in repo, materials, learner package, or peer review; only Mock/sanitized outputs are shareable | Yes | Mixed | P02/P05/P06; M04 security review | Secret/data negative fixtures and refusal path; NOT_RUN | Any pre-AI real-data submission or leaked key is accepted | Security scan and teacher operations record |
| D13 | Six collaboration modes are a supervisor decision framework, three deep/three recognition, not an industry-only standard or six systems to implement | Yes | Manual + Mixed | P01/P05; M04 mode-positioning review | Mode names, signals, misuse risks, and depth labels; NOT_RUN | Six systems or universal standard claim, or missing mode | Lesson comparison and supervisor decision evidence |
| D14 | L7 teaches MCP host/client/server/tool minimum model, says MCP is not a product business API, and exposes only one teacher-preconfigured browser entry | Yes | Mixed | P02/P03/P05; M04 MCP/API review | Trigger/negative fixture and single-entry boundary; NOT_RUN | Learner must configure multiple services or MCP is called a business API | Browser acceptance and teacher demo record |
| D15 | L8 performs independent isolated-context review; unavailable branded tool falls back to an isolated new session rather than skipping review | Yes | Mixed + Evidence | P03/P05; M04 | Fallback and isolation condition are explicit; NOT_RUN | Tool failure skips review or reuses contaminated context | Isolated review event and context manifest |
| D16 | L9 separates development toolchain, business API, and model API chains; MCP, business API and model API are not collapsed | Yes | Mixed | P01/P05/P06; M04 | Three-chain mapping and negative confusion case; NOT_RUN | Any chain is described as the same API or responsibility | L9 teaching evidence and IT handoff artefact |
| D17 | L10 uses only Mock/sanitized peer-review logic and produces a product decision/development-start package, explicitly not production-ready | Yes | Mixed | P02/P05; M01/M04 | Non-production wording and missing-work inventory; NOT_RUN | Direct-launch, seamless-production, or real-data claim | L10 package and peer-review record |
| D18 | Dual Commit is only a two-stage version/manager-confirmation metaphor; CEO trees are supervisor treatment frames, not runtime controls or industry standards | Yes | Manual + Mixed | P02/P06; M04 boundary review | Analogy boundary and non-hard-control wording; NOT_RUN | Git/CEO frame presented as approval engine, hard hook, or universal standard | Teacher explanation and learner judgment evidence |
| D19 | Do not claim absent `doctor`, `test:ui`, `verify`, or other unverified capability; distinguish implemented/teacher-manual/future asset | Yes | Auto + Manual | P02/P05; M05 capability inventory | Command/path inventory with meaningful nonexistent-capability negative cases; NOT_RUN | Missing command is written as classroom pass condition or implemented | Future script implementation and independent validation |
| D20 | Protect V2/V3/history; enforce teacher plan → independent review/user approval → GUIDE → GUIDE conformance → derived assets; preserve dirty roadmap candidate unaccepted/unrejected/un-edited | Yes | Mixed + Evidence | P01/P02/P05/P06; M05 authority review | Paths, blob/status snapshot, direct-source/ref rules, and no-batch-sync negative case; NOT_RUN | History deleted/synced, downstream rewrites upstream, or dirty candidate treated as approved | Per-lesson review/approval/conformance and asset lineage records |

## 6. F01–F10 finding closure mapping

| ID | Phase 1 requirement | Contract-blocking? | Mode | Protocol / manual check | Expected evidence (future; current result) | Failure判定 | Deferred programme evidence |
|---|---|---|---|---|---|---|---|
| F01 | Replace “IT directly implements/production ready” with a non-production product decision and development-start package plus explicit gaps | Yes | Mixed | P05; M01 wording review | Candidate text scan and gap inventory; NOT_RUN | Any direct-launch or production-ready promise remains | L10 package review and IT handoff review |
| F02 | Every first-use concept card points to the practical action just completed and states handoff value | Yes | Mixed | P06; M03 | Non-empty action reference and concept-card fixture; NOT_RUN | Fourth step has no action/decision reference | Lesson plan and classroom observation |
| F03 | Keep pre-AI sanitization, repository-external teacher calls, Mock/sanitized-only repository/material/package, and no-key boundary separate and explicit | Yes | Mixed | P02/P05/P06; M04 | Positive and refusal fixtures plus secret/data scan plan; NOT_RUN | Real data/key is accepted or external teacher boundary is blurred | Teacher environment safety record and package scan |
| F04 | Do not call absent npm `verify`, mother-repo `verify-student-project.ps1`, or repository `AGENTS.md` an existing classroom capability | Yes | Auto + Manual | P02/P05; M05 | `package.json`/path inventory and absence negative case; NOT_RUN | Nonexistent or export-only asset is a required pass command | Future capability implementation evidence |
| F05 | Reframe one-click recovery as bounded stop/range confirmation/teacher-assistant recovery until an independently tested automation exists | Yes | Mixed | P02/P06; M04 | Recovery negative case, owner, range and failure path; NOT_RUN | “One-click”, “100% safe”, or automatic restore is claimed without implementation | Future recovery implementation and negative tests |
| F06 | Retain a visible in-class result for every lesson and keep it separate from micro-task and weekly result | Yes | Mixed | P05/P06; M04 | Three-column course/template contract and non-empty example; NOT_RUN | Visible result removed or substituted by homework | Ten lesson result matrix and learner artefacts |
| F07 | Say learners need not configure MCP services themselves, while still teaching the L7 minimum model and single browser entry | Yes | Mixed | P02/P03/P05; M04 | Trigger/negative fixture and single-entry description; NOT_RUN | “No MCP” erases learning or asks learner to mount services | L7 demonstration record |
| F08 | Separate guidance text, workflow gates, and runtime hard control; never call a text rule a physical hook without executable evidence | Yes | Mixed | P02/P05; M05 control-layer review | H4 layer mapping and runtime-claim negative case; NOT_RUN | Missing code/test is described as runtime refusal/lock | Future runtime implementation and negative test |
| F09 | Include all six modes with three deep/three recognition and no universal-standard or six-system implication | Yes | Manual + Mixed | P01/P05; M04 | Mode inventory, depth labels, misuse risks; NOT_RUN | Missing/incorrect positioning or six-system requirement | Lesson comparison and supervisor decision record |
| F10 | Treat 90 minutes as a hard ceiling and initial budget, not fabricated measured timing; allow real trial calibration | Yes | Mixed + Evidence | P05/P06; M04 | Arithmetic fixture and explicit unmeasured/trial fields; NOT_RUN | Over-time plan, hidden extension, or invented exact timing | Per-lesson pilot logs, completion rates, takeover and cut records |

## 7. Embedded RED Test Plan (DRAFT; six protocol specifications)

The following six entries are protocol specifications inside this same `acceptance-rubric.md`. They are not protocol files. At this stage every plan is `PLANNED` and every run is `NOT_RUN`. A protocol writer may create the six exact paths only after user Gate A and `DESIGN_FROZEN`; production must remain zero-diff during every run.

### P01 — TLP→TPA forward boundary

- **Exact protocol path:** `docs/changes/course-curriculum-revision-2026-08/verification/tlp-tpa-forward-test.md`
- **Requirement IDs:** D01, D02, D03, D04, D10, D11, D13, D14, D15, D16, D20, F02, F07, F09.
- **Fixture/input:** A frozen single-lesson input manifest containing a valid roadmap/design ref, a persistent Brief with `contract_version` and `HANDOFF_READY`, a practical action reference, Mock/sanitized data, and a specified lesson target. The fixture is supplied by the future run event; none is created now.
- **Pre-implementation action/check:** Invoke TLP with the frozen lesson input and verify that it produces only a Lesson Design Brief; pass that Brief to TPA and verify that TPA consumes the exact contract and produces only the eight-module teacher plan. Check that no GUIDE, derived asset, invented capability, or changed acceptance meaning is emitted.
- **Expected pre-implementation result:** `RED_EXPECTED` for any baseline violation of the separation/authority contract; any already-conforming frontmatter or wording is a characterization baseline and must not be manufactured into RED. Current result: `NOT_RUN`.
- **Intended failure reason / protected invariant:** The boundary prevents a Skill from becoming an artifact owner, bypassing Brief authority, or producing a GUIDE before independent review/user approval. A filename or heading alone is insufficient; the output-type and forbidden-output assertions must be non-empty and fail on a deliberately cross-triggered input.
- **Production-zero-diff proof:** Capture hashes/status for all seven candidate production paths, including the dirty roadmap working blob, before and after; only the exact protocol path and external run record may change. Any production diff invalidates the run.
- **External run/evidence record:** Future task/thread run event ID, fixture version/hash, output manifest, and reviewer evidence reference; no fabricated ID and no repository report file.
- **Post-implementation GREEN/manual condition:** After approved TLP/TPA implementation, the same fixture yields Brief-only then eight-module-plan-only outputs, with manual course-owner confirmation of scope and no GUIDE; current status remains `NOT_RUN`.

### P02 — Negative capability, safety, and fail-closed boundary

- **Exact protocol path:** `docs/changes/course-curriculum-revision-2026-08/verification/tlp-tpa-negative-test.md`
- **Requirement IDs:** D11, D12, D17, D18, D19, D20, F01, F03, F04, F05, F08.
- **Fixture/input:** Negative cases for nonexistent `doctor`/`test:ui`/`verify` claims, candidate/dirty roadmap presented as approved, direct-production/one-click claims, real-data/key input, unsanitized Mock, text rule presented as runtime hard control, and a missing/invalid canonical TPA for the `.claude` shim.
- **Pre-implementation action/check:** Feed each negative case to the relevant Skill/shim and inspect the response, refusal, or stop behavior. Inventory actual commands/paths from the repository rather than trusting prose. Do not send real data or keys; use marked synthetic sentinel strings only.
- **Expected pre-implementation result:** `RED_EXPECTED` only where a changed contract is violated; an absent command correctly rejected is a baseline characterization, not a forced RED. Current result: `NOT_RUN`.
- **Intended failure reason / protected invariant:** Prevents capability hallucination, secret/real-data acceptance, false production readiness, dirty-candidate approval, and shim continuation without canonical authority. The negative cases must contain a meaningful forbidden input and cannot pass because a file merely exists.
- **Production-zero-diff proof:** Pre/post hash and status manifest for all seven production candidates; no key, payload, build artifact, or production edit is allowed. A refusal test that writes a secret or real payload is invalid and must stop immediately.
- **External run/evidence record:** Sanitized input manifest, command/path inventory, refusal output, shim resolution trace, and external event/evidence ID; no secrets in the record.
- **Post-implementation GREEN/manual condition:** Every forbidden input is refused or stopped with a bounded explanation; manual safety owner confirms no key/real data crossed the repository boundary; current status remains `NOT_RUN`.

### P03 — Trigger and fallback boundary

- **Exact protocol path:** `docs/changes/course-curriculum-revision-2026-08/verification/tlp-tpa-trigger-boundary-test.md`
- **Requirement IDs:** D01, D02, D03, D04, D07, D09, D13, D14, D15, D17, D20, F06, F07, F09.
- **Fixture/input:** Requests for learning goals/evidence/activity logic, requests to write repository TEACHER_PLAN/GUIDE, fixed seven-segment lesson sequences that may be merged/reordered, L7 single browser entry/tool-unavailable fallback, L8 isolated-session fallback, and absence-pack prerequisite input.
- **Pre-implementation action/check:** Exercise the TLP and TPA trigger boundaries separately; verify a tool failure selects the documented fallback rather than skipping the contract; verify a fixed sequence can be reorganized when coverage and total minutes remain correct; verify absence recovery blocks personal-mainline continuation until prerequisite evidence exists.
- **Expected pre-implementation result:** Characterization baseline is expected for any already-valid fallback; `RED_EXPECTED` only when an old trigger or sequence rule violates the changed boundary. Current result: `NOT_RUN`.
- **Intended failure reason / protected invariant:** Protects actor responsibility, non-mechanical learning sequence, three-minute takeover/absence boundaries, single-entry MCP exposure, isolated review, and non-production L10 framing. A trigger test must assert resulting responsibility/output, not just the trigger word.
- **Production-zero-diff proof:** Snapshot all seven candidate production hashes/status before and after; any protocol run that edits lesson, Skill, root policy, shim, or roadmap is invalid.
- **External run/evidence record:** Prompt/input set, selected actor, fallback branch, minutes calculation, isolation/takeover event and run ID; no repository report file.
- **Post-implementation GREEN/manual condition:** TLP/TPA triggers are separated, fallback is bounded, sequence can be merged/reordered without losing coverage, and teacher/course-owner manual review accepts the boundary; current status remains `NOT_RUN`.

### P04 — Schema and contract-version boundary

- **Exact protocol path:** `docs/changes/course-curriculum-revision-2026-08/verification/tlp-tpa-schema-version-test.md`
- **Requirement IDs:** D03, D04, D11, D13, D14, D15, D16, D18, D20, F02, F07, F08.
- **Fixture/input:** One valid Brief contract fixture with exact `contract_version`, plus missing-field, wrong-version, wrong-lesson, stale-source, duplicate-schema, and invalid-readiness variants. Include the TLP reference exact path and canonical TPA consumer declaration.
- **Pre-implementation action/check:** Validate that TLP reference is the sole schema owner; TPA accepts only the compatible version and required fields; `HANDOFF_READY` is completeness rather than approval; wrong lesson/source/ref stops; `.claude` resolves only the canonical Skill and does not carry a second schema.
- **Expected pre-implementation result:** `RED_EXPECTED` for any missing/changed schema contract introduced by the future implementation; valid pre-existing fields receive characterization baseline, not fabricated RED. Current result: `NOT_RUN`.
- **Intended failure reason / protected invariant:** Prevents schema drift, duplicated authority, guessed refs, and accidental approval semantics. A schema check must include a malformed non-empty fixture and a version mismatch that demonstrably stops downstream consumption.
- **Production-zero-diff proof:** Compare the seven production path hashes/status before and after; schema fixtures are in-memory or external run inputs and cannot create reference files in this slice.
- **External run/evidence record:** Fixture version/hash, validator output, canonical-resolution trace, wrong-version stop evidence, and run/event ID; no fabricated approval ref.
- **Post-implementation GREEN/manual condition:** Valid version is consumed once, invalid/missing versions stop, and an independent reviewer confirms one schema authority; current status remains `NOT_RUN`.

### P05 — Course roadmap and authority conformance

- **Exact protocol path:** `docs/changes/course-curriculum-revision-2026-08/verification/phase1-roadmap-conformance-test.md`
- **Requirement IDs:** D01, D02, D05, D06, D07, D08, D09, D10, D11, D12, D13, D14, D15, D16, D17, D18, D19, D20, F01, F03, F04, F06, F07, F08, F09, F10.
- **Fixture/input:** The approved/frozen design reference when available, the current dirty roadmap candidate as an explicitly unapproved input, repository path/command inventory, root CLAUDE/shim inventory, seven-object candidate list, and D01–D20/F01–F10 conformance checklist. Current roadmap blob `b42b49cc3b9eb02fb848951e180d29b6587c3bdf` and numstat 67/53 are process evidence, not acceptance.
- **Pre-implementation action/check:** Check that the course-level baseline contains each decision/finding without claiming lesson enactment; check old defaults/nonexistent capabilities/production claims, Mock/no-key/external-call boundary, six-mode positioning, three-chain and control-layer distinctions, visible-result rule, and dirty-candidate preservation. Every structural assertion must point to the contract it protects and have a negative candidate case.
- **Expected pre-implementation result:** Characterization must record the dirty candidate as `PRESERVE_UNREVIEWED_DRAFT`; `RED_EXPECTED` only for a real conformance violation in a changed baseline, never because the candidate is dirty by itself. Current result: `NOT_RUN`.
- **Intended failure reason / protected invariant:** Prevents treating a prose heading or dirty candidate as approved authority and prevents future roadmap text from inventing commands, production readiness, runtime hooks, or classroom evidence. A “file exists” result alone is never sufficient.
- **Production-zero-diff proof:** Record pre/post blob, numstat, status, and hashes for all seven candidate production paths; the roadmap working blob must remain b42b49cc3b9eb02fb848951e180d29b6587c3bdf with 67/53 diff.
- **External run/evidence record:** Checklist version, input blob/hash, inventory output, reviewer conformance decision, and external run/event ID. No acceptance report path is created.
- **Post-implementation GREEN/manual condition:** Approved roadmap and root-policy/shim/template boundaries are structurally faithful, dirty candidate remains preserved until its own Slice, and course owner manually accepts wording/authority; current status remains `NOT_RUN`.

### P06 — Teacher-plan template and dual-track contract

- **Exact protocol path:** `docs/changes/course-curriculum-revision-2026-08/verification/phase1-teacher-plan-template-contract-test.md`
- **Requirement IDs:** D03, D04, D05, D06, D07, D08, D09, D10, D11, D12, D14, D15, D16, D18, D20, F02, F03, F05, F06, F08, F10.
- **Fixture/input:** Current `docs/LESSON_TEMPLATE.md` plus a frozen single-lesson template fixture containing eight modules, adjustable minute blocks with total ≤90, 2–3 independent must-master concepts, named/plain/background exposure, teacher workbench and learner prototype tracks, visible result/micro-task/weekly result fields, safety boundaries, and one-way plan approval/GUIDE/conformance links.
- **Pre-implementation action/check:** Check module coverage, minute arithmetic, concept ledger, dual-track fields, visible-result separation, absence/recovery pass-through, Mock/no-key boundary, three-chain/control-layer wording, first-use four-step practical reference, and absence of fixed five Pause/three diagrams/hand Git/verify/100% defaults. Include an over-time, over-load, missing-result, and old-default fixture so checks are non-vacuous.
- **Expected pre-implementation result:** `RED_EXPECTED` for an actual template/design conflict that the future implementation must remove; already-valid module or arithmetic behavior is a characterization baseline and must not be forced into RED. Current result: `NOT_RUN`.
- **Intended failure reason / protected invariant:** Prevents a template from silently overriding UIC/design, hiding concept overload in compound labels, replacing classroom outputs with homework, or introducing a second approval authority. A heading-only check cannot pass without field values and an invalid fixture.
- **Production-zero-diff proof:** Capture hashes/status for all seven candidate production paths before and after; no template, lesson, Skill, shim, script, build or student-package write is permitted during protocol execution.
- **External run/evidence record:** Fixture version/hash, arithmetic/exposure output, invalid-case stop evidence, manual teacher-plan review and run/event ID; no repository report file.
- **Post-implementation GREEN/manual condition:** Template contract is structurally valid, adjustable timing is within the hard ceiling, concept and dual-track rules are visible, and an independent reviewer/course owner accepts the instructional interpretation; current status remains `NOT_RUN`.

### 7.1 Non-vacuous RED and characterization rule

The protocol writer must distinguish a changed or newly imposed constraint from an invariant already satisfied by the baseline. A changed constraint with a reproducible baseline violation may be expected to produce a real RED result after `DESIGN_FROZEN`; an invariant already satisfied must receive a characterization/baseline record and must not be made to fail artificially. Neither characterization nor expected RED is a current state transition. No protocol may be edited after the run merely to turn a result into a pass.

### 7.2 Shared production-zero-diff and evidence rule

Before every future protocol run, capture the exact path, blob/hash, status and diff stat for all seven candidate production files. After the run, compare the same manifest. A production change, unapproved fixture write, secret, real-data payload, build output, or report file is an invalid run and a stop condition. The external evidence record must identify the task/thread/run event, protocol version, input fixture version/hash, observed result, and reviewer/operator; it may not invent IDs or convert an external record into a repository report.

## 8. Manual acceptance and risk controls

| Check ID | Manual judgment required | Planned evidence | Current result |
|---|---|---|---|
| M01 | Whether wording truly addresses business supervisors and does not silently require code/Git/MCP/terminal expertise or teach engineers instead | Independent reviewer/course-owner wording decision tied to exact paths and versions | NOT_RUN |
| M02 | Whether concept load is genuinely 2–3 independent judgments, and whether recognition/background labels are not hidden mastery requirements | Exposure ledger review with a non-compound example and rationale | NOT_RUN |
| M03 | Whether four-step first-use explanations are accurate, bounded by analogy/counterexample, and tied to the just-completed practical action | Manual concept-card review and lesson-owner decision | NOT_RUN |
| M04 | Whether six-mode positioning, MCP/API distinctions, Mock/sanitization, no-key boundary, external teacher environment, fallback, timing, and non-production claims are safe and intelligible | Independent reviewer plus teacher/operations/course-owner decisions; no automated business-risk score | NOT_RUN |
| M05 | Whether root `CLAUDE.md` is maintenance policy rather than misleading course authority, and whether it avoids old defaults and false runtime claims | Root-policy review against UIC/design and repository facts | NOT_RUN |
| M06 | Whether `.claude` is a minimal compatibility shim and cannot become a second TPA authority; canonical failure is visibly fail-closed | Shim/canonical side-by-side review and negative resolution trace | NOT_RUN |
| M07 | Whether GUIDE and derived-asset lineage is one-way and uses real review/approval/conformance refs rather than prose assertions | Independent authority/ref review | NOT_RUN |
| M08 | Whether dirty roadmap and V2/V3 history are preserved without acceptance, rejection, deletion, merge, or batch synchronization | Git/status/blob review and course-owner decision | NOT_RUN |

### 8.1 Gate A invalidation triggers

Gate A must not be requested, or becomes invalid for this change, if any of the following occurs:

- Formal design approval cannot be resolved to the source thread/decision, or the base commit, UIC v1.3, A01/A02, or design version changes without a new review;
- D01–D20 meaning, the seven production paths, six protocol paths, zero report paths, non-goals, or acceptance meaning changes without an explicit user amendment and design review;
- a RED plan is proposed as an independent file/path, a seventh protocol, or a report file;
- a protocol is authored/run before Gate A and `DESIGN_FROZEN`, or `TESTS_RED` is recorded without real pre-implementation failure evidence;
- a production file, lifecycle JSON, UIC, design specification, roadmap candidate, lesson, Skill, script, source, learner package, build artifact, secret, or real-data payload changes during rubric preparation or a zero-diff protocol run;
- a candidate roadmap is treated as approved, a nonexistent command is treated as implemented, a placeholder is treated as evidence, or text is called runtime hard control without executable proof;
- TLP/TPA/shim authority, Brief schema/version, approval/ref semantics, GUIDE conformance, or one-way downstream behavior cannot be resolved to an exact path/version/event;
- runtime-sync `OUTDATED` or mirror absence is presented as a successful gate or used to infer lifecycle authority.

### 8.2 Specification-gap and safety stop conditions

Stop and return to DRAFT/design review when a check exposes a new user requirement, changed learning objective, new acceptance meaning, unresolved authority choice, or a conflict between UIC, frozen design candidate, approved roadmap, and direction-specific source. Refuse and stop on real/sensitive data before sanitization, keys/configuration in repository/material/package, unsafe external teacher-call leakage, or any request to weaken the Mock/sanitization boundary. Refuse and stop rather than inventing `doctor`, `test:ui`, `verify`, recovery automation, runtime hooks, schemas, approval IDs, or classroom evidence. Scope drift, concurrent writers, wrong lesson/ref, stale blob, missing fixture, missing event record, or a production diff blocks the affected gate.

## 9. Current result ledger and handoff

| Item | Current state |
|---|---|
| Rubric status | DRAFT |
| Mapping D01–D20 | 20 rows specified; result fields `NOT_RUN` |
| Mapping F01–F10 | 10 rows specified; result fields `NOT_RUN` |
| Embedded RED Test Plan | Six exact protocol specifications; plan status `PLANNED`; run status `NOT_RUN` |
| Protocol files | 0 created; `delivery-state.json.test_files` remains empty |
| Production files | 0 changed or registered; seven remain candidate-only |
| Report files | 0; no report path permitted |
| Lifecycle | L2 / `DRAFT`; no `TESTS_RED`, lock, transition, or freeze |
| Runtime sync | `l2-implement-loop` and `tm` observed `OUTDATED`; not repaired and not evidence of success |
| Next action | Independent review of this A-RUBRIC-DRAFT; do not request or infer user Gate A from the Formal Design Review approval |

This document is complete as a DRAFT acceptance-plan candidate. It requests A-RUBRIC-DRAFT review only. It does not request Gate A, `DESIGN_FROZEN`, protocol creation, `TESTS_RED`, `ACCEPTANCE_FROZEN`, or implementation.
