# 第四课教案 (V2 闭环版)：把大需求拆成连续的小成功

## 1. 课程元数据

| 项 | 内容 |
| --- | --- |
| 课次 | 第 4 课 |
| 课程名称 | 把大需求拆成连续的小成功 |
| 面向角色 | 运营主管 / 业务部门一级主管 |
| 建议时长 | 90 分钟 |
| 前置课程 | 第 3 课：把模糊想法变成可执行的业务契约 |
| 对应路线图 | `docs/COURSE_ROADMAP.md` 第 4 课 |
| 课程状态 | 草稿V2 / 待合入 |
| 课程负责人 | 待指定 |
| 最后复核日期 | 2026-08-05 |
| 学员包版本 | 待生成 |
| 来源 commit 或 tag | 待生成 / main@d57a8e1f |

## 2. 本课定位

说明：
- **解决问题**：解决业务主管在面对复杂业务页面时，用裸 Prompt 或单次生成导致代码结构崩塌、上下文记忆爆炸、白屏死机且无法排错的典型卡点。
- **核心主概念**：**增量实施 (Incremental Implementation)**——不让 Agent 一口气完成整个功能，而是先形成计划，每次只完成一个可验证的小切片。
- **上下游关系**：承接 L3 输出的 `docs/BUSINESS_FEATURE_CARD.md`、`prototype-contract.d.ts` 与 `src/mocks/prototype-data.ts`；输出持久化实施计划状态机 `docs/LESSON_04_IMPLEMENTATION_PLAN.md` 与首个包含 4 种技术呈现状态及代码归档的业务组件切片。

## 3. 核心目标

1. 掌握 **增量实施范式**，使用 `.claude/skills/incremental-implementation/SKILL.md` 护栏将拆解计划落盘至 `docs/LESSON_04_IMPLEMENTATION_PLAN.md`。
2. 掌握 **Step级 Workflow 授权门禁（首行精确匹配 `授权执行 Step 1`）**，受控下发切片编码指令。
3. 掌握 **页面技术呈现状态（Loading/Empty/Error/Success）** 与 **业务流程状态（待处理/处理中/已阻塞/已完成）** 的本质区别。
4. 掌握 **`prototypeState` 可视化调试切片（`import.meta.env.DEV`）** 与针对三类原型的切片设计。
5. 掌握 **三层递进验收机制（静态工程自测、人工页面点击验收、主管业务验收）** 与失败时的 `BLOCKED` 标记暂停处理。

## 4. 可见成果

- 一份已批准的外部长期记忆实施计划状态机 `docs/LESSON_04_IMPLEMENTATION_PLAN.md`。
- 一个带有 `Prototype Debug` 标识、支持 4 种技术状态点击切换的已验证 Vue 业务组件切片 (Step 1)。
- 一个规范的代码 Commit 节点。
- 一份包含剩余 Step 2–N 执行指引的清单。

## 5. 本课明确不做

- 不在 90 分钟课堂内强行跑完 Step 2–N 全量细节（课堂聚焦跑通 1 个完整切片闭环）。
- 不把底层 `taskkill`、超时退出码 124/125 或两提交暂存内部细节作为主管课堂必考点（下沉至教师与运维附录）。
- 不把静态 Mock 接口与真 API 混为一谈。

## 6. 教师准备

| 项 | 状态 | 说明 |
| --- | --- | --- |
| 教师演示环境 | 待完成 | Node.js, Claude Code CLI, Vite 运行环境 |
| 示例项目或页面 | 待完成 | 前置 L3 产物就绪项目 |
| 所需截图 | 待完成 | 1 巨石生成崩塌对比图，2 4技术状态调试切片效果图 |
| 所需 Skill | 待验证 | `.claude/skills/incremental-implementation/SKILL.md` |
| Skill 来源与版本 | addyosmani/agent-skills (bdf76c7c6b7b3b3e01bb15c9fdc42ac5351855c1) | 物理改编 V2 版 |
| Skill 是否已验证 | Skill定义检查：已完成；课堂实测状态：待候选包隔离验证 | 待隔离验证 |
| 教师标准答案 | 待完成 | 包含 `prototypeState` 切换调试器与 4 状态分支的 Vue 组件 |

## 7. 学员准备

- 解压学员起点包，在终端运行 `npm run dev` 确保项目起手可运行。
- 确认处于干净基线提交（Task 0 检查）。

## 8. 课堂时间安排

| 时段 | 时长 | 内容 |
| --- | --- | --- |
| 成果展示与 Task 0 基线检查 | 10 分钟 | 检查 L3 资产，演示巨石盲开崩塌 vs 增量切片对比 |
| 教师演示 | 15 分钟 | 演示唤醒 `/incremental-implementation`，下发授权落盘与 `授权执行 Step 1` |
| 学员实操 Task 1 & 2 | 45 分钟 | 唤醒 Skill 生成并保存 `docs/LESSON_04_IMPLEMENTATION_PLAN.md`，下发授权门禁落盘 Step 1 组件 |
| 静默自测与三层验收归档 | 10 分钟 | 派遣 `Verifier Subagent` 运行 `scripts/run-lesson-verifier.ps1 -Step 1`，完成三层验收与 Commit |
| 总结与 Exit Ticket | 10 分钟 | 完成 Exit Ticket 问答，总结页面技术呈现状态 vs 业务流程状态区别 |

## 9. 业务场景

