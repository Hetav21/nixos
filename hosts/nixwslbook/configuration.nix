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
      # Coreutils for remote server compatibility
      {src = "${lib.getExe' pkgs.coreutils "uname"}";}
      {src = "${lib.getExe' pkgs.coreutils "mkdir"}";}
      {src = "${lib.getExe' pkgs.coreutils "cp"}";}
      {src = "${lib.getExe' pkgs.coreutils "cat"}";}
      {src = "${lib.getExe' pkgs.coreutils "ls"}";}
      {src = "${lib.getExe' pkgs.coreutils "rm"}";}
      {src = "${lib.getExe' pkgs.coreutils "mv"}";}
      {src = "${lib.getExe' pkgs.coreutils "chmod"}";}
      {src = "${lib.getExe' pkgs.coreutils "env"}";}
      {src = "${lib.getExe' pkgs.coreutils "dirname"}";}
      {src = "${lib.getExe' pkgs.coreutils "readlink"}";}
      {src = "${lib.getExe' pkgs.coreutils "wc"}";}
      {src = "${lib.getExe' pkgs.coreutils "head"}";}
      {src = "${lib.getExe' pkgs.coreutils "tail"}";}
      {src = "${lib.getExe' pkgs.coreutils "tr"}";}
      # Additional common tools
      {src = "${lib.getExe pkgs.gnused}";}
      {src = "${lib.getExe pkgs.gnugrep}";}
      {src = "${lib.getExe pkgs.gnutar}";}
      {src = "${lib.getExe pkgs.gzip}";}
      {src = "${lib.getExe pkgs.findutils}";}
      {src = "${lib.getExe pkgs.wget}";}
      {src = "${lib.getExe pkgs.curl}";}
    ];
    # Re-register WSLInterop to allow running .exe files alongside other binfmt registrations
    interop.register = true;
    docker-desktop.enable = true;
  };

  # Minimal WSL system profile (CLI/TUI only, no desktop environment)
  profiles.system.wsl-minimal.enable = true;

  # Host-specific stateVersion (override common 25.11)
  system.stateVersion = lib.mkForce "24.11";

  # Override flatpak packages to be empty for WSL (no GUI apps needed)
  services.flatpak.packages = lib.mkForce [];
}
