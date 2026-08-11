# 第九课学员操作指南 — 业务 Agent 场景判断与产品设计：确定性逻辑切割与 Mock 降级保护桥梁

> 💡 **本课的核心思想只有一句话：**  
> **算术归算术，生成归生成；API MCP 插座挂载，Mock 降级演练绝不白屏！**

---

## 一、 本课背景、底层原理与学习目标

### 1.1 业务背景与真实痛点
在原型开发进入尾声、向老板或 IT 部门汇报演练时，最常遇到的两个死穴是：
1. **逻辑混淆算错账**：把订单计算、折扣扣减、权限判定等本该 100% 确定性的逻辑丢给 AI 生成，导致 AI 概率性算出错账。
2. **外部接口宕机导致白屏崩盘**：汇报现场网络卡顿、真实 API 接口超时或抛出 500 报错，导致前端页面整个白屏崩盘，项目惨遭打回。

### 1.2 宏观受控闭环与 Mock 降级保护流转
本课将引入 **确定性与概率性逻辑切割 (Deterministic vs Probabilistic Logic Split)**、**API MCP 插座 (API MCP Socket)** 与 **Mock 降级保护桥梁 (Mock Fallback Bridge)**，将系统纳入一条**“逻辑硬核切割 ➔ API MCP 抓取数据 ➔ 超时自动降级 Mock 本地底稿 ➔ 确定性代码计算 ➔ 0 白屏演练汇报”**的受控闭环中：
1. **确定性与概率性逻辑切割**：所有数值计算、状态流转统一由 TypeScript 代码硬核执行（零随机度）；LLM 仅负责智能文本生成与推荐，且必须经过 Schema 校验与 HITL 主管确认。
2. **API MCP 插座 (API MCP Server & Tooling Socket)**：为 Agent 挂载符合 MCP 规范的标准接口插座，实现前端与后端 Mock 数据契约的无缝对接。
3. **Mock 降级保护桥梁 (Mock Fallback Bridge)**：在数据请求层外包裹保护桥梁。外部 API 一旦响应超时 (>2000ms) 或报错，0.1 秒内无缝自动降级加载第 3 课 `src/mocks/prototype-data.ts` 静态数据，确保汇报演练 **0 白屏崩盘、100% 稳定**！

### 1.3 核心学习目标
完成本课实操后，你将能够：
1. 理解确定性逻辑与概率性逻辑的物理切割范式，将算钱与扣减交给 TypeScript 代码执行。
2. 掌握挂载 API MCP 插座，驱动 Agent 输出符合结构化 TypeScript 契约的 JSON 数据。
3. 掌握 Mock 降级保护桥梁的配置与演练，验证在 API 断网/超时场景下 0.1 秒无缝降级至本地底稿。

---

## 二、 💡 本课核心工程概念卡 (Core Concepts)

### 核心概念 1：Deterministic vs Probabilistic Logic Split (确定性规则与概率性生成逻辑切割)
- **硬核工程定义**：在系统设计中，将“数值计算、状态流转、权限判定”划归为结果 100% 确定、零随机度的经典代码逻辑（确定性）；将“文本生成、语义推演、智能总结”划归为 LLM 大模型逻辑（概率性）的架构隔离范式。
- **底层运作机制**：算术与条件分支由 TypeScript 函数直接执行；LLM 仅负责填空、生成与提取，且 LLM 输出结果必须经过 Schema 校验与 HITL 主管确认。
- **具象业务比喻**：**收银机计算器与前台推销员的分工** 🧮👨‍💼。算钱扣款用收银机（确定性），推销问候用推销员（概率性），推销员绝不能擅自算账扣钱。
- **IT 沟通场景**：“我们在架构上对确定性算式与概率性 AI 推演进行了物理切割，核心逻辑 100% 由 TypeScript 代码硬核保障。”

### 核心概念 2：API MCP Server & Tooling Socket (API MCP 接口插座与协议)
- **硬核工程定义**：符合 Model Context Protocol 规范的 API 连接插座，为 Agent 提供标准化获取外部数据、调用后端 Mock 接口与输出 TypeScript 结构化 JSON 的扩展接口。
- **底层运作机制**：Agent 通过 JSON-RPC 下发 API 请求 Tool Call，API MCP Server 代理请求后端服务并将数据按契约 Schema 解包返回。
- **具象业务比喻**：**墙上的标准三孔电源插头与插座** 🔌。无论是接入 Mock 数据源还是真实 API 数据库，只需插上 MCP 插座，Agent 即可即插即用获取数据。
- **IT 沟通场景**：“我们的 AI 原型通过标准 API MCP 插座连接了后端 Mock 接口，实现了前端 UI 与后端数据契约的无缝对接。”

