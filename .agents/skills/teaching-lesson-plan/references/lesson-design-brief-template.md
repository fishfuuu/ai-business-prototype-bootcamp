# Lesson Design Brief Contract

`contract_version: 2.1`

This file is the only owner of the Brief schema and contract version. `HANDOFF_READY` means completeness and internal consistency.

## 1. Metadata and authority

| Field | Required | Contract |
| --- | --- | --- |
| `lesson_number` | Yes | Exact L1—L10 lesson |
| `course_context` | Yes | Audience, prior knowledge, modality, group/support, session limit |
| `authority_refs` | Yes | Current locked/frozen/approved inputs: `TEN_LESSON_FROZEN_BASELINE.md`, `COURSE_ROADMAP.md`, `CURRICULUM_REBALANCING_AND_DUAL_TRACK_OPTIMIZATION_PROPOSAL.md` (v1.4.1 Approved & Frozen Baseline · 2026-09-16), `GLOSSARY.md` |
| `contract_version` | Yes | Must equal `2.1` |
| `candidate_version` | Yes | Version being designed, without overwriting history |
| `comparison_baseline` | No | Historical artifact used only for explicit comparison under `lessons/` |

## 2. Result and non-goals

| Field | Required | Contract |
| --- | --- | --- |
| `classroom_main_result` | Yes | One integrated classroom result combining prototype progress and supervisor judgment |
| `dual_track_structure` | Yes (L6–L10) | Explicit partition: `track_a_sandpit` (0–35 min, Tasks 1–2) and `track_b_management` (35–70 min, Tasks 3–4) |
| `prototype_progress_line` | Yes | Visible prototype increment + minimum evidence (Track A: Git commit, Vite UI state, Playwright screenshot) |
| `supervisor_judgment_line` | Yes | Judgment increment + minimum evidence (Track B: Signoff verification report, Skill vetting checklist, Audit card, custom `SKILL.md`) |
| `line_merge` | Yes | How both lines form one result. **Enforce P-04 non-offsetting rule**: Prototype evidence and Judgment evidence are strictly independent and CANNOT mutually offset |
| `non_goals` | Yes | Explicit lesson exclusions |
| `next_ai_integration_boundary` | Yes | Whether business AI/Agent integration is absent, introduced, or revisited |
| `archetype_adaptations` | Yes | Explicit accommodation for 4 archetypes: Type A (Monitoring & Decision), Type B (Task & Workflow), Type C (Tool & Operation), Type D (R&D & Creative Studio) |

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
| `core_concepts` | Yes | Each item: name, first/revisited, actionable 3-part card (**是什么 / 怎么用 / 避坑红线**) + Task ref & 交接价值, independently assessed judgment |
| `core_concept_count` | Yes | Integer 3-5 |
| `extension_concepts` | Yes | Recognition only; may be empty |
| `extension_concept_count` | Yes | Integer 0-2 |
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
| `macro_phases` | Yes | For L1–L5: 4–6 phases within 90 min.<br>For L6–L10: **Rigid 35+35+10+10 structure**: Track A (0–35m) ➔ Track B (35–70m) ➔ Isomorphic Synthesis (70–80m) ➔ Closing & Sync (80–90m) |
| `hard_cutoff_gate` | Yes (L6–L10) | **35-min Hard Cutoff Gate (硬切门禁)**: TA issues pre-built recovery snapshot to any blocked student at 35 min; all students transition to Track B on time |
| `time_budget` | Yes | Integer minute arithmetic and compression order |
| `tasks` | Yes | Shared Task semantics with teacher and learner cards.<br>For L6–L10: Tasks 1–2 map to Track A (Prototype Sandpit); Tasks 3–4 map to Track B (Management & Skills Practice) |
| `tasks[].teacher_card` | Yes | demonstration / cue / patrol_judgment / failure_fallback |
| `tasks[].learner_card` | Yes | purpose / copy_or_execute / expected_observation / check / mandatory_stop |
| `branching` | Yes | Branches and reconvergence; one GUIDE only |

