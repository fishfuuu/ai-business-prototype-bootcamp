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

1. **Strict Non-Destructive Execution**: Do NOT modify `src/` code during the interview process.
2. **One Question at a Time**: Ask exactly 1 question per turn with your recommended option.
3. **Four Core Elements & Data Contract**:
   - Resolve **Goal** (business pain point and target user).
   - Resolve **Boundaries & Out of Scope** (what to build vs. what NOT to build).
   - Resolve **Risks & Data Contract** (fields, types, sensitivity levels, business rules).
   - Resolve **Stop Conditions** (expected business inputs/outputs).
4. **Deliverables Output**:
   - Save the finalized feature card to `docs/BUSINESS_FEATURE_CARD.md`.
   - Output the corresponding TypeScript contract draft to `src/types/prototype-contract.d.ts`.