### 核心概念 3：Mock Fallback Bridge (Mock 降级保护桥梁)
- **硬核工程定义**：在外部 API 接口出现超时、断网、4xx/5xx 报错或格式异常时，系统自动捕抓异常并在 0.1 秒内回退加载第 3 课 `src/mocks/prototype-data.ts` 本地静态数据的容错机制。
- **底层运作机制**：在数据请求层外包裹 `try-catch-fallback` 保护桥梁。只要 API 抛错或响应超过 2000ms，熔断器自动触发并无缝加载本地底稿数据，Console 抛出降级警告。
- **具象业务比喻**：**大厦的双路供电与备用发电机** ⚡。主电网（外部 API）一旦停电，备用发电机（Mock 数据）0.1 秒自动启动，大楼灯火通明、演练绝不出错。
- **IT 沟通场景**：“原型部署了 Mock 降级保护桥梁，即便外部 API 崩溃，演示依然能依靠本地底稿 100% 稳定运行。”

---

## 三、 🧠 流程图三层元模式 (Diagram Meta-Pattern)

### 模式 A (痛点反例)：把算钱全交给 AI 导致算错账 + 外部 API 崩掉导致全页白屏崩溃
```text
┌─────────────────────────────────────────────────────────────┐
│ ❌ 痛点反例：未切割逻辑 + 无降级保护                       │
│ 叫 AI“帮我算订单总价” ➔ AI 概率性算出错账或漏折扣 💥        │
│ 汇报时外部 API 超时 ➔ 前端网络抛错 ➔ 全页白屏打回惨崩 💥    │
└─────────────────────────────────────────────────────────────┘
```

### 模式 B (受控流转图)：确定性切割 + API MCP 插座 + Mock 降级保护桥梁
```text
                  ┌──────────────────────────────┐
                  │ 1. 下发 API 请求指令         │
                  │    挂载 API MCP 插座         │
                  └──────────────┬───────────────┘
                                 │
                  ┌──────────────▼───────────────┐
                  │ 2. 发起 API 数据抓取          │
                  │    超时设置: 2000ms          │
                  └──────────────┬───────────────┘
                                 │
                  ┌──────────────┴───────────────┐
                  ▼                              ▼
        【API 响应正常 200 OK】        【API 超时/断网/500 报错】
                  │                              │
                  ▼                              ▼
        渲染真实 API 返回 JSON          0.1s 触发 Mock Fallback 桥梁
                  │                     自动加载 prototype-data.ts
                  │                              │
                  └──────────────┬───────────────┘
                                 ▼
                    【确定性代码做数值计算/状态扣减】
                                 │
                                 ▼
                    【LLM 仅生成文本摘要/推荐语】
                                 │
                                 ▼
                    【主管 HITL 确认 ➔ 归档】
```

### 模式 C (三层调试架构图解)：Mock 降级熔断器视效图解
```text
┌─────────────────────────────────────────────────────────────┐
│ 1. 优先层 (Primary): API MCP 接口插座 (http://127.0.0.1:3000)│
├─────────────────────────────────────────────────────────────┤
│ 2. 降级层 (Fallback): Mock 备用发电机 (src/mocks/prototype-data.ts)│
├─────────────────────────────────────────────────────────────┤
│ 3. 计算层 (Deterministic): TS 确定性计算 (Math.round / sum) │
└─────────────────────────────────────────────────────────────┘
```

---

## 四、 🛠️ 课堂实操与自学导引任务清单

### Task 1: 确定性与概率性逻辑切割实操

#### ⚡ 极速操作步骤
1. 打开 CLI 窗口，下发逻辑切割指令：
   ```text
   执行逻辑切割：算术与扣减归 TypeScript 代码，摘要推荐归 LLM
   ```
2. AI 将自动重构代码，把价格与折扣计算隔离给 TypeScript `calculateTotal()` 确定性函数。

#### 💡 独立自学原理解析
> **为什么要进行“逻辑切割”？**  
> LLM 的底层物理本质是概率预测，绝对不能让它去算钱或判定敏感权限。把算术交给 TypeScript 确定性代码，能确保结果 100% 准确、零随机波动。

---

### Task 2: 挂载 API MCP 插座连接后端 Mock 数据接口

#### ⚡ 极速操作步骤
1. 在 CLI 窗口下发 API MCP 插座挂载口令：
   ```text
   唤醒 API MCP 插座，连接后端 Mock 结构化数据
   ```
