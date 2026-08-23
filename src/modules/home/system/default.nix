{
  lib,
  config,
  ...
}: {
  # --- Submodule Imports ---
  imports = [
    ./packages.nix
    ./downloads.nix
    ./settings.nix
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

    home.system.nix.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Alias for home.system.settings.enable";
    };
  };

  # --- Module Wiring ---
  config = {
    home.system.packages.enable = lib.mkDefault config.home.system.enable;
    home.system.downloads.enable = lib.mkDefault (config.home.system.enable || config.home.downloads.enable);
    home.system.settings.enable = lib.mkDefault (config.home.system.enable || config.home.nixSettings.enable || config.home.system.nix.enable);
  };
}
