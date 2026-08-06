# 第五课教案 (V2 闭环版)：建立不会轻易失控的项目

## 1. 课程元数据

| 项 | 内容 |
| --- | --- |
| 课次 | 第 5 课 |
| 课程名称 | 建立不会轻易失控的项目 |
| 面向角色 | 运营主管 / 业务部门一级主管 |
| 建议时长 | 90 分钟 |
| 前置课程 | 第 4 课：把大需求拆成连续的小成功 |
| 对应路线图 | `docs/COURSE_ROADMAP.md` 第 5 课 |
| 仓库内容状态 (Repository Status) | CANDIDATE (候选课程内容就绪，处于待试讲验证状态) |
| 教学验证状态 (Teaching Status) | PILOT_PENDING (草稿V2 / 待合入 / 待试讲) |
| 课程负责人 | 待指定 |
| 最后复核日期 | 2026-08-06 |
| 学员包版本 | 待生成 |
| 来源 commit 或 tag | 待生成 / main@b592db8 |

## 2. 本课定位

说明：
- **解决问题**：解决业务主管在开发原型过程中，由于 Agent 擅自安装未知 npm 包、改坏 Vite 配置文件、修改敏感环境变量或在长对话后产生幻觉，导致项目物理崩溃且无法恢复的典型卡点。
- **核心主概念**：**工程 Harness (`CLAUDE.md`) 与 三分记忆模型**——用最高工程规约限制 Agent 修改边界，用三分记忆与 Git 节点提供安全的 S/L 存档与基线还原保障。
- **上下游关系**：承接 L4 输出的稳定代码与切片计划；输出项目最高工程规约 `CLAUDE.md`、更新的 `docs/PROJECT_STATE.md` 与包含安全防御能力的项目基线。

## 3. 核心目标

1. 掌握 **工程 Harness (`CLAUDE.md`)** 的配置与作用，锁定包管理器与框架规约。
2. 掌握 **三分记忆模型**（工作记忆：聊天窗口；外部长期记忆：`PROJECT_STATE.md`；版本证据：Git Commit 节点）。
3. 掌握 **【解药 1：环境脱幻与独立工具箱】**，强制 Agent 在编写前先探查项目真实文件与依赖版本。
4. 掌握 **S/L 存档与基线还原机制**，在 Agent 产生严重幻觉或改坏配置时，一键放弃错误尝试并还原回最近的稳定 Git Commit。
5. 掌握 **项目安全巡检与基线存档**，完成 `docs/PROJECT_STATE.md` 更新与稳定 Git Commit。

## 4. 可见成果

- 根目录下生效的项目最高工程规约文件 `CLAUDE.md`。
- 一次成功拦截 Agent 越界修改/擅自安装依赖的防错体验记录。
- 一次演示成功的 S/L 存档基线还原记录。
- 更新后的 `docs/PROJECT_STATE.md` 与 Git 稳定 Commit。

## 5. 本课明确不做

- 不在 90 分钟课堂内深入讲解复杂的 npm 依赖冲突算法或 Vite 插件底层细节。
- 不要求主管编写 Shell 脚本（所有巡检工具均为物理预置）。
- 不在 `CLAUDE.md` 中写入过于繁琐的正则微调规则（聚焦 4 大核心防错红线）。

## 6. 教师准备

| 项 | 状态 | 说明 |
| --- | --- | --- |
| 教师演示环境 | 待完成 | Node.js, Claude Code CLI, Vite 运行环境 |
| 示例项目或页面 | 待完成 | 包含前 4 课产物的稳定项目 |
| 教师标准答案 | 待完成 / 待试讲验证 | 包含完整规约的 `CLAUDE.md` 样例 |

## 7. 学员准备

- 完成前四课，项目起手可运行 `npm run dev`。
- 确认处于干净基线提交（Task 0 检查）。

## 8. 课堂时间安排与关键暂停点 (Pause Points)

| 时段 | 时长 | 内容 | 关键暂停点 (Pause Point) |
| --- | --- | --- | --- |
| 成果展示与 Task 0 基线检查 | 10 分钟 | 检查 L4 资产，演示无护栏越界崩溃 vs CLAUDE.md 防御对比 | **[ Pause Point 1 ]**：提问学员“为什么聊天窗口里的规则不能代替 CLAUDE.md 文件？” |
| 教师演示 | 15 分钟 | 演示配置 `CLAUDE.md`，模拟发送越界指令，演示护栏拦截与一键还原 | **[ Pause Point 2 ]**：检查学员是否观察到 `CLAUDE.md` 触发拦截提示 |
| 学员实操 Task 1 & Task 2 | 40 分钟 | 配置 `CLAUDE.md` 护栏，测试越界指令拦截，体验 S/L 存档还原机制 | **[ Pause Point 3 ]**：确认学员成功触发了护栏拦截，并完成了基线还原测试 |
| 工程巡检与基线存档 | 15 分钟 | 运行 `verify-student-project.ps1` 全量巡检，更新 PROJECT_STATE.md 与 Git Commit | **[ Pause Point 4 ]**：确认学员输出了 `[PASS]` 并完成了 Git Commit |
| 总结与 Exit Ticket | 10 分钟 | 总结三分记忆模型与 S/L 存档机制，完成 Exit Ticket 问答 | **[ Pause Point 5 ]**：退出门禁答题与下节课 Bug 排错预告 |

## 9. 业务场景

