# IT 工程师接包一页纸导览 (IT_ENGINEER_QUICKSTART.md)

欢迎 IT 团队接手本项目原型！本包由业务部门统一通过受控 AI 原型工程打包导出。

## 📦 包内资产目录与接入指南

1. **src/mocks/prototype-data.ts (核心 TypeScript 数据契约)**
   - 包含了前端 Vue3 界面所依赖的所有数据结构与 JSON Schema。
   - **IT 接入动作**：后端开发真实 API 时，请严格按照此 TypeScript 接口定义出参，即可实现前端零改动无缝接入。

2. **docs/DEPARTMENT_REDLINES.md (部门不可 Agent 化物理红线清册)**
   - 明确规定了资金划扣、电子合同签署、敏感数据导出为物理禁区，包含引擎拒止钩子。
   - **IT 接入动作**：在后端 Gateway 网关层继承此白名单规则。

3. **docs/LESSON_07_EVIDENCE_INDEX.md (四类测试证据总卡)**
   - 包含视觉、行为、工程与范围四类自动测试证据链，验证界面与流转 Clean。

4. **docs/LESSON_08_AUDIT_REPORT.md (Codex 独立盲审报告)**
   - 包含只读 Codex 审计官落盘的 Audit PASS 报告，确认代码改动零溢出、零历史死锁。

5. **CLAUDE.md (工程护栏与治理规则)**
   - 包含 Vue3 / TS / Element Plus 规范与物理拒止钩子。
