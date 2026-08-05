# 第四课教案 (V2 重构版)：把大需求拆成连续的小成功

## 1. 课程元数据

| 项 | 内容 |
| --- | --- |
| 课次 | 第 4 课 |
| 课程名称 | 把大需求拆成连续的小成功 |
| 面向角色 | 运营主管 / 业务部门一级主管 |
| 建议时长 | 90 分钟 |
| 前置课程 | 第 3 课：让 Agent 帮助自己想清楚需求 |
| 对应路线图 | `docs/COURSE_ROADMAP.md` 第 4 课 |
| 课程状态 | 已重构（含 Verifier Subagent、4 状态切换器与 HITL 授权口令） |
| 课程负责人 | AI 业务原型训练营组 |
| 最后复核日期 | 2026-08-04 |
| 学员包版本 | 待生成 / main@d57a8e1 |
| 来源 commit 或 tag | main@d57a8e1 |

## 2. 本课定位

说明：
- **解决问题**：解决业务主管在面对复杂业务页面时，用裸 Prompt 或单次生成导致代码结构崩塌、上下文记忆爆炸、白屏死机且无法排错的典型卡点。
- **阶段安排**：处于“需求与结构”阶段收官课。在 L3 锁定了《业务功能卡》与《数据契约卡》后，L4 正式开启基于护栏的受控自主 Loop（Plan & Execute 范式）。
- **上下游关系**：承接 L3 输出的 `BUSINESS_FEATURE_CARD.md` 与 `prototype-contract.d.ts`；输出带有 4 种接口状态和稳定 Commit 的业务组件，为 L5 的 `CLAUDE.md` 工程护栏与防崩演练打下坚实基础。

## 3. 核心目标

1. 掌握 **Plan & Execute 增量范式**，使用 `.claude/skills/incremental-implementation/SKILL.md` 护栏与 **`授权执行 Step X` HITL 口令** 将大需求物理收敛为 3–5 步薄切片。
2. 掌握 **数据接口 4 种物理状态（Loading / Empty / Error / Success）** 及其 **`prototypeState` 可视化切换按钮** 的物理验证。
3. 掌握 **`Verifier Subagent` 静默自测机制**，在不污染主 Context 记忆的前提下跑通 `npm run build` 并完成 Atomic Git Commit 存档。

## 4. 可见成果

- 一个带有 `prototypeState` 调试按钮、支持 4 种数据状态（骨架屏、空状态、报错重试、数据列表）流畅点击切换的 Vue 业务模块。
- 包含 3–5 个清晰增量 commit 节点的 Git 历史记录。
- 经由 `Verifier Subagent` 静默断言全绿通过的最终工程。

## 5. 本课明确不做

- 不涉及真正的后端数据库与 API 连接（仅使用 `prototype-data.ts` Mock 数据控制 4 种状态）。
- 不涉及深度的端到端 Browser MCP 自动化操作（此为第 7 课内容）。
- 不涉及多 Agent 仲裁与代码审查（此为第 8 课内容）。

## 6. 教师准备

| 项 | 状态 | 说明 |
| --- | --- | --- |
| 教师演示环境 | 已完成 | Node.js, Claude Code CLI, Vite 运行环境 |
| 示例项目或页面 | 已完成 | 前置 L3 产物就绪项目 |
| 所需截图 | 待完成 | 1 巨石生成崩塌对比图，2 4状态切换器点击效果图 |
| 所需 Skill | 已完成 | `.claude/skills/incremental-implementation/SKILL.md` |
| Skill 来源与版本 | 已验证 | 基于 Addy Osmani 物理规范改编 V2 版 |
| Skill 是否已验证 | 是 | 已在本仓库物理验证 |
| 起点 ZIP 或 tag | 已完成 | 基于 L3 交付基线项目 |
| 教师标准答案 | 已完成 | 包含 `prototypeState` 切换按钮与 4 状态分支的 Vue 组件 |

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
| 教师演示 | 15 分钟 | 演示唤醒 `/incremental-implementation`，下发 `授权执行 Step 1` 口令 |
| 学员实操 Task 1 & 2 | 45 分钟 | 唤醒 Skill 生成 Plan，下发授权口令，物理植入 `prototypeState` 4 状态切换按钮 |
| Verifier 静默自测与 Git 存档 | 10 分钟 | 派遣 `Verifier Subagent` 静默校验，无误后提交 Atomic Git Commit |
| 总结与 Exit Ticket | 10 分钟 | 完成 Exit Ticket 问答，总结主 Context 保护与 4 状态可视化价值 |

