{extraLib, ...} @ args:
(extraLib.modules.mkModule {
  name = "system.baseservices.flatpak";
  hasCli = false;
  hasGui = true;
  guiConfig = _: {
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
})
args
