{
  extraLib,
  pkgs,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "system.desktop.power-management";
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

    # --- Power Management & Diagnostics ---
    powerManagement.enable = true;
    environment.systemPackages = [pkgs.powertop];
  };
}
