# 培训底座设计对齐决策

## 1. 权威来源

培训项目的视觉规范以以下文件为准：

1. `references/original-design/DESIGN.md`
2. `references/original-styles/core/tailwind.css`
3. 正式财务前端实际使用的Element Plus主题文件

培训项目不得建立与财务项目冲突的独立视觉体系。

## 2. Token策略

培训项目采用 `--art-*` 作为正式设计Token命名。

已有 `--prototype-*` 暂时保留为兼容别名，避免一次修改所有现有组件。

后续新增代码不得创建新的 `--prototype-*` 变量。

组件对齐时，应逐步将组件内部引用改为 `--art-*`。

## 3. 三类颜色体系

### 业务页面和通用业务组件

遵循财务项目 `DESIGN.md` 和 `tailwind.css` 的业务语义色。

### Element Plus组件

继续使用当前 `src/assets/styles/el-light.scss`。

该文件与正式财务项目同源，本培训项目不单独修改其主题色。

### 图表

使用财务项目规定的独立图表色板：

- good `#18a058`
- warn `#f59e0b`
- bad `#dc2626`
- nodata `#9ca3af`
- axis label `#687385`
- split line `#edf0f5`
- primary series `#1f78d1`
- secondary series `#2563eb`

不得把Element Plus success色直接当作图表good色。

## 4. 字体策略

设计规范使用Fira Sans和Fira Code。

培训项目不增加远程字体网络依赖。

CSS中保留Fira字体为第一顺位，本机不存在时使用系统中文字体和系统等宽字体。

## 5. 简化原则

培训项目只对齐视觉语言，不复制正式系统的：

- 登录
- 权限
- 动态菜单
- 多标签页
- 用户信息区
- 主题切换
- 真实业务口径
- 真实接口

组件结构、Props、插槽和无API架构继续保留。

## 6. 后续顺序

1. Token和全局样式
2. 基础布局
3. 通用业务组件
4. 通用图表
5. 组件展示页视觉验收
6. 生成培训精简版 `DESIGN.md`

## 7. 本步骤Token取值说明（10B）

| Token | 取值 | 来源 |
| --- | --- | --- |
| `--art-primary` | `oklch(0.7 0.23 260)` | 参考 `original-styles/core/tailwind.css` 亮色 `:root` |
| `--art-info` | `oklch(0.58 0.03 254.1)` | 同上 |
| `--art-gray-100/200/500/900` | `#f9fafb` / `#f2f4f5` / `#949eb7` / `#323251` | 同上亮色灰阶 |
| `--art-gray-50` | `#f9fafb` | 参考文件无独立 gray-50；与 gray-100 及 Tailwind gray-50 一致 |
| `--art-page-bg` | `#fafbfc` | 参考 `--default-bg-color` 与 DESIGN 页面底色 |
| `--art-success` | `#16a34a` | DESIGN §3.2 业务语义 `text-green-600`（非 el-light、非图表 good） |
| `--art-warning` | `#f59e0b` | DESIGN §3.2 `text-amber-500` / 图表 warn 同值 |
| `--art-danger` | `#ef4444` | DESIGN §3.2 `text-red-500`（图表 bad `#dc2626` 单独在 chart Token） |
| `--art-shadow-panel` | `0 8px 24px rgba(26, 37, 64, 0.08)` | 参考 `@theme --shadow-panel` 亮色 |
| 图表八色 | 见上表 | DESIGN §3.10 / §7.4 |

与审计报告差异：审计摘要中业务危险色曾与图表 bad 一并写作 `#dc2626`；本步骤业务语义严格按 DESIGN `text-red-500` 映射为 `#ef4444`，图表 bad 仍为 `#dc2626`。
