{
  extraLib,
  pkgs,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "system.communication.thunderbird";
  hasCli = false;
  hasGui = true;
  guiConfig = _: {
    environment.systemPackages = [
      pkgs.thunderbird
    ];
  };
})
args
