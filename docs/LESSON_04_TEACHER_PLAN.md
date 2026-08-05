# 第四课教案 (V2 闭环版)：把大需求拆成连续的小成功

## 1. 课程元数据

| 项 | 内容 |
| --- | --- |
| 课次 | 第 4 课 |
| 课程名称 | 把大需求拆成连续的小成功 |
| 面向角色 | 运营主管 / 业务部门一级主管 |
| 建议时长 | 90 分钟 |
| 前置课程 | 第 3 课：让 Agent 帮助自己想清楚需求 |
| 对应路线图 | `docs/COURSE_ROADMAP.md` 第 4 课 |
| 课程状态 | 草稿V2 / 待合入 |
| 课程负责人 | 待指定 |
| 最后复核日期 | 2026-08-05 |
| 学员包版本 | 待生成 |
| 来源 commit 或 tag | 待生成 / main@d57a8e1f |

## 2. 本课定位

说明：
- **解决问题**：解决业务主管在面对复杂业务页面时，用裸 Prompt 或单次生成导致代码结构崩塌、上下文记忆爆炸、白屏死机且无法排错的典型卡点。
- **阶段安排**：处于“需求与结构”阶段收官课。在 L3 锁定了《业务功能卡》与《数据契约卡》后，L4 正式开启基于护栏的受控自主 Loop（Plan & Execute 范式）。
- **上下游关系**：承接 L3 输出的 `BUSINESS_FEATURE_CARD.md`、`prototype-contract.d.ts` 与 `src/mocks/prototype-data.ts`；输出持久化实施计划状态机 `docs/LESSON_04_IMPLEMENTATION_PLAN.md` 与首个包含 4 种接口状态及稳定 Commit 的业务组件切片，为 L5 的 `CLAUDE.md` 工程护栏打下坚实基础。

## 3. 核心目标

1. 掌握 **Plan & Execute 增量范式**，使用 `.claude/skills/incremental-implementation/SKILL.md` 护栏将拆解计划落盘至 `docs/LESSON_04_IMPLEMENTATION_PLAN.md`。
2. 掌握 **Step级 Workflow 授权门禁（首行精确匹配 `授权执行 Step 1`）**，受控下发切片编码指令。
3. 掌握 **数据接口 4 种物理状态（Loading / Empty / Error / Success）** 及其 **`prototypeState` 可视化调试切片（`import.meta.env.DEV`）**。
4. 掌握 **`Verifier Subagent` 静默自测机制**，运行 `scripts/run-lesson-verifier.ps1 -Step 1` 调用 `scripts/verify-student-project.ps1`，将编译日志落盘至 `local-backups/lesson-04-evidence/`，不污染主 Context 记忆并完成 Atomic Git Commit。

## 4. 可见成果

- 一份已批准的外部长期记忆实施计划状态机 `docs/LESSON_04_IMPLEMENTATION_PLAN.md`。
- 一个带有 `Prototype Debug` 标识、支持 4 种数据状态物理点击切换的已验证 Vue 业务组件切片 (Step 1)。
- 一个规范的 Git Commit 节点。
- 一份包含剩余 Step 2–N 执行指引的清单。

## 5. 本课明确不做

- 不在 90 分钟课堂内强行跑完 Step 2–N 全量细节（课堂聚焦跑通 1 个完整垂直切片闭环，剩余切片留作课后练习）。
- 不涉及真正的后端数据库与 API 连接（使用冻结 Mock 路径 `src/mocks/prototype-data.ts`）。
- 不涉及深度的端到端 Browser MCP 自动化操作（此为第 7 课内容）。
- 不涉及多 Agent 仲裁与代码审查（此为第 8 课内容）。

## 6. 教师准备

| 项 | 状态 | 说明 |
| --- | --- | --- |
| 教师演示环境 | 待完成 | Node.js, Claude Code CLI, Vite 运行环境 |
| 示例项目或页面 | 待完成 | 前置 L3 产物就绪项目 |
| 所需截图 | 待完成 | 1 巨石生成崩塌对比图，2 4状态调试切片效果图 |
| 所需 Skill | 待验证 | `.claude/skills/incremental-implementation/SKILL.md` |
| Skill 来源与版本 | addyosmani/agent-skills (bdf76c7) | 物理改编 V2 版 |
| Skill 是否已验证 | Skill定义检查：已完成；课堂实测状态：待候选包隔离验证 | 待隔离验证 |
| 起点 ZIP 或 tag | 待完成 | 基于 L3 交付基线项目 |
| 教师标准答案 | 待完成 | 包含 `prototypeState` 切换调试器与 4 状态分支的 Vue 组件 |

