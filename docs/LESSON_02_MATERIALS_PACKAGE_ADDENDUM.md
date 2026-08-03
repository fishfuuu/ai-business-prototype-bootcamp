# 第二课材料包附录 (LESSON_02_MATERIALS_PACKAGE_ADDENDUM)

> [!NOTE]
> 本文档是 [STUDENT_PACKAGE_SPEC.md](STUDENT_PACKAGE_SPEC.md) 的第二课材料包专用扩展附录。
> 当本文档与 `STUDENT_PACKAGE_SPEC.md` 发生冲突或描述不一致时，**必须以 `STUDENT_PACKAGE_SPEC.md` 的规定为准**。

---

## 1. 材料增量包定义与定位

材料增量包是用于在第二课主路径（90% 学员）中平滑注入第二课学员合一卡与脱敏参考图卡的小型 ZIP 文件。它**只包含只读文档与视觉资产**，绝不包含任何源代码（`src/**`）或脚本修改。

### 导出格式与路径
* **导出产物**：`artifacts/student-packages/ai-business-prototype-lesson-02-materials-v0.1.0.zip`
* **导出脚本**：`scripts/export-lesson-materials.ps1`

---

## 2. 包内目录与元数据结构

材料增量包采用标准的 `payload / metadata` 分离架构：

```text
ai-business-prototype-lesson-02-materials-v0.1.0/
├── install-lesson-materials.ps1             # 安全原子注入脚本
├── metadata/
│   ├── VERSION.txt                           # 包版本与构建元数据
│   ├── PACKAGE_MANIFEST.txt                  # 排序后的全量文件相对路径清单
│   └── SHA256SUMS.txt                        # 逐文件 SHA256 校验哈希表
└── payload/
    └── docs/
        ├── LESSON_02_GUIDE.md                # 第二课学员合一卡
        └── assets/lesson-02/
            ├── lesson-02-flow.png            # 第二课 Master 全景关系图
            ├── ref-monitor-decision.png      # 监控与决策页脱敏示范图卡
            ├── ref-task-workflow.png         # 任务与流程工作台脱敏示范图卡
            └── ref-operation-tool.png        # 操作工具与助手页脱敏示范图卡
```

### `VERSION.txt` 必需字段：
```text
Package: ai-business-prototype-lesson-02-materials
Version: v0.1.0
Repository Source Commit: <SourceRef 提交 SHA>
Built At UTC: <ISO 8601 UTC 时间>
Delivery Mode: Incremental Materials Overlay
```

---

## 3. 安全安装器 (`install-lesson-materials.ps1`) 4 级防御规则

为防止材料包注入损坏学员项目或造成混乱，`install-lesson-materials.ps1` 必须执行以下 4 级原子性拦截：

### 1. 目标工程合法性预检
解压后运行脚本，脚本自动校验当前运行目录。目标根目录必须同时存在以下 3 个文件：
- `package.json`
- `DESIGN.md`
- `docs/LESSON_01_GUIDE.md`

若缺少任一文件，脚本说明“目标目录不是合法的学员工程”，**立即终止**。

### 2. 同名文件冲突预检（无覆盖原则）
读取 `payload/docs/` 下的所有文件路径。对目标位置：
- 若文件不存在：记为待复制；
- 若文件已存在且内容 SHA256 哈希完全一致：记为可跳过；
- 若文件已存在但 SHA256 哈希不一致：**立即报错停止，严禁静默覆盖**。

### 3. 事务原子性复制与清理回滚
只有预检 100% 通过且 0 冲突后，才开始统一将 `payload/docs/**` 复制到目标工程的 `docs/` 目录。
若在复制过程中因权限或磁盘异常失败，脚本自动删除本次新创建的文件，恢复至安装前的工程状态。

### 4. `src/**` 精准清单防越界断言
安装器在复制前后分别记录 `src/**` 下所有文件的“排序后相对路径 + 逐文件 SHA256 清单”。
安装完成后对比清单，断言 `src/**` 保持 100% 零修改。

### 5. 安装回执保存路径
安装成功的回执文件保存至已被第一课 `.gitignore` 忽略的目录：
`local-backups/lesson-02-evidence/materials-install-receipt.json`
