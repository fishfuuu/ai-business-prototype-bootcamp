# Protocol P05 — Course Roadmap and Authority Conformance

## Control header

| Field | Value |
|---|---|
| Protocol ID | P05 |
| Exact path | `docs/changes/course-curriculum-revision-2026-08/verification/phase1-roadmap-conformance-test.md` |
| Change ID | `course-curriculum-revision-2026-08` |
| Project ID | `ailearning` |
| Risk | L2 |
| Change base commit | `25c6f3d9214e29378f4945f51a977dc06603c8e4` |
| Lifecycle at run | `DESIGN_FROZEN` (per-change delivery-state.json authoritative) |
| Requirement IDs | D01, D02, D05, D06, D07, D08, D09, D10, D11, D12, D13, D14, D15, D16, D17, D18, D19, D20, F01, F03, F04, F06, F07, F08, F09, F10 |
| Rubric source | `docs/changes/course-curriculum-revision-2026-08/acceptance-rubric.md` §7 P05 (LOCKED) |
| Run status | EXECUTED — pre-implementation characterization |
| Run event ID | `019feea7-d40f-73e2-9d0b-b3d9b1bbefd6` (execution thread; real, not fabricated) |
| Run timestamp | 2026-08-11T15:31:32+08:00 |

## 1. Fixture / input

- Current dirty roadmap candidate `docs/COURSE_ROADMAP.md` as an explicitly unapproved input (working blob `b42b49cc3b9eb02fb848951e180d29b6587c3bdf`, numstat 67/53).
- Repository path/command inventory (`package.json` scripts, `scripts/` listing, root file presence).
- Root `CLAUDE.md` and `.claude` shim inventory.
- Seven-object candidate list and D01–D20/F01–F10 conformance checklist from the LOCKED acceptance rubric.

## 2. Pre-implementation action / check

Check that the course-level baseline contains each decision/finding without claiming lesson enactment; check old defaults/nonexistent capabilities/production claims, Mock/no-key/external-call boundary, six-mode positioning, three-chain and control-layer distinctions, visible-result rule, and dirty-candidate preservation. Every structural assertion must point to the contract it protects and have a negative candidate case.

## 3. Expected pre-implementation result

Characterization must record the dirty candidate as `PRESERVE_UNREVIEWED_DRAFT`; `RED_EXPECTED` only for a real conformance violation in a changed baseline, never because the candidate is dirty by itself.

## 4. Actual run result — characterization baseline with real violations

### 4.1 Dirty-candidate disposition (characterization baseline — preserved)

`docs/COURSE_ROADMAP.md` remains an uncommitted candidate: working blob `b42b49cc3b9eb02fb848951e180d29b6587c3bdf`, HEAD blob `180f574f3db2385a9aa023dc879f1fd2bf1c67b5`, numstat 67 additions / 53 deletions. It was not accepted, rejected, edited, staged, or committed in this run. Disposition: `PRESERVE_UNREVIEWED_DRAFT`. This is a characterization baseline, not a RED.

### 4.2 Authority claim conflict (RED_EXPECTED)

`docs/COURSE_ROADMAP.md` line 8 (header) claims "唯一权威执行版（Authoritative Execution Plan）". This conflicts with the locked disposition: the candidate is an unapproved DRAFT and cannot claim to be the unique authoritative execution version (D20/F05). The future roadmap revision must remove or reclassify this claim.

### 4.3 Nonexistent capability claims (RED_EXPECTED)

- Line 31: `npm run verify` — nonexistent npm script (package.json has only `dev`, `build`, `typecheck`, `preview`); violates D19/F04.
- Line 89: `verify-student-project.ps1` — nonexistent in mother repository; violates D19/F04.
- Line 181: `verify-student-project.ps1` output `[PASS]` — same violation.
- Lines 92, 141, 232, 234: `AGENTS.md` — no such file in repository root; violates D19/F04.

### 4.4 Direct-production / one-click claims (RED_EXPECTED)

- Line 23: "让 IT 部门直接落地的《IT 原型交接包》" — direct-launch implication conflicts with D17/F01 (the same line does state "明确声明非生产就绪系统", but "直接落地" must be removed per F01).
- Line 253: "可让 IT 部门直接落地的《IT 原型交接包》" — same F01 violation.
- Line 143: "可点真 AI 演示原型" — production-ready implication for L10 output; conflicts with D17 non-production framing.
- Lines 138, 180, 256: "一键" one-click claims (一键恢复流程, 一键 Discard 还原, 一键生成标准归档 ZIP 包) — F05 requires bounded stop/range confirmation/teacher-assistant recovery until independently tested automation exists.

### 4.5 Correctly marked future assets (characterization baseline — present)

