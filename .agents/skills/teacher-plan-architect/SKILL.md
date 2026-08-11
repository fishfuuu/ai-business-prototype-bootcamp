---
name: teacher-plan-architect
description: "The sole final renderer for the 8-module TEACHER_PLAN (教师教案). Consumes a HANDOFF_READY Lesson Design Brief and renders the repository's 8-module teacher plan structure. Does not self-approve, does not auto-produce GUIDE, and does not modify repository course materials beyond the authorized TEACHER_PLAN write."
---

# Teacher Plan Architect (教师教案终稿渲染器)

当需要编写或重构《教师备课与控场指南 (TEACHER_PLAN)》时，本 Skill 是**唯一终稿渲染器**。它消费 HANDOFF_READY 的 Lesson Design Brief，按仓库八模块教案结构渲染教师教案。

## Role Boundaries

- **唯一职责**：渲染八模块教师教案（TEACHER_PLAN）。
- **不自我授权**：不自我批准教案；教案需 Independent Review + 用户/课程负责人批准后才进入 GUIDE 阶段。
- **不自动产 GUIDE**：GUIDE 由后续独立步骤生成，需教案批准后执行。
- **不拥有生命周期**：本 Skill 不持有 lifecycle、artifact ownership 或审批权，只提供方法与渲染约束。
- **不修改课程材料**：除授权的 TEACHER_PLAN 写入外，不修改 GUIDE、派生资产或其他仓库文件。

## Input Contract

本 Skill 只消费 **HANDOFF_READY** 的 Lesson Design Brief：

- Brief schema 唯一权威：`.agents/skills/teaching-lesson-plan/references/lesson-design-brief-template.md`
- `contract_version` 由该 reference 文件唯一拥有；本 Skill 只声明消费的版本并做字段校验。
- `brief_readiness` 必须为 `HANDOFF_READY`（仅表示完整性，不是批准）。
- Brief 的 authority refs 必须指向当前 locked UIC / frozen design spec / approved roadmap / approved lesson artifacts。

## Fail-Closed Rules

- **Wrong lesson**：Brief 的 `lesson_number` 与请求不符 → 停止并报告。
- **Stale source**：Brief 引用的 UIC/design/roadmap 不是当前锁定/冻结/批准版本 → 停止并报告。
- **Invalid readiness**：`brief_readiness` 不是 `HANDOFF_READY` → 停止，不消费。
- **Schema drift**：`contract_version` 不匹配或字段缺失 → 停止并报告。
- **Spec gap**：Brief 会改变目标、非目标或验收含义 → 分类为规格缺口，返回 DRAFT，不静默吸收。

## 8-Module Teacher Plan Structure

教师教案按以下 8 大执教模块渲染（模块可合并/重排，但必须覆盖）：

| 模块 | 核心内容 | 关键要求 |
| :--- | :--- | :--- |
| **一、课程元数据与定位** | 元数据、定位、背景痛点、版本记录 | 集中定义课程基本属性与演进信息 |
| **二、逆向目标与四步概念卡** | Bloom ABCD 能力矩阵 + 2–3 个核心概念卡 | 目标与核心概念集中对齐 |
| **三、教学准备与沙箱隔离** | 准备资源、沙箱规则、环境检查 | 罗列开课前需要检查的环境项 |
| **四、90 分钟控场主线** | 时间预算表（总 ≤ 90 分钟，可调） | 提问问答嵌入时间表；不设固定暂停点数量与位置 |
| **五、逐 Task 示范与巡视指导** | 按 Task 聚合：示范、口令、巡视、辅导 | 示范动作、口令、巡视卡点在同一 Task 下 |
| **六、现场 Debug 预案** | Troubleshooting 表 | 应急排错预案；不虚构未实现的验证命令 |
| **七、退场测试与课后拓展作业** | Exit Ticket（1–2 个必答提示）+ 巩固作业 | 结束前评估与总结 |
| **八、教师备课质量自测 Checklist** | 课前检查 Checklist | 确保备课质量闭环 |

## 四步概念卡

每个首次出现的“必须掌握”概念使用四步卡，第四步必须回指学员**刚完成的哪一步实操**：

1. **是什么 / 不是什么**：标准定义与边界。
2. **机制**：底层实际流转逻辑。
3. **业务类比与反例**：记忆锚点 + 反例澄清。
4. **交接价值**：对应刚完成的哪一步实操，以及主管为何需要用该词与 IT 沟通或作出判断。

单概念讲解控制在 3–5 分钟。安全/权限/数据前置概念必须在实操前讲。

## 双 Commit 与 CEO 决策树边界

- **双 Commit** 仅为两阶段版本记录/主管确权比喻（D18），Git 不理解业务审批；不得把 Git 操作描述为业务审批机制。
- **CEO 三大决策树**是主管处置框架，不是代码运行时硬控制，也不是行业标准。
- 教案中不得把文字规则冒充 runtime hard control；控制层按 guidance / workflow gate / runtime hard control 分层描述。

## 证据链

教案结尾必须包含明确的证据验收机制，但不得虚构能力：

1. **视觉证据**：页面/界面对比截图或状态切换。
2. **行为证据**：交互点击无报错日志，终端网络输出正常。
3. **工程证据**：以真实运行输出为准；`verify-project.ps1` 是遗留母仓库维护检查，不作为课堂/业务通过证明。
4. **范围证据**：`git status` 确认未修改超出许可范围的文件；不要求“Working Tree 100% Clean”作为教案通过条件。

## 教案与指南质量自我审计 Checklist

在生成或重构教案后，自我审计是否满足：

- [ ] 教师教案覆盖 8 大执教模块（可合并/重排，不设固定暂停点数量）。
- [ ] 所有核心概念均包含【是什么/不是什么 + 机制 + 业务类比与反例 + 交接价值】4 步，第四步回指刚完成实操。
- [ ] 时间预算总长 ≤ 90 分钟，真实时长经逐课试讲校准，不伪造精确时间数据。
- [ ] 概念暴露台账区分 named/plain/background 与独立考核判断。
- [ ] 双轨教学（教师统一工作台 / 学员个人原型）与三类成果分离（课堂内可见成果 / 课间微任务 / 每周完整成果）已覆盖。
- [ ] Mock/无密钥/安全边界已声明；教师真实调用完全在仓库外。
- [ ] 未虚构 `verify-project.ps1`、`npm run verify`、`doctor`、`test:ui` 等未实现能力。
- [ ] 教案未自我批准；批准记录引用真实 Independent Review + 用户/课程负责人批准。
