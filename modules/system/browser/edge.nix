{extraLib, ...} @ args:
extraLib.modules.mkModule args {
  name = "system.browser.edge";
  hasCli = false;
  hasGui = true;
  guiConfig = {
    # --- Microsoft Edge Flatpak ---
    services.flatpak.packages = [
      "com.microsoft.Edge"
    ];
  };
}