## 7. Assessment and support

| Field | Required | Contract |
| --- | --- | --- |
| `required_questions` | Yes | 1-5, with answer/judgment points and Task timing |
| `extension_questions` | Yes | 0-2, with answer/judgment points |
| `misconceptions` | Yes | 0-5 items |
| `troubleshooting_categories` | Yes | 0-5 root-cause categories with fallback |
| `support_scaffolds` | Yes | Specific scaffolds referenced:<br>• L6: `student-package/templates/SIGNOFF_VERIFICATION_TEMPLATE.md` & `student-package/cases/cross_department_delay_case.md` (含待签发草案与原始物证素材) & `student-package/cases/signoff_practice_packs.md`<br>• L7: `student-package/templates/FIND_SKILLS_VETTING_CHECKLIST.md` & `student-package/cases/monthly_expense_sample.csv` & 预审分析技能 `student-package/templates/skills/csv-data-analyzer/SKILL.md`<br>• L8: `student-package/templates/RED_BLUE_AUDIT_CARD.md` & Reviewed-Change 独立审查框架<br>• L9: `student-package/templates/SKILL_TEMPLATE_BUSINESS.md` & 3 套 Golden Sample (`fin-invoice-audit`, `hr-interview-screener`, `ops-supplier-quote-compare`) & `/shape`<br>• L10: 结业综合评估与交接套件（`student-package/templates/IT_DEVELOPMENT_STARTER_PACK_TEMPLATE.md` & `student-package/templates/DEPARTMENT_AGENT_DEPLOYMENT_SOP_TEMPLATE.md` & `/evaluate` / HITL / `/coordinate` 导出规范） |

## 8. Output rendering contracts

| Field | Required | Contract |
| --- | --- | --- |
| `teacher_plan_contract` | Yes | 8 H2 modules; 35+35+10+10 dual-track pacing for L6–L10; Task teacher cards |
| `learner_guide_contract` | Yes | 6 H2 chapters; one GUIDE; Task learner cards |
| `guide_requires_approved_plan` | Yes | Must be `true` |
| `guide_conformance_required` | Yes | Must be `true` |

## 9. Safety and Data Redlines

| Field | Required | Contract |
| --- | --- | --- |
| `mock_chain` | Yes | Owner -> template -> Agent draft -> teacher/assistant check |
| `no_real_keys` | Yes | No learner keys;全程 Mock 数据红线 |
| `pre_deidentification` | Yes | Before AI input |
| `teacher_real_calls` | Yes | Outside repository in controlled environment |
| `no_fabricated_capabilities` | Yes | No invented scripts/tools/results/controls |

## 10. Readiness and inheritance

| Field | Required | Contract |
| --- | --- | --- |
| `brief_readiness` | Yes | `DRAFT` or `HANDOFF_READY` |
| `readiness_checks` | Yes | Schema, sources, counts, time, safety, dual lines, model, Task cards |
| `inheritance_table` | Yes | Complete content inheritance and adjustment table comparing original lesson against frozen baseline |

## Fail-Closed Rules

- **Wrong lesson**: `lesson_number` mismatch -> stop.
- **Stale source**: authority refs not current, or pointing to `docs/` instead of `lessons/` -> stop.
- **Schema mismatch**: `contract_version` not `2.1` -> stop.
- **Dual-track violation (L6–L10)**: Lacking 35+35+10+10 time breakdown, missing 35-min hard cutoff gate, or failing to separate Track A sandpit and Track B management tasks -> stop.
- **Evidence offset violation (P-04)**: Allowing prototype evidence to offset judgment evidence or vice-versa -> stop.
- **Concept format drift**: Using unaligned formats instead of the actionable 3-part framework (是什么 / 怎么用 / 避坑红线) -> stop.
- **Missing inheritance table**: Brief produced without content inheritance table -> stop.
- **Unsupported deletion**: Original content deleted without a reason from the default-retain list -> stop.
- **Placeholders**: Detecting `TODO`, `...`, or empty prompts in Task cards -> stop.
