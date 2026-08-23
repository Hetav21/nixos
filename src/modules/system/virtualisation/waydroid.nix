{extraLib, ...} @ args:
extraLib.modules.mkModule args {
  name = "system.virtualisation.waydroid";
  hasCli = false;
  hasGui = true;
  guiConfig = {
    # --- Waydroid Service ---
    virtualisation.waydroid.enable = true;
  };
}
