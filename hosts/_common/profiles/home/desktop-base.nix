# Base desktop home profile without heavy applications
# Includes: Essential CLI/TUI + lightweight GUI tools
{
  lib,
  config,
  pkgs,
  ...
}:
with lib; {
  options.profiles.home.desktop-base = {
    enable = mkEnableOption "Base desktop home profile without heavy applications";
  };

  config = mkIf config.profiles.home.desktop-base.enable {
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

    # Enable essential desktop modules only
    home.desktop.hyprland.enableGui = true;
    home.desktop.waybar.enableGui = true;
    home.desktop.clipboard.enableGui = true;
    home.desktop.notification.enableGui = true;
    home.desktop.launcher.enableGui = true;

    # Disable non-essential desktop modules
    home.desktop.hypridle.enableGui = false;
    home.desktop.hyprlock.enableGui = false;
    home.desktop.hyprshot.enableGui = false;
    home.desktop.rofi.enableGui = false;
    home.desktop.wallpaper.enableGui = false;
    home.desktop.wlogout.enableGui = false;

    # Enable browser
    home.browser.zen.enableGui = true;

    # GTK theming configuration (common for all desktop hosts)
    gtk = {
      enable = true;
      gtk3.extraConfig = {gtk-application-prefer-dark-theme = 1;};
      gtk4.extraConfig = {gtk-application-prefer-dark-theme = 1;};
    };

    # Qt configuration (common for all desktop hosts)
    qt.enable = true;
  };
}
