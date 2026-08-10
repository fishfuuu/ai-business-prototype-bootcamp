# 第四课教师备课与控场指南 (TEACHER_PLAN V2) — 把大需求拆成连续的小成功

> [!IMPORTANT]
> 本教案为 **V2 融合升级版**，完整集成了 `teaching-lesson-plan`（逆向设计、建构性对齐、Bloom ABCD、WHERETO）与 `teacher-plan-architect`（22 章节物理硬约束、四步概念卡、HITL 授权盖章口令与 PowerShell 自动化校验）。

---

## 1. 课程元数据
- **课程名称**：AI 业务原型开发训练营·第四课 (V2 升级版)
- **主讲主题**：把大需求拆成连续的小成功：受控 Agent 循环与 Working Tree 物理状态机
- **授课对象**：非技术背景业务主管 / 产品经理 / 业务专家 (10–30人)
- **课时时长**：90 分钟 (极客控场 + 5 个固定 Pause Points)
- **授课模式**：18 分钟极客示范 ➔ 10 分钟概念核对 ➔ 45 分钟学员分步实操 ➔ 10 分钟验证归档
- **前置依赖**：学员已完成第三课并拥有 [`docs/BUSINESS_FEATURE_CARD.md`](file:///d:/AILearning/docs/BUSINESS_FEATURE_CARD.md)、[`src/types/prototype-contract.d.ts`](file:///d:/AILearning/src/types/prototype-contract.d.ts) 与 [`src/mocks/prototype-data.ts`](file:///d:/AILearning/src/mocks/prototype-data.ts) 三份契约资产。

---

## 2. 本课定位
- **在全套课程中的位置**：承接第三课《需求澄清与契约冻结》，开启真正的受控代码增量构建。
- **解决的核心痛点**：非技术主管直接让 AI 写全套代码导致“一改就崩”、“代码黑盒失控”、“大失血式重头再来”。
- **核心突破口**：引入“薄切片 (Thin Slices)”与“ Working Tree 砧板模型”，让 Agent 必须先出计划，每次只授权完成 1 个可验证的切片，并自动通过双 Commit 进行物理归档。

---

## 3. 核心目标与 Bloom ABCD 能力矩阵

### 3.1 核心大观与本质提问 (Backward Design Stage 1)
- **核心大观 (Big Idea)**：真正的受控 AI 编程不是“一次性生成 500 行代码”，而是“一次只做一个切片，通过干净 Working Tree 与双 Commit 实现无损存档与回退”。
- **本质提问 (Essential Question)**：当 Agent 写出的代码报错或超出预期时，业务主管如何做到 1 秒钟无损还原，并保证未污染的代码安全归档？

### 3.2 Bloom ABCD 学习目标
完成本课后，学员将能够：
1. **[Objective 1 - Apply (3)]**：在给定的项目 Working Tree 环境下 (**C**)，学员 (**A**) 能使用自然指令 `同意保存实施计划` 与 `确认完成 Step 1` (**B**)，解锁第一个薄切片并成功写入工程 (**D**)。
2. **[Objective 2 - Analyze (4)]**：在面对 Agent 生成的代码切片时 (**C**)，学员 (**A**) 能通过 `prototypeState` 页面技术状态调试器 (**B**)，准确判断 Loading / Empty / Error / Success 四种界面状态与业务状态的解耦情况 (**D**)。
3. **[Objective 3 - Evaluate (5)]**：在代码切片报错或出现验收冲突时 (**C**)，学员 (**A**) 能下发口令 `同意记录 Step N 问题` (**B**)，触发快照补丁导出与 Working Tree 100% Clean 自动恢复 (**D**)。

### 3.3 建构性对齐审计表 (Constructive Alignment Audit)
| 学习目标 | Bloom's 认知层级 | 课堂教学活动 (WHERETO) | 考核手段与证据 | 对齐校验 |
| :--- | :--- | :--- | :--- | :--- |
| Objective 1: 计划落盘与授权执行 | Apply (3) | 教师演示 Task 1-2 & 学员独立操作 Task 2 | 检查 `LESSON_04_IMPLEMENTATION_PLAN.md` 状态机转为 READY | ✅ 100% 对齐 |
| Objective 2: 调试器解耦 | Analyze (4) | 教师示范 `prototypeState` 切换 & 学员点击四态按钮 | 视效截图 + 界面切换行为无报错 | ✅ 100% 对齐 |
| Objective 3: 失败还原与记录 | Evaluate (5) | 模拟自测拦截演练 & 下发自然记录口令 | `.patch` 补丁生成 + Working Tree 恢复 Clean | ✅ 100% 对齐 |

---

## 4. 可见成果
1. **工程配置文件**：[`docs/LESSON_04_IMPLEMENTATION_PLAN.md`](file:///d:/AILearning/docs/LESSON_04_IMPLEMENTATION_PLAN.md) 状态机文件（`plan_status: APPROVED`，Step 1 `status: COMPLETED`，Step 2 `status: PENDING` / `READY`）。
2. **Vue 原型组件切片**：包含 `prototypeState` 技术状态调试按钮的可运行组件 [`src/components/WorkOrderBoard.vue`](file:///d:/AILearning/src/components/WorkOrderBoard.vue)。
3. **Git 物理提交证据**：生成 Commit A (源码) 与 Commit B (计划状态) 的历史记录，Working Tree 恢复 `100% Clean`。

---

## 5. 本课明确不做 (Out of Scope)
- ❌ 本课**不做**后置 Step 2..N 的全套业务逻辑深度开发（作为课后拓展 homework）。
- ❌ 本课**不做**后端真实的 API 接口与持久化数据库对接。
- ❌ 本课**不做**复杂 CSS 样式与响应式排版微调。

---

## 6. 教师准备
- [ ] 检查环境：确保 Node.js >= 18.0，Vite dev server 能正常启动。
- [ ] 准备契约基线：确认工程根目录下已存在 `BUSINESS_FEATURE_CARD.md`、`prototype-contract.d.ts` 与 `prototype-data.ts`。
- [ ] 校验 Skill 锁：运行 `powershell -ExecutionPolicy Bypass -File scripts/verify-project.ps1` 确认通过。

---

## 7. 学员准备
- [ ] 确认已安装 VS Code 与 Claude Code CLI。
- [ ] 准备好第三课完成的工单/原型工程。
- [ ] 若第三课未完成，统一解压发放的 `lesson-04-student-materials.zip` 课前起点包。

---

## 8. 课堂时间安排 (90 分钟 WHERETO 时间盒)

| 时间段 | 建议时长 | WHERETO 心理学环节 | 教师动作 | 学员动作 | 关键暂停点 (Pause Point) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **00:00-00:08** | 8 分钟 | **W** (Where & Big Picture) | 展示传统“一改就崩”失控项目 vs 受控小切片项目的物理对比 | 观看并对齐本课终局成果 | **暂停点 1**：明确本课交付物与 Working Tree 概念 |
| **00:08-00:25** | 17 分钟 | **H** (Hook) & **E** (Equip) | 连续示范 4 个 Task：契约交接校验 ➔ 计划预览 ➔ 解锁 Step 1 ➔ 双 Commit 归档 | 记录关键自然口令与 Diff 试图 | **暂停点 2 & 3**：硬核拆解“切片”与双 Commit 物理逻辑 |
| **00:25-00:35** | 10 分钟 | **R** (Rethink) | 口头核对 Working Tree 砧板模型与 `prototypeState` 解耦卡片 | 口头回答 Working Tree Clean/Dirty 的流转原理 | **暂停点 4**：确认 Pre-Plan 契约冻结线 |
| **00:35-00:80** | 45 分钟 | **E** (Evaluate) & **T** (Tailor) | 巡视指导，观察学员下发口令，监控 Working Tree 干净度 | 独立完成 Task 0 ~ Task 3，运行 PowerShell 校验 | **暂停点 5**：人在回路盖章归档 |
| **00:80-00:90** | 10 分钟 | **O** (Organize) | 运行 `verify-project.ps1`，点评学员退场测试 | 提交验证日志，填记退场卡 | 成果证据物理落盘归档 |

---

## 9. 业务场景
- **案例背景**：以“企业工单管理原型”为例，主管需要在前端页面渲染工单列表，并支持 Loading 加载中、Empty 空数据、Error 报错、Success 成功四种技术的模拟调优。
- **痛点还原**：如果不按切片写，Agent 会一次性把网络请求、数据过滤、DOM 渲染、弹窗全部写完，任何一步报错就会导致整个页面白屏。

---

## 10. 教师演示步骤与人在回路 (HITL) 授权口令

### 演示 Step 1：契约交接门禁 (Pre-Plan Gate)
- **教师输入**：`/incremental-implementation`
- **Agent 输出**：自动复核第三课 3 份文件的一致性，输出结构化 3 步切片计划预览。
- **关键提醒**：严禁在未收到学员许可前写入任何文件（只读阶段）。

### 演示 Step 2：计划落盘授权
- **HITL 盖章口令**：学员在聊天窗口输入 `同意保存实施计划`。
- **Agent 动作**：将计划写入 `docs/LESSON_04_IMPLEMENTATION_PLAN.md`，初始 Step 1 为 `READY`，Step 2 为 `PENDING`。

### 演示 Step 3：解锁切片 1 编码
- **HITL 盖章口令**：学员输入 `确认完成 Step 1`。
- **Agent 动作**：在 `allowed_files` 范围内修改代码，Working Tree 变为 `Dirty`。自动化 Verifier 运行静默自测。

### 演示 Step 4：双 Commit 归档
- **归档动作**：自测通过，Agent 自动跑 Commit A（源码提交）+ Commit B（计划状态更新为 Step 2 `READY`），Working Tree 自动还原为 `100% Clean`。

---

## 11. 学员实操任务
- **Task 0**：检查工程环境，确认 Working Tree 为 100% Clean。
- **Task 1**：唤醒 `/incremental-implementation` 预览计划，下发 `同意保存实施计划`。
- **Task 2**：下发 `确认完成 Step 1`，观察代码生成与 `prototypeState` 调试按钮。
- **Task 3**：验证页面调试器功能，确认 Commit SHA 回填与 Working Tree 恢复 Clean。

---

## 12. 推荐提示词
- **计划生成**：`请根据功能卡生成 Lesson 04 薄切片实施计划。`
- **计划落盘**：`同意保存实施计划` (或 `授权保存 Lesson 04 实施计划`)
- **切片授权**：`确认完成 Step 1` (或 `同意保存 Step 1 成果`)
- **异常记录**：`同意记录 Step 1 问题` (或 `暂停 Step 1 并记录问题`)

---

## 13. Skill 使用与行业对比

| 维度 | 传统盲盒开发模式 | 本课增量实施范式 (Incremental Skill) |
| :--- | :--- | :--- |
| **控制力** | 代理人盲盒，一次生成数百行代码 | 受控 Step 级 Workflow，每次仅授权 1 个切片 |
| **状态回退** | 改崩后手动按 Ctrl+Z，容易遗漏污染文件 | ** Working Tree 物理管理**：失败导出补丁，1 秒无损还原 |
| **进度可视化** | 口头询问“写得怎么样了” | 磁盘长期记忆状态机 (`IMPLEMENTATION_PLAN.md`) 实时跟进 |

---

## 14. 核心工程概念【四步解析卡】

### 概念 1：Working Tree (工作区 / 工作树)
1. **硬核工程定义**：Git 版本控制系统中，当前磁盘上允许被查看、修改和暂存的物理文件目录。
2. **底层运作机制**：任何文件修改都会将 Working Tree 标记为 `Dirty` 状态；执行 `git commit` 或 `git restore` 后恢复为 `100% Clean` 干净状态。
3. **具象业务比喻**：**厨师切菜的砧板**。菜切到一半是 Dirty，切好盘装走（Commit）或冲洗砧板（Restore）后恢复 Clean。
4. **IT 沟通与交接价值**：“请确保提交前 Working Tree 处于 Clean 干净状态，避免脏代码混入。”

### 概念 2：状态机 (State Machine)
1. **硬核工程定义**：一种表示有限个状态以及在这些状态之间转移和动作的数学与软件设计模型。
2. **底层运作机制**：`PENDING` ➔ `READY` ➔ `IN_PROGRESS` ➔ `COMPLETED` / `BLOCKED`，状态不可逆向跳跃。
3. **具象业务比喻**：**工厂流水线传送带**。上一道工序没盖章验收，下一道工序的机械臂绝对不启动。
4. **IT 沟通与交接价值**：“实施计划落盘为状态机，确保 AI 编码步骤具备确定性的物理流转门禁。”

---

## 15. 验证和证据 (4 类可复核证据链)
1. **视觉证据**：浏览器中呈现 `prototypeState` 调试按钮，点击可无缝切换四态。
2. **行为证据**：Vite 热更新正常，控制台无 Console Error。
3. **工程证据**：运行 `powershell -ExecutionPolicy Bypass -File scripts/verify-project.ps1` 输出 `[PASS]`。
4. **范围证据**：`git status` 显示 `working tree clean`，未越界修改 `allowed_files` 之外的文件。

---

## 16. 课堂成果
- [`docs/LESSON_04_IMPLEMENTATION_PLAN.md`](file:///d:/AILearning/docs/LESSON_04_IMPLEMENTATION_PLAN.md) 状态机文件正确回填了 Step 1 的 `commit_sha`。
- 学员成功掌握通过自然口令指挥 Agent 完成增量受控构建。

---

## 17. 课后作业
- **必做作业**：下发 `确认完成 Step 2`，完成绑定 Mock 数据并渲染工单列表。
- **挑战作业**：手动模拟一次代码语法错误，下发 `同意记录 Step 2 问题`，观察自动导出 `step-2-blocked.patch` 并恢复 Working Tree 干净的过程。

---

## 18. 通过标准
- [ ] 必须跑通 `verify-project.ps1` 静态断言校验。
- [ ] 必须跑通 `node .\scripts\run-l4-verifier-isolation-tests.cjs` 8 大隔离场景测试。
- [ ] 实施计划状态集中 Step 1 `status` 必须为 `COMPLETED`，Step 2 为 `PENDING` 或 `READY`。

---

## 19. 常见问题 (Misconceptions Table)

| 常见学员误区 | 正确硬核理解 | 教师课堂纠偏动作 |
| :--- | :--- | :--- |
| “为什么不能直接让 AI 把 5 个 Step 全部一次性写完？” | 一次性写全套代码风险极高，任何环节报错都会导致全面排错瘫痪。 | 用“切菜砧板”比喻提醒学员：贪多嚼不烂，每次只授权 1 个切片。 |
| “`prototypeState` 页面技术状态和业务状态是一回事吗？” | 完全不同！`prototypeState` 是界面加载调试器（Loading/Error）；业务状态是工单生命周期（待处理/已完成）。 | 在页面上现场演示点击四态按钮，展示技术状态与业务逻辑解耦的物理效果。 |

---

## 20. 课后记录
- **时间分配审计**：示范 17 min，概念核对 10 min，学员实操 45 min，总结 10 min。
- **卡点归纳**：部分学员在输入盖章口令时拼写错误，需提醒学员使用标准口令 `同意保存实施计划` 与 `确认完成 Step 1`。

---

## 21. 学员包信息
- 包含 `LESSON_04_GUIDE_V2.md`
- 包含 `.claude/skills/incremental-implementation/SKILL.md`
- 包含 `.claude/agents/verifier.md`
- 包含 `scripts/run-lesson-verifier.ps1` 与 `skills-lock.json`

---

## 22. 教师复盘
- **授课亮点**：通过引入“ Working Tree 砧板模型”和“切片概念”，非技术主管彻底看懂了代码无损存档与回退的底层原理。
- **改进方向**：下次授课可多预留 3 分钟演示 `同意记录 Step N 问题` 生成 `.patch` 快照的真实场景。
