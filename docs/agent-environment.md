# Agent Environment Configuration

AI agent tooling (Claude Code, Codex, OpenCode, OpenCode 2, Antigravity) is configured in `src/modules/home/development/agents.nix` (module `home.development.agents`). Shared agent resources are managed declaratively across agent skill directories via the external [nix-skills](https://github.com/Hetav21/nix-skills) flake, imported as `inputs.nix-skills.homeManagerModules.default` in `src/modules/home/default.nix`.

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

Under `~/.claude/` only `skills/` is managed; MCP servers are merged into the user scope of `~/.claude.json` at activation. Everything else there is Claude Code's mutable state.

## Adding Skills

Skills are declared declaratively via `programs.agent-skills` in `src/modules/home/development/agents.nix`. Each entry can be a direct package (auto-discovered and flattened) or a filtered spec:

```nix
programs.agent-skills = {
  enable = true;
  targets = {
    agents = true;  # ~/.agents/skills
    claude = true;  # ~/.claude/skills
    codex = true;   # ~/.codex/skills
    gemini = true;  # ~/.gemini/skills & ~/.gemini/antigravity-cli/skills
  };
  skills = [
    # 1. Direct package: recursively discovers and flattens SKILL.md
    pkgs.custom.agent-sources.emilkowalski-skills

    # 2. Filtered source with excludes
    {
      source = pkgs.custom.agent-sources.mattpocock-skills;
      excludes = [ "deprecated" "in-progress" ];
    }

    # 3. Filtered source with cherry-picked includes
    {
      source = pkgs.custom.agent-sources.anthropic-skills;
      includes = [ "docx" "pdf" "pptx" "xlsx" ];
    }
  ];
};
```

Workflow for a new upstream source:

1. Add the repository as an input to the `src/pkgs/agent-sources` sub-flake and update lockfiles in order: first update the sub-flake lockfile (`nix flake lock --update-input <source-name> /etc/nixos/src/pkgs/agent-sources`), then update the root flake lockfile (`nix flake lock --update-input agent-sources /etc/nixos`).
2. Wrap it as a package under `src/pkgs/agent-sources/default.nix` so it's exposed as `pkgs.custom.agent-sources.<source-name>`.
3. Reference it in `programs.agent-skills.skills` in `agents.nix` directly as a package or as a filtered source spec (`{ source, includes, excludes }`).

## nix-skills Library Functions

Provided by the `nix-skills` flake input:

- **`mkEnvironment pkgs { inputs, agents, skills, commands, hooks, targets }`**: Evaluates sources and builds the `home.file` attribute mapping across target directories (`.agents`, `.claude/skills`, `.codex/skills`, `.gemini/skills`).
- **`extract pkgs src "path" { includes = [...]; excludes = [...]; }`**: Extracts a subdirectory from a source package, optionally filtering entries.
- **`flattenSkills pkgs src`**: Recursively finds `SKILL.md` files and flattens directory structures into single-depth folders based on skill folder basenames.
- **`programs.agent-mcp`** and **`mcp.*`**: render one canonical `mcp.json` for Claude Code, OpenCode, Codex and Antigravity (see [MCP](#other-managed-pieces-agentsnix) below).

## Other Managed Pieces (`agents.nix`)

- **Packages**: AI agent CLIs (e.g. `claude-code`, `codex`, `coderabbit-cli`, `antigravity-cli`) come from `pkgs.llm-agents.*` via the `llm-agents` overlay (binary-cached from `cache.numtide.com`).
- **OpenCode**: `programs.opencode` with model settings configured in `.config/opencode/opencode.json`; oh-my-opencode preset config generated from `assets/dotfiles/.config/opencode/oh-my-opencode-slim.json`.
- **MCP**: one canonical `mcp.json` is the only place MCP servers are written; `programs.agent-mcp` (nix-skills) renders it into each agent's own format and location. The format, where each agent's copy lands, and how `{env:VAR}` references are translated are documented in the [nix-skills `AGENTS.md`](https://github.com/Hetav21/nix-skills/blob/main/AGENTS.md#mcp-servers-programsagent-mcp).
  - **Global**: `assets/dotfiles/.config/mcp/mcp.json`, passed as `programs.agent-mcp.file`. nix-skills runs `npx`/`bunx`/`uvx` commands from the Nix store, so GUI-launched agents don't depend on `PATH`.
  - **Per project**: put an `mcp.json` (same format) at the project root and run `agent-mcp sync`. It writes `.mcp.json`, `opencode.json` (`mcp` key only), `.codex/config.toml` (`mcp_servers` only) and `.agents/mcp_config.json`.
  - Gotcha: only OpenCode understands `{env:VAR}`; Claude Code gets `${VAR}` and Codex its env-forwarding keys, and a server an agent can't express is skipped for that agent with an evaluation warning. Antigravity can't send env-based headers at all.
