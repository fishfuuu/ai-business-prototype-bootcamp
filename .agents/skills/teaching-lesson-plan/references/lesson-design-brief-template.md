# Lesson Design Brief Contract

`contract_version: 2.0`

This file is the only owner of the Brief schema and contract version. `HANDOFF_READY` means completeness only.

## 1. Metadata and authority

| Field | Required | Contract |
| --- | --- | --- |
| `lesson_number` | Yes | Exact L1—L10 lesson |
| `course_context` | Yes | Audience, prior knowledge, modality, group/support, session limit |
| `authority_refs` | Yes | Current locked/frozen/approved inputs and exact lesson baseline |
| `contract_version` | Yes | Must equal `2.0` |
| `candidate_version` | Yes | Version being designed, without overwriting history |
| `comparison_baseline` | No | Historical artifact used only for explicit comparison |

## 2. Result and non-goals

| Field | Required | Contract |
| --- | --- | --- |
| `classroom_main_result` | Yes | One integrated classroom result |
| `prototype_progress_line` | Yes | Visible prototype increment + minimum evidence |
| `supervisor_judgment_line` | Yes | Judgment increment + minimum evidence |
| `line_merge` | Yes | How both lines form one result; no mutual offset |
| `non_goals` | Yes | Explicit lesson exclusions |
| `next_ai_integration_boundary` | Yes | Whether business AI/Agent integration is absent, introduced, or revisited |

## 3. Objectives and evidence

| Field | Required | Contract |
| --- | --- | --- |
| `objectives` | Yes | Bloom ABCD, observable degree |
| `objective_levels` | Yes | Cognitive level per objective |
| `alignment_map` | Yes | Objective -> activity -> evidence -> decision |
| `auto_checkable` | Yes | Fixed-answer evidence |
| `teacher_judged` | Yes | Business reasoning/risk/quality evidence |

## 4. Concept exposure ledger

| Field | Required | Contract |
| --- | --- | --- |
| `core_concepts` | Yes | Each item: name, first/revisited, four-step card, Task ref, independently assessed judgment |
| ``core_concept_count`` | Yes | Integer 3-5 |
| `extension_concepts` | Yes | Recognition only; may be empty |
| ``extension_concept_count`` | Yes | Integer 0-2 |
| `operation_language` | Yes | Plain-language operational terms, not core cards |
| `teacher_background` | Yes | Teacher/engineering background, not learner mastery |
| `composite_rule_check` | Yes | Confirms no compound name hides independent judgments |

## 5. Integrated lesson model

| Field | Required | Contract |
| --- | --- | --- |
| `lesson_integrated_model.type` | Yes | architecture / method_loop / pattern_comparison / capability_evolution / judgment_framework / evidence_chain |
| `lesson_integrated_model.elements` | Yes | Core, extension, background nodes and relations |
| `lesson_integrated_model.learning_function` | Yes | What relationship the learner should retain |
| `lesson_integrated_model.not_timetable` | Yes | Must be `true` |

## 6. Activity and Task logic

| Field | Required | Contract |
| --- | --- | --- |
| ``macro_phases`` | Yes | Adjustable macro phases; 4-6, default ~5; total within 90 minutes |
| `time_budget` | Yes | Integer minute arithmetic and compression order |
| `tasks` | Yes | Shared Task semantics with teacher and learner cards |
| ``tasks[].teacher_card`` | Yes | demonstration / cue / patrol_judgment / failure_fallback |
| ``tasks[].learner_card`` | Yes | purpose / copy_or_execute / expected_observation / check / mandatory_stop |
| `branching` | Yes | Branches and reconvergence; one GUIDE only |

## 7. Assessment and support

| Field | Required | Contract |
| --- | --- | --- |
| ``required_questions`` | Yes | 1-5, with answer/judgment points and Task timing |
| ``extension_questions`` | Yes | 0-2, with answer/judgment points |
| ``misconceptions`` | Yes | 0-5 items |
| ``troubleshooting_categories`` | Yes | 0-5 root-cause categories with fallback |
| ``teacher_checklist_budget`` | Yes | Recommended maximum 8 |

