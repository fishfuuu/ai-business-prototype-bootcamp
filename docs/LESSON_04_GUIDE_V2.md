# 第四课学员操作指南 (GUIDE V2) — 受控 Agent 循环与 Working Tree 物理状态机

> **学习目标**：掌握受控 Agent 循环与“薄切片 (Thin Slices)”构建范式，学习如何通过状态机与 Working Tree 干净度控制，实现 AI 编程的无损存档与 1 秒还原。

---

## 💡 IT 跨界沟通术语卡：Working Tree (工作区 / 工作树)

- **标准 IT 术语**：`Working Tree` (工作区 / 工作树)
- **生活化通俗比喻**：**厨师切菜的砧板** 🔪
  - 砧板上有刚切好的菜（修改代码），此时砧板状态是 **Dirty（未打扫/有脏数据）**。
  - 菜切好装盘并盖章入库（Commit）后，砧板被洗干净，恢复 **100% Clean（干净状态）**。
  - 如果菜切坏了，把脏菜倒进垃圾桶冲洗砧板（Restore），也能立马恢复 **100% Clean**。
- **IT 沟通场景**：“请确保提交前 Working Tree 处于 Clean 干净状态，避免脏代码混入开发主干。”

---

## 🔄 薄切片受控流转模型

```
[契约交接 Pre-Plan Check] ➔ [下发口令: 同意保存实施计划] ➔ [生成 IMPLEMENTATION_PLAN.md]
                                                                        │
                                                                        ▼
[100% Clean Working Tree] ◄─── [跑 Commit A (源码) + Commit B (状态)] ◄─── [下发口令: 确认完成 Step 1]
                                                                        │ (代码变 Dirty)
                                                                        ▼
                                                          [界面调试器 prototypeState 检验]
```

---

## 🛠️ 学员实操任务清单

### Task 0: 启动工程与干净状态检查
1. 打开 VS Code 终端，启动本地开发服务器：
   ```powershell
   npm run dev
   ```
2. 确认 Working Tree 处于 Clean 干净状态：
   ```powershell
   git status
   ```
   *预期输出*：`nothing to commit, working tree clean`

---

### Task 1: 唤醒增量实施 Skill 并落盘实施计划
1. 在 Claude Code CLI 窗口中输入：
   ```text
   /incremental-implementation
   ```
2. AI 将自动对齐第三课的《业务功能卡》与数据契约文件，并在窗口中输出 3 步增量计划预览。
3. 检查预览无误后，下发自然授权口令：
   ```text
   同意保存实施计划
   ```
4. **验证产物**：工程中将自动落盘 [`docs/LESSON_04_IMPLEMENTATION_PLAN.md`](file:///d:/AILearning/docs/LESSON_04_IMPLEMENTATION_PLAN.md)，初始 Step 1 为 `READY`。

---

### Task 2: 授权执行 Step 1 薄切片编码
1. 在聊天窗口下发授权解锁口令：
   ```text
   确认完成 Step 1
   ```
2. AI 将在受控目录 `src/components/WorkOrderBoard.vue` 中写入 Step 1 薄切片代码， Working Tree 状态变为 `Dirty`。
3. 打开浏览器页面 `http://localhost:5173/`，验证 `prototypeState` 调试按钮：
   - 点击 `Loading`：展示加载骨架屏。
   - 点击 `Empty`：展示空数据占位。
   - 点击 `Error`：展示网络报错提示。
   - 点击 `Success`：展示正常工单列表。

---

### Task 3: 三层验收与双 Commit 物理归档
1. 观察控制台日志与页面点击无报错。
2. AI 在后台通过 Verifier 静默自测后，将自动执行：
   - **Commit A**：提交源码修改。
   - **Commit B**：更新 `LESSON_04_IMPLEMENTATION_PLAN.md` 状态机（Step 1 变为 `COMPLETED`，Step 2 变为 `READY`）。
3. 运行 Git 检查：
   ```powershell
   git status
   ```
   *预期结果*：Working Tree 重新恢复为 `100% Clean` 干净状态！

---

## ❓ 常见问题与纠偏 (Misconceptions)

| 误区 | 正确理解 | 纠偏动作 |
| :--- | :--- | :--- |
| 一次性让 AI 写完所有 Step | 风险极高，改崩后无法精准定责与恢复。 | 坚持每次只授权 1 个切片，确认无误再推进下一步。 |
| 页面技术状态与业务状态混淆 | `prototypeState` 是界面调试器，工单生命周期是业务状态。 | 点击 `prototypeState` 调试按钮，观察界面加载与业务解耦效果。 |

---

## 📝 课后退场测试 (Exit Ticket)

1. **[填空题]** 在增量实施范式中，菜切坏了或代码报错时，系统会自动导出 `.patch` 快照补丁，并将 Working Tree 物理恢复为 ____________ 干净状态。
2. **[IT 沟通场景题]** 当你需要向 IT 工程师解释为什么要分 Step 授权落盘时，你应该怎么说？
   - **参考回答**：“我们采用了 Step 级状态机与薄切片范式，每次授权一个可独立测试的增量切片，配合双 Commit 物理归档，确保 Working Tree 随时可退回 100% 干净状态。”
