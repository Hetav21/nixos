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

## Project Docs

Load these on demand — only when the task touches their domain:

- **[docs/nx-commands.md](docs/nx-commands.md)** — `nx` command reference, testing changes, troubleshooting. Read before running any build/rebuild/maintenance command.
- **[docs/code-style.md](docs/code-style.md)** — naming conventions, the `mkModule` pattern, best practices. Read before writing or editing any module.
- **[docs/operations.md](docs/operations.md)** — security rules and workflows: namespaces, flake inputs, overlays, packages, secrets.
- **[docs/agent-environment.md](docs/agent-environment.md)** — declarative agent tooling (`~/.claude`, OpenCode, MCP) via `programs.agent-resources` and the nix-skills flake.
- **[modules/AGENTS.md](modules/AGENTS.md)** — module operations, config conversions.
- **[pkgs/AGENTS.md](pkgs/AGENTS.md)** — custom package definition.
- **[hosts/AGENTS.md](hosts/AGENTS.md)** — profile and host operations.
- **[secrets/README.md](secrets/README.md)** — secret management with sops-nix.
- **[templates/AGENTS.md](templates/AGENTS.md)** — project templates and `mkProjectEnv` dev shells. Read when creating or editing `templates/`.

## Docs Maintenance

- Docs carry stable contracts, workflows, and gotchas only. Never copy volatile
  facts (host lists, input lists, command tables, config snippets) — point to
  the owning file on a `Source of truth:` line. Fenced examples are illustrative.
- One owning doc per topic; other docs link to it instead of restating.
- If your change touches a file named on a `Source of truth:` line, update that
  doc's owning section in the same commit (grep `*.md` for the path).
- On doc-vs-code conflict, code wins — fix the doc.
- Write illustrative paths as `<placeholders>` (e.g. `pkgs/<name>/default.nix`);
  real backticked repo paths and links are validated by `nix flake check`.
