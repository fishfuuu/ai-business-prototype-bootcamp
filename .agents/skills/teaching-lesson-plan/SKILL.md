---
name: teaching-lesson-plan
description: "Upgrade one lesson from its original version by comparing the original teacher plan and learner guide against the frozen baseline, the dual-track optimization baseline, and a reference sample. Produces only the Lesson Design Brief (contract_version 2.1); never renders TEACHER_PLAN or GUIDE."
---

# Teaching Lesson Plan (Inheritance-Based Upgrade)

> **来源致谢 / Source**: 本 Skill 改编自 [mohitagw15856/pm-claude-skills](https://github.com/mohitagw15856/pm-claude-skills)（MIT License，© Mohit Aggarwal），并经本课程教学化二次改造，适配双轨制（Dual-Track 35+35+10+10）教学工程体系。

Produce only a **Lesson Design Brief** (contract_version 2.1). Do not render a final teacher plan, learner guide, or repository course artifact.

This skill does not design a lesson from scratch. It **upgrades an existing lesson** by carrying forward proven teaching content, aligning with the actionable 3-part concept framework, and applying the dual-track architecture for L6–L10.

## Authority and schema

1. Read `.agents/skills/teaching-lesson-plan/references/lesson-design-brief-template.md` in full. Treat it as the only Brief schema and `contract_version` authority.
2. The consumed Brief version is `contract_version: 2.1`. Versions prior to 2.0 fail closed; version 2.0 upgrades to 2.1 with dual-track fields.
3. Stop on a missing/stale source, schema mismatch, wrong lesson, or changed objective/non-goal/acceptance meaning.

`HANDOFF_READY` means the Brief is complete, thickness-verified, and internally consistent. It is not approval, lifecycle state, or authorization to write a teacher plan.

## Mandatory inputs (four types)

Before writing the Brief, read all four input types. Missing any one is a fail-closed stop:

### 1. Frozen baseline & optimization proposal
- `lessons/TEN_LESSON_FROZEN_BASELINE.md`: Course direction, per-lesson positioning, concept distribution, and acceptance boundaries.
- `lessons/CURRICULUM_REBALANCING_AND_DUAL_TRACK_OPTIMIZATION_PROPOSAL.md`: The approved dual-track architecture (v1.4.1 Approved & Frozen Baseline · 2026-09-16), including 35+35+10+10 time allocation, 35-min hard cutoff gate (P-01), desk runtime guides (P-02), cold-start scaffolds (P-03), TPA evidence independence (P-04), and `intent-to-outcome-loop` integration.
- `lessons/COURSE_ROADMAP.md`: Current course roadmap and four business archetype definitions (A/B/C/D).

### 2. Current lesson materials
The current teacher plan and learner guide for the target lesson under `lessons/`:
- `lessons/LESSON_XX_TEACHER_PLAN.md`
- `lessons/LESSON_XX_GUIDE.md`
(Note: Historical pre-v4 drafts under `archive/docs/` or `docs/` are read-only reference manuscripts and must NOT be used as the primary upgrade target).

### 3. Concept framework authority
`GLOSSARY.md` and commit `7114ddc` actionable 3-part framework:
1. **是什么 (What it is / is not)**: Objective definition and boundaries.
2. **怎么用 (How to use it)**: Real operational action in the task.
3. **避坑红线 (Redlines / Anti-patterns)**: Explicit prohibited behaviors.
+ **交接价值 (Handoff / Task reference)**: Explicit mapping back to supervisor task and IT communication value.

### 4. Reference sample (frozen)
The frozen reference sample teacher plan and learner guide. This is the structural and density reference showing target 8-module teacher plan and 6-chapter learner guide density.

## Required workflow: compare first, generate second

### Step 1: Read and compare

Read all input types. Produce a **content inheritance and adjustment table** before writing any Brief fields:

| Original content | Frozen baseline requirement | Judgment | Treatment | Rationale |
| --- | --- | --- | --- | --- |
| Original core concepts | Actionable 3-part framework (是什么/怎么用/避坑红线) | retain / rewrite / migrate / delete | specific treatment | correct? actionable? is this lesson's focus? |
| Original flow diagrams | This lesson's integrated model | retain and rewrite | place in guide ch.1 | does it aid understanding? not a timetable? |
| Original Tasks | Dual-track result (Track A沙盘 + Track B管理实操) | retain / shrink / split / reorder | Track A (T1-T2) vs Track B (T3-T4) | does it serve the dual-track main result? |
| Original prompts | New Task cards | retain verbatim / adjust / migrate | specific treatment | can students use it directly? no placeholders? |
| Original troubleshooting | Debug / fallback plan | retain / consolidate | new position | root cause <= 5 categories? real and useful? |
| Original in-class questions | New assessment design | retain / adjust / add | specific treatment | 1-5 required, 0-2 extension, with answers? |
| Original misconceptions | Misconceptions list | retain / adjust / consolidate | specific treatment | <= 5 items? still relevant to business? |

### Step 2: Confirm treatment decisions

For each original content item, confirm one of five treatments:
- **Retain**: keep as-is because it is correct and serves the lesson's main line.
- **Rewrite**: keep teaching value but adjust expression to the actionable 3-part concept format or dual-track timing.
- **Migrate**: move to a more appropriate lesson (record which lesson).
- **Delete**: remove only with an explicit reason from the default-retain list.
- **Add**: introduce new content required by the dual-track baseline (e.g. Track B management exercise, scaffold checklist, Golden Sample).

### Step 3: Generate the Brief

Only after the inheritance table is complete and treatment decisions are confirmed, generate the Brief following the `contract_version: 2.1` schema.

## Default-retain principle

Original content does not disappear just because the new template has no matching field. Deletion requires an explicit reason from this list:
1. The concept is wrong or stated too absolutely.
2. It is unrelated to this lesson's main line.
3. It is severely redundant.
4. It exceeds the depth a supervisor needs.
5. It conflicts with current safety boundaries.
6. It has migrated to a more appropriate lesson.

Every deletion or downgrade must be recorded in the inheritance table with its reason. The Brief must not silently drop original content.

## Dual-track architecture rules (L6–L10)

For lessons L6 through L10, the Brief MUST enforce the approved dual-track model:

1. **35+35+10+10 Time Budget**:
   - `00–35 min`: **Track A (Prototype Sandpit)** — Hands-on code prototype milestone.
   - `35 min`: **Hard Cutoff Gate (硬切门禁)** — Any student blocked at 35 min must be given a pre-built snapshot by the TA and transitioned to Track B immediately.
   - `35–70 min`: **Track B (Management Practice & Skills)** — Hands-on non-code management exercise (L6: Pre-signature verification & management sign-off, L7: Find Skills + 办公数据分析实操, L8: Dual-Agent red-blue audit & Reviewed-Change, L9: Find ➔ Critique ➔ /shape 定型 ➔ Create 创造四步闭环, L10: /evaluate 全量评估 ➔ HITL 整改 ➔ /coordinate 双轨交接与抽签答辩).
   - `70–80 min`: **Isomorphic Synthesis & Sign-off** — Conceptual bridge between code sandpit and management practice; sign checklist/audit card.
   - `80–90 min`: **Closing & Archival** — Git commit, `PROJECT_STATE.md` update, buffer.

2. **TPA Dual-Line Minimum Evidence Independence (P-04)**:
   - `prototype_progress_line`: Minimum evidence from Track A (Git commit, Vite UI state, Playwright screenshot).
   - `supervisor_judgment_line`: Minimum evidence from Track B (L6: 签发前核验与裁决单; L7: 外部技能体检表+表格对账实测; L8: 重大方案内审卡+交接包; L9: 部门专属SKILL.md+测试记录; L10: 答辩讲稿/PPT+部门落地清单与HITL责任人).
   - **Non-offsetting rule**: Prototype evidence CANNOT offset judgment evidence, and vice-versa. Both lines must independently pass.

3. **Four Archetypes Decision Loop Adaptation (`a665ff4`)**:
   - Type A (Monitoring & Decision), Type B (Task & Workflow), Type C (Tool & Operation), Type D (R&D & Creative Studio).
   - Tasks must accommodate decision loops (inspect anomaly -> root cause -> strategy draft -> HITL approval).

## Teaching thickness checks

Before setting `HANDOFF_READY`, verify:
- Is there sufficient teacher exposition content (not just headings)?
- Are there directly usable demonstrations and prompts (zero placeholders)?
- Does the learner know how to do each step specifically?
- Is there a complete core-concept relationship diagram (not a timetable)?
- For L6–L10: Are Track A (Tasks 1-2) and Track B (Tasks 3-4) explicitly mapped with time bounds?
- Are the standard scaffolds referenced where required (`FIND_SKILLS_VETTING_CHECKLIST.md`, `csv-data-analyzer`, `RED_BLUE_AUDIT_CARD.md`, `SKILL_TEMPLATE_BUSINESS.md`, Golden Samples, `IT_DEVELOPMENT_STARTER_PACK_TEMPLATE.md`, `DEPARTMENT_AGENT_DEPLOYMENT_SOP_TEMPLATE.md`, `intent-to-outcome-loop`)?
- Are in-class questions, extension questions, misconceptions, and troubleshooting preserved or improved?

If any check fails, the Brief is `DRAFT`, not `HANDOFF_READY`.

## Fail-closed rules

Stop and report when:
- `lesson_number` or authority reference is wrong;
- Any of the mandatory input types is missing;
- Input path points to stale `docs/` instead of active `lessons/`;
- `contract_version` is not `2.1`;
- The Brief lacks a complete content inheritance table;
- An original element was deleted without a valid default-retain reason;
- L6–L10 fails to implement the 35+35+10+10 dual-track budget or lacks the 35-min hard cutoff gate;
- Dual-line evidence allows cross-offsetting (violating P-04);
- Concepts use obsolete unaligned formats instead of the actionable 3-part framework;
- Teaching thickness checks fail or placeholders are detected.