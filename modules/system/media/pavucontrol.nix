{
  extraLib,
  pkgs,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "system.media.pavucontrol";
  hasCli = false;
  hasGui = true;
  guiConfig = _: {
    environment.systemPackages = with pkgs; [
      pavucontrol
    ];
  };
})
args
