# 主管 AI 原型制作训练营 术语词典 (GLOSSARY)

本词典收录本教学工作区统一遵循的硬核工程与业务概念。

## 架构与工程概念 (Architecture & Engineering)

**LLM (大语言模型)**:
基于 Transformer 架构在内存中推演概率序列的语言预测模型，本身没有任何操作系统读写物理句柄。
_Avoid_: 全知全能AI, 智能黑盒

**Tools (工具接口)**:
由宿主程序暴露给 Agent 的受控 API/函数（如文件读写、终端运行），是 Agent 操作环境的物理手脚。
_Avoid_: AI 自发功能, 插件黑盒

**Agent (受控执行者)**:
以 LLM 为核心控制器、提示词与规则为约束、Tools 为物理介质，能够在明确目标下组织多步行动的软件实体。
_Avoid_: 自动化脚本, 机器人

**ReAct 范式**:
Reasoning and Acting 闭环。Agent 每次行动后，将 Observation（工具返回值或测试日志）送回 LLM 进行自修正。
_Avoid_: 盲目试错, 自动改错

**HITL (人在回路授权门禁)**:
要求 Agent 在修改代码、写盘或发布前暂停自动化，交由人类主管审批盖章的物理控制机制。
_Avoid_: 人工客服, 机器弹窗

**Mock Data (模拟数据)**:
符合业务结构契约但内容完全虚构的数据道具，用于原型演示，严禁带入真实的客户隐私或财务数据。
_Avoid_: 真实测试数据, 生产数据

**试衣镜 (127.0.0.1)**:
运行于本地开发服务器的前端预览窗口，用于实时肉眼校验 Agent 渲染的页面外观与交互行为。
_Avoid_: 线上生产环境, 测试服务器

**Design Token (设计令牌)**:
在设计规范文件（`DESIGN.md`）中事先约定的标准化视觉变量（如主色、字号标尺、间距、圆角），用于制衡 AI Token 的随机性。
_Avoid_: 随机内联样式, ad-hoc 杂色

**视觉 Harness (DESIGN.md)**:
主管为 Agent 设立的物理视觉约束字典，强制 Agent 在写样式前通过 `read_file` 物理点开查阅并锚定。
_Avoid_: 口头审美要求, 提示词自由发挥

**Grill-Me 追问范式**:
使用反向面试的思考路径，让 Agent 主动扮演考官，追问并锁定 Goal / Boundary / Risk / Stop 四大要素。
_Avoid_: 模糊需求, 凭空脑补

**Data Contract (数据契约)**:
在物理写界面代码前落盘的标准化 `mock-contract.json` 假数据结构文件，确保 UI 与未来 IT API 零缝隙无损对接。
_Avoid_: 随机内联字段, 临时假数据
