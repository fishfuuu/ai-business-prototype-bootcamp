# 快速开始：第一课学员启动指引

欢迎来到 **AI 业务原型制作训练营**！

---

## 🛠️ 首次启动两步走

为了保证你的环境能够顺利运行，请按照以下步骤启动：

### 第一步：检查 Node.js 环境与安装依赖（仅首次或 node_modules 不存在时）
* 本项目推荐使用 **Node.js 20.x**（或 18.x / 22.x LTS 版本）。
* 首次解压压缩包后，请在项目根目录打开 **Windows PowerShell**，运行以下命令安装所需依赖：
  ```powershell
  npm ci
  ```
  *(如果终端提示 `npm install`，亦可运行 `npm install` 完成依赖下载)*

### 第二步：双击启动项目
* 依赖安装完成后，在文件资源管理器中直接**双击运行 `start-project.bat`**（或在 PowerShell 中运行 `.\start-project.bat`）。
* 启动成功后，浏览器会自动打开 `http://127.0.0.1:8888`（你的本地试衣镜）。

---

## 📖 学员核心文档导航

* **唯一指南与实操卡**：请阅读 [docs/LESSON_01_GUIDE.md](file:///docs/LESSON_01_GUIDE.md)。

---

## 🚀 开始使用 Claude Code

在 PowerShell 中启动 `claude`（或你所使用的 AI 助手），然后按照 [docs/LESSON_01_GUIDE.md](file:///docs/LESSON_01_GUIDE.md) 中的 Task 1 开始输入你的业务需求！

如果有任何疑问，可随时在 PowerShell 运行一键验证脚本进行检查：
```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\verify-student-project.ps1
```
