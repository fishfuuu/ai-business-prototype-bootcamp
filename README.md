# AI 业务原型训练营 (母仓库)

这是面向主管 AI 原型制作训练营的私有教师与维护者母仓库。

## 📚 第一课教学材料说明

- **[docs/LESSON_01_GUIDE.md](./docs/LESSON_01_GUIDE.md)**：第一课学员实操工作手册（融合知识卡、观察、实操与复述）。
- **[docs/LESSON_01_AI_BASICS.md](./docs/LESSON_01_AI_BASICS.md)**：第一课 AI 基础概念材料（解析 LLM、Tools、Agent、ReAct 与 Workflow）。
- **[docs/LESSON_01_TEACHER_PLAN.md](./docs/LESSON_01_TEACHER_PLAN.md)**：教师备课与控场指南（含 5 个连续演示暂停提问点）。
- **[docs/COURSE_ROADMAP.md](./docs/COURSE_ROADMAP.md)**：10 课整体路线图与双轨交付说明。

## 🛠️ 项目维护与导出

* **全量项目自测**：
  ```powershell
  powershell -ExecutionPolicy Bypass -File .\scripts\verify-project.ps1
  ```
* **导出学员起点包**：
  ```powershell
  powershell -ExecutionPolicy Bypass -File .\scripts\export-student-package.ps1 -CourseState "lesson-01-start" -Version "v0.1.5" -SourceRef "HEAD"
  ```
