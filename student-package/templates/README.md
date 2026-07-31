# AI Business Prototype Starter（学员包）

企业业务系统原型培训的**学员可运行项目包**。

本包帮助业务人员通过 Claude Code 创建可运行的企业业务页面，并学习如何把业务问题转化为系统原型。

> 说明：本目录来自教师导出的标准 ZIP。你**不需要** GitHub 即可完成本课练习。

## 当前能力

项目已经提供：

- Vue 3 + TypeScript + Vite
- Vue Router
- Element Plus
- Tailwind CSS 和 SCSS
- Pinia
- ECharts
- 简化企业系统布局
- 培训起始页
- 通用业务组件
- 通用图表组件
- 组件展示页
- 培训设计规范

项目没有连接：

- 真实 API
- 数据库
- 用户系统
- 权限系统
- 真实业务数据
- AI 模型服务

## 环境要求

- Node.js 20.19.0 或更高
- npm
- Windows PowerShell 或命令提示符

## 安装

在项目根目录（含 `package.json`）执行：

```powershell
npm ci
```

或：

```powershell
npm install
```

## 启动

双击：

`start-project.bat`

或执行：

```powershell
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
powershell -ExecutionPolicy Bypass -File .\scripts\verify-student-project.ps1
```

也可以分别执行：

```powershell
npm run typecheck
npm run build
```

## 重要文档

| 文件 | 用途 |
|------|------|
| `START_HERE.md` | 首次打开请先读 |
| `CLAUDE.md` | 使用 Claude Code 时的规则与边界 |
| `DESIGN.md` | 页面与组件设计规范 |
| `docs/COMPONENT_CATALOG.md` | 通用组件说明 |
| `docs/LESSON_01_GUIDE.md` | 第一课流程与验收 |
| `VERSION.txt` | 本包课程状态、版本与来源提交 |

## 目录结构（节选）

```text
.
├── docs
│   ├── COMPONENT_CATALOG.md
│   └── LESSON_01_GUIDE.md
├── scripts
│   └── verify-student-project.ps1
├── src
│   ├── components
│   ├── layouts
│   ├── pages
│   └── ...
├── CLAUDE.md
├── DESIGN.md
├── README.md
├── START_HERE.md
├── VERSION.txt
├── PACKAGE_MANIFEST.txt
├── SHA256SUMS.txt
├── start-project.bat
├── package.json
└── vite.config.ts
```

## 使用原则

1. 先描述业务问题，再讨论页面功能。
2. 第一版只做小型、可运行、可讨论的原型。
3. 优先复用现有组件。
4. 所有数据使用虚构模拟数据。
5. 不接入真实 API、账号、数据库或密钥。
6. 页面视觉必须遵循 `DESIGN.md`。
7. 每次代码修改后执行类型检查和构建。

## 安全边界

- 禁止使用真实客户、员工或经营数据。
- 禁止写入 Token、密码、密钥或数据库连接。
- 本包不包含教师侧 `references/` 与协作治理文档。

## 包版本信息

详见根目录：

- `VERSION.txt` — 课程状态、版本、Source Commit
- `PACKAGE_MANIFEST.txt` — 文件清单
- `SHA256SUMS.txt` — 包内文件校验

如需确认 ZIP 是否被篡改，请向教师索取与 ZIP 配套的 `.sha256` 文件并核对。
