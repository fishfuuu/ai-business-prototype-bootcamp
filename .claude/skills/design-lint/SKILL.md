---
name: design-lint
description: Audit Vue and CSS files in the project for Design System compliance (DESIGN.md). Checks for hardcoded hex/rgb colors, invalid grid spacing, and unauthorized inline styles. Output a compliance report.
---

# Design System Compliance Audit Skill (design-lint)

Use this skill to perform a non-destructive design compliance audit on Vue/CSS prototype files.

---

## 1. When to Use This Skill

Activate this skill during **Lesson 02 Task 4 (Visual Verification)** or whenever validating whether code strictly adheres to `DESIGN.md`.

---

## 2. Audit Rules

Inspect the target Vue and CSS files against the following 3 strict rules:

### Rule 1: No Hardcoded Hex/RGB Colors
* **Violation**: Any raw hex color (e.g., `#1890ff`, `#333333`) or `rgb(...)` / `rgba(...)` in template inline styles or `<style>` blocks.
* **Requirement**: Colors MUST use `--art-*` tokens (e.g., `--art-primary`, `--art-card-bg`, `--art-text-main`) or Element Plus system variables.

### Rule 2: Grid Spacing Compliance
* **Violation**: Margins, paddings, or border-radii using non-standard pixel values (e.g., `margin-top: 15px`).
* **Requirement**: Spacing must adhere to 8px / 12px / 16px / 24px grid rules or `--art-spacing-*` / `--art-radius-*` tokens.

### Rule 3: Component Class Protection
* **Violation**: Unscoped CSS rules trying to override `.el-card` or `.el-button` global component themes directly without using CSS variables.

---

## 3. Output Format

Print the compliance audit report in the following format:

```markdown
========================================
🎨 DESIGN SYSTEM COMPLIANCE AUDIT REPORT
========================================

Target File: [Path to Vue/CSS file]
Spec Reference: DESIGN.md

[PASS / FAIL] Color Token Compliance: [Details]
[PASS / FAIL] Grid Spacing Compliance: [Details]
[PASS / FAIL] Component Class Protection: [Details]

Audit Result: [PASS / ACTION REQUIRED]
========================================
```
