{
  extraLib,
  pkgs,
  ...
} @ args:
extraLib.modules.mkProfileModule args {
    name = "profiles.home.wsl";
    description = "Consolidated WSL home profile";

    profileConfig = {
      # --- System Settings & Utilities ---
      home.system = {
        packages.enable = true;
        downloads.enable = true;
        settings.enable = true;
      };

      # --- Development Tools ---
      home.development = {
        git.enable = true;
        neovim.enable = true;
        ssh.enable = true;
        agents.enable = true;
        misc.enable = true;
        misc.enableGui = false;
      };

      # --- Shell & CLI Tools ---
      home.shell = {
        shells.enable = true;
        tmux.enable = true;
        tools.enable = true;
        newsboat.enable = true;
        terminals.enableGui = false;
      };

      # --- Desktop Components (Disabled) ---
      home.desktop = {
        hyprland.enableGui = false;
        hypridle.enableGui = false;
        hyprlock.enableGui = false;
        hyprpaper.enableGui = false;
        hyprshot.enableGui = false;
        clipboard.enableGui = false;
        launcher.enableGui = false;
        notification.enableGui = false;
        wallpaper.enableGui = false;
        panel.enableGui = false;
        wlogout.enableGui = false;
        theme.enableGui = false;
      };

      # --- Web Browsers (Disabled) ---
      home.browser = {
        helium.enableGui = false;
      };

      # --- WSL Packages ---
      home.packages = [pkgs.custom.antigravity-wsl-shim];
    };
  }
