# AI 业务原型训练营 (母仓库)

面向主管 AI 原型制作训练营的私有教师与维护者母仓库。

## 课程文档

- [lessons/LESSON_01_GUIDE_V4.md](lessons/LESSON_01_GUIDE_V4.md)：第一课学员指南（概念认知 + 实操卡合一）
- [lessons/LESSON_01_TEACHER_PLAN_V4.md](lessons/LESSON_01_TEACHER_PLAN_V4.md)：教师教案与控场指南
- [lessons/COURSE_ROADMAP_V4.md](lessons/COURSE_ROADMAP_V4.md)：10 课路线图与双轨交付说明
- [lessons/V4_10_LESSON_FROZEN_BASELINE.md](lessons/V4_10_LESSON_FROZEN_BASELINE.md)：V4 十课冻结基线
- [GLOSSARY.md](GLOSSARY.md)：课程术语表
- [DESIGN.md](DESIGN.md)：设计执行规范
- [CLAUDE.md](CLAUDE.md)：AI agent 工程治理守则

## 学习资源

### 内部

- [.claude/skills/incremental-implementation/SKILL.md](.claude/skills/incremental-implementation/SKILL.md)：增量实施与 Plan 状态机
- [.claude/skills/diagnosing-bugs/SKILL.md](.claude/skills/diagnosing-bugs/SKILL.md)：有界排错

### 外部

- [MCP 开放标准](https://modelcontextprotocol.io)：Anthropic Model Context Protocol 官方说明
- [ReAct 论文](https://arxiv.org/abs/2202.03629)：Yao et al., ReAct 范式学术原著

## 仓库定位

本仓库是企业内部 AI 业务原型培训的教师课程母仓库，保存：

- 稳定的培训底座
- 各节课程文档（lessons/ 目录下的 V4 文件）
- 通用组件和设计规范
- 教师标准示例
- 培训方法和验收标准

本仓库不是学员共同提交作业的仓库。各主管的部门业务原型放在独立学员仓库，不直接合并进 `main`。

仓库必须保持私有。未经仓库负责人明确批准，不得改为公开。

## 分支职责

### main

只保存已验证、可教学、文档完整、可交付的稳定课程内容。除首次远程仓库初始化外，后续课程开发不得直接在 `main` 上进行。

### 课程分支

```text
course/lesson-01-<topic>
course/lesson-02-<topic>
```

### 文档分支

```text
docs/<topic>
```

### 修复分支

```text
fix/<topic>
```

不得使用含义不清的分支名（test、temp、new、update、work）。

## 标准协作流程

```powershell
# 开始任务前
git switch main
git pull --ff-only origin main
git status

# 创建工作分支
git switch -c course/lesson-XX-topic

# 完成修改后
npm run typecheck
npm run build

# 检查并提交
git diff --check
git status
git add <明确的文件>
git commit -m "<type>: <description>"

# 推送
git push -u origin <branch-name>
```

随后在 GitHub 创建 Pull Request，审查后合并到 `main`。

## Pull Request 要求

每个 PR 必须说明：

- 本次课程或修改的目标
- 修改了哪些文件
- 学员将学到什么
- 哪些内容明确不做
- 是否修改通用组件或设计规范
- 类型检查和构建结果
- 页面或交互验证结果
- 是否使用真实数据或真实接口

合并前必须满足：

- `npm run typecheck` 通过
- `npm run build` 通过
- 没有真实 API、Token、密码或数据库配置
- 没有修改 `references/`
- 相关课程文档已同步更新
- 页面修改符合 `DESIGN.md`

## 课程标签

```text
lesson-XX-start    # 该节课开始前的状态
lesson-XX-complete # 教师标准完成状态
```

标签发布后不得移动、覆盖或删除。新标签必须使用 annotated tag：

```powershell
git tag -a lesson-XX-complete -m "Complete lesson XX: <topic>"
git push origin lesson-XX-complete
```

## 学员项目隔离

各主管的实际业务原型不进入课程母仓库 `main`。建议为每位主管创建独立仓库（如 `ai-prototype-operations`）。

课程母仓库只保留通用教学内容、通用示例、标准答案、可复用组件和课程过程文档。

## Commit 规范

推荐类型：`feat:` `fix:` `docs:` `refactor:` `test:` `chore:`

一次提交围绕一个明确目标。不要提交含义不清的消息（update、changes、fix stuff、final）。

## Git 安全

未经仓库负责人明确授权，禁止：

```text
git push --force
git push --force-with-lease
git reset --hard
git clean -fd
git clean -fdx
git rebase main
git tag -f
git branch -D
```

禁止重写已推送的课程历史和标签。

## 受保护内容

禁止修改 `references/`。禁止提交 `.env`、Token、密码、密钥、数据库连接、真实客户/员工/经营数据、内部账号或生产接口地址。所有培训数据必须为虚构模拟数据。

## 导出学员起点包

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\export-student-package.ps1 -CourseState "lesson-01-start" -Version "v0.1.5" -SourceRef "HEAD"
```

## 冲突处理

发现以下情况时停止操作并报告：远程 `main` 有未知提交、工作区不干净、`references/` 发生变化、课程标签指向变化、远程仓库不是私有、构建或验证失败、修改范围超出任务、发现真实数据或敏感配置。不得通过强制推送或删除文件解决冲突。