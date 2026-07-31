# 培训底座设计对齐审计

## 1. 审计结论

- **财务项目权威设计规范**：`前端代码/uzis-admin/DESIGN.md`（前端工程根目录，全文明确为视觉语言与通用交互权威源）。
- **培训底座是否存在独立设计体系**：是。培训项目使用 `--prototype-*` CSS 变量体系（定义于 `src/assets/styles/tailwind.css`），与财务前端的 `--art-*` / Tailwind 语义类 / Element Plus 主题并行存在，并非同一 Token 命名。
- **是否需要对齐**：需要。卡片阴影、部分语义色意图接近，但主色表达、状态色体系、页面底色、字号阶梯、KPI/筛选/图表约定、布局密度等与权威规范及正式代码均有明显差异。
- **本步骤是否修改了运行代码**：否。仅新增只读参考副本与本审计报告。

## 2. 权威来源

| 项 | 值 |
| --- | --- |
| 原设计规范路径 | `C:\Users\Administrator\Desktop\财务经营分析系统\前端代码\uzis-admin\DESIGN.md` |
| 参考副本路径 | `D:\AILearning\references\original-design\DESIGN.md` |
| 原文件 SHA256 | `CA4CAF27AC353EDB52C6459B23995107BF5FC5ECF1883E9A4999DE446892009B` |
| 目标文件 SHA256 | `CA4CAF27AC353EDB52C6459B23995107BF5FC5ECF1883E9A4999DE446892009B` |
| 是否一致 | 是（大小均为 32480 字节） |
| 规范版本或更新时间 | 文中未声明独立版本号；文件系统最近修改时间约 `2026-07-15T18:11:49` |

**候选情况**：在 `uzis-admin` 内递归查找仅命中上述 1 个 `DESIGN.md`。

**判断依据**：

1. 位于前端工程根目录；
2. 标题与开篇声明“所有新页面和已有页面修改必须遵守”，并规定问题分类权威表；
3. 明确冲突处理规则与“必须/禁止/统一”用语。

## 3. 财务项目设计规范摘要

### 色彩

| 项 | 规范内容 |
| --- | --- |
| 主色 Primary | CSS 变量权威在 `tailwind.css`；语义为 `oklch(0.7 0.23 260)`（蓝色系），用于主操作、选中、关键链接 |
| 成功 | 亮色 `text-green-600` / 暗色 `text-green-400` |
| 危险/超支 | 亮色 `text-red-500` / 暗色 `text-red-400` |
| 警告 | 亮色 `text-amber-500` / 暗色 `text-amber-400` |
| 信息/中性文字 | 辅助 `text-gray-500` 等 |
| 正文标题 | `text-gray-900` / 暗 `text-gray-100` |
| 页面背景 | `bg-gray-50` 或 `bg-[#fafbfc]` |
| 卡片背景 | `bg-white`（亮） |
| 边框 | 卡片 `border-gray-100`；表内 `border-gray-200` |
| 图表状态色 | good `#18a058`、warn `#f59e0b`、bad `#dc2626`、nodata `#9ca3af` |

### 圆角

- 大卡片/面板：`rounded-xl`
- 表格/小卡片：`rounded-lg`
- 按钮/标签：`rounded-md`

### 阴影

- 卡片 `shadow-panel`：亮色 `0 8px 24px rgba(26,37,64,0.08)`
- 弹窗 `shadow-dialog`：亮色 `0 12px 32px rgba(26,37,64,0.14)`

### 间距

- 卡片间距 `gap-4`
- 模块间距 `mt-4` / `mb-4`
- 卡片内边距 `p-4` 或 `p-6`
- 图表内边距 `p-6`

### 字体

- 正文字体：`Fira Sans`, ui-sans-serif, system-ui, sans-serif
- 等宽：`Fira Code`
- 字号：KPI `text-2xl font-extrabold`；模块标题 `text-lg font-semibold`；正文/表 `text-sm`；辅助 `text-xs`
- 禁止非标准任意字号（如 10/11/15px）

### 卡片

