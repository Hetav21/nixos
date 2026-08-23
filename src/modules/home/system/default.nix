{
  lib,
  config,
  ...
}: {
  # --- Submodule Imports ---
  imports = [
    ./packages.nix
    ./downloads.nix
    ./nix.nix
  ];

  # --- Options ---
  options = {
    home.system = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable all system utilities and packages";
      };
    };

    # Backwards compatibility options
    home.downloads.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable downloads utilities";
    };

    home.nixSettings.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Nix development settings";
    };
  };

  # --- Module Wiring ---
  config = {
    home.system.packages.enable = lib.mkDefault config.home.system.enable;
    home.system.downloads.enable = lib.mkDefault (config.home.system.enable || config.home.downloads.enable);
    home.system.nix.enable = lib.mkDefault (config.home.system.enable || config.home.nixSettings.enable);
  };
}
