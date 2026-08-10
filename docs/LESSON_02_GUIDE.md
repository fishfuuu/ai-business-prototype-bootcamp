# 第二课学员操作指南 — 用参考图与设计规则做出像样的页面：视觉 Harness (DESIGN.md) 与事实锚定

> 💡 **本课的核心思想只有一句话：**  
> **不要用口头凭空描述 UI，用参考图、DESIGN.md 规则与 Git 节点进行锚定防护。**

---

## 一、 本课背景、底层原理与学习目标

### 1.1 业务背景与真实痛点
在非技术主管用 AI 制作界面时，最常见的问题是“界面土气、排版混乱、色彩冲突”，或者“AI 每改一次就把原本好看的样式改乱”。口头用自然语言描述“要高端大气上档次”极易产生理解偏差。

### 1.2 宏观受控闭环
本课的核心工程机制，是将 UI 视觉设计纳入一条**“视觉参考图输入 ➔ DESIGN.md 规则挂载 ➔ CSS Tokens 规范约束 ➔ Git 节点双存档 ➔ Discard Changes 安全撤销”**的受控闭环中：
1. **视觉 Harness (`DESIGN.md`) 与事实锚定**：通过根目录 [`DESIGN.md`](file:///d:/AILearning/DESIGN.md) 物理定义视觉设计规范（如低饱和度颜色、阴影、圆角与 Tailwind/CSS Tokens），AI 在生成样式前强制读取。
2. **CSS Tokens 规范**：使用标准小写 CSS 变量（如 `var(--art-primary)`，绝对禁止大写 `var(--art-PrimaryBad)`），确保样式主题全局可控。
3. **安全防护与撤销**：每次大改前先提交 Git 节点存档（如 `git commit -m "baseline: ..."`，严禁使用盲目打包命令如 `git commit -a -m` 或丢弃命令 `git restore .`）。一旦改崩，在 VS Code 界面点击 `Discard Changes` 1 秒物理撤销恢复。

### 1.3 核心学习目标
完成本课实操后，你将能够：
1. 掌握使用设计参考图与 [`DESIGN.md`](file:///d:/AILearning/DESIGN.md) 视觉规则包，控制 AI 输出高颜值界面。
2. 理解小写 CSS Tokens (`var(--art-primary)`) 与 `tailwind.css` 的设计约束机制。
3. 掌握 Git 节点安全存档与 VS Code UI 中使用 `Discard Changes` 撤销物理恢复方法。

---

## 二、 💡 本课核心工程概念卡 (Core Concepts)

### 核心概念 1：视觉 Harness (`DESIGN.md`) 与事实锚定 (Fact-Anchored Design)
- **硬核工程定义**：在工程根目录落盘的视觉规范契约，结合设计参考截图作为 AI 生成样式时的物理锚定基准。
- **底层运作机制**：AI 在编辑 `.vue` 组件样式前，强制读取 `DESIGN.md` 中的调色板、字号、间距与圆角 Token。
- **具象业务比喻**：**建筑工程的设计图纸与样板间** 📐。有了图纸和样板间（`DESIGN.md` 与参考图），装修队（AI）就不能随心所欲乱刷墙漆。
- **IT 沟通场景**：“界面样式严格受扣于 `DESIGN.md` 视觉 Harness，保证视觉规范的确定性。”

### 核心概念 2：CSS Tokens 与标准化样式集 (`tailwind.css`)
- **硬核工程定义**：将颜色、阴影、圆角等设计属性抽象为统一的小写 CSS 变量（如 `var(--art-primary)`）与框架层级的 CSS 类目。
- **底层运作机制**：通过在 `index.css` 或 `tailwind.css` 中声明设计 Token，消除组件中写死硬编码十六进制颜色值。
- **具象业务比喻**：**乐高积木的标准规格颗粒** 🧱。所有组件只能使用标准积木块拼接，避免产生畸形异形构件。
- **IT 沟通场景**：“样式采用了全局 CSS Tokens 与 `tailwind.css` 变量规范，确保主题一致且无硬编码。”

### 核心概念 3：Git 节点安全防护与 `Discard Changes` 物理撤销
- **硬核工程定义**：在关键开发节点通过显式 Git 提交冻结镜像，并利用 GUI 工具进行文件级别的无损变更撤销。
- **底层运作机制**：使用 `git commit -m "baseline: ..."` 显式提交；出现非预期修改时，通过 IDE 内部机制执行撤销（在 VS Code 界面点击 `Discard Changes`），严禁使用易丢失代码的 `git restore .` 或 `git commit -a -m`。
- **具象业务比喻**：**单机游戏关卡前的存盘与撤销** 🎮。进入 BOSS 房前存档，打崩了直接读档重来。
- **IT 沟通场景**：“每次重大样式重构前均建立 Git 稳定节点，支持基于 `Discard Changes` 的安全物理回滚。”

---

## 三、 🔄 本课视觉流转模型

```text
===================================================================================
【模式 A：口头凭空描述】(反面案例：无设计图、无 DESIGN.md ➔ 色彩冲突/审美崩溃)

  [口头需求: "高端大气"] ───> ( AI 随机生成样式 ) ───> [ 高饱和度配色 / 布局错乱 ]

===================================================================================
【模式 B：视觉 Harness (DESIGN.md) + 事实锚定】(本课标准范式)

  [输入参考截图 + DESIGN.md 规范]
                │
                ▼
  [CSS Tokens 校验] ───> ( 必须使用 var(--art-primary) 小写变量 )
                │
                ▼
  [生成受控样式组件] ───> [ 浏览器 127.0.0.1 试衣镜实时预览 ]
                                    │
                         ┌──────────┴──────────┐
                         ▼                     ▼
  [ 满意: 提交 git commit 节点存档 ]   [ 改崩: 点击 Discard Changes 1秒撤销 ]
===================================================================================
```

---

## 四、 🛠️ 课堂实操与自学导引任务清单

### Task 0: 检查环境与准备 DESIGN.md 规范

#### ⚡ 极速操作步骤
1. 打开工程根目录下的 [`DESIGN.md`](file:///d:/AILearning/DESIGN.md)，确认包含小写 CSS Tokens（如 `var(--art-primary)`）。
2. 在终端启动开发服务器：
   ```powershell
   npm run dev
   ```

#### 💡 独立自学原理解析
> **为什么要使用小写 CSS 变量？**  
> CSS 规范对变量名称区分大小写，`var(--art-primary)` 是标准写法，写成大写 `var(--art-PrimaryBad)` 会导致浏览器无法解析，呈现无样式白屏。

---

### Task 1: 上传参考图并唤醒设计重构

#### ⚡ 极速操作步骤
1. 将视觉参考图放在工程目录下。
2. 在 CLI 中下发设计重构指令：
   ```text
   参照 DESIGN.md 中的设计规范与参考图，重构 WorkOrderBoard.vue 页面样式，使用 var(--art-primary) 调色板。
   ```

#### 🔍 代码 Before vs After 视觉对比
```diff
  /* src/components/WorkOrderBoard.vue */
- background-color: #ff0000; /* 硬编码高饱和度红 */
+ background-color: var(--art-primary); /* 引入 DESIGN.md CSS Token */
+ border-radius: var(--art-radius-md);
```

---

### Task 2: 建立 Git 稳定节点 1

#### ⚡ 极速操作步骤
1. 在终端运行显式提交命令：
   ```powershell
   git add src/
   git commit -m "baseline: 建立第二课视觉样式基线节点1"
   ```

#### 💡 独立自学原理解析
> **为什么不能使用 `git commit -a -m`？**  
> `git commit -a -m` 会盲目打包所有修改（包括未测试的脏代码和临时文件）。显式 `git add` 指定受控目录，才能保证每一个 Git 节点的纯净。

---

### Task 3: 演练样式改崩与 `Discard Changes` 撤销恢复

#### ⚡ 极速操作步骤
1. 故意让 AI 尝试修改页面布局（例如改坏导航栏）。
2. 在 VS Code 源代码管理面板中，右键点击改坏的文件，选择 `Discard Changes` 恢复干净状态。

#### 💡 独立自学原理解析
> **为什么不用 `git restore .`？**  
> 命令行运行 `git restore .` 会瞬间清空所有工作区未提交修改，误操作时无法恢复。在 VS Code 界面点击 `Discard Changes` 可以精确针对单个文件物理撤销，安全且可视化。

---

## 五、 💡 常见概念误区与正确理解 (Mindset Transformation)

| 常见误区 (Misconception) | 正确硬核理解 (Correct Engineering Reality) | 如何纠偏与护栏防护 (Remedy & Guardrails) |
| :--- | :--- | :--- |
| **误区 1：“用自然语言口头描述‘要高端大气’ AI 就能做对”** | 自然语言极度模糊，AI 会随机套用高饱和度颜色，导致界面像上世纪产物。 | 挂载 [`DESIGN.md`](file:///d:/AILearning/DESIGN.md) 视觉 Harness，配合参考图进行事实锚定。 |
| **误区 2：“在 CSS 变量中使用大写命名如 `var(--art-PrimaryBad)`”** | CSS 变量严格区分大小写，写错大小写会导致变量失效，降级为透明或白屏。 | 强制统一使用小写 CSS Tokens (`var(--art-primary)`) 与 `tailwind.css` 规则。 |
| **误区 3：“样式改坏了，直接运行 `git restore .` 清空”** | `git restore .` 是破坏性极其严重的无差别清空命令，容易误删刚写的优质代码。 | 在 VS Code 管理视图中点击 `Discard Changes`，实现单个文件的无损撤销。 |
| **误区 4：“习惯使用 `git git commit -a -m` 一键提交”** | `git commit -a -m` 会跳过 Git 暂存区检查，将未测试的临时文件打包入库。 | 严格按目录显式提交 `git add src/`，保持 Git 节点纯净。 |

---

## 六、 ❓ 常见操作报错与 Troubleshooting 指南

| 报错/异常现象 | 物理原因 | 解决与纠偏方案 |
| :--- | :--- | :--- |
| 页面组件所有背景颜色全白失效 | CSS 变量写成了大写 `var(--art-PrimaryBad)` | 检查 CSS 样式，更正为小写 `var(--art-primary)`。 |
| 改坏页面后找不到撤销按钮 | 未在 VS Code 源代码管理面板中操作 | 打开 VS Code 左侧第 3 个 Git 分支图标，右键文件选择 `Discard Changes`。 |

---

## 七、 📝 巩固与退场测试题库 (4 题精选)

### 阶段 1：课堂退场盖章测试 (Exit Ticket)
1. **[规范填空题]** 在第二课样式规范中，CSS 变量必须使用小写命名，例如 ____________。
2. **[安全选择题]** 当在 VS Code 中发现某个组件被改崩时，最安全的物理撤销方式是 ____________。
   - A. 运行 `git restore .`
   - B. 运行 `git git commit -a -m "fix"`
   - C. 在 VS Code 管理视图右键点击文件选择 `Discard Changes`
   - D. 手动删掉整个工程重拉
3. **[IT 沟通场景题]** 当你需要向设计师或前端工程师解释如何保持 UI 风格一致时，你应该怎么说？
   - **参考回答**：“我们通过 `DESIGN.md` 视觉 Harness 统一管理 CSS Tokens，保证色彩、间距与圆角的确定性，杜绝了行内硬编码。”

---

### 阶段 2：课后自学拓展思考题 (Self-Study Extension)
4. **[原理思考题]** 为什么我们在第二课中严禁使用 `git commit -a -m` 命令？它和显式 `git add` 有什么本质区别？
