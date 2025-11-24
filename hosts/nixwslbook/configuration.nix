{
  lib,
  pkgs,
  config,
  inputs,
  settings,
  ...
}: {
  imports = [
    ../_common
  ];

  # Home Manager configuration
  home-manager = {
    extraSpecialArgs = {inherit inputs settings;};
    users.${settings.username} = import ./home.nix;
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
  };

  # WSL-specific configuration
  wsl.enable = true;
  wsl.defaultUser = settings.username;

  # Minimal WSL system profile (CLI/TUI only, no desktop environment)
  profiles.system.wsl-minimal.enable = true;

  # Override flatpak packages to be empty for WSL (no GUI apps needed)
  services.flatpak.packages = lib.mkForce [];
}
