{pkgs, ...}: let
  userName = "hetav";
  homeDirectory = "/home/${userName}";
  stateVersion = "24.11";
  wallpaper = "China.jpeg";
in {
  home = {
    username = userName;
    homeDirectory = homeDirectory;
    stateVersion = stateVersion;

    file = {
      # Top Level Files symlinks
      # ".zshrc".source = ../../dotfiles/.zshrc;
      # ".zshenv".source = ../../dotfiles/.zshenv;
      ".vimrc".source = ../../dotfiles/.vimrc;
      ".local/share/applications/microsoft-edge.desktop".source =
        ../../dotfiles/.local/share/applications/microsoft-edge.desktop;

      # Directories
      # ".config/kitty".source = ../../dotfiles/.config/kitty;
      # ".config/wezterm".source = ../../dotfiles/.config/wezterm;
      ".config/mpv".source = ../../dotfiles/.config/mpv;
      ".config/fastfetch".source = ../../dotfiles/.config/fastfetch;
      ".config/wlogout/icons".source = ../../dotfiles/.config/wlogout/icons;

      # Files
      # ".config/starship.toml".source = ../../dotfiles/.config/starship.toml;
      ".cache/wallpaper".source = ../../wallpapers/${wallpaper};
      ".local/bin/cliphist-rofi-img".source =
        ../../dotfiles/.local/bin/cliphist-rofi-img;
    };

    sessionVariables = {
      LC_ALL = "en_IN";
      EDITOR = "vim";
      VISUAL = "vim";
      TERMINAL = "ghostty";
      BROWSER = "zen";

      NIXOS_OZONE_WL = "1";
      WLR_NO_HARDWARE_CURSORS = "1";
      MOZ_ENABLE_WAYLAND = "1";
      QT_QPA_PLATFORM = "wayland";
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";
      SIGNAL_PASSWORD_STORE = "gnome-libsecret";

      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_SCREENSHOTS_DIR = "$HOME/Pictures/screenshots";
      XDG_SESSION_TYPE = "wayland";
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";

      VDPAU_DRIVER = "nvidia";
      GBM_BACKEND = "nvidia-drm";
      NVD_BACKEND = "direct";
      LIBVA_DRIVER_NAME = "nvidia";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      # VK_ICD_FILENAMES =
      #   "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json";
      # ANV_VIDEO_DECODE = 1;

      # JAVA_AWT_WM_NONREPARENTING = "1";
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
