# 第二课教师备课与控场指南 — 用参考图与设计规则做出像样的页面：Token、多模态与视觉重构

> [!IMPORTANT]
> 本教案为 **8 大执教模块精简标准版**，按讲师执教动线深度整合，删除了原 22 章的碎片冗余。

---

## 一、 课程元数据与定位

### 1.1 课程元数据
- **课程名称**：AI 业务原型开发训练营·第二课
- **主讲主题**：用参考图与设计规则做出像样的页面：Token、多模态与视觉重构
- **授课对象**：非技术背景业务主管 / 产品经理 / 业务专家 (10–30人)
- **课时时长**：90 分钟 (极客控场 + 5 个固定 Pause Points)
- **授课模式**：18 分钟极客示范 ➔ 10 分钟概念核对 ➔ 45 分钟学员分步实操 ➔ 10 分钟验证归档
- 本课学员 Skill 名称 | 无
- **前置依赖**：学员已完成第一课并掌握基础五位一体架构与 127.0.0.1 试衣镜加载。
- **教学验证状态**：PILOT_PASSED
- **课程负责人**：官方教研组

### 1.2 本课定位与背景痛点
- **在全套课程中的位置**：承接第一课《破冰与试衣镜》，引入 Token 物理概念、多模态视觉提取与 `DESIGN.md` 视觉 Harness。
- **解决的核心痛点**：自然语言表达 UI 极为模糊导致的“审美崩溃”、对话过长引发的 Token 样式遗忘、改崩代码无法安全撤销。
- **核心突破口**：利用多模态提取参考截图布局，挂载 `DESIGN.md` 视觉 Harness 与小写 CSS Tokens (`var(--art-primary)`)，演示基于 VS Code GUI 的 `Discard Changes` 无损物理撤销。

---

## 二、 逆向目标与四步概念卡

### 2.1 Bloom ABCD 学习目标 (100% 原始权威对齐)
完成本课后，学员将能够：
1. **[Objective 1 - Apply (3)]**：在给定的参考截图与工程目录下 (**C**)，学员 (**A**) 能利用多模态视觉提取与 `DESIGN.md` 视觉规则 (**B**)，指导 AI 输出高保真受控 UI 样式 (**D**)。
2. **[Objective 2 - Analyze (4)]**：在面对对话增长与 Context 积压时 (**C**)，学员 (**A**) 能理解 Token 物理消耗对记忆的影响 (**B**)，并纠正大写 CSS 变量错误 (**D**)。
3. **[Objective 3 - Evaluate (5)]**：在样式改崩或出现非预期修改时 (**C**)，学员 (**A**) 能拒绝使用破坏性的 `git restore .` (**B**)，并在 VS Code 界面点击 `Discard Changes` 实现 1 秒无损物理撤销 (**D**)。

### 2.2 核心概念四步解析卡集

#### 💡 概念卡 1：Token 与 Context 上下文窗口 (Token & Context Window)
1. **硬核工程定义**：LLM 处理文本代码的物理计算单位（约0.75个英文单词），以及单次会话可保持注意力的最大 Token 内存上限。
2. **底层运作机制**：AI 每次读写均消耗 Token；Context 积压过多会稀释注意力，引发规则幻觉。
3. **具象业务比喻**：**高考试卷的答题卡与计时器** ⏱️。
4. **IT 沟通场景**：“样式改动需控制 Token 消耗，避免 Context 窗口过大导致 AI 遗忘。”

#### 💡 概念卡 2：多模态视觉提取 (Multimodal Visual Extraction)
1. **硬核工程定义**：LLM 联合解析文本与图像像素阵列的能力，将参考截图转化为结构化代码的范式。
2. **底层运作机制**：分析输入参考图的盒模型与排版，将其映射为 Vue 模板代码。
3. **具象业务比喻**：**建筑设计师的现场测绘拍照** 📸。
4. **IT 沟通场景**：“我们利用多模态视觉提取能力，直接从参考图中提取了工单看板布局。”

#### 💡 概念卡 3：视觉 Harness (`DESIGN.md`) 与事实锚定
1. **硬核工程定义**：根目录下的视觉规范契约，结合设计参考图作为样式生成时的物理锚定基准。
2. **底层运作机制**：编辑组件样式前强制读取调色板、字号、圆角 Token。
3. **具象业务比喻**：**建筑工程的设计图纸与样板间** 📐。
4. **IT 沟通场景**：“界面样式严格受扣于 `DESIGN.md` 视觉 Harness，保证视觉确定性。”

#### 💡 概念卡 4：Git 节点安全防护与 `Discard Changes` 物理撤销
1. **硬核工程定义**：通过显式 Git 提交冻结镜像，并利用 GUI 进行文件级的无损变更撤销。
2. **底层运作机制**：显式 `git commit -m` 存档；使用 VS Code UI 界面点击 `Discard Changes` 撤销。
3. **具象业务比喻**：**单机游戏关卡前的存盘与撤销** 🎮。
4. **IT 沟通场景**：“每次重大重构前建立 Git 稳定节点，支持 `Discard Changes` 安全物理回滚。”

