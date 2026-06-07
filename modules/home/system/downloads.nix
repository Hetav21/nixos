{
  extraLib,
  pkgs,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "home.system.downloads";
  hasCli = true;
  hasGui = false;
  cliConfig = _: {
    home.packages = with pkgs; [
      # Download managers
      aria2
      yt-dlp
    ];
  };
})
args
