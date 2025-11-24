# NixOS Configuration

A modular and maintainable NixOS configuration supporting multiple hosts including desktop environments and WSL setups.

## Features

- **Two-Tier Enable System**: Separate CLI/TUI and GUI tools with `enable` and `enableGui` options
- **Modular Architecture**: Organized module system categorized by function (development, shell, media, etc.)
- **Multiple Host Support**: Desktop (nixbook) and WSL (nixwslbook) configurations
- **WSL-Optimized**: Full CLI/TUI development environment without GUI dependencies
- **Profile-Based Configuration**: Pre-configured profiles for different use cases (desktop-full, desktop-minimal, wsl-minimal)
- **Home Manager Integration**: Declarative user environment management
- **Stylix Theming**: Consistent theming across applications
- **Secrets Management**: Using sops-nix for secure secret handling

## Repository Structure

```
.
├── hosts/              # Host-specific configurations
│   ├── _common/        # Common configurations shared across hosts
│   │   ├── profiles/   # System and home profiles
│   │   ├── default.nix # Common system configuration
│   │   ├── home-base.nix # Common home-manager configuration
│   │   └── user.nix    # Common user definition
│   ├── nixbook/        # Desktop host configuration
│   └── nixwslbook/     # WSL host configuration
├── modules/            # Reusable NixOS and home-manager modules
│   ├── home/           # Home-manager modules
│   │   ├── development.nix  # Development tools (git, IDEs)
│   │   ├── shell.nix        # Shell and CLI tools
│   │   ├── system.nix       # System utilities
│   │   ├── downloads.nix    # Download managers
│   │   ├── desktop/         # Desktop WM and GUI tools
│   │   └── browser/         # Web browsers
│   ├── system/         # NixOS system modules
│   │   ├── virtualisation.nix   # Docker, VMs
│   │   ├── network.nix          # Networking
│   │   ├── storage.nix          # Cloud storage
│   │   ├── media.nix            # Media tools
│   │   ├── communication.nix    # Chat, email
│   │   └── ...                  # More categorized modules
│   └── drivers/        # Hardware drivers (GPU, etc.)
├── dotfiles/           # Configuration files for various applications
├── scripts/            # Custom scripts
├── wallpapers/         # Wallpaper collection
├── secrets/            # Encrypted secrets (sops-nix)
└── flake.nix           # Flake configuration
```

## Requirements

- Running NixOS (or installing NixOS)
- GPT partitioning with UEFI boot
- Git installed on your system
- Basic knowledge of Nix and NixOS

## Installation

### 1. Initial Setup

Ensure Git and a text editor are available:

```bash
nix-shell -p git vim
```

### 2. Clone the Repository

Clone this repository to your home directory:

```bash
git clone https://github.com/Hetav21/nixos.git ~/nixos
cd ~/nixos
```

**Note**: The configuration expects to be in `~/nixos`. If you use a different location, update paths accordingly.

### 3. Create Your Host Configuration

Create a new host folder based on the appropriate template:

**For a desktop system:**
```bash
cp -r hosts/nixbook hosts/<your-hostname>
```

**For a WSL system:**
```bash
cp -r hosts/nixwslbook hosts/<your-hostname>
```

### 4. Generate Hardware Configuration

Generate your hardware configuration:

```bash
nixos-generate-config --show-hardware-config > hosts/<your-hostname>/hardware-configuration.nix
```

### 5. Configure Your System

Edit the following files in `hosts/<your-hostname>/`:

**a. Edit `configuration.nix`:**
- Review and adjust system-level settings
- Enable/disable modules as needed
- Update hostname

**b. Edit `home.nix`:**
- Configure your user environment
- Enable/disable home-manager modules
- Adjust application settings

**c. Update `flake.nix`:**
- Add your new host to `nixosConfigurations`
- Create host-specific settings by adding a new settings block:

```nix
<your-hostname>Settings = commonSettings // {
  hostname = "<your-hostname>";
  # Add any host-specific overrides
};
```

- Add your host configuration:

```nix
nixosConfigurations = {
  # ... existing configurations ...
  
  <your-hostname> = nixpkgs.lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit system;
      inherit inputs;
      settings = <your-hostname>Settings;
    };
    modules = [
      ./hosts/<your-hostname>/configuration.nix
      # Add any host-specific modules
    ];
  };
};
```

### 6. Personalize Settings

**Edit common settings in `flake.nix`:**

Replace `hetav` with your username throughout the configuration:

```bash
# Find all instances
grep -r "hetav" --include="*.nix" .

# Use your editor to replace with your username
```

