# Package Management Guidelines

## 1. Directory Structure

**Source of truth:** `pkgs/default.nix` and `overlays/default.nix`.

- `pkgs/default.nix` is the entry point: everything in the attrset it returns is exposed as `pkgs.custom.<name>` by the overlay in `overlays/default.nix` — you never edit the overlay itself.
- Each package normally lives in its own directory `pkgs/<name>/`; a few small packages are defined inline in `pkgs/default.nix` (check it before creating a directory).
- `pkgs/agent-sources/` is a sub-flake pinning external AI-agent resource repositories (skills, agents, commands).

## 2. Adding Custom Packages

### Step 1: Create Package Definition

Create `pkgs/<name>/default.nix`:

```nix
{ lib, stdenv, fetchFromGitHub, ... }:
stdenv.mkDerivation {
  pname = "<name>";
  version = "1.0.0";
  src = fetchFromGitHub { ... };
  # ... build instructions
}
```

### Step 2: Expose in `pkgs/default.nix`

Add an entry (usually `callPackage`; some entries are inline derivations) so it appears as `pkgs.custom.<name>`:

```nix
{ pkgs, inputs ? {}, ... }: {
  <name> = pkgs.callPackage ./<name> {};
}
```

## 3. Managing Agent Sources (Skills/Agents)

### Step 1: Add Input

Edit `pkgs/agent-sources/flake.nix`:

```nix
inputs = {
  new-source = {
    url = "github:<owner>/<repo>";
    flake = false;
  };
};
outputs = { ... } @ inputs: {
  inherit (inputs) new-source;
};
```

### Step 2: Update Lockfile

**CRITICAL**: You must update the sub-flake lockfile explicitly, and then update the root flake to pick up the changes.

```bash
# 1. Update the sub-flake
cd pkgs/agent-sources
nix flake update
cd ../..

# 2. Update the root flake's reference to agent-sources
# This resolves "attribute missing" errors by updating the locked hash
nix flake update agent-sources
```

### Step 3: Create Wrapper Package

Create `pkgs/<source-name>/default.nix` to expose the source:

```nix
{ lib, stdenvNoCC, new-source-src }:
stdenvNoCC.mkDerivation {
  name = "new-source";
  src = new-source-src;
  installPhase = "mkdir -p $out; cp -r $src/. $out/";
}
```

### Step 4: Expose & Wire In

1. Add to `pkgs/default.nix`:

   ```nix
   new-source = pkgs.callPackage ./new-source {
     new-source-src = inputs.agent-sources.new-source or null;
   };
   ```

2. Wire the package into `programs.agent-resources` — that mechanism is owned by **[docs/agent-environment.md](../docs/agent-environment.md)**.

## 4. Updates & Maintenance

- **Refresh inputs**: `nx update` refreshes **root** flake inputs only — it re-locks the root's reference to `agent-sources` but does not regenerate `pkgs/agent-sources/flake.lock`. To pull new upstream commits into the sub-flake, use the two-step in §3 Step 2.
- **Cleanup**: If removing a source, update `pkgs/default.nix`, `pkgs/agent-sources/flake.nix`, and delete the package directory. Then re-lock via the same two-step.
