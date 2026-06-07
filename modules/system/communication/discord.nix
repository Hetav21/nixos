{
  extraLib,
  pkgs-unstable,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "system.communication.discord";
  hasCli = false;
  hasGui = true;
  guiConfig = _: {
    environment.systemPackages = with pkgs-unstable; [
      discord
      vesktop
    ];
  };
})
args
