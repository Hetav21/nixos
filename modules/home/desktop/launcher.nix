{
  lib,
  inputs,
  config,
  ...
}:
with lib; let
  cfg = config.home.desktop.launcher;
in {
  imports = [inputs.vicinae.homeManagerModules.default];

  options.home.desktop.launcher = {
    enableGui = mkEnableOption "Enable GUI launcher";
  };

  config = mkIf cfg.enableGui {
    wayland.windowManager.hyprland.settings = {
      bind = [
        "$mainMod, D, exec, vicinae toggle"
        "$mainMod, C, exec, vicinae vicinae://extensions/vicinae/clipboard/history"
        "$mainMod, Space, exec, vicinae vicinae://extensions/vicinae/vicinae/search-emojis"
        "$mainMod, Q, exec, vicinae vicinae://extensions/vicinae/calculator/history"
      ];

      layerrule = [
        # blur
        "blur,vicinae"
        "ignorealpha 0, vicinae"
      ];
    };

    nix.settings = {
      extra-substituters = ["https://vicinae.cachix.org"];
      extra-trusted-public-keys = ["vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="];
    };

    services.vicinae = {
      enable = true;
      autoStart = true;

      settings = {
        faviconService = "twenty"; # twenty | google | none
        font = {
          normal = config.stylix.fonts.serif;
          size = config.stylix.fonts.sizes.popups;
        };
        popToRootOnClose = true;
        rootSearch.searchFiles = false;
        closeOnFocusLoss = true;
        # handled by stylix
        # theme = {
        #   name = "rose-pine-moon";
        #   iconTheme = "Bibata-Modern-Amber";
        # };
        window = {
          csd = true;
          opacity = config.stylix.opacity.popups;
          rounding = 10;
        };
      };

      # Installing (vicinae) extensions declaratively
      # extensions = [
      #   (inputs.vicinae.mkVicinaeExtension.${pkgs.system} {
      #     inherit pkgs;
      #     name = "extension-name";
      #     src = pkgs.fetchFromGitHub {
      #       # You can also specify different sources other than github
      #       owner = "repo-owner";
      #       repo = "repo-name";
      #       rev = "v1.0"; # If the extension has no releases use the latest commit hash
      #       # You can get the sha256 by rebuilding once and then copying the output hash from the error message
      #       sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
      #     }; # If the extension is in a subdirectory you can add ` + "/subdir"` between the brace and the semicolon here
      #   })
      # ];
    };
  };
}
