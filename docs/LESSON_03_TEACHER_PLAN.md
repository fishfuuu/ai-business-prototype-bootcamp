# 第三课教案 (V2 闭环版)：把模糊想法变成可执行的业务契约

## 1. 课程元数据

| 项 | 内容 |
| --- | --- |
| 课次 | 第 3 课 |
| 课程名称 | 把模糊想法变成可执行的业务契约 |
| 面向角色 | 运营主管 / 业务部门一级主管 |
| 建议时长 | 90 分钟 |
| 前置课程 | 第 2 课：用参考图与设计规则做出像样的页面 |
| 对应路线图 | `docs/COURSE_ROADMAP.md` 第 3 课 |
| 仓库内容状态 (Repository Status) | CANDIDATE (既有基线存在，本轮 V2.1 修订为候选状态) |
| 教学验证状态 (Teaching Status) | PILOT_PENDING (草稿 V2 / 待试讲) |
| 课程负责人 | 待指定 |
| 最后复核日期 | 2026-08-05 |
| 学员包版本 | 待生成 |
| 来源 commit 或 tag | 待候选版本冻结后填写 |

## 2. 本课定位

说明：
- **解决问题**：解决业务主管在提出需求时口头描述模糊、将解决方案误认为问题本质、缺乏字段与规则收扣导致 AI 凭空脑补与代码漂移的典型卡点。
- **阶段安排**：处于“需求与结构”阶段开篇课。承接前两课外观搭建，为第 4 课 Plan & Execute 增量开发提供固定的契约依据。
- **上下游关系**：输出 `docs/BUSINESS_FEATURE_CARD.md` (含 9 大完整章节及嵌入的数据契约表)、TypeScript 类型草稿 `src/types/prototype-contract.d.ts` 与 `src/mocks/prototype-data.ts`。

## 3. 核心目标

1. 掌握 **`grill-me` 追问技能护栏**，完成 3–5 分支、5–7 轮结构化对话澄清。
2. 掌握 **Given-When-Then 验收条件** 与 **Stop / Escalation 停止上提熔断条件** 的本质区别。
3. 锁定 **6 大业务要素**（Goal 业务目标、User & Problem 问题定义、Boundary 边界、Risk 风险隐私、Acceptance Criteria 验收场景、Stop Conditions 停止条件）。
4. 掌握 **阻断性待确认事项强校验门禁 (Fail-Closed Blocking Gate)**，未通过时输出 `BLOCKING_GATE_FAILED` 拒绝落盘。
5. 掌握 **三层验收机制（工程验证、契约验证、主管验收）**、`PROJECT_STATE.md` 更新与选择性暂存 (`git add --`) 存档。

## 4. 可见成果

- `docs/BUSINESS_FEATURE_CARD.md`（包含 9 大完整章节）。
- `src/types/prototype-contract.d.ts`（TypeScript 类型草稿）。
- `src/mocks/prototype-data.ts`（符合强类型结构的 Mock 数据）。
- 更新后的 `docs/PROJECT_STATE.md`。

## 5. 本课明确不做

- 不在第 3 课直接修改 `src/components/` 业务代码（本课专注需求澄清与契约落盘）。
- 不把 TypeScript 类型草稿过度承诺为生产 API 最终合同。
- 不把 Bounded Agent Loop 自动纠偏在本课展开（此为第 4 课内容）。

## 6. 教师准备

| 项 | 状态 | 说明 |
| --- | --- | --- |
| 教师演示环境 | 待完成 | Node.js, Claude Code CLI |
| 所需 Skill | 已就绪 | `.claude/skills/grill-me/SKILL.md` |
| 教师标准答案 | 待完成 / 待试讲验证 | 包含 9 大章节的 `BUSINESS_FEATURE_CARD.md` 样例 |

## 7. 学员准备

- 完成前两课，项目起手可运行 `npm run dev`。
- 确认处于干净基线提交。

## 8. 课堂时间安排与关键暂停点 (Pause Points)

| 时段 | 时长 | 内容 | 关键暂停点 (Pause Point) |
| --- | --- | --- | --- |
| 成果展示与复盘 | 10 分钟 | 展示模糊需求导致代码崩溃对比，解析 6 大业务要素 | **[ Pause Point 1 ]**：提问学员“口头指令与业务契约的区别是什么？” |
| 教师演示 | 15 分钟 | 演示唤醒 `grill-me`，下发 Task 3A 预览与 Task 3B HITL 授权口令 | **[ Pause Point 2 ]**：检查学员是否理解为什么 Task 3A 只输出文字预览不改磁盘文件 |
| 学员实操 Task 1 & 2 | 45 分钟 | 唤醒 `grill-me` 澄清 6 要素，校验阻断门禁，落盘 9 章节契约卡 | **[ Pause Point 3 ]**：巡视检查学员是否清空了 6 项阻断性待确认事项，触发强校验门禁 |
| 三层验收与 Git 存档 | 10 分钟 | 执行工程验证、契约验证与主管验收，更新 PROJECT_STATE.md | **[ Pause Point 4 ]**：确认学员执行了选择性暂存 (`git add --`) |
| 总结与 Exit Ticket | 10 分钟 | 区分 Given-When-Then 与 Stop Conditions，完成退场测试 | **[ Pause Point 5 ]**：退出门禁答题与下节课契约冻结规则宣告 |

