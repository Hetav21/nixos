{extraLib, ...} @ args:
(extraLib.modules.mkModule {
  name = "system.desktopEnvironment";
  hasCli = false;
  hasGui = true;
  guiConfig = _: {
    # Import desktop environment sub-modules
    system.desktop.appimage.enable = true;
    system.desktop.environment.enable = true;
    system.desktop.displayManager.enable = true;
    system.desktop.xdgConfig.enable = true;
    system.desktop.security.enable = true;
    system.desktop.powerManagement.enable = true;
    system.desktop.printing.enable = true;
  };
})
args
