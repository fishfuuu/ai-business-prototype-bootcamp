---
name: teacher-plan-architect
description: "Render either an 8-module repository TEACHER_PLAN from a HANDOFF_READY Lesson Design Brief, or—only after the same lesson's teacher plan has independent review and user/course-owner approval—a single 6-chapter learner GUIDE. Use for final teacher-plan or learner-guide rendering. Never render both in one invocation and never self-approve."
---

# Teacher Plan Architect

Render one final lesson artifact in one of two mutually exclusive modes:

- ``PLAN``: an 8-module teacher plan;
- ``GUIDE``: one 6-chapter learner guide derived from the same lesson`s approved teacher plan.

Never render both modes in one invocation. Do not own lifecycle, artifacts, reviews, or approvals.

## Shared authority

- Brief schema authority: `.agents/skills/teaching-lesson-plan/references/lesson-design-brief-template.md`
- Consumed Brief version: `contract_version: 2.0`
- Course rules and approved lesson artifacts outrank Skill defaults.
- Stop on wrong lesson, stale source, schema drift, missing field, changed objective/non-goal/acceptance meaning, or fabricated capability.

## Inheritance-based upgrade

This skill does not render from a blank template. Each lesson is an upgrade of an existing lesson. The Brief must carry a content inheritance table (produced by teaching-lesson-plan). TPA must verify the inheritance table is present and complete before rendering.

If the Brief's inheritance table is missing, incomplete, or contains unsupported deletions (original content deleted without a reason from the default-retain list), fail closed: stop and report.

### Teaching thickness enforcement

When rendering either PLAN or GUIDE, verify against the original lesson materials:

- Flow diagrams from the original are preserved or replaced with an equal or better integrated model.
- Detailed prompts from the original are preserved verbatim, adjusted, or replaced with equal or better prompts in the Task cards.
- Classroom tasks and demonstration steps from the original are carried into the Task cards.
- In-class questions, extension questions, misconceptions and troubleshooting from the original are preserved or replaced with equal content.
- Teacher narration and explanations have real substance, not just headings.

If the original had a flow diagram and the upgraded output has none, stop. If the original had usable prompts and the upgraded output has placeholders, stop. If the original had real teacher narration and the upgraded output has only section titles, stop.

## Mode selection

### PLAN mode

Require:

- `HANDOFF_READY` Brief for the requested lesson;
- Brief contains a complete content inheritance table;
- current authority references;
- valid concept, time, dual-line, model, Task, assessment, and safety fields.

Output only the teacher plan. Do not output a GUIDE or approval claim.

### GUIDE mode

Require all of:

- same-lesson approved teacher plan exact path and content/version identifier;
- real Independent Review reference;
- real user/course-owner approval reference;
- the corresponding Brief or a traceable approved-plan reference to its frozen meaning;
- requested GUIDE lesson number matching the plan and Brief.

Output only one GUIDE. Stop when an approval reference is missing, stale, wrong-lesson, non-resolving, or merely asserted in prose. Do not repair an approved plan from GUIDE mode; return conflicts upstream as a specification gap.

## PLAN rendering contract

Render exactly 8 H2 modules:

1. course metadata and positioning;
2. backward-aligned objectives, evidence, and concept cards;
3. teaching preparation and safety boundaries;
4. 90-minute control line;
5. Task demonstration and patrol guidance;
6. classroom Debug/fallback plan;
7. assessment, passing criteria, and between-lesson task;
8. teacher preparation checklist.

Rules:

- Preserve 3-5 core concepts and 0-2 extension concepts from the Brief.
- Render the integrated lesson model as a relationship/model for learners; keep classroom timing teacher-only.
- Use 4-6 macro phases, approximately 5 by default; do not create fixed Pause Points.
- For every Task render: **teacher demonstration / teacher cue / patrol judgment / failure fallback**.
- Keep Troubleshooting to at most 5 root-cause categories.
- Keep teacher checklist to at most 8 items unless an upstream contract explicitly requires more.
- Render the two learning lines and their separate passing evidence.
- Include 1-5 required questions and 0-2 extension questions with answer/judgment points; distribute them after corresponding Tasks when the Brief says so.
- Carry forward original prompts, flow diagrams, and teacher narration per the inheritance table. Do not replace usable content with placeholders.

## GUIDE rendering contract

Render exactly 6 H2 chapters serving these functions:

1. understand lesson value, result, integrated model, and core concepts;
2. prepare the environment and choose the lesson starting point;
3. complete the Tasks;
4. preserve safety boundaries and handle misconceptions/problems;
5. verify results and complete assessment;
6. prepare the next lesson input or micro-task.

Rules:

- Create one learner guide only. Keep A/B/C or other branches inside the relevant Task and reconverge afterward.
- Do not expose the teacher timetable as the learner integrated model.
- For every Task render: **purpose / copy or execute / expected observation / check / mandatory stop**.
- Preserve approved prompts completely unless the approved plan explicitly authorizes compression.
- Keep common misconceptions at 5 or fewer and troubleshooting root categories at 5 or fewer.
- Render 1-5 required questions, 0-2 extension questions, and answers/judgment points.
- Do not introduce concepts, Tasks, scope, passing criteria, safety claims, or homework absent from the approved teacher plan.
- Keep the classroom main result achievable in class; do not move core completion to homework.
- Carry forward original prompts, flow diagrams, and learner-facing explanations per the inheritance table. Do not replace usable content with placeholders.

## Four-step concept card

For each first-introduced core concept render:

1. what it is / is not;
2. mechanism;
3. coherent business metaphor and counterexample;
4. just-completed Task reference and supervisor handoff/judgment value.

Do not promote extension, operational, or teacher-background labels into core cards.

## Evidence and truthfulness

- Visual evidence: visible state, comparison, or result when applicable.
- Behavioral evidence: an actual interaction/result.
- Engineering evidence: only commands and outputs actually run; repository maintenance scripts are not classroom/business proof.
- Scope evidence: actual changed range when available; never require an artificially clean working tree as business proof.

Never claim text guidance is a runtime hard control; never claim automatic repair, compliance, zero error, real API/database/model integration, or a tool/script not supported by evidence.

## Self-audit

Before returning:

- verify the selected mode and output only one artifact;
- verify lesson number and authority lineage;
- verify counts and H2 structure;
- verify Task card completeness;
- verify dual-line evidence;
- verify integrated model is not a timetable;
- verify safety and factual claims;
- verify the inheritance table is present and all deletions have reasons;
- verify teaching thickness: original prompts, flow diagrams, teacher narration, questions, misconceptions and troubleshooting are preserved or replaced with equal or better content;
- for GUIDE, verify exact conformance to the approved same-lesson teacher plan.
