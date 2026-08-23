{extraLib, ...} @ args:
extraLib.modules.mkModule args {
  name = "system.desktop.powerManagement";
  hasGui = false;
  cliConfig = {
    # --- Power Services ---
    services.upower.enable = true;
    services.auto-cpufreq = {
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

    # --- Powertop & Management ---
    powerManagement = {
      enable = true;
      powertop.enable = true;
    };
  };
}
