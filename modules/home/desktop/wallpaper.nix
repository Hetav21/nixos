{
  extraLib,
  pkgs,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "home.desktop.wallpaper";
  hasCli = false;
  hasGui = true;

  guiConfig = {
    # --- Packages ---
    home.packages = [
      pkgs.waypaper
    ];

    # --- Wallpaper Daemon ---
    services.awww = {
      enable = true;
      package = pkgs.awww;
    };
  };
}
