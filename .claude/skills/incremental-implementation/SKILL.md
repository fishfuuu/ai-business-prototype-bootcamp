---
name: incremental-implementation
description: Delivers multi-file changes incrementally using contract-first thin slices, persistent implementation plans with state machines, two-commit state transition protocols, technical state debug toggles, and human-observed acceptance.
---

# Incremental Implementation (增量实施范式)

> **来源致谢 / Source**: 本 Skill 改编自 [mattpocock/skills](https://github.com/mattpocock/skills)（MIT License，© Matt Pocock），并按本课程“业务主管制作原型”场景做教学化改造。

## 概述

采用薄切片（Thin Slices）方式受控构建——先形成计划，每次只授权完成一个可验证的小切片。避免一次性修改全套逻辑。每个切片必须使系统处于可运行、可测试的稳定状态。

## 工作流与授权门禁 (Step级 Workflow 授权门禁)

### 阶段 1：只读计划预览与契约交接门禁

- **需求权威来源**：`docs/BUSINESS_FEATURE_CARD.md` 是第四课唯一的需求权威来源。`src/types/prototype-contract.d.ts`（数据字典表）与 `src/mocks/prototype-data.ts`（模拟种子数据）为派生契约资产。
- **契约一致性交接门禁 (Pre-Plan Gate)**：
  1. 三份前置文件必须全部存在。
  2. 派生的数据字典表与模拟数据必须与《业务功能卡》中的数据契约表严格一致。
  3. 若字段名、数据类型、必填性、枚举或业务含义冲突：
     - 输出通俗警示：`[契约冲突拦截] 需求卡与数据定义不一致，请先退回第三课核对` (CONTRACT_ASSET_MISMATCH)。
     - 列出具体冲突字段。
     - **严禁生成或保存实施计划**。
- 若 3 份文件校验一致，在聊天窗口中输出拟定的 3–5 步增量实施计划预览。
- **只读约束**：阶段 1 严禁写入、修改或删除任何文件。
- 结尾输出提示：`计划预览生成完毕。请输入 "同意保存实施计划" (或 "授权保存 Lesson 04 实施计划") 以写入工程。`

### 阶段 2：计划落盘与状态机规则

- 接收学员授权口令：`同意保存实施计划` (或 `授权保存 Lesson 04 实施计划`)
- **步骤状态枚举**：`PENDING` (后续未开始步骤) | `READY` (等待授权执行) | `IN_PROGRESS` (正在编码) | `COMPLETED` (两层验收通过并归档) | `BLOCKED` (页面异常或主管拒绝)。
- 将实施计划写入 `docs/LESSON_04_IMPLEMENTATION_PLAN.md`（`allowed_files` 必须为具体文件路径，禁止写文件夹）：
  ```markdown
  # Lesson 04 实施计划 (Implementation Plan)

  ```yaml
  plan_status: APPROVED
  current_waiting_step: 1

  steps:
    - id: 1
      name: "组件骨架与页面技术状态调试切片"
      status: READY
      allowed_files:
        - "src/pages/HomePage.vue"
        - "src/components/WorkOrderBoard.vue"
      acceptance: "支持页面技术状态调试器切换 (Loading / Empty / Error / Success)"
      failure_summary: ""
      verification_log: ""
      commit_sha: ""
    - id: 2
      name: "绑定 Mock 数据与渲染业务列表"
      status: PENDING
      allowed_files:
        - "src/components/WorkOrderBoard.vue"
      acceptance: "成功渲染业务列表与交互"
      failure_summary: ""
      verification_log: ""
      commit_sha: ""
  ```
  ```
- 结尾输出提示：`实施计划已保存。请输入 "授权执行 Step 1" (或 "授权开始 Step 1") 以开始首个切片编码。`

### 阶段 3：切片编码执行

- **授权解锁**：仅当学员消息匹配 `授权执行 Step N` (或 `授权开始 Step N`) 时解锁编码，其中 `N` 匹配 `current_waiting_step`。
- 收到授权后，将 Step N 状态改为 `IN_PROGRESS`。
- **执行约束**：
  - 一次授权仅允许执行一个步骤。
  - 严禁自动连续执行后续步骤。
  - 严禁修改 `allowed_files` 清单之外的文件。
  - 未经主管授权，严禁擅自修改 `allowed_files` 清单或 `acceptance` 验收标准。

### 阶段 4：两层递进验收与版本归档

1. **两层验收顺序**：
   - **第一层：人工页面观察 PASS**（物理刷新试衣镜，确认 Step 的可见变化、至少两种技术状态切换与业务状态标签）。
   - **第二层：主管业务验收 PASS**（主管下发 `主管验收 Step N 通过`，按第三课验收场景逐项核对）。

2. **结果 A：两层验收全 PASS (成功归档流程)**
   - 当两层全部 PASS 后，提示学员下发自然归档口令：
     - 学员输入：**`确认完成 Step N`** (或 `同意保存 Step N 成果` / `授权提交 Step N 源码`)
     - 底层自动执行 Commit A：暂存并提交源码 (`git add -- <allowed_files>`, 提交消息 `feat(code): implement thin slice step N`)。
     - 自动获取 Commit A SHA (`git rev-parse HEAD`)。
     - 自动更新实施计划 `docs/LESSON_04_IMPLEMENTATION_PLAN.md`：
       - `verification_log` -> `local-backups/lesson-04-evidence/step-N-verification.log`（人工页面观察记录，可选）
       - `commit_sha` -> `<Commit A SHA>`
       - Step N `status` -> `COMPLETED`
       - Step N+1 `status` -> `READY` (若为终态 Step: `plan_status: COMPLETED`, `current_waiting_step: null`)
       - `current_waiting_step` -> `N+1` (若为终态 Step: `null`)
      - 底层自动执行 Commit B：暂存并提交实施计划 (`git add -- docs/LESSON_04_IMPLEMENTATION_PLAN.md`, 提交消息 `docs(plan): mark step N completed`)。
     - 报告学员：`Step N 成果已成功保存并归档！`

3. **结果 B：页面异常 / 主管拒绝 (失败快照与自动还原流程)**
   - 当页面异常或主管下发 `主管拒绝 Step N 切片` 时：
     - **严禁提交源码 (不跑 Commit A)**。
     - 自动将未跟踪新文件纳入快照清单：`git add -N -- <allowed_files>`。
     - 自动导出完整快照补丁：`git diff -- <allowed_files> > local-backups/lesson-04-evidence/step-N-blocked.patch`。
     - 自动保存验证日志并回填 `failure_summary`。
     - **自动清扫 Working Tree 还原干净工程**：自动撤销修改并清除未跟踪文件，使 Working Tree (工作区) 恢复 100% Clean 干净。
     - 提示学员下发自然口令：**`同意记录 Step N 问题`** (或 `暂停 Step N 并记录问题` / `授权提交 Step N 阻断状态`)。
     - 底层仅执行 Commit B 提交状态记录：`git add -- docs/LESSON_04_IMPLEMENTATION_PLAN.md` (提交消息 `docs(state): record step N blocked status`)。
      - 同步更新 `docs/PROJECT_STATE.md`，记录阻断问题摘要（与学员指南 Task 5 一致）。
     - 终止后续 Step 执行，保留补丁与日志留给第六课排错。

## 页面技术状态调试器规范

- 三类原型必须统一保留 `prototypeState` 可视化调试按钮 (`showPrototypeDebug = import.meta.env.DEV`):
  ```typescript
  const showPrototypeDebug = import.meta.env.DEV
  const prototypeState = ref<'loading' | 'empty' | 'error' | 'success'>('success')
  ```
- **概念解耦**：
  - **界面技术状态**：Loading (加载中), Empty (空数据), Error (网络报错), Success (正常渲染)。
  - **业务处理流程**：待处理, 处理中, 已阻塞, 已完成 (业务对象生命周期)。
