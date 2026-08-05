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
- Target 3–5 main decision branches across 5–7 interview rounds. If max rounds are reached without convergence, record unresolved items in Open Decisions.

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

#### Fail-Closed Blocking Gate Rules (强校验阻断门禁)
The 6 core items MUST be evaluated for **existence, non-emptiness, explicit confirmed conclusions, absence of vague/conflicting claims, and absence of `[待确认]` tags**:
1. `user_and_owner`: 核心使用者或责任角色
2. `core_field_source`: 核心字段来源
3. `business_rules`: 关键业务规则
4. `sensitive_data_policy`: 敏感数据处理方式
5. `in_scope`: In Scope 边界线
6. `acceptance_scenario`: 至少 1 个核心 Given-When-Then 验收场景

If ANY item is missing, empty, vague, conflicting, or tagged `[待确认]`, the proposal MUST NOT be approved as a final contract or written to disk.

Non-blocking open questions stay in Section 9 `Open Decisions` with schema: `[事项 | 负责人 | 截止日期 | 是否阻断: 否 | 影响范围]`.

#### Prototype Type Specialization (Business Contract Differences):
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

### Phase 3: HITL Authorization & Fail-Closed Gate Evaluation (Task 3B 写入门禁)
Before accepting the HITL write stamp (`同意方案，请开始落盘功能卡与契约资产`):
1. **Re-evaluate all 6 Blocking Gate items** for existence, non-emptiness, and confirmed status.
2. **Output structured evaluation status**:
   ```yaml
   blocking_gate:
     user_and_owner: PASS # (or FAIL)
     core_field_source: PASS # (or FAIL)
     business_rules: PASS # (or FAIL)
     sensitive_data_policy: PASS # (or FAIL)
     in_scope: PASS # (or FAIL)
     acceptance_scenario: PASS # (or FAIL)
     result: PASS # (or BLOCKING_GATE_FAILED)
   ```
3. **If `result` is `BLOCKING_GATE_FAILED`**:
   - **Do NOT write any files**.
   - Output `BLOCKING_GATE_FAILED`.
   - List unresolved or missing items.
   - Instruct user to resolve them or request escalation.
4. **ONLY when `result` is `PASS`**:
   - Write `docs/BUSINESS_FEATURE_CARD.md`
   - Write `src/types/prototype-contract.d.ts`
   - Write `src/mocks/prototype-data.ts`
   - Strictly prohibit modifying any other files.

### Contract Freeze Rule (契约冻结规则)
Once approved by human manager, `docs/BUSINESS_FEATURE_CARD.md` becomes the authoritative baseline for Lesson 04 implementation. Any subsequent requirement changes MUST update the card and receive re-authorization first.
