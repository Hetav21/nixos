{
  lib,
  config,
  ...
}: {
  # --- Profile Options ---
  options.profiles.home.desktop = {
    enable = lib.mkEnableOption "Consolidated desktop home profile";
  };

  # --- Profile Configuration ---
  config = lib.mkIf config.profiles.home.desktop.enable {
    # --- System Settings & Utilities ---
    home.system = {
      packages.enable = true;
      downloads.enable = true;
      nix.enable = true;
    };

    # --- Development Tools ---
    home.development = {
      git.enable = true;
      neovim.enable = true;
      ssh.enable = true;
      agents.enable = true;
      misc.enable = true;
      misc.enableGui = true;
      editors.enableGui = true;
    };

    # --- Shell & CLI Tools ---
    home.shell = {
      shells.enable = true;
      tmux.enable = true;
      tools.enable = true;
      newsboat.enable = true;
      terminals.enableGui = true;
    };

    # --- Desktop Components ---
    home.desktop = {
      hyprland.enableGui = true;
      hypridle.enableGui = true;
      hyprlock.enableGui = true;
      hyprpaper.enableGui = true;
      hyprshot.enableGui = true;
      clipboard.enableGui = true;
      launcher.enableGui = true;
      notification.enableGui = true;
      rofi.enableGui = false;
      wallpaper.enableGui = true;
      panel.enableGui = true;
      waybar.enableGui = false;
      wlogout.enableGui = true;
      theme.enableGui = true;
    };

    # --- Web Browsers ---
    home.browser = {
      zen.enableGui = false;
      helium.enableGui = true;
    };
  };
}
