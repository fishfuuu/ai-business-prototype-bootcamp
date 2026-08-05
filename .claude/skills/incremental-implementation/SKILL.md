---
name: incremental-implementation
description: Delivers multi-file changes incrementally using contract-first thin slices, persistent implementation plans with state machines, two-commit state transition protocols, technical state debug toggles, and silent verifier self-tests.
---

# Incremental Implementation

## Overview

Build in thin vertical slices — create a plan first, then implement one verifiable piece at a time. Avoid implementing an entire feature in one pass. Each increment MUST leave the system in a working, testable state without polluting the main context window.

## Workflow & Authorization Protocol (Step级 Workflow 授权门禁)

### Phase 1: Read-Only Plan Preview (只读预览)
- Read `docs/BUSINESS_FEATURE_CARD.md`, `src/types/prototype-contract.d.ts`, `src/mocks/prototype-data.ts`.
- Output proposed 3–5 step Contract-First execution plan preview in chat.
- **CRITICAL**: Do NOT write, modify, or delete any files during Phase 1.
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
      name: "组件骨架与页面技术状态调试切片"
      status: READY
      allowed_files: ["src/pages/HomePage.vue", "src/components/"]
      acceptance: "支持页面技术状态调试器切换 (Loading / Empty / Error / Success)"
      failure_summary: ""
      verification_log: ""
      commit_sha: ""
    - id: 2
      name: "绑定 Mock 数据与渲染业务列表"
      status: BLOCKED
      allowed_files: ["src/pages/HomePage.vue", "src/components/"]
      acceptance: "成功渲染业务列表与交互"
      failure_summary: ""
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
  - **Failure Rule**: If verification fails, do NOT auto-fix blindly. Update step `status` to `BLOCKED`, write `failure_summary`, and present evidence to human manager.

### Phase 4: Verification & Selective 2-Commit Protocol (验证与选择性暂存协议)

1. **Silent Verification**:
   - Invoke `Verifier Subagent` (`.claude/agents/verifier.md`) or run `powershell -ExecutionPolicy Bypass -File scripts/run-lesson-verifier.ps1 -Step N`.
   - Log saved to `local-backups/lesson-04-evidence/step-N-verification.log`.
   - Main context receives 1 summary line: `[PASS] Step N Verification clean | Log: local-backups/lesson-04-evidence/step-N-verification.log`.
   - End response with exact prompt: `Step N 校验通过。请输入 "授权提交 Step N 源码" 以提交代码。`

2. **Commit A Selective Staging & Execution (Commit A 源码选择性暂存提交)**:
   - Require user input to match exact phrase: `授权提交 Step N 源码`
   - Execute selective staging rules:
     ```bash
     git status
     git add -- <Step N allowed_files>
     git diff --cached --name-only
     git diff --cached
     git commit -m "feat(prototype): step N - implement target slice"
     ```
   - **Staging Assertion**: Commit A MUST ONLY stage files listed in Step N `allowed_files`. It MUST NOT stage `docs/LESSON_04_IMPLEMENTATION_PLAN.md`.
   - Obtain Commit A SHA via `git rev-parse HEAD`.
   - Update `docs/LESSON_04_IMPLEMENTATION_PLAN.md`:
     - Step N `status` -> `COMPLETED`
     - Step N `verification_log` -> `local-backups/lesson-04-evidence/step-N-verification.log`
     - Step N `commit_sha` -> `<Commit A SHA>`
     - Step N+1 `status` -> `READY` (or if final step: `plan_status: COMPLETED`, `current_waiting_step: null`)
     - `current_waiting_step` -> `N+1` (or `null` if final step)
   - End response with exact prompt: `Step N 源码已提交 (Commit A)。实施计划已更新。请输入 "授权提交 Step N 状态推进" 以归档实施计划。`

3. **Commit B Selective Staging & Execution (Commit B 状态推进选择性暂存提交)**:
   - Require user input to match exact phrase: `授权提交 Step N 状态推进`
   - Execute selective staging rules:
     ```bash
     git add -- docs/LESSON_04_IMPLEMENTATION_PLAN.md
     git diff --cached --name-only
     git diff --cached
     git commit -m "docs(state): advance lesson 04 plan to step N+1" # (or "docs(state): complete lesson 04 implementation plan" if final step)
     ```
   - **Staging Assertion**: Commit B MUST ONLY stage `docs/LESSON_04_IMPLEMENTATION_PLAN.md`.

## Page Technical State Debugger Requirement (页面技术状态调试器)

- **Step 1 UI Requirement**: The initial component skeleton MUST introduce a reactive `prototypeState` technical state debug pill labeled `Prototype Debug` (`showPrototypeDebug = import.meta.env.DEV`):
  ```typescript
  const showPrototypeDebug = import.meta.env.DEV
  const prototypeState = ref<'loading' | 'empty' | 'error' | 'success'>('success')
  ```
- **Disentanglement Rule**:
  - **Page Technical States (页面技术状态)**: Loading, Empty, Error, Success (Data fetching & UI presentation states).
  - **Business Process States (业务流程状态)**: 待处理, 处理中, 已阻塞, 已完成 (Domain lifecycle states).
- **Subsequent Steps**: Preserve and maintain the `prototypeState` technical debug toggle.

## Prototype Slicing Strategies (by Prototype Type)

- **A. 监控与决策型**: Slice 1 = 指标卡骨架屏与 4 技术状态调试器切片
- **B. 任务与流程型**: Slice 1 = 看板骨架屏、4 技术状态与 4 业务流程状态标签切片
- **C. 操作工具型**: Slice 1 = 表单骨架与 Idle / Validating / Result / Error 工具状态调试切片