- 白底、细边框、`shadow-panel`、大圆角 `rounded-xl`
- KPI 层次：名称灰 + 大数值 + 多行对比；可选顶条 `border-t-4`

### 表格

- 文本左、金额/比率右对齐 + 表格数字等宽
- 状态居中；空值 `--`；禁止全行着色；金额列不加 `¥`

### 筛选控件

- 统一 large 尺寸；时间最左；主操作在条件后；本月/本年靠右
- sticky `top-23`，移动端 static
- 禁止筛选栏 `overflow-x-auto` / 随意 wrap

### 状态标签

- 规范强调业务语义着色（成功/超支/警告/中性）与 `el-tag` 用法
- **未单独给出“培训 StatusTag 五色板”的精确 hex 表**；图表四色（good/warn/bad/nodata）有明确 hex

### 图表

- 系列蓝约 `#1f78d1` / `#2563eb`
- 轴标签 `#687385`，splitLine `#edf0f5`
- 柱状圆角 `[4,4,0,0]`；禁止无意义 3D/渐变

### 布局

- 筛选 → 预警 → KPI → 图表 → 明细
- sticky 筛选栏 + 页面 `min-h-screen` 等结构约定
- 抽屉/弹窗宽度约定

### 响应式

- 使用 Tailwind `sm` / `lg` / `max-sm` 等；移动端筛选不 sticky
- 多列网格降级为单列
- **未给出单一固定 px 断点表（如 760）**，以 Tailwind 断点与页面类为准

> 规范未明确给出“禁用文字色”独立 Token 名时，记为：`原规范未以独立禁用色 Token 形式明确规定`（多使用 gray 辅助色表达）。

## 4. 正式代码实现核对

### DESIGN.md 与正式样式代码是否一致

| 对照点 | 结论 |
| --- | --- |
| 主色 `oklch(0.7 0.23 260)` | **一致**：`tailwind.css` 中 `--art-primary: oklch(0.7 0.23 260)`，并映射 `--color-primary` |
| `shadow-panel` 亮色值 | **一致**：`@theme` 中 `0 8px 24px rgba(26, 37, 64, 0.08)` |
| 页面底色 `#fafbfc` | **一致**：`--default-bg-color: #fafbfc` |
| 字体 Fira | **一致**：Google Fonts 引入 + `@theme` font-sans/mono |
| Element Plus 语义色 | **与 DESIGN 语义色部分不一致（冲突）**：`el-light.scss` 中 success `#13deb9`、warning `#ffae1f`、danger `#ff4d4f`，与 DESIGN 业务语义 `green-600`/`amber-500`/`red-500` 及图表 good `#18a058` 并非同一套数值 |
| 暗色 `shadow-panel` | 代码 dark 区存在 `0 8px 24px rgba(0,0,0,0.35)`，与规范暗色一致 |

### 实际设计 Token 来源

1. **`src/assets/styles/core/tailwind.css`**：`--art-*`、gray 阶、shadow-panel、字体（DESIGN 明确“以 tailwind.css 中 CSS 变量为准”）。
2. **`src/assets/styles/core/el-light.scss` + Element Plus useSource**：组件库主题色（与 DESIGN 业务语义色存在并行体系）。
3. **`el-ui.scss` / `app.scss` / `mixin.scss`**：组件细化半径、卡片边框等实现细节（大量依赖 `--custom-radius`、`--art-card-border`）。
4. **页面级 Tailwind 工具类**：业务页直接使用 `text-green-600`、`border-gray-100`、`rounded-xl` 等（与 DESIGN 章节一致）。

### Element Plus 主题来源

- SCSS：`el-light.scss` 的 `@forward` 覆盖 + `vite`/`ElementPlus({ useSource: true })` 类配置（培训侧已见同类 el-light 副本）。
- 运行时变量：`--el-color-primary` 等与 art 主题联动（正式 `el-ui.scss` 中可见大量覆盖）。

### 设计规范未记录、但代码实际使用的样式（代码补充标准）