- Line 140: "自动化浏览器验证脚本为待实现教学资产，当前不作为课堂通过条件" — correctly marks the browser verification script as future; consistent with D19.
- Line 225: same correct marking for L7.

These are characterization baselines: the candidate already distinguishes future assets from implemented capabilities in these two places. The future roadmap revision must keep this distinction everywhere.

### 4.6 Mock / no-key / external-call boundary (characterization baseline — present)

- Line 56: "普通学员默认使用 Mock 数据；教师在受控环境下演示真实模型/API调用。学员无需配置 API Key 或 MCP。" — consistent with D11/F07.
- Line 57: four-party Mock responsibility (主管/课程团队/Agent/教师助教) — consistent with D11.
- Line 190: 假数据脱敏规约 with "公开 / 内部 / 严禁发送 AI" labels — consistent with D12/F03.

These are characterization baselines. The future roadmap revision must preserve and strengthen them; no secret or real data was introduced in this run.

### 4.7 Cohort, schedule, timing, precheck, absence (characterization baseline — present)

- Line 70: 10–15 人班型, 1 教师 + 1 助教 — D05.
- Line 71: 5 周、每周 2 节、间隔 2–3 天 — D06.
- Line 72: 90 分钟硬上限 — D06.
- Line 73: 90 分钟时间预算 (10+15+18+10+25+10+2 = 90) — D06/F10; the arithmetic sums to 90, but the candidate presents it as a fixed budget; the locked design requires adjustable blocks with total ≤ 90 and real trial calibration. Recorded as partial baseline: arithmetic is correct, adjustability is missing.
- Line 74: 30–45 分钟 L1 前预检; 超过 3 分钟助教接管 — D07.
- Line 75: 10–15 分钟微任务; 每周第二节课后一个 30–45 分钟完整成果 — D08.
- Line 76: 缺课补课包 20–30 分钟后方可恢复个人主线 — D09.
- Line 77: 每课最多 2–3 个必须掌握概念; 其余分为需要识别与工程背景 — D04.

These are characterization baselines. The future roadmap revision must keep them and add the three-way separation of visible in-class result / micro-task / weekly result per lesson (F06; the candidate has a 可见成果 column at line 132 and the micro/weekly rules at line 75, but the per-lesson three-way separation is not explicit).

### 4.8 Four-step concept formula (partial baseline — missing practical-action tie)

- Line 38: four-step formula with 3–5 minute bound and 2–3 must-master concepts — D03 partial.
- Lines 38–41: steps are 工程定义 / 底层机制 / 业务比喻与反例 / IT 交接价值. The locked design (D03/F02) requires the first-use explanation to be tied to the just-completed practical action. The candidate does not explicitly map each concept card to the just-completed practical step. Recorded as partial baseline: formula present, practical-action reference missing (F02 gap for the future roadmap revision).

### 4.9 Dual Commit and CEO decision trees (characterization baseline — present)

- Line 41: Git 双 Commit 比喻 with explicit note "Git 本身不理解业务审批，也不自动形成授权控制" — consistent with D18.
- Line 22: CEO 3 大决策树 "本课程主管处置框架，非代码运行时硬控制，亦非行业通用标准拓扑" — consistent with D18/F08.

These are characterization baselines. The future roadmap revision must keep these boundaries.

### 4.10 Six collaboration modes (RED_EXPECTED — missing)

The candidate contains no explicit six-collaboration-mode inventory with three deep/three recognition labels (D13/F09). The locked design requires the six modes as a supervisor decision framework. Absence is a real baseline gap for the future roadmap revision.

### 4.11 MCP minimum model and three chains (RED_EXPECTED — missing/partial)

- The candidate mentions MCP at lines 38, 56, 135, 142, 244, 247 but does not teach the host/client/server/tool minimum model (D14).
- The candidate does not state "MCP 不是产品业务 API" (D14).
- The candidate does not separate development toolchain / business API / model API chains (D16).
- Line 247 "配置 API MCP 插座" implies configuration activity without clarifying the teacher-preconfigured single browser entry (F07 partial).

These are real baseline gaps for the future roadmap revision.

### 4.12 L8 isolated review (partial baseline)

- Lines 92–93, 121–122, 141, 231–234 describe independent context-isolated review sessions — directionally consistent with D15.
- The explicit fallback "branded tool unavailable → isolated new session, never skip review" is missing. Recorded as partial baseline.

### 4.13 V2/V3 history protection (RED_EXPECTED — not expressed)

The candidate does not express the V2/V3 history protection rule (D20: no deletion, no merge, no batch sync; teacher plan → approval → GUIDE → derived assets one-way order). Absence is a real baseline gap for the future roadmap revision.

### 4.14 Root CLAUDE / shim inventory (RED_EXPECTED — old defaults present)

Root `CLAUDE.md`:

