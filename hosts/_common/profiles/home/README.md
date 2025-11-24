# Home Manager Profiles

This directory contains reusable home-manager profiles for quick configuration.

## Available Profiles

### `profiles.home.desktop-full`
**Complete desktop environment with all features**

Includes:
- ✅ All CLI/TUI development tools (git, lazygit, gh, aws, etc.)
- ✅ All shell tools (fish, nushell, starship, tmux, etc.)
- ✅ System utilities (btop, vim, fastfetch, etc.)
- ✅ Download tools (aria2, yt-dlp)
- ✅ GUI development tools (VSCode, Cursor, Zed, etc.)
- ✅ GUI terminal emulators (Alacritty, Ghostty)
- ✅ Complete Hyprland desktop environment
- ✅ Desktop utilities (waybar, rofi, notifications, etc.)
- ✅ Zen browser

**Usage:**
```nix
# In home.nix
{...}: {
  imports = [
    ../_common/home-base.nix
  ];

  profiles.home.desktop-full.enable = true;

  # Optional overrides
  home.desktop.rofi.enableGui = true;  # Enable rofi if preferred
}
```

---

### `profiles.home.desktop-base`
**Essential desktop environment without heavy applications**

Includes:
- ✅ All CLI/TUI tools (development, shell, system, downloads)
- ✅ GUI development tools
- ✅ GUI terminal emulators
- ✅ Core Hyprland desktop (WM + waybar)
- ✅ Essential desktop utilities (clipboard, launcher, notifications)
- ✅ Zen browser

Excludes:
- ❌ Lock screen and idle management
- ❌ Screenshot tools
- ❌ Wallpaper management
- ❌ Logout menu
- ❌ Rofi

**Usage:**
```nix
# In home.nix
{...}: {
  imports = [
    ../_common/home-base.nix
  ];

  profiles.home.desktop-base.enable = true;
}
```

---

### `profiles.home.wsl-minimal`
**CLI/TUI tools only for WSL/servers**

Includes:
- ✅ All CLI/TUI development tools
- ✅ All shell tools (CLI only)
- ✅ System utilities
- ✅ Download tools

Excludes:
- ❌ All GUI applications
- ❌ GUI terminal emulators
- ❌ Desktop environment components
- ❌ Browser

**Usage:**
```nix
# In home.nix
{...}: {
  imports = [
    ../_common/home-base.nix
  ];

  profiles.home.wsl-minimal.enable = true;
}
```

---

## Manual Configuration

If profiles don't meet your needs, manually enable modules:

```nix
# In home.nix
{...}: {
  imports = [
    ../_common/home-base.nix
  ];

  # CLI/TUI only
  home.development.enable = true;
  home.shell.enable = true;
  home.system.enable = true;
  home.downloads.enable = true;

  # Add GUI tools
  home.development.enableGui = true;
  home.shell.enableGui = true;

  # Add specific desktop components
  home.desktop.hyprland.enableGui = true;
  home.desktop.waybar.enableGui = true;
  home.browser.zen.enableGui = true;
}
```

---

## Combining with System Profiles

Typically, you'll use both system and home profiles together:

**Full Desktop Setup:**
```nix
# configuration.nix
profiles.system.desktop-full.enable = true;

# home.nix
profiles.home.desktop-full.enable = true;
```

**WSL Setup:**
```nix
# configuration.nix
profiles.system.wsl-minimal.enable = true;

# home.nix
profiles.home.wsl-minimal.enable = true;
```

**Lightweight Desktop:**
```nix
# configuration.nix
profiles.system.desktop-base.enable = true;

# home.nix
profiles.home.desktop-base.enable = true;
```

