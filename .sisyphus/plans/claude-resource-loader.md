# Declarative Claude Agent & Skill Loader

## Context

### Original Request
The user wants a system to declaratively manage Claude agents and skills by providing a list of GitHub URLs in `flake.nix`. The system should automatically fetch these resources (handling both recursive directories and single files) and place them in `~/.claude/agents` and `~/.claude/skills`.

### Interview Summary
**Key Discussions**:
- **Fetching Strategy**: Adopted "Smart Inputs" - use Flake Inputs for safety/hashes, but allow "Array of Strings" in config for convenience. System maps URL strings to Flake Inputs.
- **Parsing**: System will auto-parse `github.com/Owner/Repo/blob/Ref/Path` to find the correct input and path.
- **File vs Dir**: Dir URLs trigger recursive scan; File URLs trigger single-file copy.

**Metis Review Findings**:
- **Gap**: Need explicit handling for single-file extraction in `lib/claude.nix` (currently dir-only).
- **Risk**: Input naming convention must be strict (Input Name = Repo Name) for auto-mapping to work.
- **Edge Case**: Branch in URL (`blob/main`) might mismatch locked input; parser must handle this gracefully (ignore branch, rely on lock).

---

## Work Objectives

### Core Objective
Enable `programs.claude.sources = [ "https://..." ]` configuration that auto-populates Claude's environment using flake inputs.

### Concrete Deliverables
- `modules/home/claude-resources.nix`: New module for source configuration.
- `lib/claude.nix`: Updated with `parseGithubUrl`, `resolveSource`, and single-file `extract` support.
- `modules/home/development.nix`: Updated to import new module (optional/example).

### Definition of Done
- [ ] User can add a GitHub URL string to config and corresponding flake input.
- [ ] System rebuilds and places files in `~/.claude/{agents,skills}`.
- [ ] Single file URL copies only that file.
- [ ] Directory URL copies/flattens directory.

### Must Have
- Support for `blob/branch` and `tree/branch` URL formats.
- Strict input matching (Input Name must match Repo Name, or Owner-Repo).
- Support for both Agents (*.md) and Skills (SKILL.md).

### Must NOT Have (Guardrails)
- Impure fetching (no `builtins.fetchGit` in module).
- Silent failures (warn/error if input missing).

---

## Verification Strategy

### Test Decision
- **Infrastructure exists**: Partial (Nix check).
- **User wants tests**: Manual verification is primary due to Nix activation nature.
- **Strategy**: Manual "Apply and Verify".

### Manual Execution Verification

**1. Parser Logic (REPL)**
- [x] Open `nix repl`
- [x] Load lib: `:lf .`
- [x] Test: `lib.claude.parseGithubUrl "https://github.com/Owner/Repo/blob/main/dir"`
- [x] Expected: `{ owner = "Owner"; repo = "Repo"; path = "dir"; ... }`


**2. Extraction Logic (Build)**
- [ ] Run `nx rebuild test`
- [ ] Check output: `ls -R ~/.claude/skills`
- [ ] Verify structure matches expected flattening/file-copy.

---

## Task Flow

```
1. Update Lib (extract/parse) → 2. Create Module (Definition) → 3. Refactor Development (Configuration)
```

---

## TODOs

- [x] 1. Update `lib/claude.nix` with Parsing & Extraction Logic

  **What to do**:
  - Add `parseGithubUrl` function:
    - Regex match `github.com/([^/]+)/([^/]+)/(blob|tree)/([^/]+)/(.*)`
    - Return structured data.
  - Update `extract` function:
    - **Logic**: Use `if [ -d ... ]` for `rsync` and `elif [ -f ... ]` for `cp`.
    - **Critical**: Ensure `rsync` uses trailing slash only for directories.
  - Add `resolveSource` helper:
    - Arguments: `urlStr`, `inputs`.
    - Find input by `repo` name (priority) or `owner-repo`.
    - Return derivation (via `extract` call).

  **Test**: `nx flake check` to ensure syntax is valid.

- [x] 2. Create `modules/home/claude-resources.nix` (The Resource Manager)

  **What to do**:
  - Define options:
    - `programs.claude.agents` (list of packages/derivations)
    - `programs.claude.skills` (list of packages/derivations)
    - `programs.claude.sources.agents` (list of strings - URLS)
    - `programs.claude.sources.skills` (list of strings - URLS)
  - Implementation:
    - Access `inputs` via module arguments (`{ inputs, ... }:`) or `specialArgs`.
    - Resolve `programs.claude.sources.*` strings to derivations using `lib.claude.resolveSource`.
    - Merge resolved sources with manual lists (`programs.claude.agents` + resolved agents).
    - **Exclusive Owner**: Call `extraLib.claude.mkEnvironment` here with the final merged lists.
    - This module becomes the *only* place that writes to `home.file.".claude/..."`.

- [x] 3. Refactor `modules/home/development.nix`

  **What to do**:
  - Import `claude-resources.nix`.
  - **Remove** the direct call to `extraLib.claude.mkEnvironment`.
  - Migrate existing lists to the new options:
    - Move `pkgs.custom.agent-skills` etc. to `programs.claude.skills = [ ... ]`.
  - Test the new system:
    - Add a sample URL to `programs.claude.sources.skills`.
    - Ensure `inputs` contains the matching repo.

  **Verification**:
  - `nx rebuild test`.
  - Verify `~/.claude/skills` contains both manual and fetched skills.
  - Verify no collision errors.

---

## Success Criteria

### Final Checklist
- [x] `lib/claude.nix` handles parsing `blob/main/path`.
- [x] `lib/claude.nix` extracts single files correctly.
- [x] Module accepts list of strings.
- [x] Correctly maps URL -> Input -> Path.
