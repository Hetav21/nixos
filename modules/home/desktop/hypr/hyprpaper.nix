{
  extraLib,
  pkgs,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "home.desktop.hyprpaper";
  hasCli = false;
  hasGui = true;

  guiConfig = {
    # --- Hyprpaper Wallpaper Daemon ---
    services.hyprpaper = {
      enable = true;
      package = pkgs.hyprpaper;
      settings = {
        ipc = true;
        splash = false;
      };
    };
  };
}
