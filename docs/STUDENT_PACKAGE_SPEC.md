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
3. 不包含教师治理文件、只读参考副本、Git 历史或敏感配置。
4. 可追溯到明确的 Git commit 或 tag。
5. 可用版本号、清单与 SHA256 复核完整性。

ZIP 包是**教学交付物**，不是仓库的替代品。

---

## 2. 包含范围（白名单）

正式学员包**只允许**包含以下类别内容（具体路径以导出脚本白名单为准）：

| 类别 | 说明 |
|------|------|
| 可运行脚手架 | `package.json`、`package-lock.json`、`vite.config.ts`、`tsconfig.json`、`index.html`、`start-project.bat` |
| 运行时代码 | `src/**`（不含 `node_modules`、`dist`） |
| 设计规范 | 根目录 `DESIGN.md` |
| 学员可读课程文档 | 当前课程状态所需文档，例如第一课起点包中的 `docs/COMPONENT_CATALOG.md`、`docs/LESSON_01_GUIDE.md` |
| 学员版说明 | 由模板生成的 `START_HERE.md`、`README.md`、`CLAUDE.md`、`.gitignore` |
| 学员验证脚本 | `scripts/verify-student-project.ps1` |
| 包元数据 | `VERSION.txt`、`PACKAGE_MANIFEST.txt`、`SHA256SUMS.txt` |

原则：

- 使用**白名单复制**，不整仓打包。
- 必须替换为学员版 `README.md`、`CLAUDE.md` 与验证脚本。
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
| `.git/` 与 Git 历史 | 学员包为快照交付，不含仓库历史 |
| `node_modules/` | 由学员本地 `npm ci` / `npm install` 生成 |
| `dist/` | 构建产物，由学员本地构建 |
| `.env` / `.env.*`（除示例说明外） | 敏感配置 |
| 真实 API、Token、密码、客户或经营数据 | 安全边界 |
| 原财务项目绝对路径与教师私有仓库 URL | 避免误用与信息泄露 |
| `artifacts/` | 导出产物本身 |
| `student-package/` 源模板目录 | 模板属于教师导出机制，不直接发给学员（内容已合并进学员版文件） |
| 导出脚本 `scripts/export-student-package.ps1` | 仅教师使用 |

---

## 4. 版本与命名

### 4.1 Course State

课程状态标识当前教学起点或完成点，例如：

```text
lesson-01-start
lesson-01-complete
```

须与课程标签或已批准的交付状态一致，不得随意编造。

### 4.2 Version

包版本独立于 `package.json` 的应用版本，使用语义化标签，例如：

```text
v0.1.0
```

规则：

- 首次候选测试可用 `v0.1.0`，**不得**在未完成验证与负责人批准前称为正式发布包。
- 已发放包不得覆盖；内容修订必须提升版本号。
- 测试失败后的重试应提升版本，或经确认删除**尚未发放**的失败产物后再导出同名版本。

### 4.3 产物命名

```text
ai-business-prototype-<course-state>-<version>
```

示例：

```text
ai-business-prototype-lesson-01-start-v0.1.0
```

生成文件：

```text
artifacts/student-packages/ai-business-prototype-lesson-01-start-v0.1.0.zip
artifacts/student-packages/ai-business-prototype-lesson-01-start-v0.1.0.zip.sha256
```

ZIP 内部必须有且仅有一个顶层根目录，名称与上式一致。

---

## 5. 导出规则

1. **仅教师与课程维护者**执行导出。
2. 导出必须来自**明确 Git ref**（commit SHA、tag 或已解析的 `HEAD` 等），且工作区在导出提交上应可复现。
3. 必须使用：

   ```powershell
   powershell -ExecutionPolicy Bypass -File `
     .\scripts\export-student-package.ps1 `
     -CourseState "lesson-01-start" `
     -Version "v0.1.0" `
     -SourceRef "HEAD"
   ```

4. 禁止手工压缩教师仓库目录作为正式学员包。
5. 导出脚本：
   - 使用白名单从指定 ref 提取内容（推荐 `git archive`）
   - 替换学员版文档与验证脚本
   - 写入 `VERSION.txt`、`PACKAGE_MANIFEST.txt`、`SHA256SUMS.txt`
   - 生成 ZIP 与外部 `.sha256`
   - **不**提交、**不**推送
   - **不**静默覆盖已存在的同名 ZIP / `.sha256`
6. 产物目录 `artifacts/student-packages/` 必须被 Git 忽略，**不得**提交 ZIP 或校验文件。

---

## 6. 包内元数据

### 6.1 VERSION.txt

至少包含：

- Package Name
- Course State
- Version
- Source Ref
- Source Commit（完整 SHA）
- Export Timestamp（UTC 或本地明确时区）
- Generator（脚本名称）

### 6.2 PACKAGE_MANIFEST.txt

- 列出包内全部相对路径（相对 ZIP 顶层根目录）
- 一行一个路径，排序稳定
- 必须与解压后实际文件列表一致

### 6.3 SHA256SUMS.txt

- 对包内每个文件（除 `SHA256SUMS.txt` 自身外）记录 SHA256
- 发放前后可用工具或脚本复核

### 6.4 外部 .sha256

- 对 ZIP 文件本身的 SHA256
- 与 ZIP 同目录，文件名 `*.zip.sha256`

---

## 7. 发放前验证（强制）

在声称“可发放”之前，必须在**仓库外的独立临时目录**完成：

1. 解压 ZIP，确认唯一顶层根目录且名称正确。
2. 检查必备文件存在。
3. 检查禁止路径不存在（`references/`、`.git/`、教师治理文件、`.env` 等）。
4. `VERSION.txt` 中 Source Commit 与导出所用 commit 一致。
5. `PACKAGE_MANIFEST.txt` 与实际文件列表一致。
6. 包内文件 SHA256 与 `SHA256SUMS.txt` 一致。
7. ZIP 文件 SHA256 与外部 `.sha256` 一致。
8. 扫描不得出现原财务项目路径、教师私有仓库 URL、真实密钥模式。
9. 在解压根目录执行 `npm ci`（或课程批准的等价安装命令）。
10. 执行：

    ```powershell
    powershell -ExecutionPolicy Bypass -File .\scripts\verify-student-project.ps1
    ```

11. typecheck 与 production build 通过，且 `dist\index.html` 存在。
12. 确认无真实 API / `.env`。
13. 清理临时解压目录；**保留**本地 `artifacts/student-packages` 中的候选产物供检查，但仍忽略于 Git。

未完成以上验证，**不得**声称可发放。

---

## 8. 发放规则

1. 课程负责人批准后方可发放。
2. 正式包必须来自明确 commit 或 tag。
3. 已发放版本不得覆盖；修订提升版本。
4. 不得把教师 README、CLAUDE、`references/`、协作规则发给普通学员。
5. 不得通过 GitHub Release / 公开仓库误传教师母仓库全文。
6. 候选测试包（如本地 `v0.1.0`）在负责人批准前**不是**正式发布包。

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
