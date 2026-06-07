{
  extraLib,
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

    services.awww = {
      enable = true;
      package = pkgs.awww;
    };
  };
})
args