## 9. 业务场景

- **使用者**：业务部门主管。
- **场景**：工单预警 / 经营分析 / 流程处理需求澄清。
- **解决动作**：从口头一句话通过 `grill-me` 锁定问题本质、边界线、 Given-When-Then 场景与数据契约。

## 10. 教师演示步骤

### 步骤 1：唤醒 `grill-me` 追问
- 输入：`/grill-me 请协助我澄清工单预警需求。`

### 步骤 2：Task 3A/3B 聊天窗口预览与 HITL 工作流 (HITL Workflow)
- 输入：`请在聊天窗口输出 docs/BUSINESS_FEATURE_CARD.md、src/types/prototype-contract.d.ts 与 src/mocks/prototype-data.ts 预览。`

### 步骤 3：Task 3B HITL 授权落盘
- 输入：`同意方案，请开始落盘功能卡与契约资产`

### 步骤 4：三层验收与选择性暂存
- 执行 `npm run typecheck`、更新 `docs/PROJECT_STATE.md` & `git add --` 选择性暂存提交。

## 11. 学员实操任务

- **Task 1**：唤醒 `grill-me` 澄清 6 要素，清空阻断项。
- **Task 2**：Task 3A 预览与 Task 3B 口令授权落盘（触发 Blocking Gate 校验）。
- **Task 3**：三层验收、更新 `docs/PROJECT_STATE.md` 与 `git add --` 暂存 Commit。

## 12. 推荐提示词

```text
/grill-me
我想针对我选定的业务原型方向做需求澄清。请一次只问一个问题，控制在 5-7 轮内帮助我澄清使用者与问题、目标、边界、风险、Given-When-Then 验收场景、停止条件与数据契约。
```

## 13. Skill 使用

| 项 | 内容 |
| --- | --- |
| Skill 名称 | `grill-me` |
| Skill 用途 | 逐题澄清 6 大要素与数据契约 |

## 14. 工程化知识

- **Harness Engineering**：用契约卡与 Skill 约束大模型。
- **Given-When-Then**：场景化验收条件表达。
- **Stop Conditions**：Agent 熔断暂停与呈报主管条件。

## 15. 验证和证据

- [ ] `docs/BUSINESS_FEATURE_CARD.md` 包含 9 大章节，无阻断性待确认事项
- [ ] `npm run typecheck` & `npm run build` PASS
- [ ] `docs/PROJECT_STATE.md` 已同步更新为 L03 PASS
- [ ] Git Log 呈现 `feat: complete lesson 3 business and data contracts`

## 16. 课堂成果

- `docs/BUSINESS_FEATURE_CARD.md`
- `src/types/prototype-contract.d.ts`
- `src/mocks/prototype-data.ts`
- `docs/PROJECT_STATE.md`

## 17. 课后作业

复核 `docs/BUSINESS_FEATURE_CARD.md` 中的 `[待确认]` 事项，在下节课前与业务团队确认非阻断细节。

## 18. 通过标准

- [ ] 三层验收（工程、契约、主管）全部 PASS。

## 19. 常见误区与处理 (Misconceptions Table)

| 常见误区 | 现象描述 | 纠偏与处理方案 |
| --- | --- | --- |
| 误区 1：把解决方案当成问题 | 学员说“我要做个 AI 看板” | 引导关注当前人工耗时与遗漏事实，先定义具体痛点 |
| 误区 2：把 Given-When-Then 误当停止条件 | 将场景测试用例当成 Agent 熔断边界 | 明确 Given-When-Then 是功能正确性，Stop 是暂停呈报门禁 |
| 误区 3：带着阻断项直接进入第四课 | 关键字段来源未确认就写实施计划 | 强调阻断门禁规则，出现 `BLOCKING_GATE_FAILED` 时必须先清空阻断问题 |

## 20. 课后记录

```text
系统名称：待填
完成内容：第三课需求与数据契约落盘
修改文件：docs/BUSINESS_FEATURE_CARD.md, src/types/prototype-contract.d.ts, src/mocks/prototype-data.ts, docs/PROJECT_STATE.md
```

## 21. 学员包信息

| 项 | 内容 |
| --- | --- |
| 包版本 | 待生成 |

## 22. 教师复盘

```text
实际授课时间：待填
```

## 附录 A：契约冻结规则说明 (Teacher Appendix)

主管验收 PASS 后，`BUSINESS_FEATURE_CARD.md` 成为第四课的唯一需求基线。后续如需修改范围、业务规则、数据契约或验收场景，必须先更新 `BUSINESS_FEATURE_CARD.md` 并重新获得主管确认。