## 7. 学员准备

### ZIP 模式（默认）
- 解压 `lesson-04-starter.zip`
- 在终端运行 `npm run dev` 确保项目起手可运行
- 打开 Claude Code CLI

### Git 模式（进阶，非强制）
- 确认处于干净基线提交（Task 0 检查）

## 8. 课堂时间安排

| 时段 | 时长 | 内容 |
| --- | --- | --- |
| 成果展示与 Task 0 基线检查 | 10 分钟 | 检查 L3 资产，演示巨石盲开崩塌 vs 增量切片对比 |
| 教师演示 | 15 分钟 | 演示唤醒 `/incremental-implementation`，下发授权落盘与 `授权执行 Step 1` |
| 学员实操 Task 1 & 2 | 45 分钟 | 唤醒 Skill 生成并保存 `docs/LESSON_04_IMPLEMENTATION_PLAN.md`，下发授权门禁落盘 Step 1 组件 |
| Verifier 静默自测与 Git 存档 | 10 分钟 | 派遣 `Verifier Subagent` 运行 `scripts/run-lesson-verifier.ps1 -Step 1`，提交 Commit |
| 总结与 Exit Ticket | 10 分钟 | 完成 Exit Ticket 问答，总结主 Context 保护与 4 状态调试切片价值 |

## 9. 业务场景

- **使用者**：业务部门主管（运营 / 供应链 / 销售主管）。
- **当前问题**：主管向 AI 描述了一个复杂的工单看板，AI 吐出 800 行代码，不仅报错白屏，而且根本无法验证没数据或网络报错时界面长什么样。
- **工作场景**：工单管理看板原型增量开发。
- **本课处理动作**：通过 `/incremental-implementation` 拆解计划落盘，受控落地 Step 1 UI 状态切片。
- **使用的模拟数据**：`src/mocks/prototype-data.ts` 中的虚构工单列表。

## 10. 教师演示步骤

### 步骤 0：Task 0 基线校验
- **目标**：验证起点环境干净，确认前置契约文件存在。
- **输入**：“请检查当前 Git 状态及 docs/BUSINESS_FEATURE_CARD.md 是否就绪。”
- **预期结果**：确认起点无脏代码。

### 步骤 1：唤醒 Skill 与 Plan 落盘演示
- **目标**：演示计划预览与授权落盘。
- **输入 1**：`/incremental-implementation` 读取 L3 契约生成 Plan 预览。
- **输入 2**：`授权保存 Lesson 04 实施计划`
- **预期结果**：根目录物理生成包含状态机字段的 `docs/LESSON_04_IMPLEMENTATION_PLAN.md`。

### 步骤 2：下发授权门禁与 `prototypeState` 调试切片演示
- **目标**：演示 Workflow 授权门禁与 4 状态调试切片。
- **输入**：`授权执行 Step 1`
- **操作**：刷新页面，物理点击顶部 `Prototype Debug` 单选按钮（Loading / Empty / Error / Success），演示 4 种界面切换。
- **预期结果**：组件中物理生成 `prototypeState` 条件渲染分支。

### 步骤 3：Verifier Subagent 静默自测演示
- **目标**：演示后台静默自测与日志落盘。
- **输入**：“派遣 Verifier Subagent 运行 scripts/run-lesson-verifier.ps1 -Step 1。”
- **操作**：展示主窗口仅接收到 `[PASS]` 总结，日志写入 `local-backups/lesson-04-evidence/step-1-verification.log`，状态机更新至 Step 2。

## 11. 学员实操任务

### Task 0：基线断言
- **输入提示词**：`检查当前环境与 L3 契约文件是否存在。`
- **完成标准**：Working tree clean。

### 任务 1：唤醒 Skill 并落盘 Plan
- **输入提示词 1**：`/incremental-implementation 请读取需求卡与 TS 契约，生成 3-5 步计划预览。`
- **输入提示词 2**：`授权保存 Lesson 04 实施计划`
- **完成标准**：生成 `docs/LESSON_04_IMPLEMENTATION_PLAN.md`。

