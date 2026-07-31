# AI Business Prototype Training 协作规范

## 1. 仓库定位

本仓库是企业内部 AI 业务原型培训的教师课程母仓库。

仓库用于保存：

- 稳定的培训底座
- 各节课程文档
- 通用组件和设计规范
- 教师标准示例
- 课程起点与完成状态
- 培训方法和验收标准

本仓库不是所有学员共同提交作业的仓库。

各主管在课程中创建的部门业务原型，应放在独立学员仓库中，不直接合并进本仓库的 `main`。

## 2. 仓库可见性

仓库必须保持私有。

原因：

- 包含企业内部培训方法
- 包含原财务项目的只读参考副本
- 包含内部设计规范和实现参考
- 可能逐步沉淀内部业务案例

未经仓库负责人明确批准，不得将仓库改为公开。

## 3. 分支职责

### main

`main` 只保存：

- 已验证
- 可教学
- 文档完整
- 可以交付给下一位主管使用

的稳定课程内容。

除首次远程仓库初始化外，后续课程开发不得直接在 `main` 上进行。

### 课程分支

每一节课程使用独立分支：

```text
course/lesson-01-<topic>
course/lesson-02-<topic>
course/lesson-03-<topic>
```

示例：

```text
course/lesson-01-business-prototype
course/lesson-02-requirement-clarification
course/lesson-03-page-iteration
```

### 文档分支

只修改培训文档时使用：

```text
docs/<topic>
```

示例：

```text
docs/update-course-collaboration
docs/improve-lesson-01-guide
```

### 修复分支

修复底座错误时使用：

```text
fix/<topic>
```

示例：

```text
fix/chart-mobile-overflow
fix/start-script-error
```

不得使用含义不清的分支名：

```text
test
temp
new
update
work
```

## 4. 标准协作流程

开始任务前：

```powershell
git switch main
git pull --ff-only origin main
git status
```

从最新 `main` 创建工作分支：

```powershell
git switch -c course/lesson-XX-topic
```

完成修改后执行：

```powershell
npm run typecheck
npm run build
powershell -ExecutionPolicy Bypass -File .\scripts\verify-project.ps1
```

检查修改：

```powershell
git diff --check
git status
git diff --stat
```

提交：

```powershell
git add <明确的文件>
git commit -m "<type>: <description>"
```

推送工作分支：

```powershell
git push -u origin <branch-name>
```

随后在GitHub创建Pull Request，经过审查后合并到 `main`。

## 5. Pull Request要求

每个Pull Request必须说明：

- 本次课程或修改的目标
- 修改了哪些文件
- 学员将学到什么
- 哪些内容明确不做
- 是否修改通用组件
- 是否修改设计规范
- 类型检查结果
- 正式构建结果
- 页面或交互验证结果
- 是否使用真实数据或真实接口

合并前必须满足：

- `npm run typecheck`通过
- `npm run build`通过
- `verify-project.ps1`通过
- 没有真实API、Token、密码或数据库配置
- 没有修改 `references/`
- 没有修改原财务项目
- 相关课程文档已同步更新
- 页面修改符合根目录 `DESIGN.md`

## 6. 课程标签

课程标签用于保存明确的教学状态。

命名规则：

```text
lesson-XX-start
lesson-XX-complete
```

含义：

- `lesson-XX-start`：该节课开始前，学员应拥有的状态
- `lesson-XX-complete`：该节课教师标准完成状态

现有标签：

```text
lesson-01-start
```

标签发布后原则上不得移动、覆盖或删除。

新标签必须使用annotated tag：

```powershell
git tag -a lesson-XX-complete -m "Complete lesson XX: <topic>"
git push origin lesson-XX-complete
```

创建和推送标签必须获得仓库负责人的明确授权。

## 7. 学员项目隔离

不同主管的实际业务原型不得直接进入课程母仓库 `main`。

建议为每位主管创建独立仓库：

```text
ai-prototype-operations
ai-prototype-procurement
ai-prototype-finance
ai-prototype-hr
```

或者：

```text
ai-prototype-<department>-<person>
```

课程母仓库只保留：

- 通用教学内容
- 通用示例
- 标准答案
- 可复用组件
- 课程过程文档

部门专属页面、业务数据和学员作业进入独立仓库。

## 8. 受保护内容

禁止修改：

```text
references/
```

禁止修改或写入：

```text
C:\Users\Administrator\Desktop\财务经营分析系统
```

禁止提交：

- `.env`
- Token
- 密码
- 密钥
- 数据库连接
- 真实客户信息
- 真实员工信息
- 真实经营数据
- 内部账号
- 生产接口地址

所有培训数据必须为虚构模拟数据。

## 9. 设计协作

根目录：

```text
DESIGN.md
```

是培训项目的设计执行规范。

设计修改必须：

1. 先说明修改原因
2. 对照上游财务项目设计规范
3. 更新 `DESIGN.md`
4. 更新受影响组件或页面
5. 在组件展示页验证
6. 通过类型检查和正式构建

禁止在单个页面中另建一套颜色、字号、圆角和阴影体系。

## 10. 通用组件协作

创建新页面前，先阅读：

```text
docs/COMPONENT_CATALOG.md
```

优先复用现有组件。

修改通用组件时，Pull Request必须说明：

- 修改原因
- 受影响页面
- Props或插槽是否变化
- 是否保持向后兼容
- 组件展示页验证结果

单个页面的业务口径不得写入通用组件。

## 11. Commit规范

推荐类型：

```text
feat:
fix:
docs:
refactor:
test:
chore:
```

示例：

```text
feat: add lesson 02 requirement clarification exercise
docs: improve lesson 01 teaching guide
fix: prevent chart overflow on mobile
refactor: simplify prototype filter layout
chore: update repository collaboration guidance
```

一次提交应围绕一个明确目标。

不要提交：

```text
update
changes
fix stuff
final
new version
```

## 12. 禁止的Git操作

未经仓库负责人明确授权，禁止：

```text
git push --force
git push --force-with-lease
git reset --hard
git clean -fd
git clean -fdx
git rebase main
git tag -f
git branch -D
```

禁止重写已经推送到远程的课程历史和课程标签。

## 13. 冲突处理

发现以下情况时停止操作并报告：

- 远程 `main` 包含未知提交
- 本地工作区不干净
- `references/`发生变化
- 课程标签指向发生变化
- 远程仓库不是私有仓库
- 构建或验证失败
- 修改范围超出当前任务
- 发现真实数据或敏感配置

不得通过强制推送或删除文件解决冲突。
