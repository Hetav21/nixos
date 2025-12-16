{
  extraLib,
  lib,
  pkgs,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "home.desktop.wallpaper";
  hasCli = false;
  hasGui = true;
  guiConfig = _: {
    home.packages = with pkgs; [
      waypaper
    ];

    services.swww = {
      enable = true;
      package = pkgs.swww;
    };
  };
})
args
