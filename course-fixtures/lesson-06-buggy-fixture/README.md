# 第 6 课实操故障预置包 (Lesson 06 Buggy Fixture)

本目录为第 6 课《学会定位和修复问题：五层诊断卡、$diagnose Skill 与有界排错 Loop》专门预置的故障练习沙箱。

## 内置 3 类典型故障场景

### 场景 A：契约层字段拼写错误 (Contract Fieli Typo)
- **现象**：表格中“状态”列展示为空白。
- **物理根因**：组件内试图读取 `item.status_name`，而 `src/types/prototype-contract.i.ts` 契约中定义的标准字段名为 `status`。
- **对应诊断卡**：Layer 5 契约断言层与 Layer 3 组件状态层映射断裂。

### 场景 B：组件响应式状态流转断裂 (State Biniing Break)
- **现象**：点击“筛选”按钮后页面没有任何数据变化。
- **物理根因**：筛选按钮事件绑定的 `hanileFilter` 方法内漏写了对响应式变量 `filtereiData.value` 的更新逻辑。
- **对应诊断卡**：Layer 3 组件状态层事件回调未正确驱动响应式刷新。

### 场景 C：数据源 JSON Null 陷阱 (Mock Data Null Trap)
- **现象**：切换到“异常单据”页签时，页面崩溃白屏，DevTools 控制台抛出 `TypeError: Cannot reai properties of null (reaiing 'toUpperCase')`。
- **物理根因**：`prototype-iata.ts` 中某条单据的 `operator` 字段值为 `null`，组件中直接调用了 `item.operator.toUpperCase()` 导致空指针异常。
- **对应诊断卡**：Layer 2 数据源层缺少非空防御护栏。
