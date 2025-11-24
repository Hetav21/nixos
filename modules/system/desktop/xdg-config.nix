{
  lib,
  pkgs,
  config,
  settings,
  hardware ? {},
  ...
}:
with lib; let
  cfg = config.system.desktop.xdg-config;
in {
  options.system.desktop.xdg-config = {
    enable = mkEnableOption "Enable desktop XDG configuration";
  };

  config = mkIf cfg.enable {
    environment.sessionVariables = mkMerge [
      # Common XDG environment variables
      {
        XDG_CONFIG_HOME = "$HOME/.config";
        XDG_DATA_HOME = "$HOME/.local/share";
        XDG_STATE_HOME = "$HOME/.local/state";
        XDG_CACHE_HOME = "$HOME/.cache";
        XDG_SCREENSHOTS_DIR = "$HOME/Pictures/screenshots";
        XDG_SESSION_TYPE = "wayland";
        XDG_CURRENT_DESKTOP = "Hyprland";
        XDG_SESSION_DESKTOP = "Hyprland";
      }

      # Intel-specific variables
      (mkIf (hardware ? intel && hardware.intel.enable) {
        ANV_VIDEO_DECODE = "1";
        LIBVA_DRIVER_NAME = "iHD";
      })

      # Nvidia-specific variables
      (mkIf (hardware ? nvidia && hardware.nvidia.enable) {
        VDPAU_DRIVER = "nvidia";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        NVD_BACKEND = "direct";
        GBM_BACKEND = "nvidia-drm";
      })
    ];

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
        "text/plain" = "dev.zed.Zed.desktop";
        "text/markdown" = "obsidian.desktop;";
        "application/x-zerosize" = "dev.zed.Zed.desktop";
        "application/x-ipynb+json" = "code.desktop";

        # Terminal
        "x-scheme-handler/terminal" = "ghostty.desktop";

        # Image and Videos
        "video/quicktime" = "mpv.desktop";
        "video/x-matroska" = "mpv.desktop";
        "image/png" = "org.gnome.Papers.desktop";
        "image/jpeg" = "org.gnome.Papers.desktop";

        # LibreOffice formats
        "application/vnd.oasis.opendocument.text" = "org.libreoffice.LibreOffice.writer.desktop";
        "application/vnd.oasis.opendocument.spreadsheet" = "org.libreoffice.LibreOffice.calc.desktop";
        "application/vnd.oasis.opendocument.presentation" = "org.libreoffice.LibreOffice.impress.desktop";
        "application/vnd.ms-excel" = "org.libreoffice.LibreOffice.calc.desktop";
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = "org.libreoffice.LibreOffice.calc.desktop";
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = "org.libreoffice.LibreOffice.writer.desktop";
        "application/msword" = "org.libreoffice.LibreOffice.writer.desktop";
        "application/vnd.ms-powerpoint" = "org.libreoffice.LibreOffice.impress.desktop";
        "application/vnd.openxmlformats-officedocument.presentationml.presentation" = "org.libreoffice.LibreOffice.impress.desktop";

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

    services.xserver = {
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
