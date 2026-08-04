# 第三课：让 Agent 帮助自己想清楚需求（教师备课与控场指南）

## 1. 课程元数据

| 项 | 内容 |
| --- | --- |
| 课次 | 第 3 课 |
| 课程名称 | 让 Agent 帮助自己想清楚需求（兼 Skill 护栏、数据契约与前置验收硬核解析） |
| 面向角色 | 运营主管 / 其他一级主管 |
| 建议时长 | 90 分钟（成果展示 8m，微型演示 17m，概念核对 10m，学员实操 45m，总结验证 10m） |
| 前置课程 | 第 2 课：用参考图与设计规则做出像样的企业页面 |
| 对应路线图 | [COURSE_ROADMAP.md](COURSE_ROADMAP.md) 第 3 课 |
| 课程状态 | 草稿 V2 / 待合入 |
| 课程负责人 | 待指定 |
| 最后复核日期 | 2026-08-04 |
| 学员包版本 | 待本次变更合并后确定 |
| 来源 commit | 待本次变更合并后填写 |

---

## 2. 本课定位

说明：
- **解决什么学习问题**：解决主管“只有模糊口头想法、不知道怎么跟 Agent 表达”的问题。防止学员直接发一句“帮我做个系统”导致 AI 凭空脑补与产生数据幻觉。
- **层级定位（Harness Engineering 层）**：本课实操完全处于 **Harness Engineering（工程护栏层）**。主要掌握 **`grill-me` 技能护栏**、**7 维数据契约卡（海关报关单）** 与 **前置 4 大要素（Goal / Boundary / Risk / Stop）**。
- **与后续 Loop 的关系**：前置 4 大要素本质上是未来受控自主循环（Bounded Agent Loop）的终止断言与边界线。本课在 Harness 层把 4 大要素锁死，是在为第 4 课开启受控自主 Loop 铺平道路。
- **与前后课的关系**：本课产出的《业务功能卡》、数据契约卡与 `src/types/prototype-contract.d.ts` 将直接作为第 4 课（Plan & Execute 增量开发）、第 6 课（Bug 诊断）、第 7 课（Playwright 自动化测试）和第 8 课（Codex 独立审查）的唯一基准。

---

## 3. 核心目标

基于布鲁姆分类法（Bloom's Taxonomy），本课目标如下：

1. **对比与阐述** AI 三层能力演进模型（Prompting -> Harness Engineering -> Bounded Agent Loop）与 Skill Harness (`grill-me`) 追问护栏的物理机制。
2. **构建与锁定** 驱动受控 Agent 循环的前置 **4 大要素（Goal 目标、Boundaries 边界、Risks 风险、Stop Conditions 停止条件）**。
3. **推导与标记** 包含 7 维属性与敏感等级（写给 IT 部门看）的《轻量数据契约卡》。
4. **生成与交付** 业务文档 `docs/BUSINESS_FEATURE_CARD.md` 与 TypeScript 类型接口草稿 `src/types/prototype-contract.d.ts`。
5. **执行** 工程校验 `verify-project.ps1`，完成阶段 Git 稳定存档与退场测试卡。

---

## 4. 可见成果

学员独立产出并归档 3 个确定性资产：
1. **`docs/BUSINESS_FEATURE_CARD.md`**：《业务功能卡》（含目标、边界、风险与前置 Stop Conditions 验收断言）。
2. **`src/types/prototype-contract.d.ts`**：根据数据契约生成的 TypeScript 接口定义草稿（供第 4 课代码直接使用）。
3. **`docs/PROJECT_STATE.md` 更新**：记录 L03 状态为 PASS 及稳定 Git Commit SHA。

---

## 5. 本课明确不做

- 不在追问和澄清阶段进行任何 Vue 代码的修改或逻辑编写（保持零代码变动）。
- 不引入复杂的数据库外键建模或真实 API 接口调试。
- 不忽略数据敏感等级标记（必须明确区分公开/内部/严禁发送AI）。

---

## 6. 教师准备

| 项 | 状态 | 说明 |
| --- | --- | --- |
| 教师演示环境 | 已完成 | Node.js 20.x, Claude Code, `.claude/skills/grill-me/SKILL.md` |
| 全景关系示意图 | 已完成 | 需求与数据契约闭环线框图 |
| 17分钟连续微型演示案 | 已完成 | “订单履约超时预警台需求追问与契约导出”（含 5 个固定暂停点） |
| 学员知识概念与实操卡 | 已完成 | [docs/LESSON_03_GUIDE.md](LESSON_03_GUIDE.md) |

---

## 7. 学员准备

### 主路径（90% 学员）
- 继续使用第 2 课项目，运行 `start-project.bat` 并启动 Agent。

---

## 8. 课堂时间安排 (90 分钟)

