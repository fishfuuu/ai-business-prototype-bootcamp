---
name: find-skills
description: Search, discover, and install specialized AI agent skills from open skills registries (e.g., skills.sh, vercel-labs/skills, anthropics/skills). Use when looking for new capabilities, testing tools, or specialized workflows.
---

# Find Skills (AI Agent Skill Discovery & Manager)

Use this skill when you need to find, evaluate, or install modular skills to extend Agent capabilities.

---

## 1. When to Use This Skill

Activate this workflow whenever:
* The user asks: "Find a skill for [X]", "How do I do [X]", or "Is there a skill for [X]?"
* You need specialized domain knowledge or workflows not present in your local skills directory.
* You want to discover community best-practice skills for testing, code review, or design token validation.

---

## 2. CLI Commands for Finding Skills

Run the following commands using terminal execution:

### Search for Skills
```bash
npx -y skills find <query>
```
*Example*: `npx -y skills find "design tokens"` or `npx -y skills find "playwright"`

### Add / Install a Skill
```bash
npx -y skills add <package-or-repo>
```
*Example*: `npx -y skills add vercel-labs/skills`

### Update Installed Skills
```bash
npx -y skills update
```

---

## 3. Evaluation & Safety Checklist

Before installing any third-party skill:
1. **Inspect SKILL.md**: Read the YAML frontmatter and instruction body.
2. **Check Scope & Guardrails**: Ensure the skill does not execute unverified binary scripts or modify root system files.
3. **Verify Compatibility**: Confirm it aligns with the local project structure (e.g., `CLAUDE.md`, `DESIGN.md`).
