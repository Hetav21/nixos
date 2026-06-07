{
  extraLib,
  pkgs,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "system.network.applet";
  hasCli = false;
  hasGui = true;
  guiConfig = _: {
    environment.systemPackages = [
      pkgs.networkmanagerapplet
    ];
  };
})
args
