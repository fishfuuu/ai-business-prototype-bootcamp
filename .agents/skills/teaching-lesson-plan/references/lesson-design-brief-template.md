# Lesson Design Brief Template

> **Schema authority**: This file is the **only** owner of the Lesson Design Brief field contract and its `contract_version`. `teacher-plan-architect` (TPA) only declares which `contract_version` it consumes and validates fields against this file.
>
> **Status**: This template is part of the Phase 1 production boundary. It is a schema/reference document, not a lifecycle authority, not an approval record, and not a course artifact.

## contract_version

`contract_version: 1.0`

TPA must declare the `contract_version` it consumes. If the declared version does not match this file's `contract_version`, TPA must fail closed and stop.

## Authority Chain

The Brief must reference, in order of precedence:

1. **Locked UIC** (`docs/changes/course-curriculum-revision-2026-08/user-intent-contract.md`, v1.3, A01/A02, D01–D20)
2. **Frozen design specification** (`docs/changes/course-curriculum-revision-2026-08/design-specification.md`)
3. **Approved roadmap** (`docs/COURSE_ROADMAP.md`, after Phase 1 implementation and approval)
4. **Approved lesson artifacts** (approved TEACHER_PLAN for the corresponding lesson, when it exists)
5. **Skill defaults** (lowest precedence; never override the above)

Downstream conflicts cannot override upstream authority. If a conflict is found, stop and classify it as a specification gap; do not silently resolve it.

## Brief Field Contract

### 1. Lesson Metadata

| Field | Required | Description |
| --- | --- | --- |
| `lesson_number` | Yes | Exact lesson number (L1–L10) |
| `course_context` | Yes | Course name, audience (business department heads, no code/Git/MCP/terminal background default), group size (10–15), teacher+assistant (1+1), 5 weeks × 2 sessions/week, 2–3 day gap, 90-minute hard upper bound |
| `authority_refs` | Yes | Exact references to locked UIC / frozen design spec / approved roadmap / approved lesson artifacts, with version or record IDs where available |
| `contract_version` | Yes | Must equal this file's `contract_version` |

### 2. Learning Objectives

| Field | Required | Description |
| --- | --- | --- |
| `objectives` | Yes | Bloom ABCD format: Audience, Behavior (action verb), Condition, Degree (business-observable) |
| `objective_levels` | Yes | Recognition-level objectives allowed, but summative objectives default to Apply and above |
| `non_goals` | Yes | Explicitly what this lesson does not do |

### 3. Evidence Design

| Field | Required | Description |
| --- | --- | --- |
| `evidence` | Yes | What evidence would show each objective is met |
| `auto_checkable` | Yes | Fixed-answer recognition/judgment items that can be auto-checked |
| `teacher_judged` | Yes | Reasoning, risk trade-off, and disposition-quality evidence requiring teacher judgment |
| `not_for_auto_score` | No | Only if a specific item cannot be auto-scored; decision depends on judgment criteria, not question type |

### 4. Activity Logic

| Field | Required | Description |
| --- | --- | --- |
| `coverage_functions` | Yes | Teacher demo / standard case / personal migration / evidence / closure; may be merged or reordered |
| `time_budget` | Yes | Total must be ≤ 90 minutes; real durations calibrated by trial teaching, never fabricated |
| `sequence_notes` | No | Why the chosen order; no fixed seven-segment sequence required |

### 5. Concept Exposure Ledger

| Field | Required | Description |
| --- | --- | --- |
| `concepts` | Yes | Each concept: first-introduced vs revisited; student-facing named label vs plain-language experience vs teacher-only background; independently assessed judgment (yes/no); corresponding just-completed hands-on step |
| `must_master_count` | Yes | 2–3 per lesson maximum |
| `composite_rule` | Yes | Composite names must not hide concept load; two independent judgments must be listed separately |

### 6. Safety Boundary Declaration

| Field | Required | Description |
| --- | --- | --- |
| `mock_chain` | Yes | Business owner defines boundary → course team supplies templates → Agent drafts → teacher/assistant checks de-identification and sensitive info |
| `no_real_keys` | Yes | Students do not configure real API keys |
| `pre_deidentification` | Yes | Real data must be de-identified before entering AI |
| `teacher_real_calls` | Yes | Completely outside the repository in a controlled teacher environment; repository, course materials, and student packages only contain Mock/de-identified artifacts |
| `no_fabricated_capabilities` | Yes | Do not claim `verify-project.ps1`, `npm run verify`, `doctor`, `test:ui`, or other non-existent capabilities as implemented |

### 7. Readiness Declaration

| Field | Required | Description |
| --- | --- | --- |
| `brief_readiness` | Yes | `DRAFT` or `HANDOFF_READY` — completeness only, not approval |
| `readiness_checks` | Yes | Schema completeness, authority refs current, time budget valid, safety boundary complete |

## HANDOFF_READY Validation Rules

`HANDOFF_READY` is set only when:

1. All required fields above are present and non-empty.
2. `contract_version` matches this file.
3. Authority refs point to current locked/frozen/approved versions (not stale).
4. Time budget sums to ≤ 90 minutes.
5. Safety boundary declaration is complete.

`HANDOFF_READY` is **not**:

- An approval (not DESIGN_REVIEWED/FROZEN, not user approval)
- A lifecycle state
- Authorization to modify repository course materials

## Fail-Closed Rules

- **Wrong lesson**: `lesson_number` mismatch → stop, do not consume.
- **Stale source**: authority refs not current → stop, do not consume.
- **Invalid readiness**: `brief_readiness` not `HANDOFF_READY` → stop, do not consume.
- **Schema drift**: `contract_version` mismatch or missing fields → stop, do not consume.
- **Spec gap**: Brief would change objectives, non-goals, or acceptance meaning → classify as specification gap, return to DRAFT; do not silently absorb.
