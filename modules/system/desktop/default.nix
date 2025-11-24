{...}: {
  imports = [
    # Desktop environment components (managed by system.desktop-environment)
    ./appimage.nix
    ./environment.nix
    ./display-manager.nix
    ./power-management.nix
    ./printing.nix
    ./security.nix
    ./xdg-config.nix
  ];
}
