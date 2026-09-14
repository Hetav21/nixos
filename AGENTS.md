# AGENTS.md

Behavioral guidelines to reduce common LLM coding mistakes. Merge with project-specific instructions as needed.

**Tradeoff:** These guidelines bias toward caution over speed. For trivial tasks, use judgment.

## 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:
- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

## 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:
- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:
- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.

## 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:
- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:
```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

---

**These guidelines are working if:** fewer unnecessary changes in diffs, fewer rewrites due to overcomplication, and clarifying questions come before implementation rather than after mistakes.

---

## 5. Planning & Preflight

- Establish explicit scope and verifiable acceptance criteria before editing.
- Explicitly declare `spec review mode` (`per-task` or `final-only`) and `execution mode` (`interactive` or approved autonomous).
- **Branch Preflight:** In accordance with [docs/operations.md](docs/operations.md), **never make changes directly on `main`**. Ensure a dedicated feature branch is checked out (`git switch -c <branch>`) before making any modifications.

## 6. Parallelism & Delegation

- Parallel subagents are permitted only when their file write scopes are strictly non-overlapping; sequence overlapping writes.
- The primary agent or validation owner confirms the integrated result rather than assuming delegated success.

## 7. Review & Verification

- Execute a two-phase review:
  1. **Phase 1: Spec Compliance Review** — verify requested behavior, exact file paths, safety, and acceptance criteria.
  2. **Phase 2: Code-Quality Review** — verify Nix module style (`extraLib.modules.mkModule`), formatting, and absence of regressions.
- **Command-Level Evidence:** Never claim task completion without running relevant Nix verification commands (e.g. `nix eval`, `nix flake check`, or `nh os test`) and reporting verbatim output.

## 8. Completion & Release Gates

- Explicit human approval is required prior to:
  - `git commit`, `git push`, or Pull Request creation.
  - Destructive Git operations (`git reset`, `git clean`, deleting files).
  - Permanent system activation (`nh os switch` or `sudo nixos-rebuild switch`).
- Keep implementation and release decisions separate.

## 9. Safety & Authentication Invariant

- Authentication is strictly human-controlled. Stop immediately and hand off to the human when SSH keys, GPG signing, GitHub login, or token refresh is needed.
- Never inspect, request, copy, or log plaintext age keys (`~/.config/sops/age/keys.txt`, `/var/lib/sops-nix/key.txt`) or decrypted sops secret content.

---

## Project Docs

Load these on demand — only when the task touches their domain:

- **[docs/project-context.md](docs/project-context.md)** — Repository topography, component boundaries, ownership, and security contracts.
- **[docs/commands.md](docs/commands.md)** — Command reference (`nh` & raw `nix`), testing changes, troubleshooting. Read before running any build/rebuild/maintenance command.
- **[docs/code-style.md](docs/code-style.md)** — naming conventions, the `mkModule` pattern, best practices. Read before writing or editing any module.
- **[docs/operations.md](docs/operations.md)** — security rules and workflows: namespaces, flake inputs, overlays, packages, secrets.
- **[docs/agent-environment.md](docs/agent-environment.md)** — declarative agent tooling (`~/.claude`, OpenCode, MCP) via `programs.agent-resources` and the nix-skills flake.
- **[docs/neovim-keybinds.md](docs/neovim-keybinds.md)** — declarative Neovim keybindings and plugin reference.

## Docs Maintenance

- Docs carry stable contracts, workflows, and gotchas only. Never copy volatile
  facts (host lists, input lists, command tables, config snippets) — point to
  the owning file on a `Source of truth:` line. Fenced examples are illustrative.
- One owning doc per topic; other docs link to it instead of restating.
- If your change touches a file named on a `Source of truth:` line, update that
  doc's owning section in the same commit (grep `*.md` for the path).
- On doc-vs-code conflict, code wins — fix the doc.
- Write illustrative paths as `<placeholders>` (e.g. `pkgs/<name>/default.nix`).
