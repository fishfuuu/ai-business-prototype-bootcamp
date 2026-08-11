---
name: teacher-plan-architect
description: "Compatibility entry point for the teacher-plan-architect skill. Reads and follows the canonical skill at .agents/skills/teacher-plan-architect/SKILL.md. Use when asked to write or refactor a repository TEACHER_PLAN (教师教案)."
---

# Teacher Plan Architect (Compatibility Entry)

This is a **minimal compatibility entry point** for the `teacher-plan-architect` skill. It is **not** a second authority.

## Canonical Source

The complete and canonical skill definition lives at:

`.agents/skills/teacher-plan-architect/SKILL.md`

Read that file in full and follow it. This entry point intentionally does **not** duplicate the 8-module details, Brief schema, contract version, project defaults, or approval logic.

## Fail-Closed

- If the canonical path is missing, unreadable, or fails validation, **stop and report**; do not proceed with an ad-hoc or partial implementation.
- If this entry point's content drifts from the canonical skill, the canonical skill wins.

## Trigger

Use when asked to write or refactor a repository `TEACHER_PLAN` (教师教案). The canonical skill defines the full workflow, boundaries, and fail-closed rules.
