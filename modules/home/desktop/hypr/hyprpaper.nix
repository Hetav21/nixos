{
  pkgs,
  extraLib,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "home.desktop.hyprpaper";
  hasCli = false;
  hasGui = true;
  guiConfig = _: {
    services = {
      hyprpaper = {
        enable = true;
        package = pkgs.hyprpaper;
        settings = {
          ipc = true;
          splash = false;
        };
      };
    };
  };
})
args
