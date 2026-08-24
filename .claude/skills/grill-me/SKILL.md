---
name: grill-me
description: Interview the user relentlessly about a plan or business requirement until reaching shared understanding, clarifying problem definitions, acceptance criteria, stop conditions, and data contracts.
---

# Grill-Me Skill (需求澄清与契约护栏)

> **来源致谢 / Source**: 本 Skill 改编自 [mattpocock/skills](https://github.com/mattpocock/skills)（MIT License，© Matt Pocock），并按本课程“业务主管制作原型”场景做教学化改造，吸收 Spec-Driven Development 结构化消歧机制。

唤醒需求澄清护栏，以逐题追问的方式帮助主管锁定业务原型的核心要素，完成数据契约与 TypeScript 类型字典收扣。

对于每个追问问题：
- 优先提供你推荐的业务选项（前缀 `(Recommended)`）。
- 每次只问一个问题。
- 如果可以通过浏览现有文档 (`PROJECT_STATE.md` 或 `DESIGN.md`) 直接解答，先探查文档，不问冗余问题。
- 控制在 3–5 个主要决策分支、5–7 轮追问对话内收敛。若达到轮数上限仍未收敛，将未决事项记录至 `Open Decisions`。

---

## 课程业务原型契约扩展 (第三课)

### 阶段 1：结构化澄清对话 (严格只读与三维消歧扫描)
- 对话期间严禁写入或修改任何磁盘文件。
- Agent 主动按以下三大维度扫描业务诉求中的模糊点，每次只问 1 个问题：
  1. **范围与优先级维度 (Scope & Priority)**：
     - 使用者与人工痛点（区分 `[事实]`、`[决定]`、`[假设]` 与 `[待确认]`）。
     - 业务目标 (Goal) 与成功衡量指标。
     - 明确优先级划分：**P1 核心必做 (In Scope)** 与 **P3 明确不做 (Out of Scope)**。
  2. **数据流向与敏感度维度 (Data & Sensitivity)**：
     - 核心业务字段来源（固定为 Mock 模拟数据，不接真实库）。
     - 数据安全等级（公开 Public / 内部 Internal / 严禁发送 AI）与隐私边界。
  3. **验收与异常分支维度 (Acceptance & Edge Cases)**：
     - 确定性逻辑验收用例（格式：假如 [上下文] / 当 [操作] / 则 [预期结果]）。
     - 异常与容错分支（Edge Cases，如空数据、输入格式错误、网络异常时的界面提示）。
     - 请示主管门禁 / 触发暂停条件 (Stop Conditions，遇到规则冲突或未决字段时熔断暂停)。

#### 强校验需求门禁规则 (没想清楚不准开工)
以下 6 项核心内容必须全部满足 **存在、非空、有明确确认结论、无相互冲突、且无 `[待确认]` 标签**：
1. `user_and_owner`: 核心使用者或责任角色
2. `core_field_source`: 核心字段来源
3. `business_rules`: 关键业务规则
4. `sensitive_data_policy`: 敏感数据处理方式
5. `in_scope`: In Scope (P1 核心必做) 边界线
6. `acceptance_scenario`: 至少 1 个核心业务验收场景 (假如...当...则...) 与异常分支说明

若有任意一项缺失、空白、模糊、冲突或包含 `[待确认]`，拒绝生成或落盘文件。

非阻断的常规问题保留在《业务功能卡》第 9 节 `Open Decisions`，格式：`[事项 | 负责人 | 截止日期 | 是否阻断: 否 | 影响范围]`。

#### 三类原型差异化聚焦：
- **A. 监控与决策型**：聚焦指标定义、时间粒度、基准值、预警阈值、异常等级、下钻维度与触发动作。
- **B. 任务与流程型**：聚焦发起/处理角色、业务状态机、允许动作、驳回撤销规则与权限边界。
- **C. 操作工具型**：聚焦输入结构、校验规则、处理逻辑、输出结构、异常提示与人工确认节点。

### 阶段 2：聊天窗口方案预览 (Task 3A 只读预览)
- 澄清完成后，仅在聊天窗口中输出文本方案预览：
  - `docs/BUSINESS_FEATURE_CARD.md`（包含 9 大完整章节，包含 P1/P3 边界与异常分支）
  - `src/types/prototype-contract.d.ts`（数据字典定义表 TS 草稿）
  - `src/mocks/prototype-data.ts`（运行时模拟种子数据）
- 严禁在此阶段修改任何磁盘文件。
- 提示学员：若预览无误，请输入授权许可口令。

### 阶段 3：主管授权与落盘门禁 (Task 3B 写入落盘)
在接收学员授权落盘口令（`同意方案，请开始落盘功能卡与契约资产`）前：
1. **自动复核 6 项强校验门禁**。
2. **输出结构化检验结果**：
   ```yaml
   blocking_gate:
     user_and_owner: PASS # (或 FAIL)
     core_field_source: PASS # (或 FAIL)
     business_rules: PASS # (或 FAIL)
     sensitive_data_policy: PASS # (或 FAIL)
     in_scope: PASS # (或 FAIL)
     acceptance_scenario: PASS # (或 FAIL)
     result: PASS # (或 BLOCKING_GATE_FAILED)
   ```
3. **若检查结果包含 FAIL / BLOCKING_GATE_FAILED**：
   - **严禁写入任何文件**。
   - 输出人类通俗提示：`[需求遗漏拦截] 核心需求尚有未决事项，暂不开工` (BLOCKING_GATE_FAILED)。
   - 列出具体未解决或缺失的事项，引导学员继续澄清或向上呈报。
4. **仅当检查结果为 PASS 时**：
   - 写入 `docs/BUSINESS_FEATURE_CARD.md`
   - 写入 `src/types/prototype-contract.d.ts`
   - 写入 `src/mocks/prototype-data.ts`
   - 严禁修改其他任何工程文件。

### 契约冻结规则 (Contract Freeze Rule)
主管验收通过并落盘后，`docs/BUSINESS_FEATURE_CARD.md` 即成为第四课的唯一需求基线。后续如需调整范围或业务规则，必须先更新功能卡并重新获得主管确认，不得在编写代码时静默改变需求。
