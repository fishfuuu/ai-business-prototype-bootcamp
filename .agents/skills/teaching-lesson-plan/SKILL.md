---
name: teaching-lesson-plan
description: "Upgrade one lesson from its original version by comparing the original teacher plan and learner guide against the frozen baseline and a reference sample. Produces only the Lesson Design Brief (contract_version 2.0); never renders TEACHER_PLAN or GUIDE."
---

# Teaching Lesson Plan (Inheritance-Based Upgrade)

Produce only a **Lesson Design Brief** (contract_version 2.0). Do not render a final teacher plan, learner guide, or repository course artifact.

This skill does not design a lesson from scratch. It **upgrades an existing lesson** by carrying forward proven teaching content and adjusting it to the frozen baseline boundaries.

## Authority and schema

1. Read `.agents/skills/teaching-lesson-plan/references/lesson-design-brief-template.md` in full. Treat it as the only Brief schema and `contract_version` authority.
2. The consumed Brief version is `contract_version: 2.0`. Version 1.0 inputs fail closed.
3. Stop on a missing/stale source, schema mismatch, wrong lesson, or changed objective/non-goal/acceptance meaning.

`HANDOFF_READY` means the Brief is complete and internally consistent. It is not approval, lifecycle state, or authorization to write a teacher plan.

## Mandatory inputs (three types)

Before writing the Brief, read all three input types. Missing any one is a fail-closed stop:

### 1. Frozen baseline
The ten-lesson frozen baseline. This defines course direction, per-lesson positioning, core concepts, Tasks, evidence criteria, AI integration boundaries, and the cross-lesson concept distribution. It is the authority on direction and boundaries.

### 2. Original lesson materials
The original teacher plan and learner guide for the target lesson. These live under ``docs/LESSON_XX_TEACHER_PLAN.md`` and ``docs/LESSON_XX_GUIDE.md`` (or the latest pre-upgrade version). They provide teaching thickness: flow diagrams, detailed prompts, classroom tasks, demonstration steps, teacher explanations, in-class questions, misconceptions and troubleshooting.

### 3. Reference sample (frozen)
The frozen reference sample teacher plan and learner guide. This is the structural and density reference: it shows what a correctly upgraded lesson looks like in the target structure (8 modules and 6 chapters).

## Required workflow: compare first, generate second

### Step 1: Read and compare

Read all three input types. Produce a **content inheritance and adjustment table** before writing any Brief fields:

| Original content | Frozen baseline requirement | Judgment | Treatment | Rationale |
| --- | --- | --- | --- | --- |
| Original core concepts | New concept allocation | retain / rewrite / migrate / delete | specific treatment | correct? is this lesson's focus? |
| Original flow diagrams | This lesson's integration model | retain and rewrite | place in guide ch.1 | does it aid understanding? |
| Original Tasks | New classroom results | retain / shrink / reorder | new position | does it serve the main result? |
| Original prompts | New Task cards | retain verbatim / adjust / migrate | specific treatment | can students use it directly? |
| Original troubleshooting | New debug/fallback plan | retain / consolidate | new position | is it real and useful? |
| Original in-class questions | New assessment design | retain / adjust / add | specific treatment | does it verify real understanding? |
| Original misconceptions | New misconception list | retain / adjust / consolidate | specific treatment | is it still relevant? |

### Step 2: Confirm treatment decisions

For each original content item, confirm one of five treatments:

- **Retain**: keep as-is because it is correct and serves the lesson's main line.
- **Rewrite**: keep the teaching value but adjust expression, depth, or framing to the frozen baseline boundaries.
- **Migrate**: move to a more appropriate lesson (record which lesson).
- **Delete**: remove only with an explicit reason from the default-retain list.
- **Add**: introduce new content required by the frozen baseline that the original did not cover.

### Step 3: Generate the Brief

Only after the inheritance table is complete and treatment decisions are confirmed, generate the Brief following the contract_version 2.0 schema.

## Default-retain principle

Original content does not disappear just because the new template has no matching field. Deletion requires an explicit reason from this list:

1. The concept is wrong or stated too absolutely.
2. It is unrelated to this lesson's main line.
3. It is severely redundant.
4. It exceeds the depth a supervisor needs.
5. It conflicts with current safety boundaries.
6. It has migrated to a more appropriate lesson.

Every deletion or downgrade must be recorded in the inheritance table with its reason. The Brief must not silently drop original content.

## Teaching thickness checks

Before setting `HANDOFF_READY`, verify not just chapter counts but real teaching substance:

- Is there sufficient teacher exposition content (not just headings)?
- Are there directly usable demonstrations and prompts (not placeholders)?
- Does the learner know how to do each step specifically?
- Is there a complete core-concept relationship diagram (not a timetable)?
- Are 90 minutes supported by real teaching activities (not nineteen empty sub-headings)?
- Are in-class questions, extension questions, misconceptions and troubleshooting preserved from the original or replaced with equal or better content?

If any check fails, the Brief is `DRAFT`, not `HANDOFF_READY`.

## Brief field requirements (contract_version 2.0 summary)

The Brief must include all fields from the schema reference. Key additions:

- `prototype_progress_line` and `supervisor_judgment_line`: two parallel lines, separately assessable, merged into one classroom result.
- `core_concept_count` (3-5) and `extension_concept_count` (0-2): independently counted; composite names cannot hide independent judgments.
- `lesson_integrated_model`: one model type (architecture / method_loop / pattern_comparison / capability_evolution / judgment_framework / evidence_chain); must not be a classroom timetable.
- `tasks`: shared Task semantics with teacher card (demonstration / cue / patrol_judgment / failure_fallback) and learner card (purpose / copy_or_execute / expected_observation / check / mandatory_stop).
- `required_questions` (1-5) and `extension_questions` (0-2): may be distributed after corresponding Tasks; answers or judgment points required.
- `misconceptions` (0-5) and `troubleshooting_categories` (0-5): preserved or replaced with equal content from original.
- `inheritance_table`: the content inheritance and adjustment table from Step 1.

## Per-lesson comparison checks (eight dimensions)

After generating the Brief, verify against these eight dimensions:

1. **Course main line**: has it drifted from the original positioning? (e.g., L6 must still be about debugging, not abstract theory)
2. **Concept correctness**: are core concepts correct? Check for over-absolute claims, pseudo-engineering ability, and inaccurate analogies.
3. **Concept placement**: is each concept in the correct lesson? Important but non-focus content should migrate or become extension recognition, not be deleted.
4. **Teaching thickness**: are flow diagrams, detailed prompts, operation steps, teacher narration, examples and questions all checked item by item against the original?
5. **Task alignment**: does each Task serve the classroom main result? Avoid extra homework just to fill template slots.
6. **Dual lines**: are prototype progress and supervisor judgment both advancing, converging into one main result?
7. **90-minute teachability**: is it real and teachable? Not nineteen sub-headings creating false richness, and not a bare framework with no content.
8. **Cross-lesson coherence**: does it read from the previous lesson, modify the right things, and leave the right things for the next lesson?

## Fail closed

Stop and report when:

- the lesson number or authority reference is wrong;
- any of the three mandatory input types is missing;
- the upstream lesson contract conflicts with requested counts or structure;
- the request changes a frozen objective, non-goal, or acceptance meaning;
- a Task has no evidence or stop condition;
- the integrated model is merely a classroom schedule;
- the Brief would silently create more than one GUIDE;
- required capabilities do not exist;
- original content is deleted without a reason from the default-retain list;
- the inheritance table is missing or incomplete;
- teaching thickness checks fail.