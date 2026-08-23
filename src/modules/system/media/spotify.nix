{extraLib, ...} @ args:
extraLib.modules.mkModule args {
  name = "system.media.spotify";
  hasCli = false;
  hasGui = true;
  guiConfig = {
    # --- Spotify Flatpak ---
    services.flatpak.packages = [
      "com.spotify.Client"
    ];
  };
}
