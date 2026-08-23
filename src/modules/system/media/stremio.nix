{extraLib, ...} @ args:
extraLib.modules.mkModule args {
  name = "system.media.stremio";
  hasCli = false;
  hasGui = true;
  guiConfig = {
    # --- Stremio Flatpak ---
    services.flatpak.packages = [
      "com.stremio.Stremio"
    ];
  };
}