- **使用者**：业务部门主管。
- **当前问题**：主管在与 AI 长时间对话后，AI 开始凭空假设包版本，擅自安装未授权依赖，改坏配置文件导致白屏。
- **工作场景**：工程防错与项目护栏配置。
- **处理动作**：通过配置 `CLAUDE.md` 锁定修改边界，利用三分记忆与 Git 节点保障项目永不失控。

## 10. 教师演示步骤

### 步骤 0：Task 0 基线校验
- 输入：“请检查当前 Git 状态及 docs/PROJECT_STATE.md 是否就绪。”

### 步骤 1：CLAUDE.md 规约生成演示
- 输入：“请读取 package.json 与工程结构，在项目根目录生成最高工程规约文件 CLAUDE.md。”

### 步骤 2：护栏拦截与基线还原演示
- 输入 1（越界测试）：“请帮我安装 echarts 并修改 vite.config.ts。”
- 输入 2（基线还原）：“放弃刚才的所有修改，恢复到最近的稳定 Git Commit 基线。”

### 步骤 3：巡检与存档演示
- 执行 `powershell -ExecutionPolicy Bypass -File .\scripts\verify-student-project.ps1`，更新 `docs/PROJECT_STATE.md` 并执行 `git commit`。

## 11. 学员实操任务

- **Task 0**：基线断言。
- **任务 1**：生成并落盘最高工程规约 `CLAUDE.md`。
- **任务 2**：测试护栏拦截，体验 S/L 存档还原机制。
- **任务 3**：工程巡检、更新 `docs/PROJECT_STATE.md` 与稳定 Commit。

## 12. 推荐提示词

```text
请读取当前项目的 package.json 与工程结构，在项目根目录生成最高工程规约文件 CLAUDE.md。
要求明确：
1. 本项目使用 Vue 3 + Element Plus，包管理器限定为 npm；
2. 严禁擅自 install 未在需求卡中确认的第三方 npm 包；
3. 严禁修改 vite.config.ts 与基础路由配置；
4. 每次修改代码前必须主动读取相关文件，禁止凭空臆测上下文。
```

## 13. Skill 使用

| 项 | 内容 |
| --- | --- |
| Skill 名称 | `teaching-lesson-plan` / 工程护栏规约 |
| Skill 用途 | 配置工程最高规约与防错拦截 |

## 14. 工程化知识

- **工程 Harness**：使用 `CLAUDE.md` 约束 LLM 修改范围。
- **三分记忆模型**：工作记忆、外部长期记忆与版本证据分类管理。
- **环境脱幻**：强迫 Agent 探查真实环境而非凭借假设输出。

## 15. 验证和证据

- [ ] 根目录 `CLAUDE.md` 物理存在且包含 4 大防错红线
- [ ] 模拟越界指令成功触发护栏拦截提示
- [ ] `powershell -ExecutionPolicy Bypass -File .\scripts\verify-student-project.ps1` 返回 `[PASS]`
- [ ] Git Log 显示 `feat: setup CLAUDE.md project harness and verify clean baseline`

## 16. 课堂成果

1. 最高工程规约文件 `CLAUDE.md`。
2. 更新后的 `docs/PROJECT_STATE.md`。
3. 经过工程巡检与护栏加固的稳定项目基线。

## 17. 课后作业

检查部门内其他原型的根目录，为其补充 `CLAUDE.md` 工程护栏文件。

## 18. 通过标准

- [ ] `CLAUDE.md` 正确生效，巡检脚本返回 `[PASS]`，Git 提交完成。

## 19. 常见误区与处理 (Misconceptions Table)

| 常见误区 | 现象描述 | 纠偏与处理方案 |
| --- | --- | --- |
| 误区 1：依赖 AI 的自律 | 以为在对话里交代过“别乱改配置”就足够 | 强调聊天窗口记忆会随 Context 满溢而蒸发，必须落盘 `CLAUDE.md` |
| 误区 2：在污染的项目上死磕 | 项目改坏后不断发 Prompt 让 AI 尝试修复 | 强调 S/L 存档机制，果断一键还原回最近的稳定 Git Commit |
| 误区 3：忽视环境真实探查 | 允许 AI 凭借猜测假设依赖版本与文件路径 | 激活【解药 1：环境脱幻】，要求 AI 修改前必须主动读取真实文件 |

## 20. 课后记录

```text
系统名称：待填
完成内容：第五课工程护栏与三分记忆落盘
修改文件：CLAUDE.md, docs/PROJECT_STATE.md
```

## 21. 学员包信息

| 项 | 内容 |
| --- | --- |
| 包版本 | 待生成 |

## 22. 教师复盘

```text
实际授课时间：待填
```

## 附录 A：教师与维护者内部细节 (Teacher & Maintainer Appendix)

### A1. CLAUDE.md 最高规约效力原理
- Claude Code CLI 启动与每次交互时，会自动检索根目录下的 `CLAUDE.md`（及 `.claude/rules/`）。
- 该文件在 Prompt 层级属于系统级/全局级 System Instructions，优先级高于对话中的单次 User 提示词。

### A2. 三分记忆模型与 Context 爆炸防御
- 当对话 Token 接近 Context Window 上限（如 200k tokens）时，注意力机制会出现遗忘与注意力漂移（Needle In A Haystack 衰减）。
- 外部长期记忆文件（Markdown）与 Git Commit 节点是防御 Context 爆炸的最物理手段。
