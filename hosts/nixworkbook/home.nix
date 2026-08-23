{lib, ...}: {
  # --- Imports ---
  imports = [
    ../_common/home-base.nix
  ];

  # --- Profile & State Version ---
  profiles.home.wsl.enable = true;
  home.stateVersion = lib.mkForce "24.11";

  # --- Activation Scripts (Windows Integration) ---
  # Copy Alacritty config to Windows filesystem since Windows applications cannot read Unix symlinks
  home.activation.copyAlacrittyConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    ALACRITTY_DIR="/mnt/c/Users/HetavShah/AppData/Roaming/alacritty"
    ALACRITTY_CONFIG="$ALACRITTY_DIR/alacritty.toml"
    SOURCE_CONFIG="/etc/nixos/dotfiles/_wsl/alacritty.wsl.toml"

    if [ ! -d "$ALACRITTY_DIR" ]; then
      $DRY_RUN_CMD mkdir -p "$ALACRITTY_DIR"
    fi

    $DRY_RUN_CMD cp -f "$SOURCE_CONFIG" "$ALACRITTY_CONFIG"
    $DRY_RUN_CMD chmod 644 "$ALACRITTY_CONFIG"
  '';
}
