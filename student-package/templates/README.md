# AI 业务原型训练营 - 学员起点包（十课全量）

欢迎使用 **AI 业务原型制作训练营** 起点工程！本包包含完整十课学员指南、交互课件、课程路线图与原型工程基座。

---

## ⚡ 首次安装与启动步骤

1. **安装依赖（首次解压必做）**：
   在解压后的项目根目录下打开 Windows PowerShell，运行：
   ```powershell
   npm ci
   ```
2. **启动本地开发服务器与试衣镜**：
   双击 `start-project.bat`（或在 PowerShell 中运行 `.\start-project.bat`），项目将自动启动并在浏览器中预览 `http://127.0.0.1:8888`。

3. **运行自测脚本**：
   ```powershell
   powershell -ExecutionPolicy Bypass -File .\scripts\verify-student-project.ps1
   ```

---

## 📚 目录指南

* `START_HERE.md`：快速开始指引
* `docs/LESSON_01_GUIDE.md` ~ `docs/LESSON_10_GUIDE.md`：十课学员指南
* `docs/COURSE_ROADMAP.md`：学员版课程路线图
* `lessons/html/`：十课交互课件 + 术语表 + 路线图页面（共 12 份 HTML）
* `.claude/skills/` + `.claude/agents/`：课程教学 Skill（grill-me / diagnose / incremental-implementation）与验收子智能体
* `src/`：Vue 3 + TypeScript 源代码