# Dynamic Project Templates with Agent Injection

## Context

### Original Request
The user wants a system to handle project-wise agents and skills (`./.claude/agents`, `./.claude/skills`) similar to the user-level system. This should be integrated into the existing `templates/` system so that initializing a new project (e.g., Python) automatically populates it with relevant agents (e.g., Python Expert).

### Interview Summary
**Key Discussions**:
- **Architecture**: Dynamic generation of templates using Nix functions is preferred over manual static file management.
- **Lifecycle**: Files are "Init Only" - copied once during `nix flake init`, not managed by the devshell afterwards.
- **Source**: Agents/Skills will be sourced from the existing central library (`pkgs/claude-sources`, exposed via overlays).

**Research Findings**:
- **Existing Lib**: `lib/claude.nix` has `mkEnvironment` and `flattenSkills` helper logic.
- **Existing Pkgs**: `pkgs/default.nix` exposes `agent-skills`, `superpowers`, etc., via `pkgs.custom` (or similar overlay structure).
- **Flake Structure**: `flake.nix` currently imports `templates` directly. It needs to pass `pkgs` to enable dynamic generation.

### Metis Review
**Identified Gaps** (addressed):
- **Symlinks vs Copies**: Nix store paths are read-only. Templates MUST use `cp -rL` (dereference) to ensure the user gets writable, independent files in their new project.
- **System Dependency**: Template generation requires a build system. We will hardcode `x86_64-linux` for the template builder, which is standard for architecture-independent file generation.
- **Namespace**: Packages are likely under `pkgs` directly (via overlay) or `pkgs.custom`. We need to verify the overlay structure (found `pkgs/default.nix`).

---

## Work Objectives

### Core Objective
Implement a dynamic template generation system that injects specific Claude agents and skills into the `.claude/` directory of new projects created via `nix flake init`.

### Concrete Deliverables
- `lib/templates.nix`: Helper function `mkTemplate`.
- `templates/default.nix`: Refactored to use `mkTemplate` and map agents/skills.
- `flake.nix`: Updated to pass `pkgs` to the templates import.

### Definition of Done
- [ ] `nix flake check` passes.
- [ ] `nix flake show` lists the templates.
- [ ] `nix flake init -t .#python` (dry run or actual) produces a directory with `.claude/agents/` containing the injected agent.
- [ ] The generated files are writable (not read-only symlinks).

### Must Have
- Use `cp -rL` for dereferencing.
- Reuse existing agent sources from `pkgs`.
- Maintain existing template base files (`templates/*/flake.nix`).

### Must NOT Have (Guardrails)
- Do NOT delete the source `templates/` directory.
- Do NOT make the templates system-dependent in the `flake.nix` outputs (they should remain in `outputs.templates`, not `outputs.packages`).

---

## Verification Strategy

### Test Decision
- **Infrastructure exists**: YES (NixOS flake)
- **User wants tests**: N/A (Infrastructure task)
- **Approach**: Manual verification via `nix` commands.

### Manual QA Procedures

1.  **Verify Flake Validity**:
    -   Command: `nx flake check`
    -   Expected: No errors.

2.  **Verify Template List**:
    -   Command: `nix flake show`
    -   Expected: Output lists `templates.python`, `templates.node`, etc.

3.  **Verify Template Content (Dry Run)**:
    -   Command: `nix build .#templates.python` (Note: templates are not buildable packages, so we might need `nix eval` or just init).
    -   Better Command: `mkdir test-init && cd test-init && nix flake init -t ..#python`
    -   Verify:
        -   `ls .claude/agents` -> shows agent file.
        -   `test -w .claude/agents/some-agent.md` -> confirms it is writable.

---

## Task Flow

```
1. Create Helper (lib/templates.nix) 
   -> 2. Update Flake (flake.nix) 
      -> 3. Refactor Templates (templates/default.nix)
```

---

## TODOs

- [ ] 1. Create `lib/templates.nix` with `mkTemplate` function

  **What to do**:
  - Define `mkTemplate` taking `{ pkgs }` and `{ path, description, agents ? [], skills ? [] }`.
  - Use `pkgs.runCommand` to create the output derivation.
  - Logic:
    - Copy base `path` to `$out`.
    - `mkdir -p $out/.claude/{agents,skills}`.
    - Loop over `agents` and `skills` lists.
    - Use `cp -rL` (dereference) to copy them into the respective `.claude` subdirs.
    - Ensure `$out` is writable/clean permissions.

  **Reference**:
  - `lib/claude.nix` (for inspiration on `pkgs.runCommand` usage).
  - Metis recommendation: `cp -rL`.

  **Acceptance Criteria**:
  - [ ] Function signature matches requirements.
  - [ ] Handles empty agent/skill lists gracefully.

- [ ] 2. Update `flake.nix` to instantiate pkgs and pass to templates

  **What to do**:
  - In `outputs` let-block, instantiate `pkgsForTemplates`.
  - Use `import nixpkgs { system = "x86_64-linux"; overlays = [ ... ]; }`.
  - Reuse the existing overlay import logic from lines 104-107 if possible, or duplicate strictly for this helper.
  - Update `templates = import ./templates { pkgs = pkgsForTemplates; inputs = inputs; };`.

  **Reference**:
  - `flake.nix`: Existing `overlays` definition.

  **Acceptance Criteria**:
  - [ ] `pkgsForTemplates` has access to `pkgs.agent-skills` etc.
  - [ ] `templates` import receives the arguments.

- [ ] 3. Refactor `templates/default.nix` to define dynamic templates

  **What to do**:
  - Convert file to function: `{ pkgs, ... }:`.
  - Import `mkTemplate` from `lib/templates.nix` (or passed in via `extraLib` if we add it there).
    - *Decision*: Let's import `lib/templates.nix` directly or via `callPackage` pattern. Simplest is `import ../lib/templates.nix { inherit pkgs; }`.
  - Redefine the templates using `mkTemplate`.
  - Example mapping:
    - `python`: `agents = [ pkgs.agent-skills + "/python-expert.md" ]`.
    - `node`: `agents = [ pkgs.agent-skills + "/javascript-expert.md" ]`.
    - `nix`: `agents = [ pkgs.superpowers + "/agents/nix-specialist.md" ]`.
  - Keep `path` pointing to existing `./dir`.

  **Reference**:
  - `pkgs/default.nix` (to know available package names).

  **Acceptance Criteria**:
  - [ ] All existing templates are preserved.
  - [ ] At least Python and Node templates have relevant agents injected.

- [ ] 4. Verification

  **What to do**:
  - Run `nx flake check`.
  - Perform a test init in a temp directory.

  **Acceptance Criteria**:
  - [ ] Flake check passes.
  - [ ] Generated project contains `.claude/agents/python-expert.md` (or similar).
  - [ ] File is writable.

---

## Success Criteria

### Verification Commands
```bash
nx flake check
mkdir /tmp/test-tpl && cd /tmp/test-tpl && nix flake init -t /etc/nixos#python
ls -l .claude/agents/
```

### Final Checklist
- [ ] Templates generated dynamically
- [ ] Agents injected correctly
- [ ] Files are writable
- [ ] No regression in existing templates
