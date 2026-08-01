# 标准学员 ZIP 包规范

本文档定义教师课程母仓库向**无 GitHub 的普通学员**发放标准项目包的范围、版本、校验与发放规则。

适用角色：

- 教师
- 课程维护者
- 课程负责人

普通学员**不需要**阅读或执行本规范中的导出步骤。

---

## 1. 目标

学员 ZIP 包必须满足：

1. 可在本机独立解压后安装依赖并启动。
2. 仅包含当前课程状态所需的运行与学习文件。
3. 不包含教师治理文件、只读参考副本、教师 Git 历史或敏感配置。
4. 可追溯到明确的 Git commit 或 tag。
5. 可用版本号、清单与 SHA256 复核完整性。
6. **运行文件与学员模板全部来自同一个 Source Commit**；当前工作区未提交变化不得进入包。

ZIP 包是**教学交付物**，不是仓库的替代品。双轨交付定位不变：普通学员默认 ZIP，教师/进阶使用私有 GitHub。

---

## 2. 包含范围（白名单）

正式学员包**只允许**包含以下类别内容（具体路径以导出脚本白名单为准）：

| 类别 | 说明 |
|------|------|
| 可运行脚手架 | `package.json`、`package-lock.json`、`vite.config.ts`、`tsconfig.json`、`index.html`、`start-project.bat` |
| 运行时代码 | `src/**`（不含 `node_modules`、`dist`） |
| 可选静态资源 | Source Commit 中若存在 `public/`，则一并纳入 |
| 设计规范 | 根目录 `DESIGN.md` |
| 学员可读课程文档 | 当前课程状态所需文档，例如第一课起点包中的 `docs/COMPONENT_CATALOG.md`、合一卡 `docs/LESSON_01_GUIDE.md` 以及视觉素材图片 `docs/assets/lesson-01/lesson-flow.png`、`docs/assets/lesson-01/page-layout.png`、`docs/assets/lesson-01/component-map.png`、`docs/assets/lesson-01/first-cohort-example.png` |
| 学员版说明 | 由 **Source Commit 中** `student-package/templates/**` 生成的 `START_HERE.md`、`README.md`、`CLAUDE.md`、`.gitignore` |
| 学员验证脚本 | `scripts/verify-student-project.ps1`（同样来自 Source Commit 模板） |
| 包元数据 | `VERSION.txt`、`PACKAGE_MANIFEST.txt`、`SHA256SUMS.txt` |

原则：

- 使用 **git archive + 白名单**，不整仓打包。
- 运行文件与学员模板必须来自**同一 Source Commit**；禁止从当前工作区直接复制模板。
- 必须替换为学员版 `README.md`、`CLAUDE.md` 与验证脚本。
- 最终包内**不得**保留 `student-package/` 目录本身。
- 学员包不依赖教师仓库路径或私有远程地址即可运行。

---

## 3. 排除范围

正式学员包**不得**包含：

| 排除项 | 原因 |
|--------|------|
| `references/` | 原财务项目只读参考，仅教师使用 |
| 教师版 `CLAUDE.md` / `README.md` | 含教师协作与母仓库规则 |
| `CONTRIBUTING.md` | 教师协作规范 |
| 教师 `scripts/verify-project.ps1` | 校验 `references` 与教师必备文件 |
| `docs/COURSE_ROADMAP.md` | 教师课程规划 |
| `docs/LESSON_TEMPLATE.md` | 教师写课模板 |
| `docs/DESIGN_ALIGNMENT_*.md` | 设计对齐过程文档 |
| `docs/主管 AI 原型制作训练营.md` | 原始课程稿，教师保留 |
| `.github/` | PR 模板等治理文件 |
| `.git/` 与教师 Git 历史 | 学员包为快照交付，导出时不含仓库历史 |
| `node_modules/` | 由学员本地 `npm ci` / `npm install` 生成 |
| `dist/`、`.vite/` | 构建产物 |
| `.env` / `.env.*`（允许 `.env.example`） | 敏感配置 |
| `*.pem` / `*.key` / `*.pfx` / `*.p12` / `id_rsa` | 证书与密钥材料 |
| 真实 API、Token、客户或经营数据 | 安全边界 |
| 原财务项目绝对路径与教师私有仓库 URL | 避免误用与信息泄露 |
| `artifacts/` | 导出产物本身 |
| `student-package/` 源模板目录 | 模板内容已合并进学员版文件后不再保留目录 |
| 导出脚本 `scripts/export-student-package.ps1` | 仅教师使用 |

