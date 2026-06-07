{
  extraLib,
  pkgs,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "system.media.mpv";
  hasCli = true;
  hasGui = false;
  cliConfig = _: {
    environment.systemPackages = with pkgs; [
      mpv
    ];
  };
})
args
