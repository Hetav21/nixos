{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../_common/home-base.nix
  ];

  # Enable WSL minimal profile
  profiles.home.wsl-minimal.enable = true;

  # WSL-specific configuration: Copy Alacritty config to Windows filesystem
  # Note: Windows applications cannot read Unix symlinks, so we must copy the file
  home.activation.copyAlacrittyConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    ALACRITTY_DIR="/mnt/c/Users/HetavShah/AppData/Roaming/alacritty"
    ALACRITTY_CONFIG="$ALACRITTY_DIR/alacritty.toml"
    SOURCE_CONFIG="/etc/nixos/dotfiles/_wsl/alacritty.wsl.toml"

    # Create directory if it doesn't exist
    if [ ! -d "$ALACRITTY_DIR" ]; then
      $DRY_RUN_CMD mkdir -p "$ALACRITTY_DIR"
    fi

    # Copy the config file (overwrite if it exists)
    $DRY_RUN_CMD cp -f "$SOURCE_CONFIG" "$ALACRITTY_CONFIG"

    # Set proper permissions for Windows to read
    $DRY_RUN_CMD chmod 644 "$ALACRITTY_CONFIG"
  '';
}
