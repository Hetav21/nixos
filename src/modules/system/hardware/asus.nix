{extraLib, ...} @ args:
extraLib.modules.mkModule args {
  name = "drivers.asus";
  hasGui = false;
  cliConfig = {
    # --- ASUS Hardware Services ---
    services.supergfxd.enable = true;
    services.asusd.enable = true;

    # --- ROG Control Center ---
    programs.rog-control-center = {
      enable = true;
      autoStart = true;
    };
  };
}
