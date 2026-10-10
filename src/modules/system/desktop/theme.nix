{
  extraLib,
  pkgs,
  config,
  settings,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "system.desktop.theme";
  hasGui = false;
  cliConfig = {
    # --- System Theming ---
    system.stylix.enable = true;

    # --- Fonts ---
    fonts = {
      enableDefaultPackages = true;

      fontconfig = {
        hinting = {
          enable = true;
          style = "slight";
          autohint = false;
        };
        antialias = true;
        subpixel = {
          rgba = "rgb";
          lcdfilter = "default";
        };
      };

      packages = [
        pkgs.nerd-fonts.jetbrains-mono
        pkgs.nerd-fonts.fira-code
        pkgs.font-awesome
        pkgs.dejavu_fonts
        pkgs.ubuntu-classic
        pkgs.noto-fonts
        pkgs.noto-fonts-color-emoji
      ];
    };

    # --- Stylix Desktop Visuals ---
    stylix = {
      image = extraLib.paths.wallpaper settings.wallpaper;

      cursor = {
        name = let
          suffix =
            if config.stylix.polarity == "dark"
            then "Ice"
            else "Classic";
        in "Bibata-Modern-${suffix}";
        package = pkgs.bibata-cursors;
        size = 24;
      };

      fonts = {
        monospace = {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetBrainsMono Nerd Font Mono";
        };

        serif = {
          package = pkgs.noto-fonts;
          name = "Noto Serif";
        };

        sansSerif = {
          package = pkgs.ubuntu-classic;
          name = "Ubuntu";
        };

        emoji = {
          package = pkgs.noto-fonts-color-emoji;
          name = "Noto Color Emoji";
        };

        sizes = {
          applications = 12;
          terminal = 12;
          desktop = 11;
          popups = 12;
        };
      };
    };
  };
}