### 任务 2：下发授权门禁落盘 Step 1 组件
- **修改范围**：`src/components/` 目标组件。
- **输入提示词**：`授权执行 Step 1`
- **完成标准**：页面可直接点击按钮切换 4 种 UI 视图。

### 任务 3：Verifier Subagent 静默自测与 Commit
- **输入提示词**：`派遣 Verifier Subagent 后台运行 scripts/run-lesson-verifier.ps1 -Step 1 校验，确认 PASS 后提示我 commit。`
- **完成标准**：返回 `[PASS]`，Git Log 增加 1 个稳定 commit，`current_waiting_step` 更新至 2。

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
| 来源仓库 | `addyosmani/agent-skills` |
| 固定版本或 commit | bdf76c7c6b7b3b3e01bb15c9fdc42ac5351855c1 |
| 安装状态 | 已安装于 `.claude/skills/incremental-implementation/SKILL.md` |
| 验证状态 | Skill定义检查：已完成；课堂实测状态：待候选包隔离验证 |

## 14. 工程化知识

- **Plan & Execute 范式**：控制 Context Window 膨胀的核心手段。
- **Step级 Workflow 授权门禁**：首行精确匹配阻止 AI 冲动修改。
- **prototypeState 调试切片**：解决静态 Mock 环境下无法物理验证 Loading/Empty/Error 的工业级技巧。
- **Verifier Subagent 模式**：子会话静默跑编译，日志落盘至 `local-backups/lesson-04-evidence/`，保护主 Context 记忆纯净。

## 15. 验证和证据

- [ ] 页面实际操作与 `prototypeState` 4 种状态物理点击切换演示
- [ ] `Verifier Subagent` 静默自测返回 `[PASS]`
- [ ] `npm run typecheck` & `npm run build` PASS
- [ ] `git log` 显示增量 commit

## 16. 课堂成果

1. 外部长期记忆实施计划 `docs/LESSON_04_IMPLEMENTATION_PLAN.md`。
2. 包含 `prototypeState` 物理调试切换器与 4 状态分支的 Vue 组件切片 (Step 1)。
3. 规范的 Git Commit 记录与 Verifier 自测日志。

## 17. 课后作业

**作业描述**：
根据 `docs/LESSON_04_IMPLEMENTATION_PLAN.md` 的计划，依次下发 `授权执行 Step 2`，完成数据绑定与搜索筛选逻辑。

## 18. 通过标准

- [ ] 成功在根目录生成 `docs/LESSON_04_IMPLEMENTATION_PLAN.md`。
- [ ] 学员通过 `授权执行 Step 1` 首行精确匹配门禁驱动 Agent 编码。
- [ ] 成功派遣 `Verifier Subagent` 完成静默自测与 Git 提交。

## 19. 常见问题

| 问题类型 | 现象 | 处理建议 |
| --- | --- | --- |
| 概念卡点 | 为什么要在页面加调试切换按钮 | 解释静态 Mock 下白屏和边界死角问题 |
| 操作卡点 | 首行未精确匹配导致授权失败 | 强调消息第一行必须严格写 `授权执行 Step 1` |
| 记忆卡点 | 主窗口被报错日志刷屏 | 使用 Verifier Subagent 后台跑命令 |

## 20. 课后记录

```text
系统名称：工单管理看板原型
学员角色：运营主管
本课完成内容：待填
修改文件：待填
完成交互：待填
验证结果：待填
下一步：第五课 CLAUDE.md 工程护栏与防崩演练
```

## 21. 学员包信息

| 项 | 内容 |
| --- | --- |
| ZIP 文件名 | 待生成 |
| 包版本 | 待生成 |
| 来源 commit 或 tag | 待生成 / main@d57a8e1f |
| SHA256 | 待生成 |
| 包含内容 | 待生成 |
| 排除内容 | 待生成 |
| 恢复方法 | 待生成 |

## 22. 教师复盘

```text
实际授课时间：待填
学员卡点：待填
提示词问题：待填
Skill 问题：待填
底座问题：待填
下次调整：待填
是否需要更新路线图：否
```
