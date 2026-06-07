{extraLib, ...} @ args:
(extraLib.modules.mkModule {
  name = "system.browser.edge";
  hasCli = false;
  hasGui = true;
  guiConfig = _: {
    services.flatpak.packages = [
      "com.microsoft.Edge"
    ];
  };
})
args
