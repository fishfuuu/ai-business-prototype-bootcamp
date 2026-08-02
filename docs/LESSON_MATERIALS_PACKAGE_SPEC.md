# 第二课材料覆盖包与备用包规范说明

本文档定义第二课 **材料增量覆盖包 (Materials Package)** 与 **备用起点包 (Fallback Package)** 的打包与注入规范。

---

## 1. 材料增量覆盖包 (`ai-business-prototype-lesson-02-materials-v0.1.0.zip`)

### 定位
专供 90% 学员在已有第一课自创项目上注入第二课指南与图卡材料。**绝对不包含 `src/**`，绝不覆盖学员已做好的页面**。

### 包内目录结构
```text
payload/
└── docs/
    ├── LESSON_02_GUIDE.md
    └── assets/
        └── lesson-02/
            ├── lesson-02-flow.png
            ├── ref-dashboard.png
            ├── ref-table-list.png
            └── ref-form-detail.png

metadata/
├── VERSION.txt
├── PACKAGE_MANIFEST.txt
└── SHA256SUMS.txt

install-lesson-materials.ps1
```

### 安装注入规则
1. 必须使用 `install-lesson-materials.ps1` 脚本进行解压注入；
2. 只允许复制 `payload/docs/**` 到学员项目的 `docs/` 目录；
3. `metadata/**` 只保留在安装临时目录，绝不复制到学员项目根目录；
4. 注入前后校验学员项目 `src/**` 哈希 100% 完全一致；
5. 将安装记录写入 `artifacts/lesson-02-evidence/materials-install-receipt.json`。

---

## 2. 备用起点包 (`ai-business-prototype-lesson-02-fallback-start-v0.1.0.zip`)

### 定位
仅用于缺席第一课或项目损坏学员（10%）的标准备用起点包。包含一个粗糙但完整的“订单超时预警台”种子页面供第二课美化。

### 生成与导出机制
1. 种子代码存放在仓库 `course-fixtures/lesson-02-fallback/` 目录；
2. 运行 `powershell -File .\scripts\export-student-package.ps1 -CourseState "lesson-02-fallback-start" -Version "v0.1.0" -PackageProfile "lesson-02-fallback-start"` 自动合并导出；
3. 不在仓库中维护第二套完整 Vue 3 工程。