2. Agent 将自动挂载 API MCP Server，请求后返回与 `prototype-data.ts` 契约匹配的结构化 JSON。

---

### Task 3: 触发 Mock Fallback Bridge (2000ms 物理超时熔断与 Schema 残缺防护)

#### ⚡ 极速操作步骤
1. 在 CLI 窗口下发模拟降级演练口令：
   ```text
   模拟 API 故障，触发 Mock 降级保护桥梁测试
   ```
2. 观察控制台输出 `[WARN] API Timeout (2000ms) or Null Schema. Falling back to src/mocks/prototype-data.ts`，页面在 0.1 秒内无感加载本地底稿，无任何白屏崩盘！

#### 💡 2000ms 物理超时熔断器代码范式 (AbortController)
```typescript
// 物理级 2000ms 超时熔断器 + Schema 校验保护范式
async function fetchWithFallback(url: string) {
  const controller = new AbortController();
  const timeoutId = setTimeout(() => controller.abort(), 2000); // 2000ms 强制硬熔断

  try {
    const res = await fetch(url, { signal: controller.signal });
    clearTimeout(timeoutId);
    if (!res.ok) throw new Error(`HTTP Error ${res.status}`);
    
    const data = await res.json();
    // Schema 残缺字段校验防崩保护
    if (!data || !data.totalAmount) throw new Error("Invalid Schema: missing totalAmount");
    
    return data;
  } catch (err) {
    clearTimeout(timeoutId);
    console.warn("⚠️ [WARN] API Failed or Timeout (2000ms). Triggering Mock Fallback Bridge!");
    // 0.1s 无感切回本地底稿 src/mocks/prototype-data.ts
    return prototypeData; 
  }
}
```

---

## 五、 💡 常见概念误区与正确理解 (Mindset Transformation)

| 常见误区 (Misconception) | 正确硬核理解 (Correct Engineering Reality) | 如何纠偏与护栏防护 (Remedy & Guardrails) |
| :--- | :--- | :--- |
| **误区 1：“大模型功能强大，可以顺便把订单金额和扣费给算了”** | LLM 是概率语言模型，计算结果存在随机波动，绝对不能用于财务或权限计算。 | 实施确定性逻辑切割，计算逻辑 100% 交给 TypeScript 函数。 |
| **误区 2：“向老板汇报演示时，只要网络通畅就不需要准备 Mock”** | 外部 API 随时可能出现超时或 500 报错，无降级保护的演示等同于走钢丝。 | 配置 Mock Fallback Bridge，设定 2000ms 超时熔断降级。 |
| **误区 3：“API 降级后页面会报错崩溃，影响演示效果”** | Mock 降级桥梁在 0.1 秒内无感切回本地静态底稿，UI 界面依然 100% 完美呈现。 | 捕获 API 异常，静默无缝加载 `src/mocks/prototype-data.ts`。 |

---

## 六、 ❓ 常见操作报错与 Troubleshooting 指南

| 报错/异常现象 | 物理原因 | 解决与纠偏方案 |
| :--- | :--- | :--- |
| API 发生降级后页面出现空白 | 降级函数未返回 `prototypeData` 缺省对象 | 检查 `try-catch-fallback` 逻辑，确保 fallback 返回非空底稿。 |
| LLM 尝试修改确定性计算函数 | Prompt 提示词引导过度 | 下发逻辑切割保护口令，锁死 `calculateTotal()` 函数只读。 |

---

## 七、 📝 巩固与退场测试题库 (4 题精选)

### 阶段 1：课堂退场盖章测试 (Exit Ticket)
1. **[概念填空题]** 在系统设计中，将数值计算交给经典代码、将文本生成交给 LLM 的架构范式被称为 ____________。
2. **[选择题]** 当外部 API 响应超时 (>2000ms) 时，Mock 降级保护桥梁会在多长时间内无感切回本地底稿？ ____________。
   - A. 0.1 秒 (无感降级，演示不白屏)
   - B. 30 秒
   - C. 直接弹窗报错崩溃
3. **[IT 沟通场景题]** 当 IT 部门询问“如果演示现场断网或后端 API 宕机，你们的原型如何保证不白屏”时，你应该如何向他们汇报？
   - **参考回答**：“原型配置了标准 API MCP 插座，并部署了 Mock 降级保护桥梁 (Mock Fallback Bridge)。一旦外部 API 响应超时或报错，系统会在 0.1 秒内无缝降级渲染本地 `src/mocks/prototype-data.ts` 静态底稿，确保汇报演练 0 白屏崩盘、100% 稳定运行。”
