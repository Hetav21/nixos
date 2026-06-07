{
  extraLib,
  pkgs-unstable,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "home.shell.terminals";
  hasCli = false;
  hasGui = true;
  guiConfig = _: {
    programs = {
      alacritty = {
        enable = true;
        package = pkgs-unstable.alacritty;
      };

      ghostty = {
        enable = true;
        package = pkgs-unstable.ghostty;
      };
    };
  };
})
args
