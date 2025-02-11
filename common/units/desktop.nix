{
  config,
  lib,
  pkgs,
  inputs,
  options,
  ...
}: let
  wallpaper = "artistic-boy-relaxing.jpg";
in {
  environment.systemPackages = with pkgs; [
    hyprpicker
    hyprshot
    hyprlang
    hyprutils
    hyprgraphics
    hyprwayland-scanner
    wlr-protocols
    libsForQt5.qt5.qtgraphicaleffects # sddm dep
  ];

  stylix = {
    enable = true;
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
      base0A = "ebbcba";
      base0B = "31748f";
      base0C = "9ccfd8";
      base0D = "c4a7e7";
      base0E = "f6c177";
      base0F = "524f67";
    };
    image = ../../config/assets/${wallpaper};
    polarity = "dark";
    opacity.terminal = 0.8;
    cursor.package = pkgs.bibata-cursors;
    cursor.name = "Bibata-Modern-Ice";
    cursor.size = 24;
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      serif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      sizes = {
        applications = 12;
        terminal = 15;
        desktop = 11;
        popups = 12;
      };
    };
  };

  xdg = {
    mime.defaultApplications = {
      # Web and HTML
      "x-scheme-handler/http" = "userapp-Zen Browser-CWEPZ2.desktop";
      "x-scheme-handler/https" = "userapp-Zen Browser-CWEPZ2.desktop";
      "x-scheme-handler/chrome" = "userapp-Zen Browser-CWEPZ2.desktop";
      "text/html" = "userapp-Zen Browser-CWEPZ2.desktop";
      "application/x-extension-htm" = "userapp-Zen Browser-CWEPZ2.desktop";
      "application/x-extension-html" = "userapp-Zen Browser-CWEPZ2.desktop";
      "application/x-extension-shtml" = "userapp-Zen Browser-CWEPZ2.desktop";
      "application/x-extension-xhtml" = "userapp-Zen Browser-CWEPZ2.desktop";
      "application/xhtml+xml" = "userapp-Zen Browser-CWEPZ2.desktop";

      # File management
      "inode/directory" = "thunar.desktop";

      # Text editor
      ## "text/plain" = "vim";

      # Terminal
      "x-scheme-handler/terminal" = "ghostty.desktop";

      # Videos
      "video/quicktime" = "mpv-2.desktop";
      "video/x-matroska" = "mpv-2.desktop";

      # LibreOffice formats
      "application/vnd.oasis.opendocument.text" = "libreoffice-writer.desktop";
      "application/vnd.oasis.opendocument.spreadsheet" = "libreoffice-calc.desktop";
      "application/vnd.oasis.opendocument.presentation" = "libreoffice-impress.desktop";
      "application/vnd.ms-excel" = "libreoffice-calc.desktop";
      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = "libreoffice-calc.desktop";
      "application/msword" = "libreoffice-writer.desktop";
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = "libreoffice-writer.desktop";
      "application/vnd.ms-powerpoint" = "libreoffice-impress.desktop";
      "application/vnd.openxmlformats-officedocument.presentationml.presentation" = "libreoffice-impress.desktop";

      # PDF
      "application/pdf" = "com.microsoft.Edge.desktop";

      # Torrents
      "application/x-bittorrent" = "org.qbittorrent.qBittorrent.desktop";
      "x-scheme-handler/magnet" = "org.qbittorrent.qBittorrent.desktop";

      # Other handlers
      "x-scheme-handler/about" = "userapp-Zen Browser-CWEPZ2.desktop";
      "x-scheme-handler/unknown" = "userapp-Zen Browser-CWEPZ2.desktop";
      "x-scheme-handler/postman" = "Postman.desktop";
      "x-scheme-handler/tonsite" = "org.telegram.desktop.desktop";
    };
    portal = {
      enable = true;

      wlr.enable = true;

      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal
      ];

      configPackages = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-hyprland
        pkgs.xdg-desktop-portal
      ];
    };
  };
  programs = {
    hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
    };

    hyprlock = {
      enable = true;
      package = pkgs.hyprlock;
    };
  };

  services = {
    logind = {
      extraConfig = ''
        HandlePowerKey=suspend
      '';
    };

    xserver = {
      enable = false;
      xkb = {
        layout = "us";
        variant = "";
      };
      videoDrivers = ["modesetting"];
    };

    displayManager = {
      defaultSession = "hyprland-uwsm";
      sddm = {
        enable = true; # Enable SDDM.
        wayland.enable = true;
        autoNumlock = true;
        sugarCandyNix = {
          enable = true; # This set SDDM's theme to "sddm-sugar-candy-nix".
          settings = {
            # Here is a simple example:
            Background = lib.cleanSource ../../config/assets/${wallpaper};
            ScreenWidth = 1920;
            ScreenHeight = 1080;
            FormPosition = "left";
            HaveFormBackground = true;
            PartialBlur = true;
          };
        };
      };
    };
  };
}
