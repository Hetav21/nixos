{...}: {
  imports = [
    ../_common/home-base.nix
  ];

  # Enable WSL minimal profile
  profiles.home.wsl-minimal.enable = true;
}
