{
  extraLib,
  pkgs,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "system.media.obs";
  hasCli = false;
  hasGui = true;
  guiConfig = _: {
    environment.systemPackages = with pkgs; [
      obs-studio
    ];
  };
})
args
