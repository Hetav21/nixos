# Agent Navigation Guide

This document is the authoritative reference for agents working in this NixOS repository. It contains structure, naming conventions, decision trees, and implementation patterns.

---

## Table of Contents
1. [Mission & Layout](#1-mission--layout)
2. [Namespace Hierarchy](#2-namespace-hierarchy)
3. [Core Concepts](#3-core-concepts)
4. [Navigation Workflows](#4-navigation-workflows)
5. [Search & Inspection Tips](#5-search--inspection-tips)
6. [Decision Trees](#6-decision-trees)
7. [Module Templates](#7-module-templates)
8. [Implementation Checklist](#8-implementation-checklist)
9. [Best Practices](#9-best-practices)
10. [Quick Reference](#10-quick-reference)

---

## 1. Mission & Layout

- **Primary goal:** maintain a modular, multi-host NixOS configuration with Home Manager integration, supporting desktop (`nixbook`) and WSL (`nixwslbook`) targets.
- **Entry points:**
  - `flake.nix` – inputs, overlays, host definitions.
  - `hosts/*/configuration.nix` – per-host system config.
  - `hosts/*/home.nix` – per-host Home Manager config.
  - `hosts/_common/` – shared system/home base, profiles, user definition.
  - `modules/system/*` – NixOS modules (namespaces `system.*`).
  - `modules/home/*` – Home Manager modules (namespaces `home.*`).
  - `lib/` – helper functions (`mkHostSettings`, `mkModule`).
  - `.agent/` – agent-facing docs (this file).

### Directory Structure
```
nixos/
├── flake.nix              # Flake definition with per-host settings
├── config/                # Host metadata (imported into flake.nix)
├── lib/                   # Shared Nix library code (hosts.nix, modules.nix)
├── hosts/                 # Per-host configurations
│   ├── _common/           # Shared configuration across all hosts
│   │   ├── default.nix    # Common system config + centralized home-manager
│   │   ├── user.nix       # User configuration
│   │   ├── home-base.nix  # Base home-manager config
│   │   └── profiles/      # Configuration profiles (system & home)
│   ├── nixbook/           # Personal laptop
│   └── nixwslbook/        # WSL instance
├── modules/               # Modular configuration system
│   ├── system/            # System-level modules
│   ├── home/              # Home Manager modules
│   └── drivers/           # Hardware drivers
├── scripts/               # Helper scripts (rebuild, update, common)
├── secrets/               # Encrypted secrets (sops-nix)
├── dotfiles/              # Dotfiles and configs
│   ├── common/            # Shared across all hosts
│   ├── desktop/           # Desktop-only dotfiles
│   └── wsl/               # WSL-specific dotfiles
├── wallpapers/            # Wallpaper collection
├── templates/             # Development environment templates
├── pkgs/                  # Custom package definitions
└── overlays/              # Nixpkgs overlays
```

---

## 2. Namespace Hierarchy

The configuration uses four top-level namespaces:

### `system.*` - System-Level Configuration
```
system.nix.settings         - Nix configuration and settings
system.nix.ld               - Nix-ld for dynamic linking
system.virtualisation.*     - Docker, podman, virt-manager, waydroid
system.network.*            - Networking, firewall, wireshark
system.storage.*            - Rclone, syncthing, localsend, megasync
system.media.*              - MPV, yt-dlp, obs-studio, pavucontrol
system.productivity.*       - Office suites, file managers
system.communication.*      - Discord, thunderbird, zoom
system.browser.*            - Web browsers
system.baseservices.*       - System services, flatpak, locate, cron
system.llm.*                - Ollama, open-webui
system.desktop-environment.*- Display manager, XDG, power management
system.stylix.*             - System-wide theming and fonts
system.hardware.base        - Base hardware (audio, bluetooth, input)
system.misc.*               - Miscellaneous system utilities
```

### `home.*` - User-Level Configuration
```
home.nix-settings.*  - Nix tools (alejandra, nixd, nil, nix-index)
home.development.*   - Development tools (git, gh, lazygit, vscode, zed-editor)
home.shell.*         - Shell configs (fish, nushell, tmux, alacritty, ghostty)
home.system.*        - System utilities (vim, btop, fastfetch)
home.downloads.*     - Download tools (aria2, yt-dlp)
home.desktop.*       - Desktop WM and tools (hyprland, waybar, rofi, dunst)
home.browser.*       - Web browsers (zen-browser)
```

### `drivers.*` - Hardware Drivers
```
drivers.asus.*    - ASUS-specific support (asusd, supergfxd)
drivers.intel.*   - Intel GPU drivers
drivers.amdgpu.*  - AMD GPU drivers
drivers.nvidia.*  - NVIDIA drivers (with PRIME support)
```

Hardware presets are configured in `config/hardware-*.nix` and passed via `specialArgs.hardware`.

### `profiles.*` - Configuration Profiles
```
profiles.system.desktop-full.*    - Full desktop with all features
profiles.system.desktop-base.*    - Base desktop without heavy apps
profiles.system.desktop-minimal.* - Minimal desktop (WM only)
profiles.system.wsl-minimal.*     - WSL CLI/TUI only

profiles.home.desktop-full.*      - Full home with all CLI/TUI and GUI tools
profiles.home.desktop-base.*      - Essential desktop without heavy apps
profiles.home.wsl-minimal.*       - WSL CLI/TUI only
```

---

## 3. Core Concepts

### Two-Tier Enable Pattern
Most modules expose `enable` (CLI/TUI) and `enableGui` (GUI). Enabling GUI often forces `enable = true`.

```nix
# Pattern usage:
# - Both switches: virtualisation, network, storage, media, development, shell
# - CLI only: nix-settings, system, downloads
# - GUI only: productivity, communication, browser, desktop.*
```

### Settings & Hardware
- Host metadata lives under `config/*.nix` (merged via `mkHostSettings`)
- Hardware presets live in `config/hardware-*.nix` (passed via `specialArgs.hardware`)
- Per-host settings are deep-merged with common settings

### Library Helpers

**`lib/hosts.nix`** - Host configuration helper:
```nix
mkHostSettings = common: overrides: lib.recursiveUpdate common overrides;
```

**`lib/modules.nix`** - Module creation helper:
```nix
mkModule = { name, hasCli?, hasGui?, guiRequiresCli?, cliConfig, guiConfig }: ...
```

---

## 4. Navigation Workflows

| Task | Key Files | Notes |
| --- | --- | --- |
| Add/modify system module | `modules/system/<category>.nix`, `modules/system/default.nix` | Follow option naming rules; ensure module imported. |
| Add/modify home module | `modules/home/<category>.nix`, `modules/home/default.nix` | Keep CLI/GUI split. |
| Change packages for a host | `hosts/<host>/configuration.nix` or `home.nix` | Prefer modules over host-local packages. |
| Adjust shared behavior | `hosts/_common/default.nix`, `hosts/_common/home-base.nix` | Profiles auto-enable module sets. |
| Update inputs/overlays | `flake.nix`, `overlays/`, `pkgs/` | Keep `commonSettings` consistent. |
| Modify secrets | `secrets/` (via sops) | Never commit decrypted data. |
| Configure hardware | `config/hardware-*.nix` + `specialArgs.hardware` | Hardware presets passed via specialArgs. |

---

## 5. Search & Inspection Tips

- **ripgrep (`rg`)** – best for locating option declarations. Use `rg "mkIf cfg.enable" --glob '*.nix'`.
- **`codebase_search` (semantic)** – use for conceptual matches (e.g., "where are profiles defined").
- **`list_dir` + `read_file`** – prefer these over shell equivalents.
- **Tracing options:** start from host config → `profiles.*` → module file.

---

## 6. Decision Trees

### Where Should This Configuration Go?

```
Is it user-specific (dotfiles, user apps)?
├─ YES → modules/home/
│   ├─ Terminal app? → modules/home/shell.nix
│   ├─ Desktop app? → modules/home/desktop/
│   └─ Browser? → modules/home/browser/
│
└─ NO → Is it hardware-related?
    ├─ YES → modules/drivers/ or modules/system/hardware/
    │
    └─ NO → modules/system/
        ├─ Desktop-related? → modules/system/desktop/
        ├─ System utility? → modules/system/misc/
        └─ Nix config? → modules/system/nix-*.nix
```

### Should I Create a New Module or Modify Existing?

```
Does a module for this purpose already exist?
├─ YES → Add to existing module
│   └─ Is it getting too large (>200 lines)?
│       ├─ YES → Consider splitting into sub-modules
│       └─ NO → Add to existing
│
└─ NO → Create new module
    └─ Will other hosts use this?
        ├─ YES → Create as module with enable option
        └─ NO → Add directly to host configuration
```

### Package vs Service vs Module?

```
What are you adding?
├─ Just a package? → Add to appropriate .nix file's package list
├─ Service configuration? → Create module if complex, else add inline
└─ Multiple packages + config? → Create dedicated module
```

---

## 7. Module Templates

### System Module Template
```nix
{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.system.category.my-feature;
in {
  options.system.category.my-feature = {
    enable = mkEnableOption "Enable my feature";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # packages here
    ];
    
    services.my-service = {
      enable = true;
    };
  };
}
```

### Two-Tier System Module Template
```nix
{
  lib,
  pkgs,
  config,
  settings,
  ...
}:
with lib; let
  cfg = config.system.category;
in {
  options.system.category = {
    enable = mkEnableOption "Enable CLI/TUI tools";
    enableGui = mkEnableOption "Enable GUI tools";
  };

  config = mkMerge [
    (mkIf cfg.enable {
      # CLI/TUI packages and configurations
    })

    (mkIf cfg.enableGui {
      # Auto-enable CLI when GUI is enabled
      system.category.enable = true;
      # GUI packages and configurations
    })
  ];
}
```

### Home Module Template
```nix
{
  lib,
  pkgs,
  config,
  settings,
  ...
}:
with lib; let
  cfg = config.home.category;
in {
  options.home.category = {
    enable = mkEnableOption "Enable CLI/TUI tools";
    enableGui = mkEnableOption "Enable GUI tools";
  };

  config = mkMerge [
    (mkIf cfg.enable {
      home.packages = with pkgs; [ ... ];
      programs.my-program = { enable = true; };
    })

    (mkIf cfg.enableGui {
      home.category.enable = true;
      home.packages = with pkgs; [ ... ];
    })
  ];
}
```

---

## 8. Implementation Checklist

### Add a new system module
1. Create `modules/system/<category>/<feature>.nix`
2. Export options under `system.<category>.<feature>.*`
3. Import module via `modules/system/<category>/default.nix`
4. Add to relevant profile in `hosts/_common/profiles/system/<profile>.nix`

### Add a new home module
1. Create `modules/home/<category>.nix`
2. Export options under `home.<category>.*`
3. Import module via `modules/home/default.nix`
4. Add to relevant profile in `hosts/_common/profiles/home/<profile>.nix`

### Modify a profile
1. Edit `hosts/_common/profiles/{system,home}/<profile>.nix`
2. Ensure both CLI (`enable`) and GUI (`enableGui`) flags reflect desired behavior

### Add host-specific configuration
1. Update `hosts/<host>/configuration.nix` or `home.nix`
2. Set `local.homeConfig = ./home.nix;` for home-manager
3. Configure hardware via `hardware.preset.*` options
4. Keep host overrides minimal; push reusable logic into modules/profiles

### Add packages
- System-wide: update `environment.systemPackages` in relevant module
- User-only: update `home.packages` in relevant home module

---

## 9. Best Practices

### DO:
- ✅ Use profiles for common configurations
- ✅ Follow namespace hierarchy
- ✅ Create enable options for all modules
- ✅ Use descriptive module names
- ✅ Document complex configurations
- ✅ Keep modules focused and single-purpose
- ✅ Use conditional logic with `mkIf`
- ✅ Use `lib.getExe` for package binaries

### DON'T:
- ❌ Use hyphens in option paths (use dots)
- ❌ Create confusing/redundant names
- ❌ Mix system and home configurations
- ❌ Hardcode user-specific paths
- ❌ Create modules without enable options
- ❌ Use conditional imports (not supported)
- ❌ Duplicate functionality across modules

---

## 10. Quick Reference

### Namespace Prefixes
```
system.*            → System configuration
home.*              → User configuration  
hardware.preset.*   → Hardware drivers
profiles.system.*   → System configuration bundles
profiles.home.*     → Home configuration bundles
```

### File Locations
```
System modules    → modules/system/
Home modules      → modules/home/
Drivers           → modules/drivers/
System profiles   → hosts/_common/profiles/system/
Home profiles     → hosts/_common/profiles/home/
Host configs      → hosts/*/
Common config     → hosts/_common/
Host settings     → config/*.nix
Hardware presets  → config/hardware-*.nix
Library helpers   → lib/
Scripts           → scripts/
Dotfiles          → dotfiles/
```

### Common Tasks
```
Add system package → modules/system/<module>.nix
Add user package   → modules/home/<module>.nix
New module         → Create file + add to default.nix + enable
New host           → hosts/hostname/ + update flake.nix + config/<host>.nix
```

### User Groups Reference
| Module | Groups Added |
|--------|--------------|
| `system.baseservices` | `mlocate` |
| `system.virtualisation` | `libvirtd`, `kvm`, `adbusers`, `docker` |
| `system.network` | `networkmanager`, `wireshark` |

### Useful Commands
```bash
nix flake update                           # Refresh inputs
sudo nixos-rebuild switch --flake .#<host> # Apply changes
rg "home\\.development" modules -n         # Find option implementations
```

---

## Final Notes

- Always prefer non-destructive edits (module-level changes).
- Verify new modules with `nix flake check` when possible.
- After major changes, revisit this guide and ensure references remain accurate.
- For secrets management, refer to `secrets/README.md`.

Happy hacking!