## 9. 业务场景

- **使用者**：业务部门主管（运营 / 供应链 / 销售主管）。
- **当前问题**：主管向 AI 描述了一个复杂的工单看板，AI 吐出 800 行代码，不仅报错白屏，而且根本无法验证没数据或网络报错时界面长什么样。
- **工作场景**：工单管理看板原型增量开发。
- **本课处理动作**：通过 `/incremental-implementation` 拆解为“状态控制+骨架”、“列表呈现”、“异常重试”增量落盘。
- **使用的模拟数据**：`src/data/prototype-data.ts` 中的虚构工单列表。

## 10. 教师演示步骤

### 步骤 0：Task 0 基线校验
- **目标**：验证起点环境干净，锁定前置 SHA。
- **输入**：“请检查当前 Git Commit 状态及 docs/BUSINESS_FEATURE_CARD.md 是否就绪。”
- **预期结果**：确认起点无脏代码。

### 步骤 1：巨石反例 vs. `/incremental-implementation` Plan 演示
- **目标**：展示唤醒 Skill 后 AI 被锁定在 Plan 阶段。
- **输入**：`/incremental-implementation`，读取 `BUSINESS_FEATURE_CARD.md` 生成 3–5 步计划。
- **操作**：展示 AI 吐出 Plan 文本，并提示 `Plan 制定完毕。请输入 "授权执行 Step 1" 以开始编码。`
- **预期结果**：零文件修改。

### 步骤 2：下发授权口令与 `prototypeState` 切换器演示
- **目标**：演示 HITL 授权与 4 状态可视化调试。
- **输入**：`授权执行 Step 1：请创建组件并植入 prototypeState ('loading' | 'empty' | 'error' | 'success') 调试切换按钮。`
- **操作**：刷新页面，物理点击顶部按钮（Loading / Empty / Error / Success），演示 4 种界面物理切换。
- **预期结果**：组件中物理生成条件渲染分支与顶部切换单选框。

### 步骤 3：Verifier Subagent 静默自测演示
- **目标**：演示如何在不污染主 Context 的情况下跑通自测。
- **输入**：“派遣 Verifier Subagent 后台静默运行 npm run build。”
- **操作**：展示子会话静默跑完，主窗口仅接收到 `[PASS]` 总结。

## 11. 学员实操任务

### Task 0：基线断言
- **输入提示词**：`检查当前环境与 L3 契约文件是否存在。`
- **完成标准**：Working tree clean。

### 任务 1：唤醒 Skill 锁定 Plan
- **输入提示词**：`/incremental-implementation 请读取需求卡与 TS 契约，生成 3-5 步计划，不要改代码。`
- **完成标准**：CLI 输出步骤与授权提示，无源码变更。

### 任务 2：下发口令落盘 4 状态组件
- **修改范围**：`src/components/` 目标组件。
- **输入提示词**：`授权执行 Step 1：编写组件，物理植入 prototypeState 响应式调试切换按钮，实现 4 种 UI 视图。`
- **完成标准**：页面可直接点击按钮物理切换 4 种 UI。

### 任务 3：Verifier Subagent 静默自测与 Commit
- **输入提示词**：`派遣 Verifier Subagent 后台运行 npm run build 校验，确认 PASS 后提示我 commit。`
- **完成标准**：返回 `[PASS]`，Git Log 增加 1 个稳定 commit。

## 12. 推荐提示词

