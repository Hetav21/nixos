# NixOS Configuration

## Quick Start

```bash
# Update all flake inputs
nx update

# Build and switch to new configuration
nx rebuild switch

# Validate flake syntax
nx flake check
```

## nx Command Reference

| Command | Description |
|---------|-------------|
| `nx config` | Open NixOS configuration in editor |
| `nx rebuild [type]` | Rebuild NixOS (types: `test`, `switch`, `boot`) |
| `nx rollback` | Rollback to previous generation |
| `nx update [type]` | Update flake inputs (types: `latest`, `standard`, or all) |
| `nx clean` | Remove old generations |
| `nx gc` | Run garbage collection (wipe history >7d) |
| `nx optimise` | Optimise nix store (deduplicate files) |
| `nx doctor` | Run all maintenance (gc + clean + optimise) |
| `nx pull` | Pull latest changes from git |
| `nx log` | Tail the rebuild log |
| `nx flake check` | Validate flake syntax |
| `nx flake build [host]` | Dry-run build for host (default: nixwslbook) |
| `nx flake eval [host]` | Evaluate config for host (default: nixwslbook) |

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

---

## Security Considerations

- **Never commit decrypted secrets**
- Use `sops-nix` for secret management (see `secrets/README.md`)
- Keep SSH keys and API tokens in `secrets/` only

---

## Code Style Guidelines

### Naming Conventions

- Use dots (not hyphens) in option paths: `system.category.feature`
- System modules: `system.<category>.*`
- Home modules: `home.<category>.*`
- Hardware drivers: `drivers.<vendor>.*`

### Module Pattern

All modules must use `extraLib.modules.mkModule` helper to ensure consistent behavior and auto-generated enable options.

**Requirements:**
1. Destructure `extraLib` and other args (`lib`, `pkgs`, `config`) in the top-level function.
2. Pass `@ args` to the top-level function.
3. Call the result of `extraLib.modules.mkModule` with `args`.

```nix
{
  extraLib,
  lib,
  pkgs,
  config,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "system.category.feature";
  # Optional: set to false if module has no CLI/GUI component
  hasCli = true; 
  hasGui = true; 
  
  # Configuration for CLI/Server (enabled by cfg.enable)
  cliConfig = _: {
    environment.systemPackages = [ pkgs.tool ];
  };

  # Configuration for GUI (enabled by cfg.enableGui)
  guiConfig = _: {
    programs.gui-tool.enable = true;
  };
}) args
```

### Best Practices

**DO:**
- Use profiles for common configurations
- Follow namespace hierarchy
- Create enable options for all modules
- Keep modules focused and single-purpose
- Use `lib.getExe` for package binaries

**DON'T:**
- Use hyphens in option paths (use dots)
- Mix system and home configurations
- Hardcode user-specific paths
- Create modules without enable options

---

## Infrastructure Operations

### Change Namespace

```
1. Update option paths in module
2. Update all profile references
3. Update all host overrides
4. Test with nx flake check
```

### Update Flake Input

```bash
# Update all inputs
nx update

# Update specific input
nix flake lock --update-input nixpkgs
```

### Add Overlay

```nix
# In overlays/default.nix, add to additions or modifications:
additions = final: _prev: {
  my-package = final.callPackage ../pkgs/my-package { };
};
```

### Add Custom Package

```
1. Create pkgs/my-package/default.nix
2. Add to overlay for availability
```

### Add/Modify Secret

```nix
# 1. Create encrypted file: sops secrets/my-secret.yaml
# 2. In secrets/default.nix:
sops.secrets.my-secret = {
  sopsFile = ./my-secret.yaml;
  owner = config.users.users.${settings.username}.name;
};
```

---

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

---

## Nested Documentation

- **[modules/AGENTS.md](modules/AGENTS.md)** - Module operations, config conversions
- **[hosts/AGENTS.md](hosts/AGENTS.md)** - Profile and host operations
- **[secrets/README.md](secrets/README.md)** - Secret management with sops-nix

