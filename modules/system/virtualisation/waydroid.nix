{extraLib, ...} @ args:
(extraLib.modules.mkModule {
  name = "system.virtualisation.waydroid";
  hasCli = false;
  hasGui = true;
  guiConfig = {
    virtualisation.waydroid.enable = true;
  };
})
args
