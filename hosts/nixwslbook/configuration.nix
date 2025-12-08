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

  # Point to host-specific home.nix (centralized home-manager is in _common)
  local.homeConfig = ./home.nix;

  # Set hostname for WSL
  networking.hostName = settings.hostname;

  # WSL-specific configuration
  wsl = {
    enable = true;
    defaultUser = settings.username;
    wrapBinSh = true;
    extraBin = [
      {
        name = "bash";
        src = config.wsl.binShExe;
      }
      {src = "${lib.getExe' pkgs.coreutils "uname"}";}
      {src = "${lib.getExe' pkgs.coreutils "mkdir"}";}
      {src = "${lib.getExe' pkgs.coreutils "cp"}";}
    ];
    # Re-register WSLInterop to allow running .exe files alongside other binfmt registrations
    interop.register = true;
    docker-desktop.enable = true;
  };

  # Minimal WSL system profile (CLI/TUI only, no desktop environment)
  profiles.system.wsl-minimal.enable = true;

  # Override flatpak packages to be empty for WSL (no GUI apps needed)
  services.flatpak.packages = lib.mkForce [];
}
