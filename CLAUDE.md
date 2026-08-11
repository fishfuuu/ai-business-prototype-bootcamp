# 项目全局工作守则与治理规范 (CLAUDE.md)

> 本文档是 Claude Code 在母仓库工作时的**安全与工程治理守则**。无论是开发课程、编写脚本还是修改工程代码，都必须严格遵守本文档的约束。

---

## 1. 人类学员与教师阅读分工

| 角色 | 推荐阅读路径 | 说明 |
| --- | --- | --- |
| **人类学员** | [docs/LESSON_01_GUIDE.md](file:///d:/AILearning/docs/LESSON_01_GUIDE.md) | **学员端唯一合一卡**，融合基础概念与 Task 1–4 实操指引。 |
| **教师 / 助教** | [docs/LESSON_01_TEACHER_PLAN.md](file:///d:/AILearning/docs/LESSON_01_TEACHER_PLAN.md) | **教师端唯一教案**，课程参数（班型、时长、助教接管、教案结构）以已锁定的 UIC / 冻结设计 / 已批准路线图与模板为权威，本文件不硬编码旧默认。 |
| **工程维护者** | [docs/COURSE_ROADMAP.md](file:///d:/AILearning/docs/COURSE_ROADMAP.md) | 课程路线图与工程双轨交付规范。 |

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
* 修改或新增页面时，必须先查阅 [docs/COMPONENT_CATALOG.md](file:///d:/AILearning/docs/COMPONENT_CATALOG.md) 与 [DESIGN.md](file:///d:/AILearning/DESIGN.md)。
* 优先复用 `KpiCard`、`FilterPanel`、`DataTable`、`StatusTag` 等现有通用组件，不得随手编写内联样式或乱加孤立颜色。

### 2.6 Git 禁止破坏性操作
* 未经明确书面授权，绝对禁止执行 `git push --force`、`git rebase` 抹去历史、或者随意删除无备份分支。
* 确保每次 commit 前运行 `git diff --check`，不允许产生行尾多余空格或冲突标记。

### 2.7 学员包导出规则
* 导出学员包必须通过 [scripts/export-student-package.ps1](file:///d:/AILearning/scripts/export-student-package.ps1) 脚本进行。
* 学员包必须遵守 [docs/STUDENT_PACKAGE_SPEC.md](file:///d:/AILearning/docs/STUDENT_PACKAGE_SPEC.md) 白名单，不得将教师教案、路线图或测试脚本打包进学员 ZIP。

### 2.8 部门不可 Agent 化红线清册 (DEPARTMENT_REDLINES)
* 必须严格遵守 [docs/DEPARTMENT_REDLINES.md](file:///d:/AILearning/docs/DEPARTMENT_REDLINES.md) 中规定的安全红线禁区。
* 上述红线属于**指导性约束（guidance）**：以文档、提示词与流程检查点约束 Agent 行为，不得冒充运行时硬控制（runtime hard control）。本仓库不声明存在 HOOK_REFUSE_* 或 HOOK_LOCK_* 等未实现的运行时拦截机制。
* 涉及银行资金转账、法律合同签署或未脱敏敏感数据导出的请求，Agent 必须停止并报告，不得继续执行；具体拦截能力是否实现，以代码与脚本实际状态为准，不得虚构。
* 确定性算术（如 [src/utils/calculator.ts](file:///d:/AILearning/src/utils/calculator.ts) 中的 `calculateTotal()`）应保持确定性实现，不得剥离给 LLM 概率生成；这是工程约束，不是已部署的运行时锁。

### 2.9 验证和完成标准
* `scripts/verify-project.ps1` 是**遗留母仓库维护检查**，用于工程维护场景，不作为课堂/业务通过证明，也不代表课程能力已实现。
* 代码变更应通过 `npm run typecheck` 与 `npm run build` 验证；不得以“100% 通过”等绝对化措辞宣称验证结果，实际结果以真实运行输出为准。
* 课程材料（教案、指南、学员包）的验收以已锁定的 acceptance rubric 与协议为准，不以 verify-project.ps1 结果代替。