说明：

- 导出的 ZIP **初始**不含 `.git`。
- 学员解压后**可以**自行 `git init` 建立独立仓库；学员验证脚本**不得**因存在 `.git` 而失败。

---

## 4. 版本与命名

### 4.1 Course State

必须匹配：

```text
^lesson-\d{2}-(start|complete)$
```

合法示例：

```text
lesson-01-start
lesson-01-complete
```

非法示例：

```text
lesson-1-start
lesson-01-draft
```

### 4.2 Version

必须匹配：

```text
^v\d+\.\d+\.\d+$
```

合法示例：

```text
v0.1.0
v0.1.1
```

非法示例：

```text
v0.1.0-beta
1.0.0
v1.0
```

规则：

- 候选测试包在负责人批准前**不得**称为正式发布包。
- 已发放包不得覆盖；内容修订必须提升版本号。
- 测试失败后的重试应提升版本，或经确认删除**尚未发放**的失败产物后再导出同名版本。

### 4.3 产物命名

```text
ai-business-prototype-<course-state>-<version>
```

示例：

```text
ai-business-prototype-lesson-01-start-v0.1.1
```

默认输出目录：

```text
artifacts/student-packages/
```

可通过 `-OutputDirectory` 覆盖：

- 未提供：`artifacts\student-packages`（相对仓库根）
- 相对路径：以仓库根为基准解析
- 绝对路径：直接使用

---

## 5. 导出规则

1. **仅教师与课程维护者**执行导出。
2. 导出必须来自**明确 Git ref**（默认 `HEAD`，亦可为 commit / tag）。
3. 必须使用：

   ```powershell
   powershell -ExecutionPolicy Bypass -File `
     .\scripts\export-student-package.ps1 `
     -CourseState "lesson-01-start" `
     -Version "v0.1.1" `
     -SourceRef "HEAD"
   ```

   可选：

   ```powershell
   -OutputDirectory "artifacts\student-packages"
   ```

4. 禁止手工压缩教师仓库目录作为正式学员包。
5. 导出脚本必须：
   - 确认 Git toplevel 等于脚本所在仓库根
   - 使用 `git archive` 从 **Source Commit** 提取运行白名单与 `student-package/templates/**`（以及可选 `public/`）
   - 在临时 snapshot 中组装最终包；**不得**从当前工作区 `Copy-Item` 模板
   - 用 `git cat-file -e "<commit>:<path>"` 证明 Source Commit 中存在必备路径
   - 写入 `VERSION.txt`、`PACKAGE_MANIFEST.txt`、`SHA256SUMS.txt`
   - 执行禁止路径检查与高置信敏感内容扫描
   - 教师专属路径、仓库标识与协作痕迹必须扫描**所有**学员包支持的文本类型（`.md`、`.txt`、`.json`、`.ts`、`.vue`、`.js`、`.scss`、`.css`、`.html`、`.bat`、`.ps1`、`.gitignore`），不仅限于 Markdown 文档；`CONTRIBUTING.md` 字符串规则仅允许 `scripts/verify-student-project.ps1` 作为精确例外（该脚本合法将其列为禁止路径）
   - 生成 ZIP 与外部 `.sha256`
   - **不**提交、**不**推送
   - **不**覆盖已存在的同名 ZIP / `.sha256`
   - 导出失败时：删除本次产生的**任何**部分 ZIP 或部分 `.sha256`（因执行前已确认目标路径不存在，失败时存在的目标文件即属本次产物）；并清理临时目录；**不得**删除执行前已存在的产物
