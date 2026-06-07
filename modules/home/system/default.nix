{
  lib,
  config,
  ...
}: {
  imports = [
    ./packages.nix
    ./downloads.nix
    ./nix.nix
  ];

  options = {
    home.system = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable all system utilities and packages";
      };
    };

    # Backwards compatibility options
    home.downloads = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable downloads utilities";
      };
    };

    home.nixSettings = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Nix development settings";
      };
    };
  };

  config = {
    home.system.packages.enable = lib.mkDefault config.home.system.enable;

    # Forward system enable or compatibility enable to submodules
    home.system.downloads.enable = lib.mkDefault (config.home.system.enable || config.home.downloads.enable);
    home.system.nix.enable = lib.mkDefault (config.home.system.enable || config.home.nixSettings.enable);
  };
}
