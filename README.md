# AI Business Prototype Starter

企业业务系统原型培训底座。

该项目帮助业务人员通过 Claude Code 创建可运行的企业业务页面，并学习如何把业务问题转化为系统原型。

## 当前能力

项目已经提供：

- Vue 3 + TypeScript + Vite
- Vue Router
- Element Plus
- Tailwind CSS和SCSS
- Pinia
- ECharts
- 简化企业系统布局
- 培训起始页
- 通用业务组件
- 通用图表组件
- 组件展示页
- 与财务项目对齐的设计规范

项目没有连接：

- 真实API
- 数据库
- 用户系统
- 权限系统
- 真实业务数据
- AI模型服务

## 环境要求

- Node.js 20.19.0或更高
- npm
- Windows PowerShell或命令提示符

当前验证环境：

- Node.js v24.15.0
- npm 11.12.1

## 安装

首次使用时执行：

```powershell
cd D:\AILearning
npm install
```

## 启动

双击：

`start-project.bat`

或执行：

```powershell
cd D:\AILearning
npm run dev
```

默认地址：

```text
http://127.0.0.1:8888
```

培训起始页：

```text
http://127.0.0.1:8888/#/
```

组件展示页：

```text
http://127.0.0.1:8888/#/components
```

## 项目验证

执行：

```powershell
cd D:\AILearning
powershell -ExecutionPolicy Bypass -File .\scripts\verify-project.ps1
```

也可以分别执行：

```powershell
npm run typecheck
npm run build
```

## 重要文档

### CLAUDE.md

Claude Code在本项目中的工作规则、安全边界和完成标准。

### DESIGN.md

培训项目的权威设计执行规范。

### docs/COMPONENT_CATALOG.md

现有通用组件的功能和使用方法。

### docs/LESSON_01_GUIDE.md

第一课的学员极简操作流程、需求模板和验收标准。

### docs/LESSON_01_TEACHER_PLAN.md

第一课的教师备课指南、教学时间安排、微型演示步骤与卡点救援预案。

### docs/主管 AI 原型制作训练营.md

原始10课课程设计稿，作为历史来源保留。

### docs/COURSE_ROADMAP.md

当前正式课程路线图、课程顺序、目标、成果和维护规则。

### docs/LESSON_TEMPLATE.md

第2至第10课编写时使用的统一课程模板。

### docs/STUDENT_PACKAGE_SPEC.md

标准学员 ZIP 包的包含范围、排除范围、版本、校验和发放规则。

### references/

从原财务项目归档的只读参考文件。

该目录不得修改，也不得作为运行代码直接导入。

## 目录结构

```text
D:\AILearning
├── docs
│   ├── COMPONENT_CATALOG.md
│   ├── COURSE_ROADMAP.md
│   ├── DESIGN_ALIGNMENT_AUDIT.md
│   ├── DESIGN_ALIGNMENT_DECISIONS.md
│   ├── DESIGN_ALIGNMENT_FINAL_REPORT.md
│   ├── LESSON_01_GUIDE.md
│   ├── LESSON_TEMPLATE.md
│   ├── STUDENT_PACKAGE_SPEC.md
│   └── 主管 AI 原型制作训练营.md
├── references
├── scripts
│   ├── export-student-package.ps1
│   └── verify-project.ps1
├── student-package
│   └── templates
├── src
│   ├── assets
│   ├── components
│   │   ├── business
│   │   ├── charts
│   │   ├── layout
│   │   └── MonthRangePicker
│   ├── composables
│   ├── layouts
│   ├── mock-data
│   ├── pages
│   ├── plugins
│   ├── router
│   └── store
├── CLAUDE.md
├── DESIGN.md
├── README.md
├── start-project.bat
├── package.json
└── vite.config.ts
```

## 导出学员ZIP包

说明：

- 只有教师和课程维护者使用。
- 普通学员不需要执行。
- 导出必须来自明确 Git ref。
- 生成产物位于 `artifacts/student-packages` 并被 Git 忽略。

示例：

```powershell
powershell -ExecutionPolicy Bypass -File `
  .\scripts\export-student-package.ps1 `
  -CourseState "lesson-01-start" `
  -Version "v0.1.0" `
  -SourceRef "HEAD"
```

说明：

- 不会提交或推送。
- 不会自动覆盖同名包。
- 需要按 `docs/STUDENT_PACKAGE_SPEC.md` 验证后才能发放。
- 本地生成的 ZIP 仅为候选产物，在负责人批准前不是正式发布包。

## 仓库协作

本仓库是私有的教师课程母仓库。

稳定、已经验证并可用于教学的课程内容合并到：

```text
main
```

每一节课程使用独立分支开发：

```text
course/lesson-XX-<topic>
```

只修改文档时使用：

```text
docs/<topic>
```

修复培训底座时使用：

```text
fix/<topic>
```

标准流程：

```text
从main创建分支
→ 完成课程或修改
→ typecheck
→ build
→ verify-project
→ 推送工作分支
→ 创建Pull Request
→ 审查
→ 合并main
```

不同主管的实际业务原型和作业应放在独立仓库，不直接合并到本课程仓库的 `main`。

详细协作规则：

`CONTRIBUTING.md`

Pull Request提交时应使用：

`.github/pull_request_template.md`

## 使用原则

1. 先描述业务问题，再讨论页面功能。
2. 第一版只做小型、可运行、可讨论的原型。
3. 优先复用现有组件。
4. 所有数据使用虚构模拟数据。
5. 不接入真实API、账号、数据库或密钥。
6. 页面视觉必须遵循 `DESIGN.md`。
7. 每次代码修改后执行类型检查和构建。
8. Git操作必须获得用户明确授权。

## 安全边界

原财务项目：

```text
C:\Users\Administrator\Desktop\财务经营分析系统
```

该目录不属于本培训项目，禁止修改。

`references/` 仅用于查看原始实现，禁止修改。
