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
| 课程状态 | 已交付 / 闭环 |
| 课程负责人 | 课程研发组 |
| 最后复核日期 | 2026-08-05 |
| 学员包版本 | v0.1.0 |
| 来源 commit 或 tag | HEAD / main@d57a8e1f |

## 2. 本课定位

说明：
- **解决问题**：解决业务主管在提出需求时口头描述模糊、将解决方案误认为问题本质、缺乏字段与规则收扣导致 AI 凭空脑补与代码漂移的典型卡点。
- **阶段安排**：处于“需求与结构”阶段开篇课。承接前两课外观搭建，为第 4 课 Plan & Execute 增量开发提供固定的契约依据。
- **上下游关系**：输出 `docs/BUSINESS_FEATURE_CARD.md` (含 9 大完整章节及嵌入的数据契约表)、TypeScript 类型草稿 `src/types/prototype-contract.d.ts` 与 `src/mocks/prototype-data.ts`。

## 3. 核心目标

1. 掌握 **`grill-me` 追问技能护栏**，完成 3–5 轮结构化对话澄清。
2. 掌握 **Given-When-Then 验收条件** 与 **Stop / Escalation 停止上提熔断条件** 的本质区别。
3. 锁定 **6 大业务要素**（Goal 业务目标、User & Problem 问题定义、Boundary 边界、Risk 风险隐私、Acceptance Criteria 验收场景、Stop Conditions 停止条件）。
4. 区分并标记 **`[事实]`、`[决定]`、`[假设]` 与 `[待确认]`** 事项。
5. 掌握 **三层验收机制（工程验证、契约验证、主管验收）** 与选择性暂存 (`git add --`) 存档。

## 4. 可见成果

- `docs/BUSINESS_FEATURE_CARD.md`（包含 9 大完整章节：1. User & Problem, 2. Goal, 3. In Scope / Out of Scope, 4. Business Rules, 5. Risks and Data Policy, 6. Acceptance Scenarios, 7. Stop / Escalation Conditions, 8. Data Contract, 9. Open Decisions）。
- `src/types/prototype-contract.d.ts`（TypeScript 类型草稿）。
- `src/mocks/prototype-data.ts`（符合强类型结构的 Mock 数据）。

## 5. 本课明确不做

- 不在第 3 课直接修改 `src/components/` 业务代码（本课专注需求澄清与契约落盘）。
- 不把 TypeScript 类型草稿过度承诺为生产 API 最终合同。
- 不把 Bounded Agent Loop 自动纠偏在本课展开（此为第 4 课内容）。

## 6. 教师准备

| 项 | 状态 | 说明 |
| --- | --- | --- |
| 教师演示环境 | 已就绪 | Node.js, Claude Code CLI |
| 所需 Skill | 已就绪 | `.claude/skills/grill-me/SKILL.md` |
| 教师标准答案 | 已就绪 | 包含 9 大章节的 `BUSINESS_FEATURE_CARD.md` |

## 7. 学员准备

- 完成前两课，项目起手可运行 `npm run dev`。
- 确认处于干净基线提交。

## 8. 课堂时间安排

| 时段 | 时长 | 内容 |
| --- | --- | --- |
| 成果展示与复盘 | 10 分钟 | 展示模糊需求导致代码崩溃对比，解析 6 大业务要素 |
| 教师演示 | 15 分钟 | 演示唤醒 `grill-me`，下发 Task 3A 预览与 Task 3B HITL 授权口令 |
| 学员实操 Task 1 & 2 | 45 分钟 | 唤醒 `grill-me` 澄清 6 要素，输出 9 章节契约卡与类型草稿 |
| 三层验收与 Git 存档 | 10 分钟 | 执行工程验证、契约验证与主管验收，选择性暂存 Commit |
| 总结与 Exit Ticket | 10 分钟 | 区分 Given-When-Then 与 Stop Conditions，完成退场测试 |

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
- 执行 `npm run typecheck` & `git add --` 选择性暂存提交。

## 11. 学员实操任务

- **Task 1**：唤醒 `grill-me` 澄清 6 要素。
- **Task 2**：Task 3A 预览与 Task 3B 口令授权落盘。
- **Task 3**：三层验收与 `git add --` 暂存 Commit。

## 12. 推荐提示词

```text
/grill-me
我想针对我选定的业务原型方向做需求澄清。请一次只问一个问题，帮助我澄清使用者与问题、目标、边界、风险、Given-When-Then 验收场景、停止条件与数据契约。
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

- [ ] `docs/BUSINESS_FEATURE_CARD.md` 包含 9 大章节
- [ ] `npm run typecheck` & `npm run build` PASS
- [ ] Git Log 呈现 `feat: complete lesson 3 business and data contracts`

## 16. 课堂成果

- `docs/BUSINESS_FEATURE_CARD.md`
- `src/types/prototype-contract.d.ts`
- `src/mocks/prototype-data.ts`

## 17. 课后作业

复核 `docs/BUSINESS_FEATURE_CARD.md` 中的 `[待确认]` 事项，在下节课前与业务团队确认。

## 18. 通过标准

- [ ] 三层验收（工程、契约、主管）全部 PASS。

## 19. 常见问题

| 问题 | 处理 |
| --- | --- |
| 无法区分验收条件与停止条件 | 解释 Given-When-Then 是功能正确性，Stop 条件是 Agent 触发熔断 |

## 20. 课后记录

```text
系统名称：待填
完成内容：第三课需求与数据契约落盘
修改文件：docs/BUSINESS_FEATURE_CARD.md, src/types/prototype-contract.d.ts, src/mocks/prototype-data.ts, docs/PROJECT_STATE.md
```

## 21. 学员包信息

| 项 | 内容 |
| --- | --- |
| 包版本 | v0.1.0 |

## 22. 教师复盘

```text
实际授课时间：待填
```
