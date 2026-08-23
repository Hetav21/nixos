{
  extraLib,
  pkgs,
  config,
  inputs,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "home.desktop.launcher";
  hasCli = false;
  hasGui = true;

  guiConfig = {
    # --- Hyprland Keybindings ---
    wayland.windowManager.hyprland.settings = {
      bind = [
        "$mainMod, D, exec, vicinae toggle"
        "$mainMod, V, exec, vicinae vicinae://launch/clipboard/history"
        "$mainMod, Space, exec, vicinae vicinae://launch/core/search-emojis"
        "$mainMod, Q, exec, vicinae vicinae://launch/calculator/history"
      ];
    };

    # --- Vicinae Application Launcher ---
    programs.vicinae = {
      enable = true;
      package = pkgs.vicinae;
      useLayerShell = true;

      systemd = {
        enable = true;
        autoStart = true;
      };

      settings = {
        close_on_focus_loss = true;
        consider_preedit = true;
        pop_to_root_on_close = true;
        favicon_service = "twenty";
        search_files_in_root = true;

        font = {
          normal = config.stylix.fonts.serif;
          size = config.stylix.fonts.sizes.popups;
        };

        launcher_window = {
          opacity = config.stylix.opacity.popups;
        };
      };

      extensions = let
        vicinaePkgs = inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system};
      in [
        vicinaePkgs.nix
        vicinaePkgs.power-profile
      ];
    };
  };
}
