# AI Business Prototype Starter 设计规范

## 1. 文档定位

本文档是培训项目的设计执行规范。

权威来源：

1. `references/original-design/DESIGN.md`
2. `references/original-styles/core/tailwind.css`
3. `src/assets/styles/tailwind.css`

培训项目允许简化正式财务系统的功能和架构，但不得建立另一套冲突的视觉语言。

发生冲突时，按以上权威来源处理。

## 2. 设计目标

培训原型应当：

- 清晰
- 专业
- 稳定
- 容易理解
- 适合企业业务场景
- 便于业务人员和IT共同评审

界面不以视觉炫技为目标。

禁止：

- 大面积渐变
- 发光边框
- 玻璃拟态堆叠
- 3D图表
- 无业务意义的长动画
- 随意建立新的颜色体系

## 3. Token使用规则

正式Token定义在：

`src/assets/styles/tailwind.css`

新增页面和组件必须优先使用 `--art-*`。

不得新增新的 `--prototype-*` 变量。

现有 `--prototype-*` 仅作为历史兼容别名，后续不得在新代码中使用。

### 基础Token

```css
--art-primary: oklch(0.7 0.23 260);

--art-success: #16a34a;
--art-warning: #f59e0b;
--art-danger: #ef4444;

--art-page-bg: #fafbfc;
--art-card-bg: #ffffff;

--art-border-card: var(--art-gray-100);
--art-border-default: var(--art-gray-200);

--art-text-primary: var(--art-gray-900);
--art-text-secondary: var(--art-gray-500);

--art-radius-panel: 12px;
--art-radius-card: 8px;
--art-radius-control: 6px;

--art-shadow-panel: 0 8px 24px rgba(26, 37, 64, 0.08);
--art-shadow-dialog: 0 12px 32px rgba(26, 37, 64, 0.14);
```

## 4. 三类颜色体系

### 业务页面和通用组件

使用：

- `--art-primary`
- `--art-success`
- `--art-warning`
- `--art-danger`
- 财务项目灰阶Token

### Element Plus组件

继续使用：

`src/assets/styles/el-light.scss`

不得在普通页面中擅自改写Element Plus主题色。

### 图表

使用独立图表色板：

```text
主系列：#1f78d1
次系列：#2563eb
良好：#18a058
警告：#f59e0b
风险：#dc2626
无数据：#9ca3af
轴标签：#687385
分隔线：#edf0f5
```

实现来源：

`src/components/charts/chartTheme.ts`

不得把Element Plus的success颜色直接作为图表good颜色。

## 5. 字体

正文优先使用：

```text
Fira Sans
Microsoft YaHei
PingFang SC
系统无衬线字体
```

数字优先使用：

```text
Fira Code
系统等宽字体
```

数字内容应使用：

```css
financial-value
```

不得增加远程字体网络依赖。

## 6. 字号

标准字号：

| 用途 | 字号 |
| --- | ---: |
| 页面主标题 | 24px |
| 模块标题 | 18px |
| 正文、字段标签、菜单、表格 | 14px |
| 辅助文字、状态、说明 | 12px |
| KPI主数值 | 24px |

禁止随意使用：

- 10px
- 11px
- 13px
- 15px
- 28px
- 其他未说明的任意字号

确有特殊需求时，应先说明原因。

## 7. 间距

优先使用：

```text
8px
12px
16px
24px
```

推荐：

- 控件内部间距：8px
- 控件间距：12px
- 卡片间距：16px
- 页面和区块间距：24px

避免在同一页面使用大量不规则间距。

## 8. 圆角和阴影

大型卡片和面板：

```css
border-radius: var(--art-radius-panel);
box-shadow: var(--art-shadow-panel);
```

表格和中型卡片：

```css
border-radius: var(--art-radius-card);
```

按钮和控件：

```css
border-radius: var(--art-radius-control);
```

不要为每个页面单独设计圆角和阴影。

## 9. 页面布局

项目已经提供：

- `PrototypeLayout`
- `AppSidebar`
- `AppHeader`
- `PageContainer`

页面不得重新创建第二套侧边栏或顶部栏。

正式布局：

- 侧边栏宽度：230px
- 顶部栏高度：60px
- 内容区最大宽度：1440px
- 桌面端页面内边距：24px
- 移动端页面内边距：16px

