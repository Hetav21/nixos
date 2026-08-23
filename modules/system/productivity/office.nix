{extraLib, ...} @ args:
extraLib.modules.mkModule args {
  name = "system.productivity.office";
  hasCli = false;
  hasGui = true;
  guiConfig = {
    # --- Flatpak Applications ---
    services.flatpak.packages = [
      "org.libreoffice.LibreOffice"
      "org.onlyoffice.desktopeditors"
    ];
  };
}
