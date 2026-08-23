{extraLib, ...} @ args:
extraLib.modules.mkModule args {
  name = "system.media.graphics";
  hasCli = false;
  hasGui = true;
  guiConfig = {
    # --- Graphics & Video Flatpaks ---
    services.flatpak.packages = [
      "org.gnome.Loupe"
      "com.github.PintaProject.Pinta"
      "org.kde.kdenlive"
    ];
  };
}
