# AI 业务原型训练营 - 学员起点包 (Lesson 01)

欢迎使用 **AI 业务原型制作训练营** 第一课起点工程！

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
* `docs/LESSON_01_GUIDE.md`：学员唯一指南与 Task 1–4 实操合一卡
* `docs/assets/lesson-01/lesson-flow.png`：第一课全景架构图
* `src/`：Vue 3 + TypeScript 源代码
