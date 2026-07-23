# Spec: Disable oh-my-opencode-slim Built-in MCPs

## Goal
Disable the duplicate built-in MCP servers automatically started by `oh-my-opencode-slim` (`websearch`, `context7`, `grep_app`, `gh_grep`), and configure the plugin's agent permissions to use the standard MCP server names defined in `mcp.json` (`exa`, `grep`, `context7`).

## Architecture & Design
The OpenCode plugin `oh-my-opencode-slim` launches duplicate MCP servers (e.g. `websearch` and `grep_app`) by default. Since the user's `mcp.json` already defines these MCP servers under the names `exa`, `grep`, and `context7`, we will:

1. Use the `"disabled_mcps"` configuration parameter in the root of `oh-my-opencode-slim.json` to disable the default/built-in servers.
2. Update the agent-specific `"mcps"` arrays inside `oh-my-opencode-slim.json` to map access permissions to the custom servers declared in `mcp.json` instead of the disabled built-ins.

### Files to Modify
- **[oh-my-opencode-slim.json](file:///etc/nixos/dotfiles/.config/opencode/oh-my-opencode-slim.json)**:
  - Add `"disabled_mcps": ["websearch", "context7", "grep_app", "gh_grep"]` at the root.
  - In `presets.openai.oracle.mcps`: Replace `"websearch"` with `"exa"`.
  - In `presets.openai.librarian.mcps`: Replace `"websearch"` with `"exa"`, and `"grep_app"` with `"grep"`.
  - In `presets.openai.explorer.mcps`: Replace `"grep_app"` with `"grep"`.

## Verification & Testing
- Validate that `oh-my-opencode-slim.json` parses as valid JSON.
- Verify agent configurations and ensure no syntax or loading errors.
