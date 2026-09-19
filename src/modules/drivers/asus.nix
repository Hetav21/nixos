# ASUS Laptop Hardware Integration Module
#
# Configures ASUS-specific system daemons (asusd, supergfxd) for CLI
# and the ROG Control Center application for graphical environments.
{extraLib, ...} @ args:
extraLib.modules.mkModule args {
  name = "drivers.asus";
  hasGui = true;

  # --- System Daemon Configuration ---
  cliConfig = {
    services.supergfxd.enable = true;
    services.asusd.enable = true;
  };

  # --- GUI Configuration ---
  guiConfig = {
    programs.rog-control-center = {
      enable = true;
      autoStart = true;
    };
  };
}
