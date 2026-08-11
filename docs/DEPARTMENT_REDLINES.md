# 部门不可 Agent 化物理红线清册 (DEPARTMENT_REDLINES.md)

> 💡 **核心原则：**  
> **明确划定绝对禁止 AI 自动化代理、必须由人类全流程审批的物理安全禁区。**

---

## 一、 部门绝对物理红线领地 (Absolute Non-Agentizable Domains)

1. **资金划扣与财务出纳**：
   - 绝不允许 AI 自动发起任何银行转账、资金划扣或发票开具操作。
   - 涉及金额运算一律由 TypeScript 确定性代码处理，打款前必须由财务主管人工核对盖章。

2. **法律合同与劳动关系**：
   - 绝不允许 AI 自动签署法律合同、下发辞退通知或变更薪酬结构。
   - 法律文件与合同条文必须经过法务部门与主管人工审核签署。

3. **数据导出与敏感数据脱敏**：
   - 绝不允许 AI 导出包含用户真实身份证、手机号或未经脱敏的商业机密数据库。
   - 外部网络访问严格锁定 127.0.0.1 域名白名单。

---

## 二、 物理代码拒止钩子 (Refusal Hooks for CLAUDE.md Engine)

> [!CAUTION]
> **以下钩子规则被直接注入 `CLAUDE.md` 引擎根约束。一旦接收到越权 Tool Call 请求，Agent 必须物理打断并直接拒绝执行：**

- `HOOK_REFUSE_BANK_TRANSFER`: 当检测到任何试图调用银行转账、资金出纳或变动账务逻辑的指令时 ➔ **立即物理打断并输出 `[REFUSED] Redline Violation: Bank transfer is non-agentizable!`**
- `HOOK_REFUSE_CONTRACT_SIGN`: 当检测到任何试图自动签署电子合同或法律文书的指令时 ➔ **立即物理打断并输出 `[REFUSED] Redline Violation: Legal contract signing requires HITL manual signature!`**
- `HOOK_REFUSE_DATA_EXPORT`: 当检测到试图将未脱敏的用户敏感数据导出或推送到外部域名的指令时 ➔ **立即物理打断并输出 `[REFUSED] Redline Violation: Unanonymized data export is strictly prohibited!`**

---

## 三、 人在回路 (HITL) 强制审批节点表

| 业务场景 | AI 许可动作 | 绝对禁止动作 (人类强制审批) |
| :--- | :--- | :--- |
| **订单生成** | 智能文本推荐、商品展示 | 擅自算钱扣费、擅自修改折扣公式 |
| **原型修改** | 生成薄切片代码、跑自测 | 未经主管口令授权直接改动系统核心路由 |
| **工程合并** | 盲审报告落盘 `AUDIT_REPORT.md` | 代替主管自动执行 `git merge` 合并主干 |
