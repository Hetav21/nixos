{
  config,
  pkgs,
  ...
}: let
  userName = "hetav";
  homeDirectory = "/home/${userName}";
  stateVersion = "24.11";
  wallpaper = "artistic-boy-relaxing.jpg";
in {
  home = {
    username = userName;
    homeDirectory = homeDirectory;
    stateVersion = stateVersion;

    file = {
      # Cached Wallpaper for rofi
      ".cache/wallpaper".source = ../../config/assets/${wallpaper};

      # Hyprland Config
      ".config/hypr".source = ../../dotfiles/.config/hypr;

      # wlogout icons
      ".config/wlogout/icons".source = ../../config/wlogout;

      # Top Level Files symlinks
      ".vimrc".source = ../../dotfiles/.vimrc;
      ".npmrc".source = ../../dotfiles/.npmrc;
      ".zshrc".source = ../../dotfiles/.zshrc;
      ".zshenv".source = ../../dotfiles/.zshenv;
      ".xinitrc".source = ../../dotfiles/.xinitrc;
      ".ideavimrc".source = ../../dotfiles/.ideavimrc;
      ".nirc".source = ../../dotfiles/.nirc;
      ".local/bin/wallpaper".source = ../../config/assets/${wallpaper};

      # Config directories
      ".config/alacritty".source = ../../dotfiles/.config/alacritty;
      ".config/dunst".source = ../../dotfiles/.config/dunst;
      ".config/fastfetch".source = ../../dotfiles/.config/fastfetch;
      ".config/kitty".source = ../../dotfiles/.config/kitty;
      ".config/mpv".source = ../../dotfiles/.config/mpv;
      ".config/waybar".source = ../../dotfiles/.config/waybar;
      ".config/yazi".source = ../../dotfiles/.config/yazi;
      ".config/wezterm".source = ../../dotfiles/.config/wezterm;
      ## ".config/zed/settings.json".source = ../../dotfiles/.config/zed/settings.json;
      ## ".config/zed/keymap.json".source = ../../dotfiles/.config/zed/keymap.json;

      # Individual config files
      ".config/nushell/completer.nu".source = ../../dotfiles/.config/nushell/completer.nu;
      ".config/nushell/colors.nu".source = ../../dotfiles/.config/nushell/colors.nu;
      ".config/kwalletrc".source = ../../dotfiles/.config/kwalletrc;
      ".config/starship.toml".source = ../../dotfiles/.config/starship.toml;
      ".config/mimeapps.list".source = ../../dotfiles/.config/mimeapps.list;
    };

    sessionVariables = {
      LC_ALL = "en_IN";
      EDITOR = "vim";
      VISUAL = "vim";
      TERMINAL = "ghostty";
      BROWSER = "zen";
      QT_QPA_PLATFORM = "wayland";
      LIBVA_DRIVER_NAME = "nvidia";
      JAVA_AWT_WM_NONREPARENTING = "1";
      GBM_BACKEND = "nvidia-drm";
      WLR_NO_HARDWARE_CURSORS = "1";
      NIXOS_OZONE_WL = "1";
      ## __GLX_VENDOR_LIBRARY_NAME = "nvidia";

      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_SCREENSHOTS_DIR = "$HOME/Pictures/screenshots";
      XDG_SESSION_TYPE = "wayland";
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";

      VDPAU_DRIVER = "va_gl";
      __GLX_VENDOR_LIBRARY_NAME = "mesa";
    };

    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/go/bin"
    ];

    packages = [
      (import ../../scripts/rofi-launcher.nix {inherit pkgs;})
    ];
  };

  imports = [
    ../../config/ghostty.nix
    ../../config/rofi/rofi.nix
    ../../config/wlogout.nix
    ../../config/shell.nix
  ];

  # Styling
  ## stylix.targets.waybar.enable = false;
  stylix.targets.waybar.enable = true;

  gtk = {
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };
  qt = {
    enable = true;
    style.name = "adwaita-dark";
    ## platformTheme.name = "gtk3";
  };

  services.hypridle = {
    settings = {
      general = {
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
        lock_cmd = "hyprlock";
      };
      listener = [
        {
          timeout = 900;
          on-timeout = "hyprlock";
        }
        {
          timeout = 1200;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };

  programs = {
    home-manager.enable = true;
  };
}
