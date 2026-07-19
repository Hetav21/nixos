# Agent Environment Configuration

AI agent tooling (Claude Code, Codex, OpenCode) is configured in `modules/home/development/agents.nix` (module `home.development.agents`). Shared agent resources are managed declaratively in `~/.agents/` via the external [nix-skills](https://github.com/Hetav21/nix-skills) flake, imported as `inputs.nix-skills.homeManagerModules.default` in `modules/home/default.nix`.

**Source of truth:** `modules/home/development/agents.nix` — the single site wiring agent packages, resources, OpenCode, MCP, and Claude settings. Read it for the current entries; this doc describes the mechanism only.

## Directory Structure

| Path                  | Description                            |
| --------------------- | -------------------------------------- |
| `~/.agents/commands/` | Custom slash commands (`/<cmd>`)       |
| `~/.agents/skills/`   | Skill definitions (`<skill>/SKILL.md`) |
| `~/.agents/agents/`   | Agent definitions (`<agent>.md`)       |
| `~/.agents/hooks/`    | Hooks configuration                    |

Only `~/.claude/settings.json` and `~/.claude/.mcp.json` are managed under `~/.claude/` — the rest of that directory is Claude Code's mutable state.

## Adding Resources

Resources (commands, skills, agents, hooks) are declared via `programs.agent-resources` in `modules/home/development/agents.nix`. Each entry is a package (or an extracted subdirectory of one). Shape (illustrative — see `agents.nix` for the current entries):

```nix
programs.agent-resources = {
  enable = true;
  skills = [
    (inputs.nix-skills.lib.extract pkgs pkgs.custom.<source> "<subdir>" {
      includes = ["<entry>"];
    })
  ];
  # same shape for commands, agents, hooks
};
```

Workflow for a new upstream source:

1. Add the repository as an input to the `pkgs/agent-sources` sub-flake and update its lockfile (see **[pkgs/AGENTS.md](../pkgs/AGENTS.md)** — the sub-flake and root flake must be updated in the right order).
2. Wrap it as a package under `pkgs/<source-name>/` so it's exposed as `pkgs.custom.<source-name>`.
3. Reference it in `programs.agent-resources` in `agents.nix`, using `extract` to cherry-pick paths.

## nix-skills Library Functions

Provided by the `nix-skills` flake input:

- **`extract pkgs src "path" { includes = [...]; excludes = [...]; }`**: Extracts a subdirectory from a source package, optionally filtering entries.
- **`toClaudeMcpServers`**: Converts the shared MCP server definitions (`dotfiles/.config/mcp/mcp.json`) into Claude Code's `.mcp.json` format. Used in `agents.nix` to generate `~/.claude/.mcp.json`.

## Other Managed Pieces (`agents.nix`)

- **Packages**: `claude-code` and `codex` come from the `inputs.llm-agents` flake (binary-cached).
- **OpenCode**: `programs.opencode` with model settings substituted from `settings.opencode.*`; oh-my-opencode preset config generated from `dotfiles/.config/opencode/oh-my-opencode-slim.json`.
- **MCP**: `programs.mcp` shares server definitions from `dotfiles/.config/mcp/mcp.json` across tools.
- **Claude settings**: `~/.claude/settings.json` is symlinked from `dotfiles/.claude/settings.json`.
