{
  mkModule,
  lib,
  pkgs,
  config,
  settings,
  ...
} @ args:
(mkModule {
  name = "system.stylix";
  hasGui = false;
  cliConfig = _: let
    # Only use wallpaper if desktop environment is enabled (not for WSL)
    hasDesktop = config.system.desktop-environment.enableGui or false;
  in {
    # Font packages
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

      packages = with pkgs; [nerd-fonts.jetbrains-mono nerd-fonts.fira-code font-awesome dejavu_fonts];
    };

    # Stylix configuration
    stylix = lib.mkMerge [
      {
        enable = true;
        polarity = "dark";

        base16Scheme = {
          base00 = "191724";
          base01 = "1f1d2e";
          base02 = "26233a";
          base03 = "6e6a86";
          base04 = "908caa";
          base05 = "e0def4";
          base06 = "e0def4";
          base07 = "524f67";
          base08 = "eb6f92";
          base09 = "f6c177";
          base0A = "ea9a97";
          base0B = "3e8fb0";
          base0C = "9ccfd8";
          base0D = "c4a7e7";
          base0E = "f6c177";
          base0F = "524f67";
        };

        opacity = {
          applications = 1.0;
          desktop = 1.0;
          terminal = 0.8;
          popups = 0.7;
        };

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

          serif = config.stylix.fonts.monospace;
          sansSerif = config.stylix.fonts.monospace;
          emoji = config.stylix.fonts.monospace;

          sizes = {
            applications = 12;
            terminal = 12;
            desktop = 11;
            popups = 12;
          };
        };
      }

      # Only set wallpaper image for desktop environments (not WSL)
      (lib.mkIf hasDesktop {
        image = ../../wallpapers/${settings.wallpaper};
      })
    ];
  };
})
args
