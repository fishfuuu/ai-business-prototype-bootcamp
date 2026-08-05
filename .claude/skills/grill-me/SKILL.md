---
name: grill-me
description: Interview the user relentlessly about a plan or business requirement until reaching shared understanding, clarifying problem definitions, acceptance criteria, stop conditions, and data contracts.
---

# Grill-Me Skill

Interview the user relentlessly about every aspect of this business requirement until reaching a shared understanding. Walk down each branch of the decision tree, resolving dependencies between decisions one-by-one.

For each question:
- Provide your recommended answer (prefixed with `(Recommended)`).
- Ask questions ONE AT A TIME.
- If a question can be answered by exploring the codebase or existing docs (`PROJECT_STATE.md` or `DESIGN.md`), explore them first instead of asking redundant questions.

---

## Course Protocol Extensions for Business Prototypes (Lesson 03)

### Phase 1: Interactive Interview (Strict Read-Only)
- Do NOT write or modify any files during the interview.
- Ask 1 question per turn to clarify 6 core elements across the 3 prototype types:
  1. **User & Problem**: Target role, current manual workflow, pain points, fact evidence (`[事实]`), decisions (`[决定]`), hypotheses (`[假设]`), and open questions (`[待确认]`).
  2. **Goal**: Business objective, expected actions, and success metrics.
  3. **Boundary**: In Scope vs. Out of Scope.
  4. **Risk & Data Sensitivity**: Data policy (Public / Internal / Secret) and privacy boundaries.
  5. **Acceptance Criteria (验收条件)**: Functional correctness criteria formatted as `Given [Context] / When [Action] / Then [Expected Result]`.
  6. **Stop / Escalation Conditions (停止与上提条件)**: Operational limits that force the Agent to pause and request human intervention (e.g. unconfirmed critical field sources, conflicting business rules, requirement scope expansion, max interview rounds exceeded).

#### Prototype Type Specialization:
- **A. 监控与决策型**: Clarify metric definitions, time range, benchmark, threshold, anomaly level, drill-down dimensions, and trigger actions.
- **B. 任务与流程型**: Clarify roles, business states, state transitions, allowed actions, reject/revoke rules, and permission boundaries.
- **C. 操作工具型**: Clarify inputs, validation rules, processing logic, outputs, error handling, and HITL confirmation checkpoints.

### Phase 2: Read-Only Preview (Task 3A)
- Output text previews in chat ONLY for:
  - `docs/BUSINESS_FEATURE_CARD.md` (containing 9 complete sections: 1. User & Problem, 2. Goal, 3. In Scope / Out of Scope, 4. Business Rules, 5. Risks and Data Policy, 6. Acceptance Scenarios, 7. Stop / Escalation Conditions, 8. Data Contract, 9. Open Decisions)
  - `src/types/prototype-contract.d.ts` (TypeScript type draft)
  - `src/mocks/prototype-data.ts` (Mock data)
- Do NOT write to disk during preview.
- Instruct user to respond with exact HITL stamp prompt if approved.

### Phase 3: HITL Authorization & File Assets Writing (Task 3B)
- Write files ONLY after receiving the EXACT prompt:
  ```text
  同意方案，请开始落盘功能卡与契约资产
  ```
- Upon receiving exact prompt, write ONLY:
  - `docs/BUSINESS_FEATURE_CARD.md`
  - `src/types/prototype-contract.d.ts`
  - `src/mocks/prototype-data.ts`
- Strictly prohibit modifying any other files.
