# NixOS Configuration - Naming Conventions & Structure Guide

**Last Updated:** 2025-11-24  
**Purpose:** Maintain consistency and clarity in the NixOS configuration structure

**Note:** This configuration now uses a two-tier enable system: `enable` for CLI/TUI tools and `enableGui` for GUI applications.

---

## Table of Contents
1. [Namespace Hierarchy](#namespace-hierarchy)
2. [Module Organization](#module-organization)
3. [Profile System](#profile-system)
4. [File Naming Conventions](#file-naming-conventions)
5. [Option Naming Patterns](#option-naming-patterns)
6. [Package Organization](#package-organization)
7. [Adding New Components](#adding-new-components)
8. [Decision Trees](#decision-trees)

---

## Namespace Hierarchy

The configuration uses four top-level namespaces:

### `system.*` - System-Level Configuration
System-wide settings, services, and packages available to all users.

```
system.nix.settings            - Nix configuration and settings
system.nix.ld                  - Nix-ld for dynamic linking
system.virtualisation.*        - Docker, podman, virt-manager, waydroid
system.network.*               - Networking, firewall, wireshark
system.storage.*               - Rclone, syncthing, localsend, megasync
system.media.*                 - MPV, yt-dlp, obs-studio, pavucontrol
system.productivity.*          - Office suites, file managers
system.communication.*         - Discord, thunderbird, zoom, spotify
system.services.*              - System services, flatpak, locate, cron
system.llm.*                   - Ollama, open-webui
system.desktop-environment.*   - Display manager, XDG, power management
system.hardware.*              - Hardware-specific configuration
system.misc.*                  - Miscellaneous system utilities
```

### `home.*` - User-Level Configuration
User-specific configurations managed by Home Manager.

```
home.nix-settings.*  - Nix tools (alejandra, nixd, nil, nix-index)
home.development.*   - Development tools (git, gh, lazygit, vscode, zed-editor, cursor-cli)
home.shell.*         - Shell configs (fish, nushell, tmux, alacritty, ghostty)
home.system.*        - System utilities (vim, btop, fastfetch, killall, most)
home.downloads.*     - Download tools (aria2, yt-dlp)
home.desktop.*       - Desktop WM and tools (hyprland, waybar, rofi, dunst)
home.browser.*       - Web browsers (zen-browser)
```

### `drivers.*` - Hardware Drivers
Hardware-specific drivers and configurations.

```
drivers.nvidia.*   - NVIDIA GPU drivers
drivers.intel.*    - Intel GPU drivers
drivers.amdgpu.*   - AMD GPU drivers
drivers.asus.*     - ASUS-specific features
```

### `profiles.*` - Configuration Profiles
Pre-bundled sets of system modules for different use cases. Located in `hosts/_common/profiles/system/`.

**System Profiles** (`profiles.system.*`):
```
profiles.system.desktop-full.*    - Full desktop with all features
profiles.system.desktop-base.*    - Base desktop without heavy apps
profiles.system.desktop-minimal.* - Minimal desktop (WM only)
profiles.system.wsl-minimal.*     - WSL CLI/TUI only
```

**Home Profiles** (`profiles.home.*`):
```
profiles.home.desktop-full.*    - Full desktop with all CLI/TUI and GUI tools
profiles.home.desktop-base.*    - Essential desktop without heavy apps
profiles.home.wsl-minimal.*     - WSL CLI/TUI only
```

---

## Module Organization

### Directory Structure

```
nixos/
├── flake.nix              # Flake definition with per-host settings
├── NAMING_CONVENTIONS.md  # This document
├── SUGGESTIONS.md         # Code review and improvement suggestions
│
├── hosts/                 # Per-host configurations
│   ├── _common/           # Shared configuration across all hosts
│   │   ├── default.nix    # Common system config (imports modules, profiles, secrets, state version)
│   │   ├── user.nix       # User configuration
│   │   ├── home-base.nix  # Base home-manager config
│   │   └── profiles/      # System configuration profiles
│   │       ├── default.nix    # Imports system profiles
│   │       └── system/        # System-level profiles
│   │           ├── default.nix
│   │           ├── desktop-full.nix
│   │           ├── desktop-base.nix
│   │           ├── desktop-minimal.nix
│   │           └── wsl-minimal.nix
│   ├── nixbook/           # Personal laptop
│   │   ├── configuration.nix
│   │   ├── hardware-configuration.nix
│   │   └── home.nix
│   └── nixwslbook/        # Work WSL instance
│       ├── configuration.nix
│       └── home.nix
│
├── modules/               # Modular configuration system
│   ├── default.nix        # Imports all module categories
│   │
│   ├── system/            # System-level modules
│   │   ├── desktop/       # Desktop environment
│   │   ├── hardware/      # Hardware configuration
│   │   ├── misc/          # Miscellaneous utilities
│   │   ├── nix-settings.nix
│   │   └── nix-ld.nix
│   │
│   ├── home/              # Home Manager modules
│   │   ├── terminal/      # Terminal applications
│   │   ├── desktop/       # Desktop applications
│   │   └── browser/       # Web browsers
│   │
│   └── drivers/           # Hardware drivers
│       ├── nvidia-drivers.nix
│       ├── intel-drivers.nix
│       └── ...
│
├── scripts/               # Helper scripts
│   ├── desktop/           # Desktop-related scripts
│   ├── waybar/            # Waybar scripts
│   ├── rebuild/           # System rebuild scripts
│   └── update/            # Update scripts
│
├── secrets/               # Encrypted secrets (sops-nix)
├── dotfiles/              # Dotfiles and configs
├── wallpapers/            # Wallpaper collection
├── templates/             # Development environment templates
├── pkgs/                  # Custom package definitions
└── overlays/              # Nixpkgs overlays
```

### Module Categories

#### System Modules (`modules/system/`)

**Categorized Modules (Two-Tier Enable System):**
- `virtualisation.nix` - Containerization and VMs
  - `enable`: docker, podman, docker-compose, podman-compose, dive
  - `enableGui`: virt-manager, quickgui, waydroid
- `network.nix` - Networking configuration
  - `enable`: base networking, firewall, network-manager
  - `enableGui`: network-manager-applet, wireshark GUI
- `storage.nix` - Cloud and network storage
  - `enable`: rclone, syncthing, ntfs3g
  - `enableGui`: localsend, megasync, onedrive
- `media.nix` - Media tools
  - `enable`: mpv, yt-dlp
  - `enableGui`: obs-studio, pavucontrol, kdenlive, image viewers, youtube-music, spotify, stremio
- `productivity.nix` - Productivity tools (GUI only)
  - `enableGui`: obsidian, libreoffice, onlyoffice, thunar, file-roller, upscayl
- `communication.nix` - Communication apps (GUI only)
  - `enableGui`: discord, vesktop, thunderbird, zoom, teams
- `services.nix` - System services
  - `enable`: locate, cron, gnupg, preload
  - `enableGui`: flatpak
- `llm.nix` - AI/LLM services
  - `enable`: ollama service
  - `enableGui`: open-webui
- `desktop-environment.nix` - Desktop environment components (GUI only)
  - `enableGui`: display manager, XDG config, power management, printing, security

**Core Modules (Always Enabled):**
- `nix-settings.nix` - Nix configuration
- `nix-ld.nix` - Nix-ld for dynamic linking

**Legacy Desktop Sub-modules (Managed by desktop-environment):**
- `desktop/` - Individual desktop components

#### Home Modules (`modules/home/`)

**Categorized Modules (Two-Tier Enable System):**
- `nix-settings.nix` - Nix development tools (CLI only)
  - `enable`: alejandra (formatter), nixd (LSP), nil (LSP), nix-index, nix-index-database
- `development.nix` - Development tools
  - `enable`: git, gh, lazygit, lazydocker, awscli2, distrobox, cursor-cli, gemini-cli, codex
  - `enableGui`: vscode, cursor, zed-editor, bruno, hoppscotch, mongodb-compass, claude-code
- `shell.nix` - Shell and CLI tools
  - `enable`: fish, nushell, tmux, starship, zoxide, eza, bat, ripgrep, fzf, fd, yazi
  - `enableGui`: alacritty, ghostty (terminal emulators)
- `system.nix` - System utilities (CLI only)
  - `enable`: vim, btop, killall, most, tree, fastfetch, microfetch, onefetch, ntfs3g
- `downloads.nix` - Download managers (CLI only)
  - `enable`: aria2, yt-dlp

**Desktop Modules (GUI Only):**
- `desktop/hypr/` - Hyprland window manager ecosystem
- `desktop/clipboard.nix` - Clipboard manager (cliphist)
- `desktop/launcher.nix` - Application launcher (vicinae)
- `desktop/notification.nix` - Notification daemon (dunst)
- `desktop/rofi.nix` - Rofi menu system
- `desktop/wallpaper.nix` - Wallpaper manager (swww)
- `desktop/waybar.nix` - Status bar
- `desktop/wlogout.nix` - Logout menu

**Browser:**
- `browser/zen-browser.nix` - Zen web browser (GUI only)

---

## Profile System

Profiles bundle multiple modules together for common use cases. Profiles are organized in `hosts/profiles/` with separate directories for system and home configurations.

### System Profiles (`hosts/profiles/system/`)

#### `profiles.system.desktop-full`
**Purpose:** Complete desktop environment with all features enabled  
**Ideal for:** Personal laptops, workstations  
**Includes:**
- All system modules (nix, desktop, applications, hardware)
- Disk decryption
- Virtualisation, LLM services, entertainment apps

**Usage:**
```nix
# hosts/nixbook/configuration.nix
profiles.system.desktop-full.enable = true;
```

#### `profiles.system.desktop-base`
**Purpose:** Desktop environment without resource-heavy applications  
**Ideal for:** Lower-spec machines, work laptops  
**Includes:**
- Core desktop (environment, display manager, security)
- Essential services and networking
- Office and network tools
- **Excludes:** Entertainment, LLM, virtualisation

**Usage:**
```nix
profiles.system.desktop-base.enable = true;
```

#### `profiles.system.desktop-minimal`
**Purpose:** Bare-bones desktop with just window manager  
**Ideal for:** Minimal installations, testing  
**Includes:**
- Window manager and display manager
- Basic security and XDG config
- Hardware support
- **Excludes:** Most applications and services

**Usage:**
```nix
profiles.system.desktop-minimal.enable = true;
```

#### `profiles.system.wsl-minimal`
**Purpose:** CLI/TUI environment for WSL  
**Ideal for:** WSL instances, servers, headless systems  
**Includes:**
- Nix settings and nix-ld only
- **Excludes:** All desktop and hardware modules

**Usage:**
```nix
profiles.system.wsl-minimal.enable = true;
```

---

### Home Manager Configuration

Home-manager configurations can use **profiles** for quick setup or **manual module enabling** for fine-grained control.

#### Option 1: Using Home Profiles (Recommended)

**Example - Full Desktop (`hosts/nixbook/home.nix`):**
```nix
{pkgs, ...}: {
  imports = [
    ../_common/home-base.nix
  ];

  # Enable full desktop profile (includes all modules)
  profiles.home.desktop-full.enable = true;

  # Optional: Override specific settings
  home.desktop.rofi.enableGui = true;  # Enable if you prefer rofi
}
```

**Example - WSL Minimal (`hosts/nixwslbook/home.nix`):**
```nix
{...}: {
  imports = [
    ../_common/home-base.nix
  ];

  # Enable WSL minimal profile (CLI/TUI only)
  profiles.home.wsl-minimal.enable = true;
}
```

#### Option 2: Manual Module Configuration

**Example - Full Desktop (`hosts/nixbook/home.nix`):**
```nix
{pkgs, ...}: {
  imports = [
    ../_common/home-base.nix
  ];

  # Enable categorized modules with both CLI and GUI
  home.nix-settings.enable = true;
  home.development = { enable = true; enableGui = true; };
  home.shell = { enable = true; enableGui = true; };
  home.system.enable = true;
  home.downloads.enable = true;

  # Enable desktop modules (GUI only)
  home.desktop.hyprland.enableGui = true;
  home.desktop.waybar.enableGui = true;
  home.browser.zen.enableGui = true;
}
```

**Example - WSL Minimal (`hosts/nixwslbook/home.nix`):**
```nix
{...}: {
  imports = [
    ../_common/home-base.nix
  ];

  # Enable only CLI/TUI modules for WSL (manual approach)
  home.nix-settings.enable = true;
  home.development.enable = true;
  home.shell.enable = true;
  home.system.enable = true;
  home.downloads.enable = true;
}
```

### Available Home Profiles

#### `profiles.home.desktop-full`
**Purpose:** Complete desktop environment with all features  
**Includes:** Nix tools + all CLI/TUI tools + all GUI applications + browser + complete desktop environment  
**Usage:**
```nix
profiles.home.desktop-full.enable = true;
```

#### `profiles.home.desktop-base`
**Purpose:** Essential desktop environment without heavy applications  
**Includes:** Nix tools + all CLI/TUI tools + essential GUI tools (WM, waybar, browser)  
**Excludes:** Lock screen, idle manager, screenshot tools, wallpaper manager  
**Usage:**
```nix
profiles.home.desktop-base.enable = true;
```

#### `profiles.home.wsl-minimal`
**Purpose:** CLI/TUI tools only for WSL/servers  
**Includes:** Nix tools, development tools, shell configs, system utilities, downloads  
**Excludes:** All GUI applications  
**Usage:**
```nix
profiles.home.wsl-minimal.enable = true;
```

---

### Creating Custom System Profiles

**System Profile:**
```nix
# hosts/_common/profiles/system/my-profile.nix
{lib, config, ...}:
with lib; {
  options.profiles.system.my-profile = {
    enable = mkEnableOption "My custom system profile";
  };

  config = mkIf config.profiles.system.my-profile.enable {
    # Enable specific system modules
    system.nix.settings.enable = true;
    system.desktop.environment.enable = true;
    # ... more system options
  };
}
```

---

## File Naming Conventions

### Module Files
- Use kebab-case: `power-management.nix`, `app-entertainment.nix`
- Descriptive names: `xdg-config.nix` (not `system.nix`)
- Prefix for categories: `app-*` for applications

### Script Files
- Organized by category in subdirectories
- Descriptive names: `rofi-launcher.nix`, `task-waybar.nix`

### Configuration Files
- `configuration.nix` - System configuration
- `home.nix` - Home Manager configuration
- `hardware-configuration.nix` - Hardware-specific settings
- `default.nix` - Module aggregator (imports)

---

## Option Naming Patterns

### General Rules
1. **Lowercase with dots:** `system.desktop.environment`
2. **No hyphens in option paths:** Use `system.nix.settings` not `system.nix-settings`
3. **Hierarchical structure:** `category.subcategory.module`
4. **Descriptive names:** `xdg-config` not `system`

### Examples

✅ **Good:**
```nix
system.nix.settings.enable
system.desktop.environment.enable
home.terminal.shell.enable
drivers.nvidia.enable
profiles.desktop-full.enable
```

❌ **Bad:**
```nix
system.nix-settings.enable        # Hyphen in path
system.desktop.system.enable      # Confusing/redundant name
local.hardware-clock.enable       # Wrong namespace
vm.guest-services.enable          # Should be system.virtualization.guest
```

### Enable Options

**Two-Tier Enable System:**

Modules now use a two-tier enable pattern for CLI/TUI vs GUI separation:

```nix
options.namespace.module = {
  enable = mkEnableOption "Enable CLI/TUI tools";
  enableGui = mkEnableOption "Enable GUI tools";
};

config = mkMerge [
  (mkIf cfg.enable {
    # CLI/TUI packages and configurations
  })
  (mkIf cfg.enableGui {
    # GUI packages and configurations
    # Optionally auto-enable CLI tools if needed
    namespace.module.enable = true;
  })
];
```

**Pattern Usage:**
- **Both switches**: `system.virtualisation`, `system.network`, `system.storage`, `system.media`, `system.services`, `system.llm`, `home.development`, `home.shell`
- **GUI only**: `system.productivity`, `system.communication`, `system.desktop-environment`, `home.desktop.*`, `home.browser.*`
- **CLI only**: `home.nix-settings`, `home.system`, `home.downloads`

---

## Package Organization

### Where Packages Go

#### System Packages (`environment.systemPackages`)
- **Location:** `modules/system/desktop/app-*.nix`
- **Purpose:** Packages available system-wide to all users
- **Examples:** Browsers, system tools, global applications

```nix
# modules/system/desktop/app-office.nix
environment.systemPackages = with pkgs; [
  xfce.thunar
  file-roller
  pavucontrol
];
```

#### Home Packages (`home.packages`)
- **Location:** `modules/home/desktop/*.nix`
- **Purpose:** User-specific packages and tools
- **Examples:** Development tools, user applications

```nix
# modules/home/desktop/programming.nix
home.packages = with pkgs; [
  unstable.code-cursor
  unstable.codex
  mongodb-compass
];
```

#### Flatpak Packages
- **System:** `modules/system/desktop/app-*.nix`
- **Declaration:** `services.flatpak.packages = [ "app.id" ];`

### Package Categories

**System Desktop Applications:**
- Entertainment: Media players, chat clients, music streaming
- Office: Productivity tools, office suites, file managers
- Network Tools: Wireshark, network managers
- Network Storage: Cloud sync, file sharing
- LLM: AI models and interfaces

**Home Applications:**
- Programming: IDEs, editors, development tools, git
- Terminal: Shell configurations, CLI tools

---

## Adding New Components

### Adding a New System Module

1. **Create the module file:**
   ```bash
   # Location depends on category
   touch modules/system/desktop/my-feature.nix
   ```

2. **Module template:**
   ```nix
   {
     lib,
     pkgs,
     config,
     ...
   }:
   with lib; let
     cfg = config.system.desktop.my-feature;
   in {
     options.system.desktop.my-feature = {
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

3. **Add to default.nix:**
   ```nix
   # modules/system/desktop/default.nix
   imports = [
     # ... existing imports
     ./my-feature.nix
   ];
   ```

4. **Enable in host config or profile:**
   ```nix
   # hosts/nixbook/configuration.nix
   system.desktop.my-feature.enable = true;
   
   # OR add to a profile
   # modules/profiles/desktop-full.nix
   system.desktop.my-feature.enable = true;
   ```

### Adding a New Home Module

Same process, but in `modules/home/` with `home.*` namespace.

### Adding a New Profile

1. Create profile in `modules/profiles/`
2. Define options and enable relevant modules
3. Import in `modules/profiles/default.nix`
4. Use in host configuration

---

## Decision Trees

### Where Should This Configuration Go?

```
Is it user-specific (dotfiles, user apps)?
├─ YES → modules/home/
│   ├─ Terminal app? → modules/home/terminal/
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

## User Groups Reference

Certain modules automatically add users to groups:

| Module | Groups Added |
|--------|--------------|
| `system.desktop.services` | `mlocate` |
| `system.desktop.virtualisation` | `libvirtd`, `kvm`, `adbusers`, `docker` |
| `system.desktop.network-tools` | `networkmanager`, `wireshark` |

---

## Common Configuration (`_common/`)

The `hosts/_common/` directory contains shared configuration used across all hosts to reduce duplication.

### Files:
- **`default.nix`** - System-level common config (imports user.nix, modules, profiles, secrets, state version)
- **`user.nix`** - User account configuration (username, shell, groups)
- **`home-base.nix`** - Base home-manager config (username, dotfiles, session paths, module imports)

**Important:** Home Manager configuration is **per-host** (not in `_common`). Each host has its own `home-manager` block in `configuration.nix` that imports its own `home.nix`.

### Usage in Host Configs:

**System configuration (`configuration.nix`):**
```nix
imports = [
  ./hardware-configuration.nix  # Host-specific (if needed)
  ../_common                     # Imports system modules, profiles, secrets
];

# Each host needs its own home-manager block
home-manager = {
  extraSpecialArgs = {inherit inputs settings;};
  users.${settings.username} = import ./home.nix;
  useGlobalPkgs = true;
  useUserPackages = true;
  backupFileExtension = "backup";
};
```

**Home configuration (`home.nix`):**
```nix
imports = [
  ../_common/home-base.nix  # Provides: username, homeDirectory, stateVersion, 
                             # common dotfiles, sessionPath, module imports
];

# Enable specific home modules as needed
home.terminal.shell.enable = true;
home.terminal.tmux.enable = true;
# ... etc
```

This reduces each host's configuration to only what's unique to that host.

---

## Best Practices

### DO:
✅ Use profiles for common configurations  
✅ Follow namespace hierarchy  
✅ Create enable options for all modules  
✅ Use descriptive module names  
✅ Document complex configurations  
✅ Keep modules focused and single-purpose  
✅ Use conditional logic with `mkIf`  

### DON'T:
❌ Use hyphens in option paths  
❌ Create confusing/redundant names  
❌ Mix system and home configurations  
❌ Hardcode user-specific paths  
❌ Create modules without enable options  
❌ Use conditional imports (not supported)  
❌ Duplicate functionality across modules  

---

## Quick Reference Card

```
Namespace Prefixes:
  system.*           → System configuration
  home.*             → User configuration  
  drivers.*          → Hardware drivers
  profiles.system.*  → System configuration bundles

File Locations:
  System modules    → modules/system/
  Home modules      → modules/home/
  Drivers           → modules/drivers/
  System profiles   → hosts/_common/profiles/system/
  Host configs      → hosts/*/
  Common config     → hosts/_common/
  Scripts           → scripts/

Common Tasks:
  Add system package → modules/system/desktop/app-*.nix
  Add user package   → modules/home/desktop/*.nix
  New module         → Create file + add to default.nix + enable
  New host           → hosts/hostname/ + update flake.nix
```

---

## Maintenance

When making changes:
1. Update this document if namespaces change
2. Update profiles if module dependencies change
3. Document new user groups in this file
4. Keep decision trees current

For questions or clarifications, refer to:
- `SUGGESTIONS.md` for improvement ideas
- `secrets/README.md` for secrets management
- Module source files for implementation details

---
