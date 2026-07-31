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

第一课的操作流程、需求模板和验收标准。

### references/

从原财务项目归档的只读参考文件。

该目录不得修改，也不得作为运行代码直接导入。

## 目录结构

```text
D:\AILearning
├── docs
│   ├── COMPONENT_CATALOG.md
│   ├── DESIGN_ALIGNMENT_AUDIT.md
│   ├── DESIGN_ALIGNMENT_DECISIONS.md
│   ├── DESIGN_ALIGNMENT_FINAL_REPORT.md
│   └── LESSON_01_GUIDE.md
├── references
├── scripts
│   └── verify-project.ps1
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
