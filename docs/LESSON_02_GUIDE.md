# 第 2 课学员指南：用参考图与设计规则做出像样的企业页面

> **学习目标**：掌握“多模态视觉提取 + `DESIGN.md` 设计规范约束 + Keep/Remove/Modify 取舍裁决”的标准化重构方法。不用随意泛泛的“做得好看一点”，而是有界控制 Agent，把自己在第一课创建的页面重构为符合企业规范的高质感界面。

---

## 0. 本课全景关系图

在开始前，请仔细阅读第二课人机协作美化闭环：

![第二课全景关系图](assets/lesson-02/lesson-02-flow.png)

```text
第一课自创页面 + 参考图
  │
  ▼
Task 1: 多模态视觉提取 (借排版与结构) ──> 产出《参考图提取卡》
  │
  ▼
Task 2: DESIGN.md 设计约束 (样式铁律/防颜色污染) ──> 产出《设计规范映射卡》
  │
  ▼
Task 3: 主管人在回路裁决 (Keep/Omit/Remove/Modify) ──> 业务逻辑冻结线, 动代码
  │
  ▼
Task 4: 试衣镜视觉对照微调 ──> 截图存入 artifacts/lesson-02-evidence/ & verify PASS
```

---

## 1. 开始前准备与演示观察

### 本地环境确认
1. 在 PowerShell 中运行 `npm ci`（若首次使用或 `node_modules` 不存在）；
2. 双击运行 `start-project.bat`，在浏览器打开 `http://127.0.0.1:8888`；
3. 确保第一课自创的原型页面可正常访问。

### 演示观察问题（带问题看讲师示范）
1. 讲师使用参考图时，是让 Agent 100% 照抄参考图的所有颜色，还是只借排版结构？
2. 讲师在读取 `DESIGN.md` 后，为什么强调“不能继承参考图的自定义乱七八糟颜色”？
3. 讲师在动代码前，为什么非要主管确认《Keep / Omit / Remove / Modify 裁决卡》？

---

## 2. Task 1：多模态视觉提取 (Multimodal Visual Extraction)

### 任务说明
拿出第一课自己创建的页面，选择 **1 张最匹配的参考图**（可使用课程预置的三张结构示范图卡：`assets/lesson-02/ref-dashboard.png` 看板型、`ref-table-list.png` 列表型、`ref-form-detail.png` 表单型，或学员自备截图）。

让 Agent 分析参考图的信息排版与字段层级，不要盲目全盘照抄。

### 提示词模板 1 (提取排版结构)
```text
请读取参考图片 docs/assets/lesson-02/ref-table-list.png (或我的自备截图路径)。
不要修改任何代码。请分析这张参考图的：
1. 页面类型 (看板/列表/表单)；
2. 首屏重点与阅读顺序；
3. 区块分组与信息密度；
4. 主操作按钮的位置与强调方式。

请填写并输出《参考图提取卡》。
```

### 产出：参考图提取卡 (Reference Extraction Card)
```text
- 页面类型：[看板 / 列表 / 表单]
- 首屏重点：[用户第一眼需要看到的核心指标或关键表格]
- 阅读顺序：[顶部筛选/KPI -> 中部主内容 -> 底部操作]
- 区块分组：[哪些信息放在一起]
- 主操作位置：[右上角 / 列表右侧 / 底部固定条]
- 不可复制内容：[参考图中的品牌色、Logo、虚构数据与复杂装饰]
```

---

## 3. Task 2：设计系统约束与样式铁律 (Design System Guardrails)

### 任务说明
设计规则优先级：**`业务需求 > DESIGN.md 规范 > 项目现有组件及公开配置 > 项目已有语义 Class > 参考图灵感`**。

引导 Agent 戴上“设计眼睛”，对比 `DESIGN.md`。下达**样式铁律**：禁止继承参考图自定义杂乱颜色与字体，强制映射项目已有规范变量！

### 提示词模板 2 (对齐规范)
```text
请读取项目 docs/DESIGN.md 与 docs/COMPONENT_CATALOG.md。
对比 Task 1 提取的结构与我第一课的页面 (src/pages/...)。

下达样式铁律：
1. 禁止继承参考图的自定义颜色与字体；
2. 颜色与间距必须 100% 使用 DESIGN.md 规范与 Element Plus 语义样式；
3. 禁止修改 Element Plus 未公开的内部 .el-* 选择器。

请输出《设计规范映射卡》，说明拟使用的组件与规范变量。
```