**Update user information in `hosts/_common/user.nix`:**
- Adjust description and groups as needed

### 7. Build and Switch

Enable flakes and build your configuration:

```bash
sudo nixos-rebuild switch --flake .#<your-hostname>
```

On first build, you may need to enable flakes explicitly:

```bash
NIX_CONFIG="experimental-features = nix-command flakes" \
  sudo nixos-rebuild switch --flake .#<your-hostname>
```

### 8. Reboot

After successful build, reboot your system:

```bash
reboot
```

## Configuration Profiles

This configuration includes several pre-configured profiles:

### System Profiles (`hosts/_common/profiles/system/`)

- **desktop-full**: Complete desktop environment with all features
- **desktop-base**: Essential desktop features
- **desktop-minimal**: Minimal desktop setup
- **wsl-minimal**: WSL-specific configuration

### Home Profiles (`hosts/_common/profiles/home/`)

Home-manager configurations can use profiles or manual module enabling:

- **desktop-full**: Complete desktop environment with all features
- **desktop-base**: Essential desktop without heavy applications
- **wsl-minimal**: CLI/TUI tools only for WSL/servers

**Quick Start with Profiles:**
```nix
# In configuration.nix
profiles.system.desktop-full.enable = true;

# In home.nix
profiles.home.desktop-full.enable = true;
```

**Manual Configuration (Advanced):**
```nix
# In home.nix
home.development = { enable = true; enableGui = true; };
home.shell = { enable = true; enableGui = true; };
home.system.enable = true;
home.downloads.enable = true;
home.desktop.hyprland.enableGui = true;
home.browser.zen.enableGui = true;
```

## Updating the System

To update your system:

```bash
cd ~/nixos

# Update flake inputs
nix flake update

# Rebuild with new inputs
sudo nixos-rebuild switch --flake .#<your-hostname>
```

## Customization

### Enabling/Disabling Modules

This configuration uses a **two-tier enable system** for flexibility:
- **`enable`** - Enables CLI/TUI tools (works on WSL and desktop)
- **`enableGui`** - Enables GUI applications (desktop only)

**Examples:**

```nix
# Enable CLI development tools (git, lazygit, etc.)
home.development.enable = true;

# Enable both CLI and GUI development tools (adds vscode, zed-editor, etc.)
home.development = { enable = true; enableGui = true; };

# Enable shell tools
home.shell.enable = true;

# Enable system utilities
home.system.enable = true;

# Enable downloads tools
home.downloads.enable = true;

# Enable GUI-only modules
home.desktop.hyprland.enableGui = true;
home.browser.zen.enableGui = true;

# System-level modules work the same way
system.virtualisation.enable = true;  # CLI: docker, podman
system.virtualisation.enableGui = true;  # GUI: virt-manager, waydroid
```

### Adding New Packages

Add packages in the appropriate module or directly in your host configuration:

```nix
environment.systemPackages = with pkgs; [
  # Your packages here
];
```

### Theming

Theming is managed by Stylix. Configure in your host's configuration:

```nix
system.desktop.styling.enable = true;
```

Wallpapers are stored in `wallpapers/` directory. Set your wallpaper in the host settings.

## Secrets Management

This configuration uses sops-nix for secrets. See `secrets/README.md` for details.

## Documentation

- **NAMING_CONVENTIONS.md**: Detailed documentation of naming conventions, module structure, and organization
- Module-level documentation available in individual module files

## Troubleshooting

### Build Fails

1. Check syntax errors: `nix flake check`
2. Read error messages carefully - they point to specific files and options
3. Ensure all imports exist and paths are correct

### Module Not Found

- Verify the module is imported in the appropriate `default.nix`
- Check that the option namespace matches the module definition

### Home Manager Issues

- Ensure home-manager modules are only imported in home-manager context
- Check that `home-base.nix` is imported correctly in your host's home-manager configuration

## Contributing

Feel free to open issues or submit pull requests if you find bugs or have suggestions for improvements.

## License

MIT License - See LICENSE file for details

## Acknowledgments

- [NixOS](https://nixos.org/) - The declarative Linux distribution
- [Home Manager](https://github.com/nix-community/home-manager) - User environment management
- [Stylix](https://github.com/danth/stylix) - System-wide theming
- [vasujain275/rudra](https://github.com/vasujain275/rudra) - Dotfiles for this configuration
- NixOS community for excellent documentation and support

## Resources

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Nix Pills](https://nixos.org/guides/nix-pills/)
- [NixOS & Flakes Book](https://github.com/ryan4yin/nixos-and-flakes-book)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)