- 完整 `--art-gray-100`…`900` 灰阶与 dark 反转表
- `--art-secondary` / `--art-info` / `--art-error` 等扩展语义色
- `--custom-radius` 驱动的 Element 圆角公式
- 系统壳（侧栏/顶栏/多标签）的 art 布局样式（DESIGN 更偏业务页内容区，对完整后台壳细节覆盖有限）

**冲突记录（不自行裁定谁“正确”）：**

1. **业务语义成功色（DESIGN / Tailwind 类）** vs **Element Plus success 基色（el-light）** vs **图表 good hex**。
2. 培训底座另立 `--prototype-*`，与上述两套均不同名。

## 5. 培训底座当前设计摘要

### Token（`src/assets/styles/tailwind.css`）

| 变量 | 当前值 |
| --- | --- |
| `--prototype-primary` | `#2563eb` |
| `--prototype-success` | `#16a34a` |
| `--prototype-warning` | `#d97706` |
| `--prototype-danger` | `#dc2626` |
| `--prototype-page-bg` | `#f6f8fb` |
| `--prototype-card-bg` | `#ffffff` |
| `--prototype-border` | `#e5e7eb` |
| `--prototype-text-primary` | `#111827` |
| `--prototype-text-secondary` | `#6b7280` |
| `--prototype-radius` | `12px` |
| `--prototype-shadow` | `0 8px 24px rgba(26, 37, 64, 0.08)`（与规范 shadow-panel 亮色一致） |

### Element 主题副本（`el-light.scss`）

- success `#13deb9`、warning `#ffae1f`、danger `#ff4d4f`、error `#fa896b`（与财务同文件内容一致，但与 DESIGN 业务语义色仍冲突）

### 布局

- 左 240px 侧栏 + 顶栏 + `PageContainer`（padding 24/28）
- 断点多用 `760px` / `1100px` / `640px` / `600px`（固定 media query，非 Tailwind 默认断点命名）

### 组件视觉要点

- **KpiCard**：12px 圆角 + panel 阴影；顶条用状态色；主数值 28px（大于规范 KPI 24px 档）
- **FilterPanel**：卡片化容器；sticky top 92px；未强制 large 控件与本月/本年布局
- **StatusTag**：五色 pill（neutral/info/success/warning/danger）硬编码 hex，非 DESIGN 图表四色表
- **DataTable**：表头 `#f8fafc`、字号 12/13；支持 currency 列（实现可出现货币符号，与 DESIGN“禁止金额列加 ¥”可能冲突）
- **图表**：轴色约 `#64748b` / `#cbd5e1` / `#e2e8f0`；系列色依赖 ECharts 默认，未固化 good/warn/bad/nodata 与规范蓝系
- **字体**：`index.scss` 为 Inter / 微软雅黑 / 苹方，非 Fira

## 6. 差异清单

