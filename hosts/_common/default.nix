# Common system configuration shared across all hosts
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
  # Common imports
  imports = [
    ./user.nix
    ../../modules
    ./profiles
    ../../secrets
  ];

  # Option for host-specific home.nix path
  options.local.homeConfig = lib.mkOption {
    type = lib.types.path;
    description = "Path to host-specific home.nix file";
  };

  config = {
    # Centralized Home Manager configuration
    home-manager = {
      extraSpecialArgs = {inherit inputs settings extraLib pkgs-unstable pkgs-master;};
      users.${settings.username} = import config.local.homeConfig;
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "backup";
    };

    # State version
    system.stateVersion = "25.11";
  };
}
