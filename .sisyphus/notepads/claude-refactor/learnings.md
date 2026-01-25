# Learnings from Claude Refactor

## 2026-01-25 - Project Environment Architecture

### Edit Strategy: `cp -rn` vs Symlinks
We chose `cp -rn` (copy without overwriting) for project environments instead of symlinks.
- **Why**: Users need to edit files in `.claude/` (e.g., tweaking an agent's prompt). Symlinks to the Nix store are read-only.
- **Trade-off**: Updates to the source flake do NOT propagate to existing files. Users must delete the local file to get the update. This was deemed acceptable for "scaffolding" behavior.
- **Safety**: `chmod -R u+w` is critical because `cp` from the Nix store preserves the read-only permission bit by default.

### Input Resolution
- **Strings**: We allow strings like "https://github.com/..." but rely on `resolveSource` (which maps to flake inputs) rather than `builtins.fetchTree` (impure).
- **Robustness**: This enforces that all sources are pinned in `flake.nix`, maintaining the hermetic properties of the build.

### Flattening Logic
- Claude Code requires a flat `skills/` directory where each subdir contains a `SKILL.md`.
- Repositories often nest skills (e.g., `skills/nested/my-skill`).
- **Solution**: We implemented `flattenSkills` in `lib/claude.nix` which recursively finds `SKILL.md` files and flattens the directory structure (e.g., `nested-my-skill`) into the output. This is now the "Single Source of Truth" for both user and project environments.

### Library Exposure
- Templates are external flakes. They cannot see internal `extraLib`.
- **Fix**: We exposed `lib` in `flake.nix` outputs (`outputs.lib = extraLib`). This allows templates to use `inputs.dotfiles.lib.claude.mkProjectEnv`.