### 产出：设计规范映射卡 (Design System Mapping Card)
```text
- 准备借鉴的结构：[顶部筛选栏 + KPI 卡片网格 + 带状态 Tag 列表]
- 对应现有组件：[KpiCard / FilterPanel / DataTable / StatusTag]
- 对应 DESIGN.md 规则：[--el-color-primary, --el-color-danger, Element Plus 间距 Token]
- 允许样式来源：[项目已有 Element Plus 样式与 DESIGN.md 规范]
```

---

## 4. Task 3：主管人在回路裁决 (Keep / Omit / Remove / Modify)

### 任务说明
**业务逻辑冻结线**：视觉重构 ≠ 业务重构。未经主管在 `Remove from Current Page` 中明确授权，禁止修改字段含义、计算逻辑与路由。

主管下达 Keep / Omit / Remove / Modify 取舍裁决，并在人在回路确认门禁授权 Agent 修改代码。

### 提示词模板 3 (下达裁决并修改代码)
```text
我作为主管，下达《Keep / Remove / Modify 裁决卡》如下：
- Keep: 保留第一课页面已有的所有数据字段与业务计算逻辑；
- Omit from Reference: 忽略参考图中无关的图表区块；
- Remove from Current Page: 无 (不删除任何业务字段)；
- Modify: 重新调整首屏信息层级、表格布局与状态 Tag 颜色；

请确认业务逻辑冻结线。确认后，请修改 src/pages/... 对应的页面。
本轮仅限修改该页面文件，不得修改其他页面或路由。
```

### 产出：Keep / Omit / Modify 裁决卡 (主管签字卡)
```text
- Keep: [第一课已有的供应商名称、订单号、超时天数、催单按钮]
- Omit from Reference: [参考图中的无关右侧边栏]
- Remove from Current Page: [无 (明确不删除任何字段)]
- Modify: [1. 提升首屏 KPI 视觉层级；2. 增加表格行间距；3. 高亮超时状态 Tag 颜色]
- 业务逻辑冻结标记：[已确认业务逻辑 100% 冻结不变]
```

---

## 5. Task 4：视觉对照与微调闭环 (Visual Comparison & Refinement)

### 任务说明
在 `http://127.0.0.1:8888` 试衣镜预览页面，进行 **3 项视觉改进核对**。

保存【修改前截图】与【修改后截图】到 `artifacts/lesson-02-evidence/`（使用相同视口与数据），运行 `verify-student-project.ps1` 裁判脚本显示 PASS。

### 提示词模板 4 (视觉对照与自测)
```text
我已经观察了试衣镜 preview 效果。
请协助我检查：
1. 首屏关键信息是否一眼可见；
2. 区块布局与间距是否舒适易读；
3. 主操作按钮与状态语义是否清晰高亮。

检查无误后，请指导我运行验证脚本 powershell -File .\scripts\verify-student-project.ps1。
```

### 产出：前后对比与验收卡 (Visual Comparison Card)
```text
- 修改前截图：artifacts/lesson-02-evidence/before.png
- 修改后截图：artifacts/lesson-02-evidence/after.png
- 三项改进核对：
  [x] 首屏关键信息层级清晰
  [x] 主要区块布局与间距留白舒适
  [x] 状态语义 Tag 与主操作按钮高亮识别
- verify-student-project.ps1 结果：PASS
```

---

## 6. 自测验证与救援说明

### 验证脚本
在 PowerShell 中运行：
```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\verify-student-project.ps1
```

### 救援提示词 (代码改崩时使用)
```text
请立即停止修改！请将刚才对 src/pages/... 文件的修改彻底撤销，恢复到修改前的代码状态。
```

---

## 7. 第二课记忆卡

学习完成后，请尝试回答以下 3 个问题：
1. 借用参考图时，为什么要“借结构排版，不抄皮肤颜色”？
2. 为什么在动代码前，主管必须明确下达《Keep / Remove / Modify 裁决卡》？
3. `verify-student-project.ps1` 显示 PASS，是否代表页面视觉设计就 100% 合格了？为什么？