```text
/incremental-implementation
请读取 docs/BUSINESS_FEATURE_CARD.md 与 src/types/prototype-contract.d.ts。
为你制订 3-5 步 Contract-First 的增量开发计划。
要求：
1. Plan 阶段：只输出拆解计划与每步验收条件，绝不要修改任何代码；
2. 提示我下发 "授权执行 Step X" 口令后，才允许落地该步骤代码；
3. 必须在组件顶部渲染 prototypeState ('loading'|'empty'|'error'|'success') 调试切换器；
4. 编写完成后派遣 Verifier Subagent 静默跑通 npm run build。
```

## 13. Skill 使用

| 项 | 内容 |
| --- | --- |
| Skill 名称 | `incremental-implementation` |
| Skill 用途 | 物理锁死 Plan 阶段，下发 HITL 授权口令落盘，物理植入 4 状态切换器 |
| 来源仓库 | `addyosmani/agent-skills` |
| 固定版本或 commit | 物理重构 V2 版 |
| 安装状态 | 已安装于 `.claude/skills/incremental-implementation/SKILL.md` |
| 验证状态 | 已物理验证 |

## 14. 工程化知识

- **Plan & Execute 范式**：控制 Context Window 膨胀的核心手段。
- **HITL 授权门禁**：物理阻止大模型冲动写代码。
- **prototypeState 调试切片**：解决静态 Mock 环境下无法物理验证 Loading/Empty/Error 的工业级技巧。
- **Verifier Subagent 模式**：子会话静默跑编译，保护主 Context 记忆纯净。

## 15. 验证和证据

- [x] 页面实际操作与 `prototypeState` 4 种状态物理点击切换演示
- [x] `Verifier Subagent` 静默自测返回 `[PASS]`
- [x] `npm run typecheck` & `npm run build` PASS
- [x] `git log` 显示连续增量 commit

## 16. 课堂成果

1. 包含 `prototypeState` 物理调试切换器与 4 状态分支的 Vue 组件。
2. 干净的主 Context 对话与连续 Git Commit 记录。
3. 跑通 Verifier 静默校验的项目。

## 17. 课后作业

**作业描述**：
为你的组件补充 Error 状态下的“重试”物理动作：点击重新加载时，自动触发 `prototypeState = 'loading'`，1秒后恢复 `prototypeState = 'success'`。

## 18. 通过标准

- [ ] 学员通过 `授权执行 Step X` 口令驱动 Agent 编码。
- [ ] 页面存在可点击切换的 `prototypeState` 4 状态调试切片。
- [ ] 成功派遣 `Verifier Subagent` 完成静默自测与 Git 提交。

## 19. 常见问题

| 问题类型 | 现象 | 处理建议 |
| --- | --- | --- |
| 概念卡点 | 为什么要在页面加切换按钮 | 解释静态 Mock 下白屏和边界死角问题 |
| 操作卡点 | AI 没等授权就写了代码 | 检查 Skill V2 文件配置，重新强调门禁 |
| 记忆卡点 | 主窗口被报错日志刷屏 | 使用 Verifier Subagent 后台跑命令 |

## 20. 课后记录

```text
系统名称：工单管理看板原型
学员角色：运营主管
本课完成内容：使用 /incremental-implementation 完成增量拆解，物理植入 prototypeState 4 状态切换器，派遣 Verifier Subagent 静默自测并 Commit。
修改文件：src/components/WorkOrderBoard.vue, docs/LESSON_04_GUIDE.md
完成交互：4 状态调试切片物理点击切换
验证结果：Verifier Subagent PASS
下一步：第五课 CLAUDE.md 工程护栏与防崩演练
```

## 21. 学员包信息

| 项 | 内容 |
| --- | --- |
| ZIP 文件名 | `lesson-04-starter.zip` |
| 包版本 | v2.0.0-draft |
| 来源 commit 或 tag | main@d57a8e1 |
| SHA256 | 待导出生成 |
| 包含内容 | `.claude/skills/incremental-implementation/`, `docs/LESSON_04_GUIDE.md`, `docs/LESSON_04_TEACHER_PLAN.md` |
| 排除内容 | `node_modules`, `.git` |
| 恢复方法 | 解压后 `npm install` |

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
