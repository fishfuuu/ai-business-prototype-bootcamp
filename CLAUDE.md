# 项目全局工作守则与治理规范 (CLAUDE.md)

> 本文档是 Claude Code 在母仓库工作时的**安全与工程治理守则**。无论是开发课程、编写脚本还是修改工程代码，都必须严格遵守本文档的约束。

---

## 1. 人类学员与教师阅读分工

| 角色 | 推荐阅读路径 | 说明 |
| --- | --- | --- |
| **人类学员** | [lessons/LESSON_01_GUIDE.md](lessons/LESSON_01_GUIDE.md) | **学员端唯一合一卡**，融合基础概念与 Task 1–4 实操指引。 |
| **教师 / 助教** | [lessons/LESSON_01_TEACHER_PLAN.md](lessons/LESSON_01_TEACHER_PLAN.md) | **教师端唯一教案**，课程参数（班型、时长、助教接管、教案结构）以已锁定的 UIC / 冻结设计 / 已批准路线图与模板为权威，本文件不硬编码旧默认。 |
| **工程维护者** | [lessons/COURSE_ROADMAP.md](lessons/COURSE_ROADMAP.md) | 课程路线图与工程双轨交付规范。 |

---

## 2. 核心工程与安全治理守则

### 2.1 references/ 只读边界
* `references/` 目录存放参考资源、素材或第三方源码。
* **绝对只读**：严禁修改、删除或写入 `references/` 目录下的任何文件。

### 2.2 绝对禁止真实敏感信息与真实接口
* 本仓库为培训教学仓库，严禁写入任何生产真实数据、密钥、Token、API Key 或真实后端接口。
* 必须统一使用 Mock Data（前端模拟数据）。

### 2.3 技术与依赖边界
* 前端底层技术栈为：`Vue 3` + `TypeScript` + `Element Plus` + `Vite` + `Pinia` + `Vue Router`。
* 严禁无故引入无关大型框架或第三方冲突依赖；安装或更新包时必须使用 `npm`。

### 2.4 修改前确认门禁与 Workflow
* 在修改代码、重构文件或调整工程配置前，**必须先输出修改方案并等待人类确认**。
* 严禁未经授权静默删除或破坏重构既有工程代码。

### 2.5 组件复用与设计规范
* 修改或新增页面时，必须先查阅 [DESIGN.md](DESIGN.md)。
* 优先复用 `KpiCard`、`FilterPanel`、`DataTable`、`StatusTag` 等现有通用组件，不得随手编写内联样式或乱加孤立颜色。

### 2.6 Git 禁止破坏性操作
* 未经明确书面授权，绝对禁止执行 `git push --force`、`git rebase` 抹去历史、或者随意删除无备份分支。
* 确保每次 commit 前运行 `git diff --check`，不允许产生行尾多余空格或冲突标记。

### 2.7 学员包导出规则
* 导出学员包必须通过 [scripts/export-student-package.ps1](scripts/export-student-package.ps1) 脚本进行。
* 学员包不得将教师教案、路线图或测试脚本打包进学员 ZIP。

### 2.8 验证和完成标准
* 代码变更应通过 `npm run typecheck` 与 `npm run build` 验证；不得以"100% 通过"等绝对化措辞宣称验证结果，实际结果以真实运行输出为准。
* 课程材料（教案、指南、学员包）的验收以已锁定的 acceptance rubric 与协议为准。