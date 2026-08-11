# 课程交付状态（COURSE_DELIVERY_STATUS）

本文件是课程交付状态的唯一进度权威，记录每课的材料完成度、试讲状态和已知问题。材料状态以仓库实际文件为准，试讲状态由试讲记录更新，不得虚构。

课程材料状态说明：
- 教师教案状态：不存在 / 草稿 / 已试讲 / 已发布
- 学员指南状态：不存在 / 草稿 / 已发布
- V2/V3 标注：历史候选 / 已归档 / 无
- 派生资产状态（HTML/图片/脚本）：不存在 / 已生成 / 已验证
- 试讲状态：未试讲 / 1对1已通过 / 全流程彩排已通过 / 小组试讲已通过

## 十课材料与试讲状态

| 课次 | 教师教案状态 | 学员指南状态 | V2/V3 标注 | 派生资产状态 | 试讲状态 | 已知问题 | 备注 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| L01 | 草稿 | 草稿 | 无 | 已生成（HTML + 流程图） | 未试讲 | 无 | `LESSON_01_TEACHER_PLAN.md`、`LESSON_01_GUIDE.md`、`lessons/0001-*.html`、`docs/assets/lesson-01/lesson-01-flow.png` |
| L02 | 草稿 | 草稿 | 无 | 已生成（HTML + 参考图） | 未试讲 | 无 | `LESSON_02_TEACHER_PLAN.md`、`LESSON_02_GUIDE.md`、`LESSON_02_MATERIALS_PACKAGE_ADDENDUM.md`、`lessons/0002-*.html`、`docs/assets/lesson-02/*` |
| L03 | 草稿 | 草稿 | 无 | 已生成（HTML） | 未试讲 | 无 | `LESSON_03_TEACHER_PLAN.md`、`LESSON_03_GUIDE.md`、`lessons/0003-*.html` |
| L04 | 草稿 | 草稿 | 历史候选（V2/V3） | 已生成（HTML） | 未试讲 | 存在 V2/V3 历史候选，尚未归档 | `LESSON_04_TEACHER_PLAN(_V2).md`、`LESSON_04_GUIDE(_V2/_V3).md`、`lessons/0004-*.html` |
| L05 | 草稿 | 草稿 | 历史候选（V2/V3） | 已生成（HTML） | 未试讲 | 存在 V2/V3 历史候选，尚未归档 | `LESSON_05_TEACHER_PLAN(_V2).md`、`LESSON_05_GUIDE(_V2/_V3).md`、`lessons/0005-*.html` |
| L06 | 草稿 | 草稿 | 历史候选（GUIDE_V3） | 已生成（HTML，含 v1 历史版本） | 未试讲 | 主目录 HTML 与 v1 历史版本并存，需确认归档关系 | `LESSON_06_TEACHER_PLAN.md`、`LESSON_06_GUIDE(_V3).md`、`lessons/0006-*.html`、`lessons/新建文件夹/0006-*-v1.html` |
| L07 | 草稿 | 草稿 | 历史候选（GUIDE_V3） | 已生成（HTML）；证据索引为占位 | 未试讲 | `LESSON_07_EVIDENCE_INDEX.md` 当前为占位内容，需补真实证据索引 | `LESSON_07_TEACHER_PLAN.md`、`LESSON_07_GUIDE(_V3).md`、`LESSON_07_EVIDENCE_INDEX.md`、`lessons/0007-*.html` |
| L08 | 草稿 | 草稿 | 历史候选（GUIDE_V3） | 已生成（HTML，位于 `lessons/新建文件夹/`） | 未试讲 | 派生资产目录需整理迁移 | `LESSON_08_TEACHER_PLAN.md`、`LESSON_08_GUIDE(_V3).md`、`LESSON_08_AUDIT_REPORT.md` |
| L09 | 草稿 | 草稿 | 历史候选（GUIDE_V3） | 已生成（HTML，位于 `lessons/新建文件夹/`） | 未试讲 | 派生资产目录需整理迁移 | `LESSON_09_TEACHER_PLAN.md`、`LESSON_09_GUIDE(_V3).md` |
| L10 | 草稿 | 草稿 | 历史候选（GUIDE_V3） | 已生成（HTML，位于 `lessons/新建文件夹/`） | 未试讲 | 派生资产目录需整理迁移；结业交付需按 CAPSTONE_RUBRIC 校验 | `LESSON_10_TEACHER_PLAN.md`、`LESSON_10_GUIDE(_V3).md` |

## 全局问题清单

- `verify-student-project.ps1` 不存在；课程验证方式以每课 acceptance rubric 与证据协议为准，不得引用遗留脚本。
- 旧 V2/V3 历史候选文件按 V2/V3 保护规则处理：不删除、不合并、不批量同步；归档方式待后续受控变更决定。
- 教师真实模型/API 调用完全在仓库外受控教师环境；本仓库与学员包只允许 Mock / 脱敏产物。
- `lessons/新建文件夹/` 中的 L08–L10 HTML 为派生资产候选，目录整理属未来受控变更，不在本文件范围内执行。

## 下一步行动

1. 按 LESSON_TEMPLATE 八模块结构逐课对齐教师教案（L1–L10），先 L1 后依序推进。
2. 教案通过独立复核 + 用户/课程负责人批准后，才更新学员指南（GUIDE）；GUIDE 通过一致性复核后，才更新派生资产。
3. 每课试讲后更新本文件试讲状态与已知问题；试讲记录须引用真实任务/线程运行证据，不得虚构。
4. L10 结业交付按 `docs/CAPSTONE_RUBRIC.md` 五维量表评价，评价结果记录到本文件或验收记录。
