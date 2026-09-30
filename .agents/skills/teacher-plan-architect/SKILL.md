---
name: teacher-plan-architect
description: "Render either an 8-module repository TEACHER_PLAN from a HANDOFF_READY Lesson Design Brief (contract_version 2.1), or—only after the same lesson's teacher plan has independent review and user/course-owner approval—a single 6-chapter learner GUIDE. Supports dual-track architecture (35+35+10+10) for L6–L10. Never render both in one invocation and never self-approve."
---

# Teacher Plan Architect

Render one final lesson artifact in one of two mutually exclusive modes:

- ``PLAN``: an 8-module teacher plan;
- ``GUIDE``: one 6-chapter learner guide derived from the same lesson's approved teacher plan.

Never render both modes in one invocation. Do not own lifecycle, artifacts, reviews, or approvals.

## Shared authority

- Brief schema authority: `.agents/skills/teaching-lesson-plan/references/lesson-design-brief-template.md`
- Consumed Brief version: `contract_version: 2.1`
- Active course files path: `lessons/` (never read from or output to stale `docs/`)
- Course rules, frozen baseline (`TEN_LESSON_FROZEN_BASELINE.md`), and the dual-track baseline (`CURRICULUM_REBALANCING_AND_DUAL_TRACK_OPTIMIZATION_PROPOSAL.md`) outrank Skill defaults.
- Stop on wrong lesson, stale source, schema drift, missing field, changed objective/non-goal/acceptance meaning, or fabricated capability.

## Inheritance-based upgrade

This skill does not render from a blank template. Each lesson is an upgrade of an existing lesson under `lessons/`. The Brief must carry a content inheritance table (produced by `teaching-lesson-plan`). TPA must verify the inheritance table is present and complete before rendering.

If the Brief's inheritance table is missing, incomplete, or contains unsupported deletions (original content deleted without a reason from the default-retain list), fail closed: stop and report.

### Teaching thickness enforcement

When rendering either PLAN or GUIDE, verify against the original lesson materials under `lessons/`:

- Flow diagrams from the original are preserved or replaced with an equal or better integrated model.
- Detailed prompts from the original are preserved verbatim, adjusted, or replaced with equal or better prompts in the Task cards (no placeholders).
- Classroom tasks and demonstration steps from the original are carried into the Task cards.
- In-class questions, extension questions, misconceptions and troubleshooting from the original are preserved or replaced with equal content.
- Teacher narration and explanations have real substance, not just headings.
- For L6–L10: Track A (Tasks 1-2) and Track B (Tasks 3-4) are both fully rendered with concrete prompts and artifacts; neither track may be summarized or omitted.

If the original had a flow diagram and the upgraded output has none, stop. If the original had usable prompts and the upgraded output has placeholders, stop. If the original had real teacher narration and the upgraded output has only section titles, stop.

## Mode selection

### PLAN mode

Require:

- `HANDOFF_READY` Brief for the requested lesson with `contract_version: 2.1`;
- Brief contains a complete content inheritance table;
- Current authority references including `CURRICULUM_REBALANCING_AND_DUAL_TRACK_OPTIMIZATION_PROPOSAL.md`;
- Valid concept, time, dual-line, model, Task, assessment, and safety fields.

Output only the teacher plan. Do not output a GUIDE or approval claim.

### GUIDE mode

Require all of:

- Same-lesson approved teacher plan exact path (`lessons/LESSON_XX_TEACHER_PLAN.md`) and content/version identifier;
- Real Independent Review reference;
- Real user/course-owner approval reference;
- The corresponding Brief or a traceable approved-plan reference to its frozen meaning;
- Requested GUIDE lesson number matching the plan and Brief.

Output only one GUIDE. Stop when an approval reference is missing, stale, wrong-lesson, non-resolving, or merely asserted in prose. Do not repair an approved plan from GUIDE mode; return conflicts upstream as a specification gap.

## PLAN rendering contract

Render exactly 8 H2 modules:

