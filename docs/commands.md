# Command Reference

System management and daily workflows are unified via `just` (running commands in `/etc/nixos`), powered by `nh` (Nix Helper) for builds/activation and standard raw `nix` commands for evaluation and checks.

**Source of truth:** `justfile`, `src/modules/system/settings.nix` (`programs.nh.flake`).

---

## Unified Task Runner (`just`)

Run `just` or `just --list` from `/etc/nixos` (or any sub-directory) to see all available commands.

### Flake Input Updates by Group

Inputs are classified into lifecycle groups (`stable`, `unstable`, `apps`, `system`):

```bash
# Show defined input groups and member inputs
just groups

# Update a specific group of inputs
just update stable     # nixpkgs, home-manager, stylix
just update unstable   # nixpkgs-unstable, helium-flake, vicinae-extensions
just update apps       # nixvim, llm-agents, t3code
just update system     # sops-nix, lanzaboote, nixos-wsl, nix-flatpak, nix-index-database

# Update a single input
just update <input>    # e.g. just update t3code

# Update all managed groups
just update all

# Update all flake inputs unconditionally (including manual / personal inputs)
just update-all
```

### Rebuilding & Switching

```bash
# Build & switch (optionally update a group of inputs first)
just switch            # nh os switch
just switch apps       # updates 'apps' inputs and switches
just switch stable     # updates 'stable' inputs and switches
just switch unstable   # updates 'unstable' inputs and switches

# Test activation without bootloader entry
just test              # nh os test
just test apps         # updates 'apps' and tests activation

# Build and add bootloader entry without activating
just boot              # nh os boot

# Dry-run build (defaults to current host)
just dry [host]        # nh os build -H <host> --dry

# Build system toplevel derivation
just build [host]      # nh os build -H <host>
```

### Verification & Evaluation

```bash
# Fast evaluation check (no build, defaults to current host)
just eval [host]       # nix eval .#nixosConfigurations.<host>... --apply 'x: "ok"'

# Validate flake syntax, inputs, and all host configurations
just check             # nix flake check

# Format Nix files using Alejandra (or 'just fmt')
just format [path]     # alejandra <path> (default: .)

# Show detailed evaluation error trace
just trace [host]      # nix eval .#nixosConfigurations.<host>... --show-trace
```

### Maintenance, Search & Rollback

```bash
# Search packages on search.nixos.org
just search <pkg>      # nh search <pkg>

# Roll back system to previous generation (or specific number)
just rollback [gen]    # nh os rollback [--to <gen>]

# Remove old generations (defaults to keeping 5)
just clean [keep]      # nh clean all --keep 5

# Clean old generations, GC, and optimise Nix store
just optimise          # nh clean all --optimise
```

---

## Interactive System Management (`nh`)

`nh` automatically detects the flake path via the `NH_FLAKE` / `NH_OS_FLAKE` / `FLAKE` environment variables configured in `system.nix.settings`.

### Direct `nh` Commands

- `nh os test` — Build and activate the new configuration immediately **without** adding a bootloader entry (default test workflow).
- `nh os switch` — Build, activate, and make the new configuration the default boot entry.
- `nh os boot` — Build and add a bootloader entry without activating the new configuration now.
- `nh os switch --update` — Update flake inputs before switching.
- `nh os switch -U <input>` — Update a specific flake input before switching.
- `nh os build -H <host> --dry` — Dry-run build for a specific host.
- `nh search <query>` — Search packages on `search.nixos.org`.
- `nh os rollback` — Roll back to the previous generation.
- `nh os rollback --to <gen>` — Roll back to a specific generation number.
- `nh clean all --keep <N>` — Keep the last `N` generations.
- `nh clean all --optimise` — Remove old generations and deduplicate/optimise the Nix store.

---

## Flake Operations & Agent Workflows (Raw `nix`)

AI agents and automated scripts use standard raw `nix` CLI commands across any shell environment (bash, zsh, fish, nushell):

### Validation & Evaluation

```bash
# Validate flake syntax, inputs, and all host configurations
nix flake check

# Fast evaluation check for a specific host (no build)
nix eval .#nixosConfigurations.<host>.config.system.build.toplevel --apply 'x: "ok"'

# Dry-run build for a specific host
nix build .#nixosConfigurations.<host>.config.system.build.toplevel --dry-run
```

### Building & Updating

```bash
# Build system toplevel derivation for a host
nix build .#nixosConfigurations.<host>.config.system.build.toplevel

# Update all flake inputs
nix flake update

# Update a single flake input
nix flake update <input>
```

---

## Testing Changes Workflow

```bash
# 1. Check syntax and types via evaluation
just eval

# 2. Check full flake validity
just check

# 3. Test activation locally (non-permanent)
just test

# 4. Make permanent once verified
just switch
```

---

## Troubleshooting

```bash
# Find where an option is defined/used
rg "home\.development" src/modules -n

# Search for package attribute names
just search <pkg>

# Inspect evaluation error trace
just trace

# Rollback after a broken switch
just rollback
```
