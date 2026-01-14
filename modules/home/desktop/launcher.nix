{
  pkgs,
  config,
  inputs,
  extraLib,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "home.desktop.launcher";
  hasCli = false;
  hasGui = true;
  guiConfig = _: {
    wayland.windowManager.hyprland.settings = {
      bind = [
        "$mainMod, D, exec, vicinae toggle"
        "$mainMod, C, exec, vicinae vicinae://extensions/vicinae/clipboard/history"
        "$mainMod, Space, exec, vicinae vicinae://extensions/vicinae/vicinae/search-emojis"
        "$mainMod, Q, exec, vicinae vicinae://extensions/vicinae/calculator/history"
      ];

      layerrule = [
        # blur
        # "blur 1,match:class vicinae"
        # "ignore_alpha 1,match:class vicinae"
      ];
    };

    programs.vicinae = {
      enable = true;
      package = pkgs.vicinae;

      systemd = {
        enable = true;
        autoStart = true;
      };
      useLayerShell = true;

      settings = {
        close_on_focus_loss = true;
        consider_preedit = true;
        pop_to_root_on_close = true;
        favicon_service = "twenty"; # twenty | google | none
        search_files_in_root = true;

        font = {
          normal = config.stylix.fonts.serif;
          size = config.stylix.fonts.sizes.popups;
        };

        launcher_window = {
          opacity = config.stylix.opacity.popups;
        };
      };

      extensions = with inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system}; [
        nix
        bluetooth
        power-profile
      ];
    };
  };
})
args
