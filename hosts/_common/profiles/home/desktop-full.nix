# Full desktop home profile with all features
# Includes: All CLI/TUI tools + GUI applications
{
  lib,
  config,
  ...
}:
with lib; {
  options.profiles.home.desktop-full = {
    enable = mkEnableOption "Full desktop home profile with all features";
  };

  config = mkIf config.profiles.home.desktop-full.enable {
    # Enable categorized modules with both CLI and GUI
    home.development = {
      enable = true;
      enableGui = true;
    };

    home.shell = {
      enable = true;
      enableGui = true;
    };

    home.system.enable = true;
    home.downloads.enable = true;

    # Enable all desktop modules (GUI only)
    home.desktop.hyprland.enableGui = true;
    home.desktop.hypridle.enableGui = true;
    home.desktop.hyprlock.enableGui = true;
    home.desktop.hyprshot.enableGui = true;
    home.desktop.clipboard.enableGui = true;
    home.desktop.launcher.enableGui = true;
    home.desktop.notification.enableGui = true;
    home.desktop.rofi.enableGui = false;  # Using launcher instead
    home.desktop.wallpaper.enableGui = true;
    home.desktop.waybar.enableGui = true;
    home.desktop.wlogout.enableGui = true;

    # Enable browser
    home.browser.zen.enableGui = true;
  };
}

