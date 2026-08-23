{extraLib, ...} @ args:
extraLib.modules.mkModule args {
  name = "system.desktopEnvironment";
  hasCli = false;
  hasGui = true;
  guiConfig = {
    # --- Desktop Environment Stack ---
    system.desktop.appimage.enable = true;
    system.desktop.environment.enable = true;
    system.desktop.displayManager.enable = true;
    system.desktop.xdgConfig.enable = true;
    system.desktop.security.enable = true;
    system.desktop.powerManagement.enable = true;
    system.desktop.printing.enable = true;
  };
}