1. course metadata and positioning;
2. backward-aligned objectives, evidence, and concept cards;
3. teaching preparation and safety boundaries;
4. 90-minute control line (for L6–L10: rigid **35+35+10+10** dual-track structure with the 35-min hard cutoff gate);
5. Task demonstration and patrol guidance (Tasks 1–2 for Track A; Tasks 3–4 for Track B);
6. classroom Debug/fallback plan;
7. assessment, passing criteria, and between-lesson task (enforcing P-04 non-offsetting evidence);
8. teacher preparation checklist.

Rules:

- Preserve 3-5 core concepts and 0-2 extension concepts from the Brief.
- Render concept cards using the actionable 3-part framework:
  1. **是什么 (What it is / is not)**;
  2. **怎么用 (How to use it)**;
  3. **避坑红线 (Redlines / Anti-patterns)**;
  4. **交接价值 (Handoff / Task reference)**.
- Render the integrated lesson model as a relationship/model for learners; keep classroom timing teacher-only.
- For L6–L10: Explicitly define the **35-min Hard Cutoff Gate (硬切门禁)** in Module 4 & 5.
- For every Task render: **teacher demonstration / teacher cue / patrol judgment / failure fallback**.
- Keep Troubleshooting to at most 5 root-cause categories.
- Keep teacher checklist to at most 8 items.
- Render the two learning lines and their separate passing evidence: **P-04 non-offsetting rule is mandatory**.
- Include 1-5 required questions and 0-2 extension questions with answer/judgment points.

## GUIDE rendering contract

Render exactly 6 H2 chapters serving these functions:

1. understand lesson value, result, integrated model, and core concepts;
2. prepare the environment and choose the lesson starting point;
3. complete the Tasks (Tasks 1–2 for Track A; Tasks 3–4 for Track B for L6–L10);
4. preserve safety boundaries and handle misconceptions/problems;
5. verify results and complete assessment (enforcing P-04 dual-line independence);
6. prepare the next lesson input or micro-task.

Rules:

- Create one learner guide only under `lessons/LESSON_XX_GUIDE.md`. Keep A/B/C or other branches inside the relevant Task and reconverge afterward.
- Do not expose the teacher timetable as the learner integrated model.
- For every Task render: **purpose / copy or execute / expected observation / check / mandatory stop**.
- Render concept cards using the actionable 3-part framework:
  - **是什么 (What it is)**;
  - **怎么用 (How to use it)**;
  - **避坑红线 (Redlines)**.
- Preserve approved prompts completely unless the approved plan explicitly authorizes compression.
- Keep common misconceptions at 5 or fewer and troubleshooting root categories at 5 or fewer.
- Render 1-5 required questions, 0-2 extension questions, and answers/judgment points.
- Do not introduce concepts, Tasks, scope, passing criteria, safety claims, or homework absent from the approved teacher plan.
- Keep the classroom main result achievable in class; do not move core completion to homework.

## Evidence and truthfulness (P-04 Enforcement)

- **Prototype progress line**: Visual/behavioral evidence from Track A (Git commit, Vite UI state, Playwright screenshot).
- **Supervisor judgment line**: Evidence from Track B (L6: Signoff verification report, L7: Skill vetting checklist + table analysis, L8: Audit card + handoff pack, L9: custom `SKILL.md` + test record, L10: Defense slides/script + Department Deployment Checklist).
- **Non-offsetting rule**: Prototype evidence CANNOT offset judgment evidence, and vice-versa. Both lines must independently pass.
- Never claim text guidance is a runtime hard control; never claim automatic repair, compliance, zero error, real API/database/model integration, or a tool/script not supported by evidence.

## Self-audit

Before returning:
- verify the selected mode and output only one artifact;
- verify lesson number and authority lineage;
- verify file paths point to `lessons/` (not `docs/`);
- verify counts and H2 structure (8 for PLAN, 6 for GUIDE);
- verify concept cards follow the actionable 3-part framework (是什么 / 怎么用 / 避坑红线);
- for L6–L10: verify 35+35+10+10 dual-track pacing and the 35-min hard cutoff gate;
- verify Task card completeness and zero placeholders;
- verify dual-line evidence non-offsetting rule (P-04);
- verify the inheritance table is present and all deletions have reasons;
- for GUIDE, verify exact conformance to the approved same-lesson teacher plan.
