{
  mkModule,
  lib,
  pkgs,
  ...
} @ args:
(mkModule {
  name = "home.downloads";
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
