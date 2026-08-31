{
  extraLib,
  ...
} @ args:
extraLib.modules.mkCategoryModule args {
  name = "home.desktop";
  imports = [
    ./hypr
    ./clipboard.nix
    ./launcher.nix
    ./notification.nix
    ./panel.nix
    ./theme.nix
    ./wallpaper.nix
    ./wlogout.nix
  ];
  hasGui = true;
  guiDescription = "Enable all desktop GUI components";
  guiChildren = [
    "hyprland"
    "hypridle"
    "hyprlock"
    "hyprpaper"
    "hyprshot"
    "clipboard"
    "launcher"
    "notification"
    "theme"
    "wallpaper"
    "panel"
    "wlogout"
  ];
}
