# Minimal WSL home profile (CLI/TUI only)
# Includes: All development and shell tools without GUI
{
  lib,
  config,
  ...
}:
with lib; {
  options.profiles.home.wsl-minimal = {
    enable = mkEnableOption "Minimal WSL home profile with CLI/TUI tools only";
  };

  config = mkIf config.profiles.home.wsl-minimal.enable {
    # Enable only CLI/TUI modules
    home.nix-settings.enable = true;
    home.development.enable = true;
    home.shell.enable = true;
    home.system.enable = true;
    home.downloads.enable = true;
    home.desktop.notification.enable = true;

    # Explicitly disable all GUI components
    home.development.enableGui = false;
    home.shell.enableGui = false;

    # Desktop and browser modules are not enabled (GUI only)
    home.desktop.hyprland.enableGui = false;
    home.desktop.hypridle.enableGui = false;
    home.desktop.hyprlock.enableGui = false;
    home.desktop.hyprpaper.enableGui = false;
    home.desktop.hyprshot.enableGui = false;
    home.desktop.clipboard.enableGui = false;
    home.desktop.launcher.enableGui = false;
    home.desktop.notification.enableGui = false;
    home.desktop.rofi.enableGui = false;
    home.desktop.wallpaper.enableGui = false;
    home.desktop.waybar.enableGui = false;
    home.desktop.wlogout.enableGui = false;
    home.browser.zen.enableGui = false;
  };
}
