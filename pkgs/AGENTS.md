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
**CRITICAL**: You must update the sub-flake lockfile explicitly.
```bash
cd pkgs/claude-sources
nix flake update
cd ../..
nx update # Sync root lockfile
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
2. Use in `modules/home/development.nix` via `pkgs.custom.new-source`.

## 4. Updates & Maintenance
- **Refresh Inputs**: `nx update` (updates root flake and checked-in sub-flake locks).
- **Cleanup**: If removing a source, update `pkgs/default.nix`, `pkgs/claude-sources/flake.nix`, and delete the package directory. Then run `nx update`.
