---
name: find-skills
description: Helps users discover and install agent skills when they ask questions like "how do I do X", "find a skill for X", "is there a skill that can...", or express interest in extending capabilities. Supports Chinese input with auto-translation to English.
---

# Find Skills (Windows Version)

Helps users discover and install agent skills from the open ecosystem when they need new capabilities.

## When to Use

Activate this skill when users:
- Ask "how do I do X" or "can you do X" for specialized tasks
- Request "find a skill for X"
- Want to extend agent capabilities in specific domains
- Use Chinese keywords to search (auto-translate to English)

## Core Workflow

### 1. Handle Chinese Input

If user input contains Chinese, translate it to English first:

| Chinese | English |
|---------|---------|
| 网页开发 | web development |
| 测试 | testing |
| 部署 | deploy |
| 文档 | documentation |
| 代码审查 | code review |
| 设计 | design |
| 工作流 | workflow |

Example: User asks "找一个React测试的skill" → Search for "react testing"

### 2. Search for Skills

```powershell
npx skills find [query]
```

Or in CMD:
```cmd
npx skills find [query]
```

### 3. Present Results

For each result, provide:
- Skill name and purpose
- Installation command
- Link to https://skills.sh/ for details

### 4. Install if Requested

```powershell
npx skills add <owner/repo@skill> -g -y
```

## Common Search Categories

| Category | Keywords |
|----------|----------|
| Web Dev | react, nextjs, vue, angular, frontend |
| Testing | jest, playwright, cypress, testing |
| DevOps | deploy, docker, kubernetes, ci-cd |
| Documentation | readme, changelog, docs |
| Code Quality | review, lint, format |
| Design | ui, accessibility, css |
| Productivity | workflow, git, automation |

## Search Optimization Strategy

### Ranking Metrics

The skills.sh directory ranks skills by:

| View | Description | Use Case |
|------|-------------|----------|
| **All Time** | Total install count | Find proven, stable skills |
| **Trending (24h)** | Recent 24-hour activity | Discover new popular skills |
| **Hot** | Current trending | Find what's popular right now |

### Recommended Search Priority

1. **Prefer high-install skills** - Skills with 10K+ installs are battle-tested
2. **Check trending for new solutions** - Emerging skills may solve newer problems
3. **Prioritize verified sources** - `vercel-labs/agent-skills` is highly trusted

### Top Popular Skills (Reference)

| Rank | Skill | Installs | Use Case |
|------|-------|----------|----------|
| 1 | `vercel-react-best-practices` | 74.5K | React development |
| 2 | `find-skills` | 61.1K | Discover skills |
| 3 | `web-design-guidelines` | 56.5K | Web design |
| 4 | `remotion-best-practices` | 53.8K | Video creation |

### Search Tips

- **Use specific keywords** ("react testing" vs "testing")
- **Combine domain + action** ("nextjs deploy", "typescript lint")
- **Check https://skills.sh/** for browsing by category and popularity
- **Prefer skills from `vercel-labs`** - high quality, well-maintained

## Tips

- If nothing found, offer direct help or suggest creating a custom skill:
  ```powershell
  npx skills init
  ```

## Troubleshooting (Windows)

If `npx` is not recognized:
1. Ensure Node.js is installed: `node --version`
2. Ensure npm is in PATH: `npm --version`
3. Try running in PowerShell as Administrator

## Resources

- Browse all skills: https://skills.sh/
- Skills CLI documentation: `npx skills --help`
