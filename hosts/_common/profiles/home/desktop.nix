# Consolidated desktop home profile
{
  lib,
  config,
  ...
}: {
  options.profiles.home.desktop = {
    enable = lib.mkEnableOption "Consolidated desktop home profile";
  };

  config = lib.mkIf config.profiles.home.desktop.enable {
    # System settings and utilities
    home.system = {
      packages.enable = true;
      downloads.enable = true;
      nix.enable = true;
    };

    # Development tools
    home.development = {
      git.enable = true;
      neovim.enable = true;
      ssh.enable = true;
      agents.enable = true;
      misc.enable = true;
      misc.enableGui = true;
    };

    # Shell and CLI tools
    home.shell = {
      shells.enable = true;
      tmux.enable = true;
      tools.enable = true;
      terminals.enableGui = true;
    };

    # Desktop components
    home.desktop = {
      hyprland.enableGui = true;
      hypridle.enableGui = true;
      hyprlock.enableGui = true;
      hyprpaper.enableGui = true;
      hyprshot.enableGui = true;
      clipboard.enableGui = true;
      launcher.enableGui = true;
      notification.enableGui = true;
      rofi.enableGui = false; # Using launcher instead
      wallpaper.enableGui = true;
      panel.enableGui = true;
      waybar.enableGui = false; # Using panel instead
      wlogout.enableGui = true;
      theme.enableGui = true;
    };

    # Browsers enabled individually
    home.browser = {
      zen.enableGui = false;
      helium.enableGui = true;
    };
  };
}
