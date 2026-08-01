# CLAUDE.md - 项目指导与文档分工规范

本文件是 Claude Code 在本项目中执行任务时的顶级指引。

---

## 📖 文档阅读分工规则

为了防止不同角色和任务读取混淆，请严格遵守以下收敛分工：

### 1. 人类学员进行页面制作时
* **必读文件（学员唯一文档）**：
  * [docs/LESSON_01_GUIDE.md](./docs/LESSON_01_GUIDE.md)（学员指南：知识概念与 Task 1–4 实操合一）

### 2. Claude Code 执行页面代码修改任务时
* **重点读取**：
  * `CLAUDE.md`（本文件）
  * `DESIGN.md`（设计规范）
  * `docs/COMPONENT_CATALOG.md`（通用组件目录）
  * 任务相关的具体源码文件（如 `src/router/index.ts`）

### 3. 进行课程设计、教师备课、复盘或维护时
* **必须查阅**：
  * `docs/LESSON_01_TEACHER_PLAN.md`（教师唯一教案）
  * `docs/LESSON_01_GUIDE.md`（学员指南合一卡）
  * `docs/COURSE_ROADMAP.md`（路线图）
  * `docs/LESSON_TEMPLATE.md`（课程模板）
  * `docs/STUDENT_PACKAGE_SPEC.md`（学员包规范）

---

## 🛠️ 项目工程约束

1. **零破坏原则**：不得无故修改已通过验证的核心组件或 `DESIGN.md` 设计规范。
2. **样式约束**：页面开发优先复用现有全局样式与 Semantic Class，不新增 ad-hoc 颜色体系。
3. **验证约束**：任何代码修改完成后，必须运行 TypeScript 类型检查与页面构建校验。
