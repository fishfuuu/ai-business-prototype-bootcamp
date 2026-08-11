---
name: teaching-lesson-plan
description: "Design a Lesson Design Brief (教学推理中间层) using Backward Design (Wiggins & McTighe), Constructive Alignment (Biggs), Bloom's Taxonomy ABCD framework, and WHERETO as diagnostic/coverage lenses. Use when asked to design learning objectives, evidence, or activity logic for a lesson. This skill produces only the Lesson Design Brief; it does not produce final TEACHER_PLAN or GUIDE files."
---

# Teaching Lesson Plan Skill (Lesson Design Brief)

Produces a **Lesson Design Brief** — the pedagogical reasoning intermediate layer for a single lesson. It does **not** produce final `TEACHER_PLAN` or `GUIDE` files, and it does not modify repository course materials.

## Role Boundaries

- This skill only generates the Lesson Design Brief (教学推理中间层).
- Final `TEACHER_PLAN` / `GUIDE` rendering is the sole responsibility of `teacher-plan-architect` (TPA), which consumes a HANDOFF_READY Brief.
- This skill does not own the Brief artifact, lifecycle state, artifact ownership, or approval power. It only provides method and rendering constraints.
- `HANDOFF_READY` means the Brief is complete per the schema; it is **not** an approval, not DESIGN_REVIEWED/FROZEN, and not user approval.

## Schema Authority

- The **only** schema authority for the Brief is:
  `.agents/skills/teaching-lesson-plan/references/lesson-design-brief-template.md`
- That reference file is the sole owner of `contract_version`. TPA only declares which version it consumes and validates fields against it.
- If the reference file is missing, unreadable, or its `contract_version` cannot be resolved, fail closed: stop and report; do not proceed with an ad-hoc schema.

## Trigger Boundaries

Use this skill when the request is to design **learning objectives, evidence, or activity logic** for a lesson (Lesson Design Brief only).

Do **not** use this skill when the request is to write repository `TEACHER_PLAN` / `GUIDE` files — that is TPA's trigger.

## Required Inputs

Ask the user for these if not provided:
- **Lesson number and course context** (must reference the locked UIC / frozen design specification / approved roadmap)
- **Audience** (this project: business department heads, default no code/Git/MCP/terminal background)
- **Session length** (this project: 90 minutes hard upper bound, adjustable blocks)
- **Learning goal** (what should participants know or be able to do by the end?)
- **Prior knowledge** (what can you assume they already know?)

## Output Structure

The Brief must follow the field contract in `references/lesson-design-brief-template.md` exactly, including:

1. **Lesson metadata**: lesson number, course context, authority chain references (locked UIC → frozen design specification → approved roadmap → approved lesson artifacts → skill defaults).
2. **Learning objectives**: Bloom ABCD format; recognition-level objectives are allowed, but this course's summative objectives default to Apply and above, with business-observable Degree.
3. **Evidence design**: what evidence would show the objective is met; distinguish auto-checkable fixed-answer items from teacher-judged reasoning/risk/quality evidence.
4. **Activity logic**: coverage functions (teacher demo / standard case / personal migration / evidence / closure) that may be merged or reordered; must sum to the upstream time budget (≤ 90 minutes).
5. **Concept exposure ledger entry**: first-introduced vs revisited; student-facing named label vs plain-language experience vs teacher-only background; independently assessed judgments (composite names must not hide concept load).
6. **Safety boundary declaration**: Mock/no-key rules, pre-de-identification, teacher real calls outside the repository, no fabricated capabilities.
7. **Readiness declaration**: `brief_readiness: DRAFT | HANDOFF_READY` — completeness only, not approval.

## Fail-Closed Rules

- **Wrong lesson**: if the Brief's lesson number does not match the requested lesson, stop and report.
- **Stale source**: if the Brief references a source (UIC/design/roadmap) that is not the current locked/frozen/approved version, stop and report.
- **Invalid readiness**: if `brief_readiness` is not HANDOFF_READY, downstream (TPA) must not consume the Brief.
- **Spec gap**: if the Brief would change objectives, non-goals, or acceptance meaning, classify it as a specification gap and return to DRAFT; do not silently absorb it.

## Quality Checks & Anti-Patterns

- [ ] Learning objectives use action verbs (ABCD format, avoiding vague "understand")
- [ ] Constructive Alignment is used as a diagnostic lens; do not claim "100% alignment" as a mechanical guarantee
- [ ] WHERETO is used as a diagnostic/coverage lens, not a mandatory seven-cell compliance table or the only script
- [ ] Coverage functions sum to the upstream time budget (≤ 90 minutes); no fixed seven-segment sequence is required
- [ ] Concept exposure ledger distinguishes named/plain/background and independently assessed judgments
- [ ] Exit Ticket: 1–2 mandatory prompts; additional questions go to an optional after-class question bank
- [ ] No fabricated capabilities: do not claim `verify-project.ps1`, `npm run verify`, `doctor`, or `test:ui` as implemented classroom capabilities unless the repository actually provides them
- [ ] Safety boundary: Mock/no-key, pre-de-identification, teacher real calls outside the repository
- [ ] `brief_readiness` is set and means completeness only, not approval
