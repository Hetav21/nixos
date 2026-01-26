# Package Management Guidelines

## 1. Directory Structure
The `pkgs/` directory contains custom packages and overlays.

```
pkgs/
├── default.nix          # Overlay entry point (exposes packages to pkgs.custom)
├── my-package/          # Custom package definition
│   └── default.nix
├── claude-sources/      # Sub-flake for AI resources
│   ├── flake.nix        # Inputs for skills/agents
│   └── flake.lock
└── [source-name]/       # Packages wrapping claude-sources inputs
    └── default.nix
```

## 2. Adding Custom Packages

### Step 1: Create Package Definition
Create `pkgs/my-package/default.nix`:
```nix
{ lib, stdenv, fetchFromGitHub, ... }:
stdenv.mkDerivation {
  pname = "my-package";
  version = "1.0.0";
  src = fetchFromGitHub { ... };
  # ... build instructions
}
```

### Step 2: Expose in Overlay
Edit `pkgs/default.nix` to call the package:
```nix
{ pkgs, inputs ? {}, ... }: {
  my-package = pkgs.callPackage ./my-package {};
}
```

## 3. Managing Claude Sources (Skills/Agents)

### Step 1: Add Input
Edit `pkgs/claude-sources/flake.nix`:
```nix
inputs = {
  new-source = {
    url = "github:owner/repo";
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
cd pkgs/claude-sources
nix flake update
cd ../..

# 2. Update the root flake's reference to claude-sources
# This resolves "attribute missing" errors by updating the locked hash
nix flake update claude-sources
```

### Step 3: Create Wrapper Package
Create `pkgs/new-source/default.nix` to expose the source:
```nix
{ lib, stdenvNoCC, new-source-src }:
stdenvNoCC.mkDerivation {
  name = "new-source";
  src = new-source-src;
  installPhase = "mkdir -p $out; cp -r $src/. $out/";
}
```

### Step 4: Expose & Use
1. Add to `pkgs/default.nix`:
   ```nix
   new-source = pkgs.callPackage ./new-source {
     new-source-src = inputs.claude-sources.new-source or null;
   };
   ```

2. Register in `modules/home/development.nix` under `programs.claude-resources`.
   Use `extraLib.claude.extract` to target specific directories or skills.

   ```nix
   programs.claude-resources = {
     skills = [
       # Option A: Extract specific subdirectory (e.g., for a single skill in a repo)
       (extraLib.claude.extract pkgs pkgs.custom.new-source "path/to/skill" {})

       # Option B: Extract root with includes/excludes
       (extraLib.claude.extract pkgs pkgs.custom.new-source "." {
         includes = [ "skill-a" "skill-b" ];
         excludes = [ "broken-skill" ];
       })
     ];
   };
   ```

## 4. Updates & Maintenance
- **Refresh Inputs**: `nx update` (updates root flake and checked-in sub-flake locks).
- **Cleanup**: If removing a source, update `pkgs/default.nix`, `pkgs/claude-sources/flake.nix`, and delete the package directory. Then run `nx update`.