## 8. Output rendering contracts

| Field | Required | Contract |
| --- | --- | --- |
| ``teacher_plan_contract`` | Yes | 8 H2 modules; 4-6 macro phases; Task teacher cards |
| ``learner_guide_contract`` | Yes | 6 H2 chapters; one GUIDE; Task learner cards |
| `guide_requires_approved_plan` | Yes | Must be `true` |
| `guide_conformance_required` | Yes | Must be `true` |

## 9. Safety

| Field | Required | Contract |
| --- | --- | --- |
| `mock_chain` | Yes | Owner -> template -> Agent draft -> teacher/assistant check |
| `no_real_keys` | Yes | No learner keys |
| `pre_deidentification` | Yes | Before AI input |
| `teacher_real_calls` | Yes | Outside repository in controlled environment |
| `no_fabricated_capabilities` | Yes | No invented scripts/tools/results/controls |

## 10. Readiness

| Field | Required | Contract |
| --- | --- | --- |
| `brief_readiness` | Yes | `DRAFT` or `HANDOFF_READY` |
| `readiness_checks` | Yes | Schema, sources, counts, time, safety, dual lines, model, Task cards |

## HANDOFF_READY rules

Set `HANDOFF_READY` only when all required fields are present, `contract_version` is `2.0`, sources are current, core/extension/question/support counts are valid, time fits the upstream limit, both lines have evidence, the integrated model is not a timetable, and every Task has both cards.

## Inheritance and thickness contract

The Brief must carry forward proven teaching content from the original lesson materials. Before generating the Brief, produce a **content inheritance and adjustment table**:

| Original content | Frozen baseline requirement | Judgment | Treatment | Rationale |
| --- | --- | --- | --- | --- |
| Original core concepts | New concept allocation | retain / rewrite / migrate / delete | specific treatment | correct? is this lesson's focus? |
| Original flow diagrams | This lesson's integration model | retain and rewrite | place in guide ch.1 | does it aid understanding? |
| Original Tasks | New classroom results | retain / shrink / reorder | new position | does it serve the main result? |
| Original prompts | New Task cards | retain verbatim / adjust / migrate | specific treatment | can students use it directly? |
| Original troubleshooting | New debug/fallback plan | retain / consolidate | new position | is it real and useful? |

### Default-retain principle

Original content does not disappear just because the new template has no matching field. Deletion requires an explicit reason from this list:

1. The concept is wrong or stated too absolutely.
2. It is unrelated to this lesson's main line.
3. It is severely redundant.
4. It exceeds the depth a supervisor needs.
5. It conflicts with current safety boundaries.
6. It has migrated to a more appropriate lesson.

Every deletion or downgrade must be recorded in the inheritance table with its reason.

### Teaching thickness checks

The Brief must verify, not just chapter counts:

- Is there sufficient teacher exposition content?
- Are there directly usable demonstrations and prompts?
- Does the learner know how to do each step specifically?
- Is there a complete core-concept relationship diagram?
- Are 90 minutes supported by real teaching activities?
- Are in-class questions, extension questions, misconceptions and troubleshooting preserved?

## Fail-Closed Rules

- **Wrong lesson**: `lesson_number` mismatch -> stop, do not consume.
- **Stale source**: authority refs not current -> stop, do not consume.
- **Invalid readiness**: `brief_readiness` not `HANDOFF_READY` -> stop, do not consume.
- **Schema drift**: `contract_version` mismatch or missing fields -> stop, do not consume.
- **Spec gap**: Brief would change objectives, non-goals, or acceptance meaning -> classify as a specification gap, return to DRAFT; do not silently absorb.
- **Missing inheritance table**: Brief produced without a content inheritance table -> stop, do not consume.
- **Unsupported deletion**: original content deleted without a reason from the default-retain list -> stop, do not consume.

Stop on wrong lesson, stale source, schema mismatch, specification gap, multiple-GUIDE design, missing approved-plan dependency, or fabricated capability.
