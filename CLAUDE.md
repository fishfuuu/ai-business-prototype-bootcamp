# AI Business Prototype Starter

## 1. 项目用途

这是一个企业业务系统原型培训项目。

主要目标是帮助业务人员通过 Claude Code：

- 把真实业务问题转化为系统需求
- 创建可运行的前端业务页面
- 组织页面信息和操作流程
- 复用现有通用组件
- 思考业务页面与 AI 能力的结合方式

本项目不是生产系统，不连接真实业务数据。

## 2. 开始工作前必须阅读

每次开始任务前，依次阅读：

1. `README.md`
2. `DESIGN.md`
3. `docs/COMPONENT_CATALOG.md`
4. 与本次任务直接相关的页面和组件

普通学员进行第一课业务页面制作时，只需阅读：

`docs/LESSON_01_GUIDE.md`

进行第一课课程设计、教师备课、试讲复盘或教学材料维护时，必须阅读：

- `docs/LESSON_01_TEACHER_PLAN.md`
- `docs/LESSON_01_GUIDE.md`
- `docs/COURSE_ROADMAP.md`
- `docs/LESSON_TEMPLATE.md`
- `docs/STUDENT_PACKAGE_SPEC.md`

课程内容规则：

- 不得绕过 `COURSE_ROADMAP` 重新设计 10 课顺序
- 新课程文件必须使用 `LESSON_TEMPLATE`
- 不得把计划中的 Skill 写成已经安装或验证
- 原始课程稿保持只读，不得删除或重写

不得在未检查现有组件的情况下重复创建相同组件。

## 3. 第一课需求确认

第一次创建业务系统时，先确认：

1. 系统名称
2. 主要使用者
3. 当前具体业务问题
4. 首页最重要的信息
5. 用户进入首页后的第一个操作

如果用户已经明确提供，不重复提问。

第一版目标是形成一个可看到、可操作、可讨论的页面，不追求生产级完整度。

## 4. 修改前必须先说明

执行代码修改前，先输出：

- 对需求的理解
- 第一版准备包含哪些内容
- 准备复用哪些现有组件
- 准备修改或新增哪些文件
- 哪些内容本次明确不做

范围得到确认后再实施。

## 5. 技术边界

当前技术栈：

- Vue 3
- TypeScript
- Vite
- Vue Router
- Element Plus
- Tailwind CSS
- SCSS
- Pinia
- ECharts

未经用户明确批准，不得增加新的第三方依赖或技术框架。

当前阶段禁止引入：

- Agent框架
- MCP
- LangChain
- LangGraph
- Dify
- 数据库
- 后端服务
- 用户认证
- 权限系统
- 动态路由
- 消息队列
- 云服务配置

## 6. 安全边界

原财务项目：

`C:\Users\Administrator\Desktop\财务经营分析系统`

该目录永远视为只读，不得修改、移动、删除、格式化或写入文件。

`references/` 是已经归档的原始参考副本，只读，不得修改。

禁止：

- 复制真实 `.env`
- 写入Token、密码、密钥或数据库配置
- 请求真实业务接口
- 使用真实客户、订单、员工或经营数据
- 删除或覆盖用户已有文件
- 执行危险Git命令

## 7. 设计规则

所有页面和组件必须遵循：

`DESIGN.md`

核心要求：

- 新代码使用 `--art-*` Token
- 不新增或使用 `--prototype-*`
- 优先复用现有布局和通用组件
- 遵循统一字号、间距、圆角和图表色板
- 不建立第二套视觉体系
- 不使用大面积渐变、玻璃拟态、发光边框或3D图表

## 8. 现有组件优先

创建页面前，优先检查：

- `KpiCard`
- `FilterPanel`
- `StatusTag`
- `DataTable`
- `ArtEmptyState`
- `MonthRangePicker`
- `SimpleLineChart`
- `SimpleBarChart`
- `SimplePieChart`

