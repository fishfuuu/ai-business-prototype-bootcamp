# 从这里开始

欢迎使用 **AI 业务原型培训** 学员项目包。

本压缩包是可独立运行的课程起点，**不需要** Git 或 GitHub。

---

## 1. 你将得到什么

- 可运行的 Vue 3 业务原型脚手架
- 统一设计规范与通用组件
- 第一课操作指南
- 学员版项目说明与验证脚本

本包**不是**生产系统，不连接真实业务数据。

---

## 2. 环境要求

- Node.js **20.19.0** 或更高
- npm（随 Node.js 安装）
- Windows 推荐使用 PowerShell

检查版本：

```powershell
node -v
npm -v
```

---

## 3. 安装与启动（约 5 分钟）

1. 将本 ZIP **完整解压**到本地目录（路径中尽量避免仅含特殊符号的深层路径）。
2. 进入解压后的**项目根目录**（包含 `package.json` 的那一层）。
3. 安装依赖：

```powershell
npm ci
```

若 `npm ci` 不可用，可使用：

```powershell
npm install
```

4. 启动开发服务：

- 双击 `start-project.bat`，或
- 执行：

```powershell
npm run dev
```

5. 浏览器打开：

```text
http://127.0.0.1:8888/#/
```

组件展示页：

```text
http://127.0.0.1:8888/#/components
```

---

## 4. 建议阅读顺序

1. `START_HERE.md`（本文件）
2. `README.md`
3. `DESIGN.md`
4. `docs/COMPONENT_CATALOG.md`
5. `docs/LESSON_01_GUIDE.md`
6. 使用 Claude Code 时阅读 `CLAUDE.md`

---

## 5. 完成修改后如何自检

在项目根目录执行：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\verify-student-project.ps1
```

或分别执行：

```powershell
npm run typecheck
npm run build
```

两项均通过，且能打开页面，再进入课堂讨论或提交作业（按教师要求）。

---

## 6. 安全提醒

- 只使用虚构模拟数据
- 不要写入真实 Token、密码、客户或经营数据
- 不要创建或提交 `.env` 中的真实密钥
- 本包不包含教师参考目录与私有仓库历史

---

## 7. 需要帮助时

优先检查：

1. Node.js 版本是否满足要求
2. 是否在**项目根目录**执行命令
3. `npm ci` / `npm install` 是否成功
4. 端口 `8888` 是否被占用

仍无法解决时，将报错全文发给课程教师或助教。