## 10. 响应式

主要断点：

```text
1024px
640px
```

原则：

- 四列卡片在1024px以下变为两列
- 两列图表在1024px以下变为单列
- 640px以下使用移动端布局
- 筛选字段在移动端纵向排列
- 表格允许横向滚动
- 关键结论不得在移动端隐藏

不要继续使用项目未统一的600、760或1100px断点。

## 11. 页面结构

业务页面建议按以下顺序组织：

1. 页面标题与说明
2. 筛选和主要操作
3. 关键指标
4. 图表或主要信息
5. 明细表格
6. 空状态和补充说明

不要求每个页面都包含全部区域。

页面结构应围绕用户任务，而不是为了填满页面。

## 12. 通用组件优先

创建页面前，应先检查：

- `KpiCard`
- `FilterPanel`
- `StatusTag`
- `DataTable`
- `ArtEmptyState`
- `MonthRangePicker`
- `SimpleLineChart`
- `SimpleBarChart`
- `SimplePieChart`

页面负责业务含义，通用组件负责通用展示和交互。

不得把单个页面的业务字段或计算口径写入通用组件。

## 13. KPI卡片

使用：

`KpiCard`

规则：

- 名称14px
- 主数值24px
- 辅助信息12px
- 顶部状态条4px
- 数字使用等宽数字
- 不固定写入预算、同比、环比或达成率

页面通过Props传入业务名称和值。

## 14. 筛选区域

使用：

`FilterPanel`

规则：

- 控件高度接近40px
- 时间条件通常靠前
- 主操作明显
- 重置操作弱于主操作
- 移动端改为纵向排列
- 不使用横向滚动容纳大量筛选条件
- 不在组件内部写死品类、渠道或指标

## 15. 状态标签

使用：

`StatusTag`

语义：

- neutral：中性或未开始
- info：进行中或普通信息
- success：完成或正常
- warning：需要关注
- danger：风险或失败

状态必须同时包含文字，不得只依赖颜色表达。

## 16. 表格

优先使用：

`DataTable`

规则：

- 标题18px
- 表格正文14px
- 数字列右对齐
- 状态列居中
- 空值显示 `--`
- 金额只显示数字和千分位
- 单位应写在列标题中
- 不自动添加 `¥`
- 不对整行进行成功、警告或危险着色
- 无数据时显示空状态

## 17. 图表

优先使用：

- `SimpleLineChart`
- `SimpleBarChart`
- `SimplePieChart`

用途：

- 连续趋势：折线图
- 分类比较：柱状图
- 少量分类构成：饼图或环形图

规则：

- 图表标题18px
- 图表卡片桌面端padding 24px
- 移动端padding 16px
- 使用共享图表色板
- 使用统一轴标签和分隔线颜色
- 不使用渐变和3D效果
- 不在通用图表中写死单位或业务结论
- 指标计算应在页面或数据层完成

## 18. 模拟数据

培训项目只使用模拟数据。

模拟数据必须：

- 明确属于虚构数据
- 不包含真实个人信息
- 不包含公司机密
- 不伪装成已经连接真实系统
- 与页面要表达的业务结构一致

不得使用真实API、Token、数据库或环境配置。

## 19. AI能力展示

页面需要展示AI能力时，必须说明：

- AI读取什么信息
- AI产生什么结果
- 是否需要人工确认
- 是否会执行写入操作
- 失败时如何处理

模拟AI能力必须标明：

`AI能力演示 · 未连接真实服务`

不要把普通统计、筛选或固定规则包装成AI。

## 20. 验证要求

代码修改完成后至少执行：

```powershell
npm run typecheck
npm run build
```

涉及页面或交互时，还应执行：

```powershell
npm run dev
```

并检查目标页面。

不得通过关闭严格检查、排除文件或忽略错误来通过验证。

## 21. 禁止复制的正式系统内容

培训项目不得复制：

- 登录和注册
- 权限守卫
- Token存储
- 用户和菜单Store
- 动态路由
- 多标签页
- 主题切换
- 锁屏和通知
- 正式业务口径
- 真实接口
- 环境变量
- 真实经营数据

培训项目只继承正式财务项目的视觉语言和通用组件习惯。