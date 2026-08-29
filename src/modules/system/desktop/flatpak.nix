{extraLib, ...} @ args:
extraLib.modules.mkModule args {
  name = "system.desktop.flatpak";
  hasCli = false;
  hasGui = true;
  guiConfig = {
    # --- Flatpak Service ---
    services.flatpak = {
      enable = true;
      uninstallUnmanaged = true;
      update.auto = {
        enable = true;
        onCalendar = "daily";
      };
      packages = [
        "io.github.flattool.Warehouse"
        "com.github.tchx84.Flatseal"
      ];
    };
  };
}