- **使用者**：业务部门主管。
- **当前问题**：主管向 AI 描述了一个复杂的页面，AI 吐出 800 行代码，报错白屏且无法验证各种异常情况。
- **工作场景**：看板/列表原型增量开发。
- **处理动作**：通过 `/incremental-implementation` 拆解计划落盘，受控落地 Step 1 UI 状态切片。

## 10. 教师演示步骤

### 步骤 0：Task 0 基线校验
- 输入：“请检查当前 Git 状态及 docs/BUSINESS_FEATURE_CARD.md 是否就绪。”

### 步骤 1：唤醒 Skill 与 Plan 落盘演示
- 输入 1：`/incremental-implementation` 读取 L3 契约生成 Plan 预览。
- 输入 2：`授权保存 Lesson 04 实施计划`

### 步骤 2：下发授权门禁与 `prototypeState` 调试切片演示
- 输入：`授权执行 Step 1`
- 操作：刷新页面，物理点击顶部 `Prototype Debug` 单选按钮，演示 4 种界面切换。

### 步骤 3：Verifier 静默自测与版本归档演示
- 输入 1：“派遣 Verifier Subagent 运行 scripts/run-lesson-verifier.ps1 -Step 1。”
- 输入 2：`授权提交 Step 1 源码`
- 输入 3：`授权提交 Step 1 状态推进`

## 11. 学员实操任务

- **Task 0**：基线断言。
- **任务 1**：唤醒 Skill 并落盘 Plan。
- **任务 2**：下发授权门禁落盘 Step 1 组件。
- **任务 3**：静默自测、三层验收与版本归档。

## 12. 推荐提示词

```text
/incremental-implementation
请读取 docs/BUSINESS_FEATURE_CARD.md、src/types/prototype-contract.d.ts 与 src/mocks/prototype-data.ts。
为你制订 3-5 步 Contract-First 的增量开发计划。
要求：
1. 只输出 Plan 预览，提示我下发 "授权保存 Lesson 04 实施计划"；
2. 计划落盘至 docs/LESSON_04_IMPLEMENTATION_PLAN.md 后，提示我下发 "授权执行 Step 1"；
3. 必须在 Step 1 组件顶部渲染带有 Prototype Debug 标识的状态调试切换器；
4. 编写完成后派遣 Verifier Subagent 后台运行 scripts/run-lesson-verifier.ps1 -Step 1。
```

## 13. Skill 使用

| 项 | 内容 |
| --- | --- |
| Skill 名称 | `incremental-implementation` |
| Skill 用途 | 物理锁死 Plan 预览，授权保存实施计划，下发 Step级 Workflow 授权门禁落盘 |

## 14. 工程化知识

- **增量实施范式**：控制 Context Window 膨胀的核心手段。
- **页面技术呈现状态 vs 业务流程状态**：前端 UI 数据拉取状态与业务对象生命周期状态解耦。
- **三层验收机制**：静态工程自测 + 人工页面点击验收 + 主管业务验收。

## 15. 验证和证据

- [ ] 页面实际操作与 `prototypeState` 4 种状态点击切换演示
- [ ] `Verifier Subagent` 静默自测返回 `[PASS]`
- [ ] `npm run typecheck` & `npm run build` PASS
- [ ] `git log` 显示代码版本提交

## 16. 课堂成果

1. 实施计划 `docs/LESSON_04_IMPLEMENTATION_PLAN.md`。
2. 包含 `prototypeState` 物理调试切换器与 4 状态分支的 Vue 组件切片 (Step 1)。
3. 规范的代码 Commit 记录。

## 17. 课后作业

根据 `docs/LESSON_04_IMPLEMENTATION_PLAN.md` 的计划，依次下发 `授权执行 Step 2`，完成数据绑定与搜索筛选逻辑。

## 18. 通过标准

- [ ] 三层验收全部 PASS。若验证失败，成功将 Step 标记为 `BLOCKED` 并写入 `failure_summary` 同样视为合格交付。

## 19. 常见问题

| 问题类型 | 现象 | 处理建议 |
| --- | --- | --- |
| 概念卡点 | 为什么不让 AI 一口气写完 | 解释巨石代码盲开引发的白屏与爆 Context 问题 |
| 操作卡点 | 首行未精确匹配导致授权失败 | 强调消息第一行必须严格写 `授权执行 Step 1` |

## 20. 课后记录

```text
系统名称：待填
完成内容：第四课增量切片与技术状态调试落盘
修改文件：docs/LESSON_04_IMPLEMENTATION_PLAN.md, src/components/
```

## 21. 学员包信息

| 项 | 内容 |
| --- | --- |
| 包版本 | v0.1.0 |

## 22. 教师复盘

```text
实际授课时间：待填
```

## 23. 附录：运维与两提交治理内部细节 (Teacher & Maintainer Appendix)

### A1. 两提交选择性暂存协议
- **Commit A (源码暂存)**：`git add -- <Step N allowed_files>`，提交消息 `feat(prototype): step N - implement target slice`。
- **Commit B (状态暂存)**：`git add -- docs/LESSON_04_IMPLEMENTATION_PLAN.md`，提交消息 `docs(state): advance lesson 04 plan to step N+1`（或 `docs(state): complete lesson 04 implementation plan`）。

### A2. Verifier 进程树终止与退出码说明
- 超时阈值：60 秒。
- 退出码含义：`0` 为 PASS；`1` 为 FAIL；`124` 为 TIMEOUT（进程树已被 taskkill 成功销毁）；`125` 为 KILL_FAILED（进程树销毁失败）。
