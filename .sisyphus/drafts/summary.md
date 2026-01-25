## Plan Generated: claude-refactor

**Key Decisions Made:**
- **Edit Strategy**: `cp -rn` (No overwrite) + `chmod -R u+w`. Preserves edits, requires manual deletion for updates.
- **Architecture**: `lib/claude.nix` becomes the core, powering both Home Manager (User) and Shell (Project).
- **Input Strategy**: Pure Flake Inputs preferred. Strings resolved to inputs if possible.

**Scope:**
- IN: Refactoring `lib/claude.nix`, `modules/home/claude-resources.nix`, `templates/project-env`.
- OUT: `builtins.fetchTree` (Impure fetching rejected for robustness).

**Guardrails Applied:**
- Files in project env must be writable.
- No symlinks in project env (must be copied).

Plan saved to: `.sisyphus/plans/claude-refactor.md`
