# 培训原型通用组件目录

本目录记录培训项目已经提供的基础组件。

创建新页面前，应先检查这些组件是否能够满足需求，避免重复创建功能相同的组件。

## 1. KpiCard

路径：

`src/components/business/KpiCard.vue`

用途：

- 展示单个重要指标
- 支持文字或数字值
- 支持单位、说明和趋势
- 支持正常、成功、关注和风险状态
- 支持加载状态

不得在组件内部写入具体业务口径。

## 2. FilterPanel

路径：

`src/components/business/FilterPanel.vue`

用途：

- 容纳日期、下拉选择、输入框等筛选控件
- 使用默认插槽放置筛选字段
- 使用 `actions` 插槽放置查询、重置等操作按钮

组件本身不规定筛选字段。

## 3. StatusTag

路径：

`src/components/business/StatusTag.vue`

支持状态：

- `neutral`
- `info`
- `success`
- `warning`
- `danger`

可以通过 `label` 覆盖默认显示文字。

## 4. DataTable

路径：

`src/components/business/DataTable.vue`

支持列类型：

- `text`
- `number`
- `currency`
- `percent`
- `status`

数据必须由页面通过 `rows` 传入。

组件内部不得请求API，也不得包含具体业务字段。

## 5. ArtEmptyState

路径：

`src/components/business/ArtEmptyState.vue`

用途：

- 表格、图表或卡片无数据时显示空状态
- 可以单独使用
- 已被DataTable复用

## 6. MonthRangePicker

路径：

`src/components/MonthRangePicker/index.vue`

用途：

- 选择单个月份
- 选择同一年内的月份区间

当前组件不负责业务查询，只负责返回选择结果。

## 7. SimpleLineChart

路径：

`src/components/charts/SimpleLineChart.vue`

用途：

- 展示一组或多组连续趋势数据
- 页面通过 `xData` 和 `series` 传入数据
- 支持加载状态、空状态和平滑折线

组件不规定指标名称、时间粒度或单位。

## 8. SimpleBarChart

路径：

`src/components/charts/SimpleBarChart.vue`

用途：

- 对比多个分类或时间点的数据
- 支持单组、多组和堆叠柱状图
- 页面通过 `xData` 和 `series` 传入数据

组件不负责计算差异、达成率或异常状态。

## 9. SimplePieChart

路径：

`src/components/charts/SimplePieChart.vue`

用途：

- 展示分类构成
- 支持普通饼图和环形图
- 页面通过 `data` 传入名称和值

分类数量过多时，应由页面先完成聚合或筛选。

## 10. useSimpleChart

路径：

`src/composables/useSimpleChart.ts`

用途：

- 管理ECharts初始化、数据更新、尺寸调整和销毁
- 不依赖Store、主题系统或API
- 新图表组件应优先复用该Composable

## 图表使用限制

1. 图表组件只负责展示，指标计算必须在页面或数据层完成。
2. 图表组件不得直接请求API。
3. 不要在通用图表组件中写死单位、业务颜色或预警规则。
4. 新增复杂图表前，先确认三种基础图表无法满足需求。

## 使用原则

1. 页面负责业务含义，组件负责通用展示和交互。
2. 组件不得直接调用API。
3. 页面通过props传入数据，通过事件或插槽接收操作。
4. 不因单个页面需求随意修改通用组件。
5. 确有通用价值时，才新增基础组件。
