# Plan: Claude Resources Refactor

## Context

### Original Request
Refactor Claude resources to unify User/Project logic, make User logic modular, and ensure "Robust" Project implementation. Clean up git history.

### Interview Summary
**Key Discussions**:
- **Reset**: Hard reset to `d99f53e` (Done).
- **Architecture**: Core logic in `lib/claude.nix` (`buildAssets`), used by both Home Module and Project Shell.
- **Project Edit Strategy**: `cp -rn` (No overwrite) + `chmod -R u+w` (Writable).
- **Input Strategy**: Flake Inputs (Robust) + String resolution (Convenience). No impure fetching.

### Metis Review
**Identified Gaps** (addressed):
- **Permission Issue**: Added `chmod -R u+w` to ensure copied files are editable.
- **Stale Files**: Acknowledged `cp -n` limitation (updates require manual deletion). Accepted trade-off for "No Overwrite".
- **Structure**: `buildAssets` returns a single derivation with `skills/`, `agents/`, etc.

---

## Work Objectives

### Core Objective
Unify Claude resource handling into a robust library that powers both user-level configuration (Home Manager) and project-level environments (Nix Shell).

### Concrete Deliverables
- `lib/claude.nix`: Enhanced with `buildAssets`, `mkProjectEnv`, and input resolution.
- `modules/home/claude-resources.nix`: Refactored to use `buildAssets`.
- `templates/`: Updated `project-env` template to use the new system.

### Definition of Done
- [ ] `nx rebuild switch` works for global resources.
- [ ] `nix develop` in a template populates `.claude/` correctly.
- [ ] Edits in `.claude/` are preserved across shell restarts.
- [ ] `chmod -R u+w` ensures files are editable.

### Must Have
- [x] Robust Input Resolution (Strings -> Inputs).
- [x] Single source of truth for "Flattening" logic.
- [x] Write permissions on project files.

### Must NOT Have (Guardrails)
- [x] No `symlink` for project files (must be copied).
- [x] No `impure` fetching in core logic.

---

## Verification Strategy

### Manual QA
- **User Level**: `nx rebuild switch` -> Check `~/.claude/skills` symlinks.
- **Project Level**:
  1. `nix develop` -> Check `.claude/skills` exists.
  2. Edit a file in `.claude/skills`.
  3. Exit and `nix develop` again.
  4. Verify edit is preserved.

---

## Task Flow

```
1. Refactor lib/claude.nix (Core Logic)
   ↓
2. Update Home Module (User Level)
   ↓
3. Update Project Template (Project Level)
```

---

## TODOs

- [ ] 1. Refactor `lib/claude.nix` - Core Assets Builder

  **What to do**:
  - Implement `buildAssets`: Takes `agents`, `skills`, `commands`, `hooks`.
    - Returns derivation with `agents/`, `skills/`, etc.
  - Implement `mkProjectEnv`: Wrapper around `buildAssets` that returns a shell derivation with `shellHook`.
  - Ensure `flattenSkills` is applied to skills.
  - Ensure `resolveSource` is exposed and working.

  **References**:
  - `lib/claude.nix` (existing)
  - `modules/home/claude-resources.nix` (current implementation)

  **Acceptance Criteria**:
  - [ ] `buildAssets` produces a derivation.
  - [ ] `flattenSkills` logic works (moves `SKILL.md` dirs to root).

- [ ] 2. Export `lib` in `flake.nix`

  **What to do**:
  - Modify `flake.nix` outputs to expose `lib = extraLib;`.
  - This allows external flakes (like templates) to access `lib.claude`.

  **References**:
  - `flake.nix`

  **Acceptance Criteria**:
  - [ ] `nix flake show` lists `lib` as an output.

- [ ] 3. Refactor `modules/home/claude-resources.nix`

  **What to do**:
  - Replace manual `mkMerge` logic with `lib.claude.buildAssets`.
  - Symlink the result of `buildAssets` to `home.file.".claude".source`.

  **References**:
  - `lib/claude.nix:buildAssets`

  **Acceptance Criteria**:
  - [ ] `nx rebuild switch` passes.
  - [ ] `~/.claude` contains correct symlinks.

- [ ] 4. Create `templates/project-env`

  **What to do**:
  - Create directory `templates/project-env`.
  - Create `templates/project-env/flake.nix`.
  - **Inputs**: Add input for this repository (e.g., `inputs.dotfiles.url = "path:../../";` for local test, or git URL).
  - **Usage**: Use `dotfiles.lib.claude.mkProjectEnv` to build the shell.
  - Define example skills/agents.
  - Verify `shellHook` behavior.
  - Add to `templates/default.nix`.

  **References**:
  - `templates/shell/flake.nix` (as base)

  **Acceptance Criteria**:
  - [ ] `nix develop ./templates/project-env` creates `.claude/`.
  - [ ] `chmod +w` verified.
  - [ ] Re-entering shell does not overwrite.

---

## Commit Strategy

| After Task | Message | Files |
|------------|---------|-------|
| 1 | `feat(lib): refactor claude.nix with buildAssets and mkProjectEnv` | `lib/claude.nix` |
| 2 | `refactor(home): usage of lib.claude.buildAssets` | `modules/home/claude-resources.nix` |
| 3 | `feat(templates): update project-env to use robust mkProjectEnv` | `templates/project-env/flake.nix` |