| 时段 | 时长 | 环节 | 教学目标与动作 |
| --- | --- | --- | --- |
| 0–8 分钟 | 8 分钟 | 成果展示 | 打开第 2 课高颜原型，引导学员思考“页面炫酷后如何让数据与逻辑可靠”，展示需求闭环线框图 |
| 8–25 分钟 | 17 分钟 | 连续微型演示 | 讲师演示一句话需求发起、唤醒 `grill-me` 追问、导出数据契约卡与生成 TS 类型草稿（5 个固定暂停点） |
| 25–35 分钟 | 10 分钟 | 概念核对 | 对照【四步概念卡】提问，确认学员理解 Prompting vs. Skill Harness、海关报关单比喻、敏感度标记 |
| 35–45 分钟 | 10 分钟 | Task 1：需求追问 | 学员选择原型类型，唤醒 `grill-me`，完成 3~5 轮结构化追问 |
| 45–60 分钟 | 15 分钟 | Task 2：数据契约 | 梳理基础数据契约卡与三类原型专属扩展契约（强调敏感等级是给未来 IT 看的） |
| 60–75 分钟 | 15 分钟 | Task 3A/3B：契约预览与 HITL 落盘 | 定义 Stop Conditions，只读预览方案，下达 HITL 盖章口令落盘 `BUSINESS_FEATURE_CARD.md` 与契约资产 |
| 75–85 分钟 | 10 分钟 | Task 4：验证与 Commit | 更新 `PROJECT_STATE.md`，运行 `verify-project.ps1`，完成 Git 稳定提交 |
| 85–90 分钟 | 5 分钟 | 总结验证与 Exit Ticket | 填记卡，完成退场测试（为什么在写代码前要先生成 TS 类型文件？） |

---

## 9. 业务场景

* **演示案例**：订单履约超时预警台（属于“监控与决策型”示例）
* **模糊需求**：“我们部门经常漏处理超时订单，希望能有个系统预警一下。”
* **澄清后成果**：确定了 `shop_id`、`overdue_minutes`、`threshold_level` 字段，生成了对应 TS 类型草稿，设定了“超时 > 30 分钟触发红框预警”的数据契约与前置 Stop Conditions。

---

## 10. 教师演示步骤 (5 个固定暂停点)

### 暂停点 1：一句话需求与唤醒 `grill-me` (Task 1 阶段)
* **教师动作**：发送一句话需求，并加上 `请使用 grill-me 技能`。展示 Agent 开始以面试官身份提问，但终端没有任何文件修改。
* **教师提问**：“大家的终端里，Claude 开始动手改代码了吗？`grill-me` Skill 的物理本质是什么？”
* **硬核解析**：没有改代码！`grill-me` 是沉淀在 `.claude/skills/grill-me/SKILL.md` 的技能护栏。它覆盖了大模型的自由生成，强制 Agent 专注理清需求。

### 暂停点 2：1 次只问 1 个问题 (Task 1 追问阶段)
* **教师动作**：回答第一个问题，展示 Agent 接着抛出第二个关键问题。
* **教师提问**：“为什么 `grill-me` 规定 Agent 一次只能问我们一个问题？”
* **硬核解析**：避免信息过载（Overload）！人类思考复杂业务时需要分步聚焦，一次问一个问题能最大程度收敛需求误解。

### 暂停点 3：数据契约与敏感度脱敏滤网 (Task 2 阶段)
* **教师动作**：要求 Agent 输出《轻量数据契约卡》，重点指向“敏感等级”一栏，展示【工程拨乱反正卡】。
* **教师提问**：“我们现在用的是 Mock 假数据，为什么还要认真标记‘严禁发送 AI’的敏感等级？”
* **硬核解析**：这是写给未来 IT 部门的 **生产网关脱敏规约 (Sanitization Guardrail)**！提前告知 IT 生产环境真实上线时，网关必须在物理层切断该敏感字段，禁止送入任何公共大模型 API。

### 暂停点 4：方案只读预览、HITL 盖章口令与双落盘 (Task 3A/3B 阶段)
* **教师动作**：展示 Agent 在 Task 3A 输出只读预览方案后停顿，教师提示学员“未授权前 Agent 被物理阻断”；讲师输入授权口令 **`同意方案，请开始落盘功能卡与契约资产`**（Task 3B），展示 Agent 自动落盘 `docs/BUSINESS_FEATURE_CARD.md`、`src/types/prototype-contract.d.ts` 与 `src/mocks/prototype-data.ts`。
* **教师提问**：“我们还没写一行 Vue 代码，为什么要先经过 HITL 盖章授权，再进行 TypeScript 类型与种子数据的双落盘？”
* **硬核解析**：人在回路 (HITL) 门禁与强类型/运行时数据双死锁！`.d.ts` 锁定编译期静态类型，`prototype-data.ts` 提供运行时真实种子数据，彻底杜绝第 4 课写页面时 AI 再次凭空脑补假数据（消除数据与类型漂移）。

