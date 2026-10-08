# Agent Environment Configuration

AI agent tooling (Claude Code, Codex, OpenCode, Antigravity) is configured in `src/modules/home/development/agents.nix` (module `home.development.agents`). Shared agent resources are managed declaratively across agent skill directories via the external [nix-skills](https://github.com/Hetav21/nix-skills) flake, imported as `inputs.nix-skills.homeManagerModules.default` in `src/modules/home/default.nix`.

**Source of truth:** `src/modules/home/development/agents.nix` — the single site wiring agent packages, resources, OpenCode, MCP, and Claude settings. Read it for the current entries; this doc describes the mechanism only.

## Directory Structure & Agent Targets

When `programs.agent-resources` is active, skills and agent resources are synchronized across their respective agent locations:

| Path                  | Agent Target                  | Description                            |
| --------------------- | ----------------------------- | -------------------------------------- |
| `~/.agents/commands/` | OpenCode / Universal (`agents`) | Custom slash commands (`/<cmd>`)       |
| `~/.agents/skills/`   | OpenCode / Universal (`agents`) | Skill definitions (`<skill>/SKILL.md`) |
| `~/.agents/agents/`   | OpenCode / Universal (`agents`) | Agent definitions (`<agent>.md`)       |
| `~/.agents/hooks/`    | OpenCode / Universal (`agents`) | Hooks configuration                    |
| `~/.claude/skills/`   | Claude Code (`claude`)        | Skill definitions (`<skill>/SKILL.md`) |
| `~/.codex/skills/`    | OpenAI Codex (`codex`)        | Skill definitions (`<skill>/SKILL.md`) |
| `~/.gemini/skills/`   | Antigravity (`gemini`)        | Skill definitions (`<skill>/SKILL.md`) |

Only `~/.claude/settings.json`, `~/.claude/.mcp.json`, and `~/.claude/plugins/known_marketplaces.json` are managed under `~/.claude/` — the rest of that directory is Claude Code's mutable state.

## Adding Resources

Resources (commands, skills, agents, hooks) are declared via `programs.agent-resources` in `src/modules/home/development/agents.nix`. Each entry is a package (or an extracted subdirectory of one). Shape (illustrative — see `agents.nix` for the current entries):

```nix
programs.agent-resources = {
  enable = true;
  targets = {
    agents = true;
    claude = true;
    codex = true;
    gemini = true;
  };
  skills = [
    (inputs.nix-skills.lib.extract pkgs pkgs.custom.<source> "<subdir>" {
      includes = ["<entry>"];
    })
  ];
  # same shape for commands, agents, hooks
};
```

Workflow for a new upstream source:

1. Add the repository as an input to the `src/pkgs/agent-sources` sub-flake and update lockfiles in order: first update the sub-flake lockfile (`nix flake lock --update-input <source-name> /etc/nixos/src/pkgs/agent-sources`), then update the root flake lockfile (`nix flake lock --update-input agent-sources /etc/nixos`).
2. Wrap it as a package under `src/pkgs/<source-name>/` so it's exposed as `pkgs.custom.<source-name>`.
3. Reference it in `programs.agent-resources` in `agents.nix`, using `extract` to cherry-pick paths.

## nix-skills Library Functions

Provided by the `nix-skills` flake input:

- **`mkEnvironment pkgs { inputs, agents, skills, commands, hooks, targets }`**: Evaluates sources and builds the `home.file` attribute mapping across target directories (`.agents`, `.claude/skills`, `.codex/skills`, `.gemini/skills`).
- **`extract pkgs src "path" { includes = [...]; excludes = [...]; }`**: Extracts a subdirectory from a source package, optionally filtering entries.
- **`flattenSkills pkgs src`**: Recursively finds `SKILL.md` files and flattens directory structures into single-depth folders based on skill folder basenames.
- **`toClaudeMcpServers`**: Converts the shared MCP server definitions (`assets/dotfiles/.config/mcp/mcp.json`) into Claude Code's `.mcp.json` format. Used in `agents.nix` to generate `~/.claude/.mcp.json`.

## Other Managed Pieces (`agents.nix`)

- **Packages**: AI agent CLIs (e.g. `claude-code`, `codex`, `coderabbit-cli`, `antigravity-cli`) come from `pkgs.llm-agents.*` via the `llm-agents` overlay (binary-cached from `cache.numtide.com`).
- **OpenCode**: `programs.opencode` with model settings substituted from `settings.opencode.*`; oh-my-opencode preset config generated from `assets/dotfiles/.config/opencode/oh-my-opencode-slim.json`.
- **MCP**: `programs.mcp` shares server definitions from `assets/dotfiles/.config/mcp/mcp.json` across tools.
- **Claude settings**: `~/.claude/settings.json` is symlinked from `assets/dotfiles/.claude/settings.json`.