| 编号 | 设计项 | 财务项目标准 | 培训底座当前值 | 差异程度 | 建议动作 |
| --- | --- | --- | --- | --- | --- |
| D01 | 主色 | `oklch(0.7 0.23 260)` / `--art-primary` | `--prototype-primary: #2563eb` | 明显 | 替换Token |
| D02 | 成功色 | 业务语义 green-600；图表 good `#18a058`；EP 另有 `#13deb9` | `#16a34a` + EP `#13deb9` | 明显 | 需要进一步确认 |
| D03 | 警告色 | amber-500 / 图表 `#f59e0b` | `#d97706`（接近 amber-600） | 轻微 | 替换Token |
| D04 | 危险色 | red-500 / 图表 `#dc2626` | `#dc2626`（与 bad 一致） | 无差异 | 保留 |
| D05 | 页面背景 | gray-50 / `#fafbfc` | `#f6f8fb` | 轻微 | 替换Token |
| D06 | 边框 | gray-100 / gray-200 | `#e5e7eb`（偏 gray-200） | 轻微 | 替换Token |
| D07 | 主文字 | gray-900 | `#111827`（接近 gray-900） | 轻微 | 替换Token |
| D08 | 次文字 | gray-500 | `#6b7280`（偏 gray-500 偏深） | 轻微 | 替换Token |
| D09 | 卡片圆角 | `rounded-xl`（Tailwind 12px 语义） | `12px` 统一 | 轻微 | 保留 |
| D10 | 卡片阴影 | shadow-panel 亮色值 | 同值 | 无差异 | 保留 |
| D11 | 侧边栏 | 正式 art 菜单体系（宽窄/主题/动态菜单） | 240px 简化白底侧栏 | 明显 | 调整组件样式 |
| D12 | 顶部栏 | 正式 header 含用户/通知等 | 简化标题 + 模拟标签 | 明显 | 调整组件样式 |
| D13 | KPI 卡片 | text-2xl、业务对比行、? 帮助、语义着色 | 28px 主值、趋势%、状态顶条；无 ? 帮助强制 | 明显 | 调整组件样式 |
| D14 | 筛选栏 | large 控件、固定顺序、sticky top-23、禁 overflow-x | 卡片 FilterPanel + 插槽；sticky 92px | 明显 | 调整组件样式 |
| D15 | 状态标签 | 业务语义色 + 图表四色规范 | 五态硬编码色板 | 明显 | 调整组件样式 |
| D16 | 表格 | sm 字号、空值 `--`、禁金额 ¥、异常列强调 | 12/13px；currency 格式可能带币种符号 | 明显 | 调整组件样式 |
| D17 | 图表 | 统一状态色与轴色、系列蓝 | 默认 ECharts 色 + 自定轴灰 | 严重 | 调整组件样式 |
| D18 | 响应式断点 | Tailwind sm/lg/max-sm 体系 | 固定 640/760/1100 等 | 明显 | 需要进一步确认 |
| D19 | 字体 | Fira Sans / Fira Code | Inter + 中文系统字体 | 明显 | 替换Token |
| D20 | Token 命名体系 | `--art-*` + Tailwind 语义类 | `--prototype-*` | 明显 | 替换Token |

## 7. 受影响文件

### P0：设计Token和主题入口

| 文件 | 当前差异 | 建议如何对齐 | 是否改接口 | 是否仅样式 |
| --- | --- | --- | --- | --- |
| `src/assets/styles/tailwind.css` | prototype 体系与 art/DESIGN 不一致 | 将语义色/背景/边框/阴影映射到与 DESIGN+tailwind.css 一致的值；评估是否引入 `--art-*` 命名或映射层 | 否 | 是 |
| `src/assets/styles/el-light.scss` | EP 语义色与业务语义色冲突（与财务同源冲突） | 对齐前需确认：以 DESIGN 业务色为准还是以 el-light 为准（冲突上报，不擅自消解） | 否 | 是 |
| `src/assets/styles/index.scss` | 字体栈非 Fira；页面背景走 prototype | 字体与全局 body 色跟随 Token | 否 | 是 |

### P1：基础布局

| 文件 | 当前差异 | 建议如何对齐 | 是否改接口 | 是否仅样式 |
| --- | --- | --- | --- | --- |
| `AppSidebar.vue` | 简化品牌与密度 | 间距、字号、选中态贴近 art 内容区视觉（仍不引入动态菜单） | 否 | 是 |
| `AppHeader.vue` | 标题层级、10px eyebrow 非规范字号 | 字号改入 xs/sm 体系；颜色用 Token | 否 | 是 |
| `PageContainer.vue` | padding 偏大 | 对齐模块间距 p-4/p-6 语义 | 否 | 是 |
| `PrototypeLayout.vue` | 背景色 Token | 跟随页面背景 Token | 否 | 是 |

### P2：通用业务组件

| 文件 | 当前差异 | 建议如何对齐 | 是否改接口 | 是否仅样式 |
| --- | --- | --- | --- | --- |
| `KpiCard.vue` | 字号/状态表达与 KPI 章有别 | 数值层级、颜色语义；可选帮助位 | 可选新增 tip 类 prop，非必须 | 以样式为主 |
| `FilterPanel.vue` | 布局约定不足 | sticky/间距/控件 large 由页面配合；容器视觉对齐 rounded-xl 卡片 | 否 | 是 |
| `StatusTag.vue` | 色板独立 | 映射到统一成功/警告/危险/中性语义 | 否 | 是 |
| `DataTable.vue` | 字号、currency 展示 | 对齐对齐规则与空值；审视 currency 是否加币种符号 | 可能仅格式函数 | 样式+格式 |

