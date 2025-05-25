{
  pkgs,
  settings,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # Wayland specific
    swww
    waypaper
    # grim swappy slurp
    hyprshot
    wl-clipboard
  ];

  stylix = {
    enable = true;

    enableReleaseChecks = false;

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
    image = ../../wallpapers/${settings.wallpaper};
    polarity = "dark";
    opacity.terminal = 0.8;
    cursor.package = pkgs.bibata-cursors;
    cursor.name = "Bibata-Modern-Ice";
    cursor.size = 24;
  };

  xdg = {
    autostart.enable = true;
    mime.defaultApplications = {
      # Web and HTML
      "x-scheme-handler/http" = "zen-beta.desktop";
      "x-scheme-handler/https" = "zen-beta.desktop";
      "x-scheme-handler/chrome" = "zen-beta.desktop";
      "text/html" = "zen-beta.desktop";
      "application/x-extension-htm" = "zen-beta.desktop";
      "application/x-extension-html" = "zen-beta.desktop";
      "application/x-extension-shtml" = "zen-beta.desktop";
      "application/x-extension-xhtml" = "zen-beta.desktop";
      "application/xhtml+xml" = "zen-beta.desktop";
      "application/x-extension-xht" = "zen-beta.desktop";
      "x-scheme-handler/about" = "zen-beta.desktop";
      "x-scheme-handler/unknown" = "zen-beta.desktop";

      # File management
      "inode/directory" = "thunar.desktop";

      # Text editor
      "text/plain" = "ghostty -e vim";
      "text/markdown" = "obsidian.desktop;";
      "application/x-zerosize" = "dev.zed.Zed.desktop";
      "application/x-ipynb+json" = "code.desktop";

      # Terminal
      "x-scheme-handler/terminal" = "ghostty.desktop";

      # Image and Videos
      "video/quicktime" = "mpv.desktop";
      "video/x-matroska" = "mpv.desktop";
      "image/png" = "org.gnome.Loupe.desktop";

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
      "application/pdf" = "microsoft-edge.desktop";

      # Torrents
      "application/x-bittorrent" = "org.qbittorrent.qBittorrent.desktop";
      "x-scheme-handler/magnet" = "org.qbittorrent.qBittorrent.desktop";

      # Other handlers
      "x-scheme-handler/discord" = "vesktop.desktop";
      "hoppscotch" = "hoppscotch-handler.desktop";
      # "x-scheme-handler/postman" = "Postman.desktop";
      "x-scheme-handler/tonsite" = "org.telegram.desktop.desktop";
    };
    portal = {
      enable = true;
      wlr.enable = true;
      xdgOpenUsePortal = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
      ];
    };
    menus.enable = true;
    icons.enable = true;
    sounds.enable = true;
  };
  programs = {
    hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
    };
  };

  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  time.timeZone = settings.timeZone;

  i18n = {
    defaultLocale = settings.locale;
    extraLocaleSettings = {
      LC_ADDRESS = settings.extraLocale;
      LC_IDENTIFICATION = settings.extraLocale;
      LC_MEASUREMENT = settings.extraLocale;
      LC_MONETARY = settings.extraLocale;
      LC_NAME = settings.extraLocale;
      LC_NUMERIC = settings.extraLocale;
      LC_PAPER = settings.extraLocale;
      LC_TELEPHONE = settings.extraLocale;
      LC_TIME = settings.extraLocale;
    };
  };

  console.keyMap = settings.consoleKeymap;

  services = {
    gnome.gnome-keyring.enable = true;

    preload.enable = true;

    logind = {
      extraConfig = ''
        HandlePowerKey=suspend
      '';
    };

    xserver = {
      enable = true;
      exportConfiguration = true; # Make sure /etc/X11/xkb is populated so localectl works correctly
      xkb = {
        layout = settings.keyboard.layout;
        variant = settings.keyboard.variant;
      };
      videoDrivers = ["modesetting"];
    };
  };
}
