{
  lib,
  pkgs,
  config,
  settings,
  ...
}:
with lib; let
  cfg = config.home.desktop.hyprpaper;
in {
  options.home.desktop.hyprpaper = {
    enableGui = mkEnableOption "Enable hyprpaper backend to manage wallpaper";
  };

  config = mkIf cfg.enableGui {
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
}
