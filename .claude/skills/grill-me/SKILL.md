---
name: grill-me
description: Interview the user relentlessly about a plan or design until reaching shared understanding, resolving each branch of the decision tree. Use when user wants to stress-test a plan, get grilled on their design, or mentions "grill me".
---

Interview me relentlessly about every aspect of this plan or business requirement until we reach a shared understanding. Walk down each branch of the design tree, resolving dependencies between decisions one-by-one.

For each question, provide your recommended answer.
Ask the questions one at a time.
If a question can be answered by exploring the codebase or existing docs (like `PROJECT_STATE.md` or `DESIGN.md`), explore them first instead of asking redundant questions.

---

## Course Protocol Extensions for Business Prototypes (Lesson 03)

When executing `grill-me` for business prototype requirements:

1. **Phase 1: Questioning (Strict Read-Only)**:
   - Do NOT modify any files under `src/` or `docs/` during the interview.
   - Read existing codebase/docs first to avoid redundant questions.
   - Ask exactly 1 question per turn with your recommended option.
   - Resolve **Goal**, **Boundaries & Out of Scope**, **Risks & Data Contract** (fields, types, sensitivity), and **Stop Conditions** (Given-When-Then format).

2. **Phase 2: Read-Only Preview (Task 3A)**:
   - Output text previews of `BUSINESS_FEATURE_CARD.md`, `src/types/prototype-contract.d.ts`, and `src/mocks/prototype-data.ts` in chat ONLY.
   - Do NOT write to disk during preview.
   - Stop and explicitly instruct the user to provide the HITL confirmation stamp code if they approve the proposal.

3. **Phase 3: HITL Authorization Gate & File Assets Writing (Task 3B)**:
   - ONLY write files after receiving the EXACT HITL confirmation stamp prompt:
     `同意方案，请开始落盘功能卡与契约资产`
   - Upon receiving the exact prompt, write:
     - `docs/BUSINESS_FEATURE_CARD.md`
     - `src/types/prototype-contract.d.ts`
     - `src/mocks/prototype-data.ts`
   - Strictly prohibit modifying any other files outside these 3 specified paths.
