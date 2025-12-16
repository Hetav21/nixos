{
  extraLib,
  lib,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "system.desktop.power-management";
  hasGui = false;
  cliConfig = _: {
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
})
args