### P3：图表组件

| 文件 | 当前差异 | 建议如何对齐 | 是否改接口 | 是否仅样式 |
| --- | --- | --- | --- | --- |
| `SimpleLineChart.vue` | 轴色/系列色未按 §3.10/§7.4 | 抽公共 chartTheme；应用 good/warn/bad/系列蓝 | 可选 theme prop | 样式/option |
| `SimpleBarChart.vue` | 同上；圆角已接近规范 | 系列色与轴色统一 | 可选 | 样式/option |
| `SimplePieChart.vue` | label 策略与规范 outer 不一致 | 标签策略评估；色板统一 | 可选 | 样式/option |
| `useSimpleChart.ts` / `plugins/echarts.ts` | 无主题注入 | 可在 composable 合并默认 grid/tooltip 色 | 否 | 实现细节 |

### P4：培训页面

| 文件 | 当前差异 | 建议如何对齐 | 是否改接口 | 是否仅样式 |
| --- | --- | --- | --- | --- |
| `HomePage.vue` | 引导页密度/字号 | Token 化后随全局收敛 | 否 | 是 |
| `ComponentsShowcasePage.vue` | 展示用文案与断点 | 对齐后用于验收视觉，不改业务语义 | 否 | 是 |

## 8. 保留内容

以下培训底座能力建议在视觉对齐过程中**保留**：

- 通用组件 **Props / 插槽** 契约（KpiCard、FilterPanel、DataTable、图表 xData/series 等）
- **无 API / 无登录 / 无动态菜单** 的简化架构
- **静态路由 + PrototypeLayout** 外壳结构
- **模拟/示例数据** 仅出现在展示页的机制
- 组件目录 `docs/COMPONENT_CATALOG.md` 的复用原则
- 已与规范一致的 **shadow-panel 阴影数值**、**危险色 #dc2626** 等局部点

## 9. 不应复制的正式系统内容

- 登录、注册、鉴权守卫、Token 存储
- 用户 / 菜单 / 权限 Store 与动态路由
- 完整主题切换、锁屏、通知、多标签 Worktab
- 正式业务口径、指标计算、真实接口与环境变量
- 财务专用 KPI 字段语义（预算/达成/缺口等）固化进通用组件
- 完整 art 后台壳的复杂菜单与设置面板
- 原型中的示例数字与 mock 文案照搬（DESIGN 已禁止）

## 10. 建议实施顺序

> 以下仅建议后续步骤，**本步骤不执行**。

1. **对齐设计 Token**（`tailwind.css` / 全局字体与背景；先解决与 DESIGN 的映射，并单独记录 el-light 冲突项）
2. **对齐布局**（Sidebar / Header / PageContainer 密度与字号）
3. **对齐通用业务组件**（KpiCard、FilterPanel、StatusTag、DataTable）
4. **对齐图表**（统一轴色、系列色、状态四色；可选 theme 工具）
5. **对齐展示页**（ComponentsShowcase 作为验收页）
6. **最终生成培训精简版 DESIGN.md**（面向培训项目、引用已对齐 Token，而非整本业务系统文档）

## 11. 本步骤安全确认

本步骤**仅**：

- 新建目录 `references/original-design/`
- 原样复制 `DESIGN.md`（SHA256 校验通过）
- 新建 `docs/DESIGN_ALIGNMENT_AUDIT.md`

本步骤**没有**：

- 修改原财务项目任何文件
- 修改 `D:\AILearning\src\**`
- 修改 `package.json` / lock / vite / tsconfig / index.html
- 修改 `docs/COMPONENT_CATALOG.md`
- 修改 `references/original-config|components|styles` 既有内容
- 创建根目录 `D:\AILearning\DESIGN.md`
- 安装依赖、构建、启动、测试、Git 初始化
- 自动修复任何视觉差异
