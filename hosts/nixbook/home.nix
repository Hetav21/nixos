{
  pkgs,
  settings,
  ...
}: {
  home = {
    username = settings.username;
    homeDirectory = "/home/${settings.username}";
    stateVersion = "24.11";

    file = {
      # Top Level Files symlinks
      ".zshrc".source = ../../dotfiles/.zshrc;
      ".vimrc".source = ../../dotfiles/.vimrc;

      # Directories
      # ".config/kitty".source = ../../dotfiles/.config/kitty;
      # ".config/wezterm".source = ../../dotfiles/.config/wezterm;
      ".config/mpv".source = ../../dotfiles/.config/mpv;
      ".config/fastfetch".source = ../../dotfiles/.config/fastfetch;
      ".config/wlogout/icons".source = ../../dotfiles/.config/wlogout/icons;

      # Files
      # ".config/starship.toml".source = ../../dotfiles/.config/starship.toml;
      ".cache/wallpaper".source = ../../wallpapers/${settings.wallpaper};
      ".local/bin/cliphist-rofi-img".source =
        ../../dotfiles/.local/bin/cliphist-rofi-img;
    };

    sessionVariables = {
      LC_ALL = settings.extraLocale;
      EDITOR = settings.editor;
      VISUAL = settings.visual;
      TERMINAL = settings.terminal;
      BROWSER = settings.browser;
      SIGNAL_PASSWORD_STORE = "gnome-libsecret";

      NIXOS_OZONE_WL = "1";
      GDK_BACKEND = "wayland,x11";
      QT_QPA_PLATFORM = "wayland;xcb";
      JAVA_AWT_WM_NONREPARENTING = "1";
      WLR_NO_HARDWARE_CURSORS = "1";
      MOZ_ENABLE_WAYLAND = "1";
      OZONE_PLATFORM_HINT = "wayland";
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";

      VDPAU_DRIVER = "nvidia";
      ANV_VIDEO_DECODE = "1";
      LIBVA_DRIVER_NAME = "nvidia";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      NVD_BACKEND = "direct";
      GBM_BACKEND = "nvidia-drm";

      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_SCREENSHOTS_DIR = "$HOME/Pictures/screenshots";
      XDG_SESSION_TYPE = "wayland";
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";
    };

    sessionPath = ["$HOME/.local/bin" "$HOME/go/bin"];

    packages = [(import ../../scripts/rofi-launcher.nix {inherit pkgs;})];
  };

  imports = [
    ../../config/ghostty.nix
    ../../config/wlogout.nix
    ../../config/shell.nix
    ../../config/tmux.nix
    ../../config/desktop
  ];

  gtk = {
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    gtk3.extraConfig = {gtk-application-prefer-dark-theme = 1;};
    gtk4.extraConfig = {gtk-application-prefer-dark-theme = 1;};
  };

  qt.enable = true;

  programs.home-manager.enable = true;
}