完整说明：

`docs/COMPONENT_CATALOG.md`

页面负责业务含义，通用组件负责通用展示和交互。

不得把单个页面的业务字段和计算口径固化进通用组件。

## 9. 页面与数据规则

业务页面可以包含：

- 页面说明
- 筛选条件
- KPI
- 图表
- 明细表格
- 状态和操作

所有数据必须使用虚构模拟数据。

模拟数据必须：

- 明确属于虚构数据
- 不包含个人信息和公司机密
- 与页面业务结构一致
- 不伪装成已经接入真实系统

示例数据优先放在页面内部或 `src/mock-data/`。

## 10. AI能力展示

需要展示AI能力时，必须说明：

- AI读取什么信息
- AI生成什么结果
- 是否需要人工确认
- 是否会执行写入
- 失败时如何处理

模拟AI能力必须标记：

`AI能力演示 · 未连接真实服务`

不要把普通统计、筛选或固定规则包装成AI。

## 11. 修改范围原则

保持每次修改规模小而明确。

未经要求，不得顺手：

- 重构无关代码
- 修改通用组件接口
- 更换依赖版本
- 重做项目架构
- 增加登录或权限
- 接入后端
- 修改设计规范

完成后必须说明：

- 实际修改文件
- 实现内容
- 验证结果
- 尚未实现的部分

## 12. 验证要求

代码修改完成后至少执行：

```powershell
npm run typecheck
npm run build
```

两项均通过后才能声称任务完成。

涉及页面或交互时，再执行：

```powershell
npm run dev
```

并检查目标页面。

不得通过以下方式掩盖错误：

- 关闭严格检查
- 排除出错文件
- 使用 `any` 绕过类型
- 添加忽略注释
- 删除失败功能

## 13. Git与协作规则

本项目已经初始化Git，并连接私有GitHub课程仓库。

默认稳定分支：

```text
main
```

`main` 只保存已经验证、可以正式教学的课程内容。

课程开发必须从最新 `main` 创建独立分支：

```text
course/lesson-XX-<topic>
```

文档修改使用：

```text
docs/<topic>
```

底座修复使用：

```text
fix/<topic>
```

开始修改前应检查：

```powershell
git status
git branch --show-current
```

创建任务分支前应执行：

```powershell
git switch main
git pull --ff-only origin main
```

代码完成后至少执行：

```powershell
npm run typecheck
npm run build
powershell -ExecutionPolicy Bypass -File .\scripts\verify-project.ps1
```

未经用户明确授权，不得：

- 直接向 `main` 推送课程修改
- 合并Pull Request
- 创建、移动或删除课程标签
- 删除本地或远程分支
- 修改远程仓库配置
- 执行强制推送
- 重写已经推送的历史

始终禁止：

```text
git push --force
git push --force-with-lease
git reset --hard
git clean -fd
git clean -fdx
git tag -f
```

完整协作规范见：

`CONTRIBUTING.md`

## 学员包规则

- 学员包必须通过 `scripts/export-student-package.ps1` 导出。
- 禁止手工压缩教师仓库作为正式学员包。
- 学员包使用白名单，不复制完整仓库。
- 学员包必须替换为学员版 README、CLAUDE 和验证脚本。
- 不得导出 `references`、教师治理文档、Git 历史和敏感配置。
- 学员包必须记录 Source Commit 和 SHA256。
- 未完成独立解压验证不得声称可发放。
- ZIP 生成物不得提交 Git。

## 14. 第一版原型完成标准

第一版至少做到：

- 页面可以正常打开
- 页面名称和使用者明确
- 信息结构清楚
- 核心数据可见
- 至少有一个可操作交互
- 使用模拟数据
- 没有真实接口
- 优先复用现有组件
- 类型检查通过
- 正式构建通过

第一版不要求：

- 登录和权限
- 真实数据同步
- 数据库
- 生产部署
- 复杂AI Agent
