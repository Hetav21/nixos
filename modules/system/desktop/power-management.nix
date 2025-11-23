{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.system.desktop.power-management;
in {
  options.system.desktop.power-management = {
    enable = mkEnableOption "Enable power management configuration";
  };

  config = mkIf cfg.enable {
    services = {
    upower.enable = true;
    auto-cpufreq = {
      enable = true;
      settings = {
        battery = {
          governor = "powersave";
          turbo = "never";
        };
        charger = {
          governor = "performance";
          turbo = "auto";
        };
      };
    };
  };

    powerManagement = {
      enable = true;
      powertop.enable = true;
    };
  };
}
