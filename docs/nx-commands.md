# nx Command Reference

## Quick Start

```bash
# Update all flake inputs
nx update

# Build and switch to new configuration
nx rebuild switch

# Validate flake syntax
nx flake check
```

## Command Reference

> **IMPORTANT FOR AI AGENTS**: `nx` is a **nushell function** defined in `dotfiles/.config/nushell/config.nu`.
> It is NOT available in bash/fish/zsh. When executing from non-nushell environments (e.g., subprocess bash calls), use:
>
> ```bash
> nu --config ~/.config/nushell/config.nu -c "nx <command> [args]"
> ```
>
> Example: `nu --config ~/.config/nushell/config.nu -c "nx flake check"`

| Command                 | Description                                               |
| ----------------------- | --------------------------------------------------------- |
| `nx config`             | Open NixOS configuration in editor                        |
| `nx rebuild [type]`     | Rebuild NixOS (types: `test`, `switch`, `boot`; default: `test`) |
| `nx rollback`           | Rollback to previous generation                           |
| `nx update [type]`      | Update flake inputs (types: `latest`, `standard`, or all) |
| `nx clean`              | Remove old generations                                    |
| `nx gc`                 | Run garbage collection (wipe history >7d)                 |
| `nx optimise`           | Optimise nix store (deduplicate files)                    |
| `nx doctor`             | Run all maintenance (gc + clean + optimise)               |
| `nx pull`               | Pull latest changes from git                              |
| `nx log`                | Tail the rebuild log                                      |
| `nx flake check`        | Validate flake syntax                                     |
| `nx flake build [host]` | Dry-run build for host (default: nixwslbook)              |
| `nx flake eval [host]`  | Evaluate config for host (default: nixwslbook)            |

Hosts: `nixbook`, `nixwslbook`, `nixworkbook`.

## Testing Changes

```bash
# Validate flake syntax
nx flake check

# Dry-run build for specific host (without switching)
nx flake build nixbook

# Evaluate config for specific host
nx flake eval nixbook

# Test configuration without switching (default)
nx rebuild test

# Build and activate on next boot
nx rebuild boot

# Build and switch immediately
nx rebuild switch
```

## Troubleshooting

```bash
# Find where an option is set
rg "home\.development" modules -n

# View rebuild log in real-time
nx log

# Debug build failures
nx flake check

# Rollback to previous generation
nx rollback

# Refresh all inputs
nx update

# Run full maintenance
nx doctor
```
