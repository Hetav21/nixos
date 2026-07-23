# Disable oh-my-opencode-slim Built-in MCPs Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Disable built-in duplicate MCP servers in `oh-my-opencode-slim` and map agent configuration permissions to use custom servers from `mcp.json`.

**Architecture:** We will configure `"disabled_mcps"` globally and update agent presets in `oh-my-opencode-slim.json` to point to the user's `mcp.json` defined server names (`exa`, `grep`).

**Tech Stack:** OpenCode, NixOS, JSON

## Global Constraints
- Target configuration files must remain syntactically valid JSON.
- Only modify designated fields inside `oh-my-opencode-slim.json`.

---

### Task 1: Update OpenCode Plugin Config

**Files:**
- Modify: `dotfiles/.config/opencode/oh-my-opencode-slim.json`

**Interfaces:**
- Produces: Correctly configured `oh-my-opencode-slim.json` without built-in MCPs and with mapped agent permissions.

- [ ] **Step 1: Disable built-in MCPs and map agent access**
  Modify `dotfiles/.config/opencode/oh-my-opencode-slim.json` to add `"disabled_mcps"` at the root, and update `mcps` lists for agents (`oracle`, `librarian`, `explorer`) to map to user-defined servers (`exa` and `grep`).

  Here is the expected diff:
  ```diff
  {
    "preset": "openai",
    "disabled_agents": [],
  + "disabled_mcps": [
  +   "websearch",
  +   "context7",
  +   "grep_app",
  +   "gh_grep"
  + ],
    "presets": {
      "openai": {
        "orchestrator": {
          "model": "openai/gpt-5.6-terra",
          "skills": [
            "*"
          ],
          "mcps": [
            "*"
          ]
        },
        "oracle": {
          "model": "openai/gpt-5.6-sol",
          "variant": "high",
          "skills": [
            "simplify",
            "deslop",
            "receiving-code-review",
            "requesting-code-review",
            "workflow",
            "systematic-debugging",
            "codebase-design",
            "domain-modeling",
            "improve-codebase-architecture"
          ],
          "mcps": [
            "context7",
            "awslabs.aws-documentation-mcp-server",
            "aws-knowledge-mcp-server",
            "azure-devops",
  -         "websearch"
  +         "exa"
          ]
        },
        "librarian": {
          "model": "openai/gpt-5.6-luna",
          "variant": "low",
          "skills": [
            "find-skills",
            "using-superpowers",
            "research"
          ],
          "mcps": [
            "context7",
            "awslabs.aws-documentation-mcp-server",
            "aws-knowledge-mcp-server",
            "atlassian",
            "azure-devops",
  -         "websearch",
  -         "grep_app"
  +         "exa",
  +         "grep"
          ]
        },
        "explorer": {
          "model": "openai/gpt-5.4-mini",
          "variant": "low",
          "skills": [
            "find-skills",
            "wayfinder",
            "triage"
          ],
          "mcps": [
            "atlassian",
  -         "grep_app"
  +         "grep"
          ]
        },
  ```

- [ ] **Step 2: Validate JSON syntax**
  Run `jq . dotfiles/.config/opencode/oh-my-opencode-slim.json` to verify the configuration file is syntactically valid JSON.
  Expected Output: A clean, parsed JSON output without syntax errors.

- [ ] **Step 3: Commit changes**
  Run:
  ```bash
  git add dotfiles/.config/opencode/oh-my-opencode-slim.json
  git commit -m "config(opencode): disable omo-slim built-in mcps and map agent tools"
  ```
