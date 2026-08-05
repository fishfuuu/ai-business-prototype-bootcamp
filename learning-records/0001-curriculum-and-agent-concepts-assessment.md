# 学习记录 0001: 课程体系与 Agent 核心概念评估

- **日期**: 2026-08-05
- **主题**: 评估训练营路线图（`docs/COURSE_ROADMAP.md`）对一级主管的适用性与 Agent 概念准确度

## 核心评估结论

### 1. 课程体系设计：9.5 / 10（极其优秀且贴合主管定位）
- **定位精准**：明确放弃将主管培养为程序员，而是培养为**“超级业务产品经理”**。
- **能力跨越清晰**：从 Prompting → Harness Engineering（工程护栏） → Bounded Agent Loops（受控 Agent 循环） → Multi-Agent（多 Agent 独立审计）层层递进。
- **实战抓手明确**：围绕“A. 监控决策型”、“B. 任务流程型”、“C. 操作工具型”三类原型，每课 90 分钟且均需产生“肉眼可见成果”。

### 2. Agent 概念准确度：10 / 10（物理本质硬核且严谨）
- **四步解析公式**：物理工程定义 → 底层运作机制 → 具象业务比喻 → IT 沟通交接价值。彻底去除了“AI 变魔术”的虚幻色彩。
- **核心范式澄清**：
  - **ReAct 范式**：Perception (感知) -> Action (行动) -> Observation (观察)，单步自自修正；
  - **Plan & Execute 范式**：先规划持久化图纸 `docs/LESSON_04_IMPLEMENTATION_PLAN.md`，审批后再分步切片落盘；
  - **Subagent 调度与隔离**：后台静默 Verifier 子智能体跑自测，保护主 Context 记忆；独立审查 Agent（Codex）隔离上下文只读审计；
  - **MCP 插座机制**：统一 DB/API/Browser 的接口协议，为从静态原型迈向生产 AI 系统提供桥梁。

### 3. 给一级主管的关键落地建议
- **坚守人在回路 (HITL)**：Agent 可以提出 Plan、编写代码、跑测试，但凡涉及方案批准、两提交归档（Commit A / Commit B）与真 AI 写入，必须由主管签署授权。
- **信任工程护栏而非凭空猜测**：善用 `CLAUDE.md` 项目规则、`DESIGN.md` 视觉规范、`verify-project.ps1` 校验与 `prototypeState` 4 状态物理调试切换器。
