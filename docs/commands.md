# Command Reference

Interactive system management is performed using `nh` (Nix Helper), while evaluation, automated checks, and AI agent tasks use standard raw `nix` commands.

**Source of truth:** `src/modules/system/nix-settings.nix` (`programs.nh.flake`).

---

## Interactive System Management (`nh`)

`nh` automatically detects the flake path via the `NH_FLAKE` / `NH_OS_FLAKE` / `FLAKE` environment variables configured in `system.nix.settings`.

### Rebuilding & Switching

- `nh os test` — Build and activate the new configuration immediately **without** adding a bootloader entry (default test workflow).
- `nh os switch` — Build, activate, and make the new configuration the default boot entry.
- `nh os boot` — Build and add a bootloader entry without activating the new configuration now.
- `nh os switch --update` — Update flake inputs before switching.
- `nh os build -H <host> --dry` — Dry-run build for a specific host.

### Searching Packages

- `nh search <query>` — Search packages on `search.nixos.org`.

### Rollback

- `nh os rollback` — Roll back to the previous generation.
- `nh os rollback --to <gen>` — Roll back to a specific generation number.

### Maintenance & Garbage Collection

- `nh clean all` — Remove old generations (defaults to keeping the last generation).
- `nh clean all --keep <N>` — Keep the last `N` generations.
- `nh clean all --keep-since <duration>` — Remove generations older than duration (e.g. `7d`, `30d`).
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
nix eval .#nixosConfigurations.<host>.config.system.build.toplevel --apply 'x: "ok"'

# 2. Check full flake validity
nix flake check

# 3. Test activation locally (non-permanent)
nh os test

# 4. Make permanent once verified
nh os switch
```

---

## Troubleshooting

```bash
# Find where an option is defined/used
rg "home\.development" src/modules -n

# Search for package attribute names
nh search <pkg>

# Inspect evaluation error trace
nix eval .#nixosConfigurations.<host>.config.system.build.toplevel --show-trace

# Rollback after a broken switch
nh os rollback
```
