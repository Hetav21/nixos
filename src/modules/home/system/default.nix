{
  extraLib,
  lib,
  ...
} @ args:
extraLib.modules.mkCategoryModule args {
  name = "home.system";
  imports = [
    ./packages.nix
    ./downloads.nix
    ./settings.nix
  ];
  hasCli = true;
  cliDescription = "Enable all system utilities and packages";
  cliChildren = [
    "packages"
    "downloads"
    "settings"
  ];

  extraOptions = {
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

  extraConfig = {config, ...}: {
    home.system.downloads.enable = lib.mkDefault config.home.downloads.enable;
    home.system.settings.enable = lib.mkDefault (config.home.nixSettings.enable || config.home.system.nix.enable);
  };
}
