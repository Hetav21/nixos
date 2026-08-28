{
  lib,
  config,
  inputs,
  settings,
  extraLib,
  pkgs-unstable,
  pkgs-master,
  ...
}: {
  # --- Imports ---
  imports = [
    ./user.nix
    ../../modules
    ../../profiles
    ../../secrets
  ];

  # --- Host Options ---
  options.local.homeConfig = lib.mkOption {
    type = lib.types.path;
    description = "Path to host-specific home.nix file";
  };

  # --- Centralized Home Manager Configuration ---
  config = {
    home-manager = {
      extraSpecialArgs = {inherit inputs settings extraLib pkgs-unstable pkgs-master;};
      users.${settings.username} = import config.local.homeConfig;
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "backup";
    };

    # --- System State Version ---
    system.stateVersion = "25.11";
  };
}