---

## 三、 教学准备与沙箱隔离

- **代码仓库准备**：检查根目录 `DESIGN.md` 存在且使用小写 CSS Tokens。
- **环境检查命令**：
  ```powershell
  git status
  npm run dev
  ```
- **示范区与实验区**：保持环境独立隔离。

---

## 四、 90分钟控场主线与 Pause Points

| 时间段 | 环节 | WHERETO | 教师动作与 Pause Points 提问 | 学员动作 |
| :--- | :--- | :--- | :--- | :--- |
| 00-08 分 | 成果展示 | **W** | 展示自然语言盲改丑页面 vs DESIGN.md 规范页面。<br>**Pause Point 1**：“为什么对话久了 AI 会忘记之前的样式？(Token物理开销)” | 观看对齐交付物 |
| 08-25 分 | 极客示范 | **H & E** | 示范 Task 0➔3，展示多模态提取与 Discard Changes。<br>**Pause Point 2**：“多模态技术是如何从图片提代码的？”<br>**Pause Point 3**：“CSS 变量为什么要强制小写？” | 记录关键指令 |
| 25-35 分 | 概念核对 | **R** | 提问核对 Token、多模态与视觉 Harness 卡片。<br>**Pause Point 4**：“为什么不能用 `git restore .` 清空？” | 口头回答卡片 |
| 35-80 分 | 学员实操 | **E & T** | 巡视指导，监控多模态提取与 Discard Changes 撤销。<br>**Pause Point 5**：“如何验证样式物理恢复干净？” | 分 Task 独立实操 |
| 80-90 分 | 总结验证 | **O** | 运行 `verify-project.ps1` 校验。 | 填退场卡，提交日志 |

---

## 五、 逐 Task 极客示范与巡视指导

### Task 0: 检查环境与准备 DESIGN.md 规范
- **教师示范**：打开 `DESIGN.md`，讲解 Token 物理开销与 `var(--art-primary)` 等小写变量。
- **盖章口令**：`npm run dev`
- **巡视 Check**：确认学员 `DESIGN.md` 配置正确无大写变量。

### Task 1: 多模态结构提取与参考图上传
- **教师示范**：在 CLI 中下发参照 `DESIGN.md` 与参考图提取多模态 DOM 重构 `WorkOrderBoard.vue` 样式的指令。
- **盖章口令**：`参照 DESIGN.md 与参考图重构 WorkOrderBoard.vue 页面样式`
- **巡视 Check**：学员页面加载出多模态提取的响应式布局与低饱和度配色。

### Task 2: 建立 Git 稳定节点 1
- **教师示范**：运行显式提交 `git add src/` 结合 `git commit -m "baseline: ..."`。
- **盖章口令**：`git commit -m "baseline: 样式节点1"`
- **巡视 Check**：确认学员未盲目使用 `commit -a`。

### Task 3: 演练样式改崩与 `Discard Changes` 撤销恢复
- **教师示范**：让 AI 故意改坏样式，然后在 VS Code UI 界面示范右键点击 `Discard Changes` 恢复。
- **盖章口令**：`Discard Changes 物理撤销`
- **巡视 Check**：学员成功在 VS Code 界面点击 `Discard Changes` 还原 Clean 源码。

---

## 六、 现场 Debug 预案与自动化校验

### 6.1 常见错误现场 Troubleshooting
- **现象 1**：页面白屏或样式全部丢失 ➔ **预案**：检查 CSS 变量是否误写成了大写 `var(--art-PrimaryBad)`。
- **现象 2**：快捷键撤销失败 ➔ **预案**：指导学员在 VS Code 左侧第 3 个 Git 分支视图中操作。

### 6.2 自动化校验与证据提取
- **校验命令**：
  ```powershell
  powershell -ExecutionPolicy Bypass -File scripts/verify-project.ps1
  ```

---

## 七、 退场测试与课后拓展作业

### 7.1 课堂退场测试卡 (Exit Ticket)
包含 4 道考查 Token 物理概念、多模态视觉提取、Discard Changes 撤销操作的题目。

### 7.2 课后练习与巩固作业
尝试参照 `DESIGN.md` 为第二个页面替换样式。

---

## 八、 教师备课质量自测 Checklist

- [ ] 100% 匹配 **8 大执教模块** 标题，包含 5 个固定 Pause Points。
- [ ] 100% 包含 Token、多模态、DESIGN.md 与 Discard Changes 4 大核心概念卡。
- [ ] 包含了【四步解析卡】与 HITL 授权盖章口令。
- [ ] 包含了 PowerShell 脚本自测通过逻辑。
