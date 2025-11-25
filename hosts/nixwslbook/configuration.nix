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

  # Set hostname for WSL
  networking.hostName = settings.hostname;

  # Home Manager configuration
  home-manager = {
    extraSpecialArgs = {inherit inputs settings;};
    users.${settings.username} = import ./home.nix;
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
  };

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
      {src = "${pkgs.coreutils}/bin/uname";}
      {src = "${pkgs.coreutils}/bin/mkdir";}
      {src = "${pkgs.coreutils}/bin/cp";}
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
