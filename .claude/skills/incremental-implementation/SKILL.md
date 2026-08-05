---
name: incremental-implementation
description: Delivers multi-file changes incrementally using contract-first slices, HITL authorization checkpoints, 4-state visual toggles, and silent Verifier Subagent self-tests.
---

# Incremental Implementation (V2 严密版)

## Overview

Build in thin vertical slices — implement one piece, test it, verify it, then expand. Avoid implementing an entire feature in one pass. Each increment MUST leave the system in a working, testable state without polluting the main context window.

## HITL Protocol & Authorization Gate (物理门禁契约)

To prevent accidental code generation during the planning phase:

1. **PHASE 1: Plan & Propose (只读分析)**
   - Output 3–5 step Contract-First execution plan.
   - List expected files, 4-state handlers, and verification assertions for each step.
   - **CRITICAL**: Absolutely DO NOT write, modify, or delete any source code files during Phase 1.
   - End response with: `Plan 制定完毕。请输入 "授权执行 Step 1" 以开始编码。`

2. **PHASE 2: Execute Step X (授权执行)**
   - ONLY execute when user input explicitly contains `授权执行 Step X` or `同意方案，执行 Step X`.
   - Build ONLY the target step's scope.
   - MUST include visual `prototypeState` debug toggle pill (`loading` | `empty` | `error` | `success`) so all 4 states can be visually verified.

3. **PHASE 3: Silent Verification & Atomic Commit (静默断言)**
   - Trigger a silent child `Verifier Subagent` (or background verification process) to run `npm run build` / `verify-student-project.ps1`.
   - Filter long terminal output logs to protect main context window. Return ONLY 1-line status summary.
   - Prompt user for Atomic Git Commit after verification passes.

## Slicing Strategy (Contract-First)

```
Slice 0: Validate Baseline SHA & Contracts (BUSINESS_FEATURE_CARD.md + prototype-contract.d.ts)
Slice 1: Component Skeleton + Visual prototypeState Toggle (Loading / Empty / Error / Success UI)
Slice 2: Mock Data Binding & Success List View
Slice 3: Error Recovery Action (Retry Button -> Loading -> Restore) & Search Filter
Slice 4: Final Verification & Clean Commit
```

## The Increment Cycle

```
┌──────────────────────────────────────────────────────────┐
│                                                          │
│  Plan (Only) ──→ HITL Gate ──→ Slice Implementation    │
│                     │                       │            │
│                     ▼                       ▼            │
│            [授权执行 Step X]        4-State Toggle      │
│                                             │            │
│                                             ▼            │
│      Next Slice ◄── Atomic Commit ◄── Verifier Subagent │
│                                                          │
└──────────────────────────────────────────────────────────┘
```

## Implementation Rules

### Rule 0: Simplicity First & No Context Pollution
- Never generate monolithic >100 line code dumps without an explicit step boundary.
- Always implement the `prototypeState` reactive switcher so human reviewers can physically click and toggle all 4 data states in the browser.
- Run builds in silent sub-shells or Verifier Subagents to keep main context clean.
