{
  lib,
  config,
  ...
}: {
  imports = [
    ./hypr
    ./clipboard.nix
    ./launcher.nix
    ./notification.nix
    ./panel.nix
    ./rofi.nix
    ./theme.nix
    ./wallpaper.nix
    ./waybar.nix
    ./wlogout.nix
  ];

  options = {
    home.desktop = {
      enableGui = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable all desktop GUI components";
      };
    };
  };

  config = {
    home.desktop.hyprland.enableGui = lib.mkDefault config.home.desktop.enableGui;
    home.desktop.hypridle.enableGui = lib.mkDefault config.home.desktop.enableGui;
    home.desktop.hyprlock.enableGui = lib.mkDefault config.home.desktop.enableGui;
    home.desktop.hyprpaper.enableGui = lib.mkDefault config.home.desktop.enableGui;
    home.desktop.hyprshot.enableGui = lib.mkDefault config.home.desktop.enableGui;
    home.desktop.clipboard.enableGui = lib.mkDefault config.home.desktop.enableGui;
    home.desktop.launcher.enableGui = lib.mkDefault config.home.desktop.enableGui;
    home.desktop.notification.enableGui = lib.mkDefault config.home.desktop.enableGui;
    home.desktop.theme.enableGui = lib.mkDefault config.home.desktop.enableGui;
    home.desktop.wallpaper.enableGui = lib.mkDefault config.home.desktop.enableGui;
    home.desktop.panel.enableGui = lib.mkDefault config.home.desktop.enableGui;
    home.desktop.wlogout.enableGui = lib.mkDefault config.home.desktop.enableGui;
  };
}
