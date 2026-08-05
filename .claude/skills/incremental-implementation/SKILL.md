---
name: incremental-implementation
description: Delivers multi-file changes incrementally using contract-first slices, persistent implementation plans, Step-level Workflow authorization gates, prototype debug toggles, and silent Verifier Subagent self-tests.
---

# Incremental Implementation

## Overview

Build in thin vertical slices — implement one piece, test it, verify it, then expand. Avoid implementing an entire feature in one pass. Each increment MUST leave the system in a working, testable state without polluting the main context window.

## Workflow & Authorization Protocol (Step级 Workflow 授权门禁)

To enforce strict, non-ambiguous human-in-the-loop control:

### Phase 1: Read-Only Plan Preview (只读预览)
- Read `BUSINESS_FEATURE_CARD.md`, `src/types/prototype-contract.d.ts`, `src/mocks/prototype-data.ts`.
- Output proposed 3–5 step Contract-First execution plan preview in chat.
- **CRITICAL**: Absolutely DO NOT write, modify, or delete any files during Phase 1.
- End response with exact prompt: `计划预览生成完毕。请输入 "授权保存 Lesson 04 实施计划" 以写入工程。`

### Phase 2: Plan Persistence (计划落盘门禁)
- Require user input to match exact phrase: `授权保存 Lesson 04 实施计划`
- Write persistent plan to `docs/LESSON_04_IMPLEMENTATION_PLAN.md`.
- End response with exact prompt: `实施计划已落盘至 docs/LESSON_04_IMPLEMENTATION_PLAN.md。请输入 "授权执行 Step 1" 以开始首个切片编码。`

### Phase 3: Step-by-Step Execution (Step级 Workflow 授权门禁)
- **Exact Match Rule**: Code execution is unlocked ONLY when the user's message FIRST LINE matches:
  ```text
  授权执行 Step N
  ```
  where `N` matches the current waiting step recorded in `docs/LESSON_04_IMPLEMENTATION_PLAN.md`.
- **Step Constraints**:
  - One authorization permits execution of ONE step only.
  - Do NOT auto-execute subsequent steps.
  - Do NOT modify acceptance criteria or auto-commit git without explicit instruction.
  - If tests fail, stop immediately and report log path. Do NOT attempt silent code auto-fixes.

### Phase 4: Silent Verification & Atomic Commit (静默断言)
- Invoke `Verifier Subagent` (`.claude/agents/verifier.md`) or run `powershell -ExecutionPolicy Bypass -File scripts/run-lesson-verifier.ps1 -Step N`.
- Save untruncated verification logs to `local-backups/lesson-04-evidence/step-N-verification.log`.
- Main context receives 1 summary line: `[PASS] Step N Verification clean | Log: local-backups/lesson-04-evidence/step-N-verification.log`.
- Prompt user for Atomic Git Commit after verification passes.

## Prototype Debug Toggle Requirement

- **Step 1 UI Requirement**: The initial component skeleton MUST introduce a reactive `prototypeState` debug toggle pill labeled `Prototype Debug` (`showPrototypeDebug = import.meta.env.DEV`):
  ```typescript
  const showPrototypeDebug = import.meta.env.DEV
  const prototypeState = ref<'loading' | 'empty' | 'error' | 'success'>('success')
  ```
- **Subsequent Steps**: Preserve and maintain the `prototypeState` debug toggle. Do NOT delete or re-add it repeatedly.

## Slicing Strategy (Contract-First)

```
Slice 0: Validate Baseline SHA & Contracts (BUSINESS_FEATURE_CARD.md + prototype-contract.d.ts + prototype-data.ts)
Slice 1: Component Skeleton + Prototype Debug 4-State Toggle (Loading / Empty / Error / Success UI)
Slice 2: Mock Data Binding & Success List View
Slice 3: Error Recovery Action (Retry -> Loading -> Restore) & Search Filter
Slice 4: Final Verification & Clean Commit
```