6. 产物目录默认被 Git 忽略，**不得**提交 ZIP 或校验文件。

---

## 6. 包内元数据

### 6.1 VERSION.txt

固定字段（不得写入教师脚本路径或教师规范路径）：

```text
Package: AI Business Prototype Starter
Course State: <CourseState>
Version: <Version>
Source Ref: <SourceRef>
Source Commit: <完整SHA>
Built At UTC: <ISO 8601 UTC>
Git Required: No
Delivery Mode: ZIP learner package
```

不得根据 CourseState 伪造 Source Tag。

### 6.2 PACKAGE_MANIFEST.txt

- 列出包内全部相对路径（相对 ZIP 顶层根目录）
- 一行一个路径，排序稳定
- 必须与解压后实际文件列表一致

### 6.3 SHA256SUMS.txt

- 对包内每个文件（除 `SHA256SUMS.txt` 自身外）记录 SHA256
- 发放前教师侧复核使用；学员验证脚本只要求该文件存在（学员改代码后哈希会变化，不要求持续一致）

### 6.4 外部 .sha256

- 对 ZIP 文件本身的 SHA256
- 与 ZIP 同目录，文件名 `*.zip.sha256`

---

## 7. 发放前验证（强制）

在声称“可发放”之前，必须在**仓库外的独立临时目录**完成：

1. 解压 ZIP，确认唯一顶层根目录且名称正确。
2. 检查必备文件存在（含 `VERSION.txt`、`PACKAGE_MANIFEST.txt`、`SHA256SUMS.txt`）。
3. 检查禁止路径不存在（`references/`、教师治理文件、`.env` 等）。
   注意：学员验证脚本**允许**学员自行创建的 `.git`。
4. `VERSION.txt` 中 Source Commit 与导出所用 commit 一致。
5. `PACKAGE_MANIFEST.txt` 与实际文件列表一致。
6. 包内文件 SHA256 与 `SHA256SUMS.txt` 一致（发放前教师复核）。
7. ZIP 文件 SHA256 与外部 `.sha256` 一致。
8. 高置信扫描：私钥头、`github_pat_` / `ghp_` / `AKIA…` / `sk-…`；教师路径、仓库标识与协作痕迹须覆盖全部支持的文本类型（不仅 Markdown）。
9. 在解压根目录执行 `npm ci`。
10. 执行：

    ```powershell
    powershell -ExecutionPolicy Bypass -File .\scripts\verify-student-project.ps1
    ```

11. typecheck 与 production build 通过，且 `dist\index.html` 存在。
12. 可选：`git init` 后再次执行学员验证，确认仍通过。
13. 清理临时解压目录；**保留**本地候选 ZIP（仍忽略于 Git）。

未完成以上验证，**不得**声称可发放。

---

## 8. 发放规则

1. 课程负责人批准后方可发放。
2. 正式包必须来自明确 commit 或 tag。
3. 已发放版本不得覆盖；修订提升版本。
4. 不得把教师 README、CLAUDE、`references/`、协作规则发给普通学员。
5. 不得通过 GitHub Release / 公开仓库误传教师母仓库全文。
6. 候选测试包在负责人批准前**不是**正式发布包。

---

## 9. 与双轨交付的关系

| 角色 | 交付方式 |
|------|----------|
| 普通学员 | 标准 ZIP 学员包（默认） |
| 进阶 / 教师协作 | 私有 GitHub 与分支流程 |
| 特殊安排 | 本地目录或独立私有学员仓库（负责人指定） |

ZIP 默认面向**不强制安装 Git / 注册 GitHub** 的学员。

---

## 10. 变更本规范

本规范、`scripts/export-student-package.ps1` 与 `student-package/templates/**` 属于受审查源码：

- 在功能分支上修改
- 通过 PR 审查后合并 `main`
- 合并后如影响包内容，下一次正式导出须提升版本并重新验证
