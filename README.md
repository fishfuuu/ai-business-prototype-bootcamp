# AI 业务原型训练营 (母仓库)

这是面向主管 AI 原型制作训练营的私有教师与维护者母仓库。

## 📚 第一课收敛文档说明 (仅 2 份核心文档)

- **[docs/LESSON_01_GUIDE.md](./docs/LESSON_01_GUIDE.md)**：第一课学员指南（学员唯一文档：概念认知 + 实操卡合一）。
- **[docs/LESSON_01_TEACHER_PLAN.md](./docs/LESSON_01_TEACHER_PLAN.md)**：教师备课与控场指南（教师唯一文档：含目标、90分钟时间表、5个暂停点话术与熔断纪律）。
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
