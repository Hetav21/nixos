{extraLib, ...} @ args:
extraLib.modules.mkModule args {
  name = "system.productivity.teams";
  hasCli = false;
  hasGui = true;
  guiConfig = {
    # --- Flatpak Applications ---
    services.flatpak.packages = [
      "com.github.IsmaelMartinez.teams_for_linux"
    ];
  };
}