### 暂停点 5：资产落盘与 Git 稳定存档 (Task 4 阶段)
* **教师动作**：演示写入 `docs/BUSINESS_FEATURE_CARD.md`，运行 `verify-project.ps1` 输出 `[PASS]`，并执行 `git commit`。
* **教师提问**：“第三课结束时，我们为第四课开发留下了哪些确定性资产？”
* **硬核解析**：留下了《业务功能卡》骨架、数据契约海关报关单、TypeScript 强类型草稿、Mock 种子数据与稳定 Git 快照。

---

## 11. 学员实操引导与卡点救急

* **Task 1 引导**：提醒学员选择原型类型（A/B/C）。若 Agent 一次抛出 >1 问题或尝试改代码，指导发送救急口令：`请重新读取并严格遵循 .claude/skills/grill-me/SKILL.md 指令`。
* **Task 2 引导**：检查数据契约敏感等级，讲透“Mock 假数据占位符 vs. 生产 API 网关脱敏滤网”的区别。
* **Task 3 引导**：辅导学员使用 `Given-When-Then` 确定性模板编写 Stop Conditions（严禁写口号形容词），并监督 Agent 完成 `src/types/prototype-contract.d.ts` 与 `src/mocks/prototype-data.ts` 的双落盘。
* **Task 4 引导**：监督学员依次运行安全的 Git 提交指令（`git status` -> `git add .` -> `git diff --cached` -> `git commit`）。

---

## 12. 推荐提示词

已完整内置于 [docs/LESSON_03_GUIDE.md](LESSON_03_GUIDE.md) 中。

---

## 13. Skill使用与工程约束

| 项 | 内容 |
| --- | --- |
| Skill 名称 | `teaching-lesson-plan` & `teacher-plan-architect` & `grill-me` |
| Skill 用途 | 约束需求追问流程、Goal/Boundary/Risk/Stop 4 要素解构、零代码修改门禁 |
| 来源仓库 | 项目内置 (`.claude/skills/grill-me/SKILL.md`) |
| 验证状态 | 静态检查与构建通过；课堂实测状态待课程候选包隔离验证 |

---

## 14. 工程化内容

* **强类型契约**：使用 `prototype-contract.d.ts` 约束数据定义。
* **防护审计**：通过 `verify-project.ps1` 校验资产文件存在性与模板规范。

---

## 15. 验证和证据

- [ ] **`BUSINESS_FEATURE_CARD.md` 验证**：包含 Goal, Boundary, Risk, Stop Conditions。
- [ ] **`prototype-contract.d.ts` 验证**：生成的 TypeScript 类型强绑定。
- [ ] **`PROJECT_STATE.md` 验证**：记录 PASS 状态与 Git SHA。
- [ ] **自动化校验**：`verify-student-project.ps1` 输出 `[PASS]`。

---

## 16. 课堂成果

1. 包含 4 大要素的 `docs/BUSINESS_FEATURE_CARD.md`；
2. 包含 7 维属性与敏感度的《轻量数据契约卡》；
3. `src/types/prototype-contract.d.ts` TypeScript 类型草稿；
4. 获得 PowerShell 验证脚本的 `[PASS]` 结论与 Git 完结存档。

---

## 17. 课后作业

* **内容**：针对自己的原型，增加 1 个边界外项 (Out of Scope) 说明，并在数据契约中补充 1 个异常状态的示例值。
* **完成标准**：运行 `verify-project.ps1` 输出 `[PASS]`。

---

## 18. 通过标准

* [ ] `docs/BUSINESS_FEATURE_CARD.md` 存在且结构规范；
* [ ] `src/types/prototype-contract.d.ts` 存在且类型正确；
* [ ] 运行 `verify-student-project.ps1` 提示 `[PASS]`。

---

## 19. 常见问题

| 问题现象 | 硬核成因 | 处理建议 |
| :--- | :--- | :--- |
| Agent 在追问过程中突然开始改代码 | 破坏了 `grill-me` 技能护栏 | 发送安全指令：“请停止改代码，严格遵循 `.claude/skills/grill-me/SKILL.md` 规范，仅进行需求追问。” |
| 导出的数据契约缺敏感度一栏 | Prompt 遗漏或 Agent 偷懒 | 发送补全指令：“请补全敏感等级一栏（公开/内部/严禁发送AI）。” |

---

## 20. 课后记录

（略，按模板留空供教师填报）

---

## 21. 学员包信息

| 项 | 内容 |
| --- | --- |
| ZIP 文件名 | 待生成 |
| 包版本 | v0.1.0+ |
| 来源 commit | main 最新 HEAD |

---

## 22. 教师复盘与变更记录

| 日期 | 版本 | 变更内容 | 负责人 |
| --- | --- | --- | --- |
| 2026-08-04 | v1.2 | 重构引入【四步硬核概念公式】、5 个固定暂停点与 Exit Ticket 退场测试 | AI 训练营教学组 |
