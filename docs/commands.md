# nx Command Reference

`nx` is a **nushell function**. **Source of truth:** `src/modules/home/system/settings.nix` — if this doc and the function disagree, the function wins.

## Invocation

> **IMPORTANT FOR AI AGENTS**: `nx` is not available in bash/fish/zsh. When executing from non-nushell environments (e.g., subprocess bash calls), use:
>
> ```bash
> nu --config ~/.config/nushell/config.nu -c "nx <command> [args]"
> ```
>
> Example: `nu --config ~/.config/nushell/config.nu -c "nx flake check"`

Run `nx` with no arguments (or `nx -h`) to print the current command list — the built-in help is authoritative; this doc intentionally doesn't duplicate it.

## Semantics the Built-in Help Doesn't Cover

- `nx rebuild` defaults to `test`: activates the new config now but adds **no** boot entry. `switch` activates and makes it the boot default; `boot` only adds the boot entry. Rebuilds run `nh os` with live `nix-output-monitor` visuals and `nvd` package diffs.
- `nx search <query>` queries `search.nixos.org` using `nh search`.
- `nx rollback [gen]` rolls back generation using `nh os rollback` (optionally targeting a specific generation).
- `nx clean [keep]` / `nx gc [keep_since]` / `nx doctor` wrap `nh clean` for generational pruning, garbage collection, and store optimisation.
- `nx update` (no argument) updates **every** flake input, including those outside the curated lists. There is **no** `all` argument — `nx update all` errors.
- `nx update latest` updates the `latest` **and** `standard` curated lists combined; `nx update standard` updates only the `standard` list. Only bare `nx update` touches inputs in neither list.
  **Source of truth for list membership:** `settings.inputs.standard` / `settings.inputs.latest` in `src/config/common.nix` plus per-host additions in `src/config/<host>.nix` (merged by `src/lib/hosts.nix`, executed by `assets/scripts/update/all.sh`, `assets/scripts/update/latest.sh`, `assets/scripts/update/standard.sh`).
- `nx flake build` / `nx flake eval` fall back to a hardcoded default host — always pass your host explicitly. Hosts are the subdirectories of `src/hosts/` (except `_common`).
- `nx flake check` runs `nix flake check`: it evaluates every host and validates flake outputs.

## Testing Changes

```bash
# Validate flake syntax
nx flake check

# Evaluate config for a specific host (fast, eval only)
nx flake eval <host>

# Dry-run build for a specific host (without switching)
nx flake build <host>

# Apply without a boot entry (default), then make permanent
nx rebuild test
nx rebuild switch

# Search for packages
nx search <pkg>
```

## Troubleshooting

```bash
# Find where an option is set
rg "home\.development" modules -n

# Search for packages
nx search <pkg>

# Debug build failures
nx flake check

# Rollback to previous generation (optionally pass generation number)
nx rollback

# Run full maintenance (gc + clean + optimise via nh)
nx doctor
```