- Line 12: "5 个演示暂停点与 22 节治理标准" — old fixed defaults conflicting with the locked design (D06/F10).
- Line 49: "物理代码拒止" with `HOOK_REFUSE_BANK_TRANSFER` / `HOOK_REFUSE_CONTRACT_SIGN` / `HOOK_REFUSE_DATA_EXPORT` — text rules presented as physical runtime refusal without executable evidence (F08).
- Line 50: "确定性算术物理函数锁" with `HOOK_LOCK_DETERMINISTIC_CALC` — same F08 issue.
- Line 53: `verify-project.ps1` mandatory check — script governance is a future change; cannot be a classroom pass condition (F04).
- Line 54: "npm run typecheck 和 npm run build 100% 通过" — 100% wording is an old default; not a locked requirement.

`.claude/skills/teacher-plan-architect/SKILL.md` is currently an identical copy of `.agents/skills/teacher-plan-architect/SKILL.md` (blob `e4009075...`), not a minimal compatibility shim (P02/P04/M06). The future implementation must convert it to a fail-closed shim.

## 5. Intended failure reason / protected invariant

Prevents treating a prose heading or dirty candidate as approved authority and prevents future roadmap text from inventing commands, production readiness, runtime hooks, or classroom evidence. A "file exists" result alone is never sufficient; each assertion above points to the contract it protects and has a negative candidate case.

## 6. Production-zero-diff proof

Pre-run manifest (captured 2026-08-11T15:31:32+08:00), manifest hash `60cda3bb2c8491e944cea105d5177820f760b1db1453e1b3ce7b1821d33303f9`:

| Path | Git blob | SHA-256 | Status |
|---|---|---|---|
| docs/COURSE_ROADMAP.md | b42b49cc3b9eb02fb848951e180d29b6587c3bdf | 7f82c32359f86d524a4edb42539d24ba8267672f2cb1ed5ea7a764b845882040 | present |
| docs/LESSON_TEMPLATE.md | 90ce7aa99523f584e06ac2934e5fc69ce4f4649b | e13deebb144cb3731798f68a0a9678bd5c4c0d70008ac0796c5182f3ab088b75 | present |
| CLAUDE.md | ddbcce99b86a2bef5caccab44d4100f4450366f9 | b27d462f4b73ef5e66acde86702fd28662b5f439d6f8930d08077fe9b8292925 | present |
| .agents/skills/teaching-lesson-plan/SKILL.md | 107e887941b2f04ece7121c1a52c5155c5c3aee9 | 30ac13dc3a5410d972c4d7659045ee8b29708f925af7e65baae02660e5c8c5b3 | present |
| .agents/skills/teaching-lesson-plan/references/lesson-design-brief-template.md | MISSING | MISSING | missing |
| .agents/skills/teacher-plan-architect/SKILL.md | e4009075209e4c1e2fb23f96805b19447d0375ab | 6febb3107d79ab772007712e5a054773fcebb8c2bd8a4a354a7ed7a1446b6176 | present |
| .claude/skills/teacher-plan-architect/SKILL.md | e4009075209e4c1e2fb23f96805b19447d0375ab | 6febb3107d79ab772007712e5a054773fcebb8c2bd8a4a354a7ed7a1446b6176 | present |

Post-run manifest must be identical. The roadmap working blob must remain `b42b49cc3b9eb02fb848951e180d29b6587c3bdf` with 67/53 diff.

## 7. External run / evidence record

- Run event ID: `019feea7-d40f-73e2-9d0b-b3d9b1bbefd6` (execution thread; real).
- Checklist version: acceptance-rubric.md §7 P05 (LOCKED).
- Input blob/hash: roadmap working blob `b42b49cc3b9eb02fb848951e180d29b6587c3bdf`; manifest hash `60cda3bb2c8491e944cea105d5177820f760b1db1453e1b3ce7b1821d33303f9`.
- Inventory output: package.json scripts, scripts/ listing, root file presence, CLAUDE.md/shim line inventory recorded in §4.
- Reviewer conformance decision: pending Independent Acceptance Review in thread `019feb03-f4ec-7681-bb42-e64bf977c710`.
- No acceptance report path is created.

## 8. Post-implementation GREEN / manual condition

Approved roadmap and root-policy/shim/template boundaries are structurally faithful, dirty candidate remains preserved until its own Slice, and course owner manually accepts wording/authority. Current status: `RED_EXPECTED` for authority claim, nonexistent capabilities, direct-production/one-click claims, missing six modes, missing MCP minimum model/three chains, missing V2/V3 protection, and old root-CLAUDE/shim defaults; characterization baselines recorded for preserved candidate, Mock/no-key boundary, cohort/schedule/timing, four-step formula (partial), dual-commit/CEO-tree boundaries, and correctly marked future assets.
