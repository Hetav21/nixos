{
  extraLib,
  pkgs,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "system.browser.browseros";
  hasCli = false;
  hasGui = true;
  guiConfig = _: {
    environment.systemPackages = [
      pkgs.custom.browseros
    ];
  };
})
args
