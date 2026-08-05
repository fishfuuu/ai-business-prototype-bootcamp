---
name: incremental-implementation
description: Delivers multi-file changes incrementally using contract-first slices, persistent implementation plans with state machines, 2-commit state transition protocols, prototype debug toggles, and silent Verifier Subagent self-tests.
---

# Incremental Implementation

## Overview

Build in thin vertical slices — implement one piece, test it, verify it, then expand. Avoid implementing an entire feature in one pass. Each increment MUST leave the system in a working, testable state without polluting the main context window.

## Workflow & Authorization Protocol (Step级 Workflow 授权门禁)

To enforce strict, non-ambiguous human-in-the-loop control:

### Phase 1: Read-Only Plan Preview (只读预览)
- Read `docs/BUSINESS_FEATURE_CARD.md`, `src/types/prototype-contract.d.ts`, `src/mocks/prototype-data.ts`.
- Output proposed 3–5 step Contract-First execution plan preview in chat.
- **CRITICAL**: Absolutely DO NOT write, modify, or delete any files during Phase 1.
- End response with exact prompt: `计划预览生成完毕。请输入 "授权保存 Lesson 04 实施计划" 以写入工程。`

### Phase 2: Plan Persistence & State Machine Schema (计划落盘门禁)
- Require user input to match exact phrase: `授权保存 Lesson 04 实施计划`
- Write persistent plan to `docs/LESSON_04_IMPLEMENTATION_PLAN.md` using the exact Schema:
  ```markdown
  # Lesson 04 实施计划 (Implementation Plan)

  ```yaml
  plan_status: APPROVED
  current_waiting_step: 1

  steps:
    - id: 1
      name: "组件骨架与 prototypeState 4 状态调试切片"
      status: READY
      allowed_files: ["src/components/WorkOrderBoard.vue"]
      acceptance: "支持 prototypeState 4 状态调试按钮切换 (Loading / Empty / Error / Success)"
      verification_log: ""
      commit_sha: ""
    - id: 2
      name: "绑定 Mock 数据与渲染列表"
      status: BLOCKED
      allowed_files: ["src/components/WorkOrderBoard.vue"]
      acceptance: "成功渲染工单列表"
      verification_log: ""
      commit_sha: ""
  ```
  ```
- End response with exact prompt: `实施计划已落盘至 docs/LESSON_04_IMPLEMENTATION_PLAN.md。请输入 "授权执行 Step 1" 以开始首个切片编码。`

### Phase 3: Step-by-Step Execution (Step级 Workflow 授权门禁)
- **Exact Match Rule**: Code execution is unlocked ONLY when the user's message FIRST LINE matches:
  ```text
  授权执行 Step N
  ```
  where `N` matches `current_waiting_step` recorded in `docs/LESSON_04_IMPLEMENTATION_PLAN.md`.
- **Step Constraints**:
  - One authorization permits execution of ONE step only.
  - Do NOT auto-execute subsequent steps.
  - Do NOT modify allowed files or acceptance criteria without explicit human authorization.
  - If tests fail, stop immediately and report log path. Do NOT attempt silent code auto-fixes.

### Phase 4: Silent Verification & 2-Commit State Transition Protocol (两提交状态推进协议)

1. **Silent Verification**:
   - Invoke `Verifier Subagent` (`.claude/agents/verifier.md`) or run `powershell -ExecutionPolicy Bypass -File scripts/run-lesson-verifier.ps1 -Step N`.
   - Log saved to `local-backups/lesson-04-evidence/step-N-verification.log`.
   - Main context receives 1 summary line: `[PASS] Step N Verification clean | Log: local-backups/lesson-04-evidence/step-N-verification.log`.
   - End response with exact prompt: `Step N 校验通过。请输入 "授权提交 Step N 源码" 以提交代码。`

2. **Commit A Authorization & Execution (Commit A 源码提交)**:
   - Require user input to match exact phrase: `授权提交 Step N 源码`
   - Commit the implementation source code:
     `git commit -m "feat(prototype): step N - implement target slice"`
   - Obtain Commit A SHA via `git rev-parse HEAD`.
   - Update `docs/LESSON_04_IMPLEMENTATION_PLAN.md`:
     - Step N `status` -> `COMPLETED`
     - Step N `verification_log` -> `local-backups/lesson-04-evidence/step-N-verification.log`
     - Step N `commit_sha` -> `<Commit A SHA>`
     - Step N+1 `status` -> `READY` (or if final step: `plan_status: COMPLETED`, `current_waiting_step: null`)
     - `current_waiting_step` -> `N+1` (or `null` if final step)
   - End response with exact prompt: `Step N 源码已提交 (Commit A)。实施计划状态机已更新。请输入 "授权提交 Step N 状态推进" 以归档实施计划。`

3. **Commit B Authorization & Execution (Commit B 状态推进提交)**:
   - Require user input to match exact phrase: `授权提交 Step N 状态推进`
   - Commit plan state update:
     `git commit -m "docs(state): advance lesson 04 plan to step N+1"`

## Prototype Debug Toggle Requirement

- **Step 1 UI Requirement**: The initial component skeleton MUST introduce a reactive `prototypeState` debug toggle pill labeled `Prototype Debug` (`showPrototypeDebug = import.meta.env.DEV`):
  ```typescript
  const showPrototypeDebug = import.meta.env.DEV
  const prototypeState = ref<'loading' | 'empty' | 'error' | 'success'>('success')
  ```
- **Subsequent Steps**: Preserve and maintain the `prototypeState` debug toggle. Do NOT delete or re-add it repeatedly.

## Slicing Strategy (Contract-First)

```
Slice 0: Validate Baseline SHA & Contracts (docs/BUSINESS_FEATURE_CARD.md + src/types/prototype-contract.d.ts + src/mocks/prototype-data.ts)
Slice 1: Component Skeleton + Prototype Debug 4-State Toggle (Loading / Empty / Error / Success UI)
Slice 2: Mock Data Binding & Success List View
Slice 3: Error Recovery Action (Retry -> Loading -> Restore) & Search Filter
Slice 4: Final Verification & Clean Commit
```
