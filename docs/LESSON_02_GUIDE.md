# 第二课学员操作指南 — 用参考图与设计规则做出像样的页面：Token、多模态与视觉重构

> 💡 **本课的核心思想只有一句话：**  
> **不要用口头凭空描述 UI，用参考图多模态提取、DESIGN.md 规则与 Git 节点进行锚定防护。**

---

## 一、 本课背景、底层原理与学习目标

### 1.1 业务背景与真实痛点
在非技术主管用 AI 制作界面时，最常见的问题是“界面土气、排版混乱、色彩冲突”，或者“AI 每改一次就把原本好看的样式改乱”。口头用自然语言描述“要高端大气上档次”极易产生理解偏差。同时，许多主管不知道 Token 的物理开销与记忆限制，随着对话变长，AI 容易产生样式遗忘与规则幻觉。

### 1.2 宏观受控闭环
本课的核心工程机制，是将 UI 视觉设计纳入一条**“参考图多模态提取 ➔ Token 上下文管理 ➔ DESIGN.md 规则映射 ➔ CSS Tokens 规范约束 ➔ Git 节点双存档 ➔ Discard Changes 安全撤销”**的受控闭环中：
1. **多模态视觉提取与 Token 控制**：直接上传视觉参考截图，利用多模态能力提取 DOM 结构，并控制 Context Window Token 开销。
2. **视觉 Harness (`DESIGN.md`) 与字典映射**：通过根目录 [`DESIGN.md`](file:///d:/AILearning/DESIGN.md) 物理定义视觉设计规范（如低饱和度颜色、阴影、圆角与 Tailwind/CSS Tokens），AI 在生成样式前强制读取。
3. **CSS Tokens 规范**：使用标准小写 CSS 变量（如 `var(--art-primary)`，绝对禁止大写 `var(--art-PrimaryBad)`），与 `src/assets/styles/tailwind.css` 运行时物理文件进行映射。
4. **安全防护与撤销 (SL 游戏存档大法)**：每次大改前先提交 Git 节点存档（使用 `git commit -m "baseline: ..."`，严禁使用盲目打包命令如 `git commit -a -m` 或丢弃命令 `git restore .`）。一旦改崩，在 VS Code 界面点击 `Discard Changes` 1 秒物理撤销恢复。

### 1.3 核心学习目标
完成本课实操后，你将能够：
1. 掌握使用 Token 物理概念与多模态视觉提取能力，将参考截图转化为结构化 DOM 布局。
2. 掌握使用设计参考图与 [`DESIGN.md`](file:///d:/AILearning/DESIGN.md) 视觉规则包，控制 AI 输出高颜值界面。
3. 理解小写 CSS Tokens (`var(--art-primary)`) 与 `src/assets/styles/tailwind.css` 的设计约束机制与变色业务价值。
4. 掌握 Git 节点安全存档与在 VS Code UI 中使用 `Discard Changes` 撤销物理恢复方法。

---

## 二、 💡 本课核心工程概念卡 (Core Concepts)

### 核心概念 1：Token 与 Context 上下文窗口 (Token & Context Window)
- **硬核工程定义**：大语言模型处理文本与代码时的物理计算单位（约 0.75 个英文单词或半个汉字），以及单次会话可保持注意力的最大 Token 内存上限。
- **底层运作机制**：AI 每次读取文件或生成代码都会消耗 Token；当 Context 窗口积压过多过期 Prompt 时，模型注意力被稀释，引发样式遗忘与规则幻觉。
- **具象业务比喻**：**高考试卷的答题卡与计时器** ⏱️。答题卡格子数有限（Context Window），填满后就写不下了，必须定期清理草稿。
- **IT 沟通场景**：“样式改动需控制 Token 消耗，避免 Context 窗口过大导致 AI 产生规则遗忘。”

### 核心概念 2：多模态视觉提取 (Multimodal Visual Extraction)
- **硬核工程定义**：LLM 联合解析文本与图像像素阵列的多模态能力，将视觉图片中的布局、色彩、字体物理转化为结构化 HTML/CSS 代码的范式。
- **底层运作机制**：AI 分析输入参考图的盒模型 (Box Model) 与栅格排版，将其映射为 Vue 模板代码与预设的样式类目。
- **具象业务比喻**：**建筑设计师的现场测绘拍照** 📸。看到一套优质精装房，拍照后直接在图纸上按比例复刻其硬装结构。
- **IT 沟通场景**：“我们利用多模态视觉提取能力，直接从参考图中提取了工单看板的响应式布局。”

### 核心概念 3：视觉 Harness (`DESIGN.md`) 与 `tailwind.css` 字典映射
- **硬核工程定义**：在工程根目录落盘的视觉规范契约，结合 `src/assets/styles/tailwind.css` 中的运行时 CSS 变量映射规则。
- **底层运作机制**：在 `DESIGN.md` 中声明 `--art-primary: oklch(0.7 0.23 260)` 令牌名与具体色值；组件通过 `var(--art-primary)` 引用 Token。
- **具象业务比喻**：**乐高积木的标准规格颗粒与品牌字典** 🧱。如果有一天公司升级品牌主色，程序员不需要修改几十个 Vue 页面，只需在 `tailwind.css` 修改一处 Token 色值，全站瞬间自动变色！
- **IT 沟通场景**：“界面样式严格受扣于 `DESIGN.md` 视觉 Harness，消除写死 Hex 硬编码。”

### 核心概念 4：Git 节点安全防护与 `Discard Changes` (SL 游戏存档大法)
- **硬核工程定义**：在关键开发节点通过显式 Git 提交冻结镜像，并利用 GUI 工具进行文件级别的无损变更撤销。
- **底层运作机制**：`git commit` 生成不可变哈希点；`git diff` 计算当前工作区与上次快照的行级差异；`git restore / discard` 将工作区指针重置到上一个 Commit 点。
- **具象业务比喻**：**代码界的 SL 游戏存档大法 (Save & Load)** 🎮：
  - **`Git Commit`** 相当于 **【节点手动存档 Save】**：锁住稳定版本；
  - **`Git Diff`** 相当于 **【装备属性对比】**：监视 AI 动作，防止误删代码；
  - **`Git Discard`** 相当于 **【一键读档 Load】**：AI 改崩代码，在 VS Code 界面点击 1 秒无损还原！
- **IT 沟通场景**：“每次重大样式重构前均建立 Git 稳定节点，支持基于 `Discard Changes` 的安全物理回滚。”

---

## 三、 🔄 视觉重构闭环线框图 (Visual Refactoring Wireframe)

```text
+-----------------------------------------------------------------------------------+
|                              第二课 视觉重构四步闭环                               |
|                                                                                   |
|  [Task 1: 结构提取] -> [Task 2: 规范映射] -> [Task 3: 裁决与授权] -> [Task 4: 微调与验收]  |
|                                                                                   |
|  - 多模态看布局           - 物理点开 DESIGN.md   - Keep / Omit        - 试衣镜对比      |
|  - 100% 过滤杂色          - 优先 --art-* Token   - Modify 3项         - 脚本验证 PASS   |
|  - 业务能力迁移           - 字典映射不硬编码      - Git 节点1存档 Save  - Git 节点2完结存档 |
+-----------------------------------------------------------------------------------+
```

---

## 四、 🛠️ 课堂实操与自学导引任务清单

### Task 0: 检查环境与物理阅读 DESIGN.md 规范

#### ⚡ 极速操作步骤
1. 打开 VS Code 左侧文件树，双击点开根目录下的 [`DESIGN.md`](file:///d:/AILearning/DESIGN.md)，确认包含小写 CSS Tokens（如 `var(--art-primary)`）。
2. 在终端启动开发服务器，并打开试衣镜 `http://127.0.0.1:5173/`：
   ```powershell
   npm run dev
   ```

#### 💡 独立自学原理解析
> **规范说明 vs 运行时定义**  
> `DESIGN.md` 是项目的视觉规范说明书 (Design Harness)；而真正被浏览器加载的物理 CSS 变量保存在 `src/assets/styles/tailwind.css` 中。组件统一使用小写 `var(--art-primary)`，写成大写 `var(--art-PrimaryBad)` 会导致浏览器无法解析。

---

### Task 1: 视觉结构提取卡 (多模态提取)

#### ⚡ 极速操作步骤
1. 确认工程中存放的参考图卡文件：
   - `docs/assets/lesson-02/ref-monitor-decision.png` (或 `ref-task-workflow.png` / `ref-operation-tool.png`)
2. 在 CLI 中发送多模态结构提取提示词模板：
   ```text
   请读取项目中的参考图卡文件：docs/assets/lesson-02/ref-monitor-decision.png

   请帮我分析这张参考图的视觉结构，并列出：
   1. 首屏的整体布局（如顶部 KPI 栏、左右双栏、三段式卡片流）
   2. 页面中视觉最醒目的核心模块（主视觉焦点）
   3. 次要信息与操作区域的排布规律

   注意：请只提取布局和结构，不要使用参考图中的任何背景颜色、字体或杂乱样式。先不要修改代码，只输出分析结果。
   ```

#### 🔍 代码 Before vs After 视觉对比
```diff
  /* src/components/WorkOrderBoard.vue */
- background-color: #ff0000; /* 硬编码高饱和度红 */
+ background-color: var(--art-primary); /* 引入 DESIGN.md CSS Token */
+ border-radius: var(--art-radius-md);
```

---

### Task 2: 设计规范映射卡 (查字典映射)

#### ⚡ 极速操作步骤
1. 在 CLI 中发送设计规范映射提示词模板：
   ```text
   现在，请戴上眼睛读取项目中的设计规范文件：
   - DESIGN.md
   - docs/COMPONENT_CATALOG.md

   请将 Task 1 提取的结构与 DESIGN.md 进行映射，说明：
   1. 页面背景、卡片容器与文字颜色如何映射到已有的 --art-* 变量
   2. 间距与圆角如何符合 8/12/16/24px 规范
   3. 哪些区域可以直接复用现有组件库中的结构（如 ElCard, ElTag, ElButton）

   注意：不得虚构不存在的 Token，不得新建样式库。先不要修改文件，只输出映射方案。
   ```

---

### Task 3: Keep / Modify 裁决矩阵与安全重构

#### ⚡ 极速操作步骤
1. **🎮 节点 1 存档动作**：在 PowerShell 终端运行显式提交指令：
   ```powershell
   git status
   git add .
   git diff --cached
   git commit -m "baseline: complete lesson 1 prototype"
   ```
2. **发送主管裁决与授权提示词模板**：
   ```text
   针对第二课页面美化，我的裁决如下：

   1. Keep (保留并冻结现有业务内容)：
   【第一课工单看板中所有显示的工单 ID、标题、状态与 Mock 数据】

   2. Omit from Reference (参考图忽略项)：
   【参考图中不需要复制的无关装饰线条或多余小图标】

   3. Remove from Current Page (现有页面清理项)：
   【第一课页面中粗糙无用的临时占位文本】

   4. Modify (明确进行的 3 项视觉改进)：
   (1) 重构首屏视觉层级，突出核心区域
   (2) 优化卡片布局与 16/24px 间距
   (3) 提升关键状态与核心操作按钮的显眼度

   请复述你理解的重构范围。在得到我回复“同意方案，请开始修改代码”前，不要修改文件。
   ```
3. 收到 AI 复述无误后，发送盖章口令：
   ```text
   同意方案，请开始修改代码
   ```
4. **🚨 监视与一键读档救急 (Diff & Discard)**：
   - 在 VS Code 左侧第 3 个 Git 分支视图中监视红绿修改，确保未误删代码。
   - 一旦改崩，右键点击该文件，选择 **Discard Changes (放弃更改)** 1 秒物理撤销恢复！

---

### Task 4: 视觉对比与证据验收

#### ⚡ 极速操作步骤
1. 刷新 `http://127.0.0.1:5173/` 试衣镜，对比重构前后效果。
2. （可选）发送指令 `请使用 /design-lint 审计当前页面是否包含硬编码杂色` 获取合规报告。
3. **🎮 节点 2 完结存档动作**：在终端运行完结存档与快照指令：
   ```powershell
   git add .
   git commit -m "style: complete lesson 2 visual refactor"
   git log --oneline -5
   ```
4. 确认截屏与快照保存至 `local-backups/lesson-02-evidence/lesson-02-screenshot.png`。

---

## 五、 💡 常见概念误区与正确理解 (Mindset Transformation)

| 常见误区 (Misconception) | 正确硬核理解 (Correct Engineering Reality) | 如何纠偏与护栏防护 (Remedy & Guardrails) |
| :--- | :--- | :--- |
| **误区 1：“用自然语言口头描述‘要高端大气’ AI 就能做对”** | 自然语言极度模糊，AI 会随机套用高饱和度颜色，导致界面像上世纪产物。 | 挂载 [`DESIGN.md`](file:///d:/AILearning/DESIGN.md) 视觉 Harness，配合多模态参考图进行事实锚定。 |
| **误区 2：“在 CSS 变量中使用大写命名如 `var(--art-PrimaryBad)`”** | CSS 变量严格区分大小写，写错大小写会导致变量失效，降级为透明或白屏。 | 强制统一使用小写 CSS Tokens (`var(--art-primary)`) 与 `tailwind.css` 规则。 |
| **误区 3：“样式改坏了，直接运行 `git restore .` 清空”** | `git restore .` 是破坏性极其严重的无差别清空命令，容易误删刚写的优质代码。 | 在 VS Code 管理视图中点击 `Discard Changes`，实现单个文件的无损撤销。 |
| **误区 4：“习惯使用 `git commit -a -m` 一键提交”** | `git commit -a -m` 会跳过 Git 暂存区检查，将未测试的临时文件打包入库。 | 严格按目录显式提交 `git add src/`，保持 Git 节点纯净。 |

---

## 六、 ❓ 常见操作报错与 Troubleshooting 指南

| 报错/异常现象 | 物理原因 | 解决与纠偏方案 |
| :--- | :--- | :--- |
| 页面组件所有背景颜色全白失效 | CSS 变量写成了大写 `var(--art-PrimaryBad)` | 检查 CSS 样式，更正为小写 `var(--art-primary)`。 |
| 改坏页面后找不到撤销按钮 | 未在 VS Code 源代码管理面板中操作 | 打开 VS Code 左侧第 3 个 Git 分支图标，右键文件选择 `Discard Changes`。 |

---

## 七、 📝 巩固与退场测试题库 (4 题精选)

### 阶段 1：课堂退场盖章测试 (Exit Ticket)
1. **[概念填空题]** 在 `DESIGN.md` 与 `tailwind.css` 映射中，`--art-primary` 是 ____________，`oklch(...)` 是 ____________；这种映射关系的业务价值是 ____________。
2. **[多模态选择题]** 直接通过上传参考 UI 截图来提取 DOM 布局的技术属于 AI 的哪种能力？ ____________。
   - A. 纯文本 Prompting
   - B. 多模态视觉提取 (Multimodal Visual Extraction)
   - C. 数据库查询
   - D. 编译校验
3. **[IT 沟通场景题]** 当你需要向设计师或前端工程师解释如何保持 UI 风格一致时，你应该怎么说？
   - **参考回答**：“我们通过 `DESIGN.md` 视觉 Harness 统一管理 CSS Tokens，保证色彩、间距与圆角确定性，全站一处改色即可全局生效。”

---

### 阶段 2：课后自学拓展思考题 (Self-Study Extension)
4. **[原理思考题]** 简述 Git SL 存档中 `Git Commit` (Save)、`Git Diff` (对比) 与 `Git Discard` (Load) 的物理对应关系。
