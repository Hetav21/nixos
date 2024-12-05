{
  config,
  pkgs,
  ...
}: let
  userName = "hetav";
  homeDirectory = "/home/${userName}";
  stateVersion = "24.11";
  wallpaper = "China.jpeg";
in {
  home = {
    username = userName;
    homeDirectory = homeDirectory;
    stateVersion = stateVersion;

    enableNixpkgsReleaseCheck = false;

    file = {
      # Cached Wallpaper for rofi
      ".cache/wallpaper".source = ../../config/assets/${wallpaper};

      # Hyprland Config
      ".config/hypr".source = ../../dotfiles/.config/hypr;

      # wlogout icons
      ".config/wlogout/icons".source = ../../config/wlogout;

      # Top Level Files symlinks
      ".npmrc".source = ../../dotfiles/.npmrc;
      ".zshrc".source = ../../dotfiles/.zshrc;
      ".zshenv".source = ../../dotfiles/.zshenv;
      ".xinitrc".source = ../../dotfiles/.xinitrc;
      ## ".gitconfig".source = ../../dotfiles/.gitconfig;
      ".ideavimrc".source = ../../dotfiles/.ideavimrc;
      ".nirc".source = ../../dotfiles/.nirc;
      ".local/bin/wallpaper".source = ../../config/assets/${wallpaper};

      # Config directories
      ".config/alacritty".source = ../../dotfiles/.config/alacritty;
      ".config/dunst".source = ../../dotfiles/.config/dunst;
      ".config/fastfetch".source = ../../dotfiles/.config/fastfetch;
      ".config/kitty".source = ../../dotfiles/.config/kitty;
      ".config/mpv".source = ../../dotfiles/.config/mpv;
      ".config/tmux/tmux.conf".source = ../../dotfiles/.config/tmux/tmux.conf;
      ".config/waybar".source = ../../dotfiles/.config/waybar;
      ".config/yazi".source = ../../dotfiles/.config/yazi;
      ".config/wezterm".source = ../../dotfiles/.config/wezterm;
      ## ".config/zed/settings.json".source = ../../dotfiles/.config/zed/settings.json;
      ## ".config/zed/keymap.json".source = ../../dotfiles/.config/zed/keymap.json;

      # Individual config files
      ".config/kwalletrc".source = ../../dotfiles/.config/kwalletrc;
      ".config/starship.toml".source = ../../dotfiles/.config/starship.toml;
      ".config/mimeapps.list".source = ../../dotfiles/.config/mimeapps.list;
    };

    sessionVariables = {
      EDITOR = "vim";
      VISUAL = "zeditor";
      TERMINAL = "alacritty";
      BROWSER = "firefox";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_SCREENSHOTS_DIR = "$HOME/Pictures/screenshots";
      JAVA_AWT_WM_NONREPARENTING = "1";
      XDG_SESSION_TYPE = "wayland";
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      GBM_BACKEND = "nvidia-drm";
      LC_ALL = "en_IN";
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
    ../../config/rofi/rofi.nix
    ../../config/wlogout.nix
  ];

  # Styling
  stylix.targets.waybar.enable = false;
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
    platformTheme.name = "gtk3";
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
   nushell = {
      enable = true;
      configFile.source = ../../dotfiles/.config/nushell/config.nu;
   };
   carapace = { 
     enable = true;
     enableNushellIntegration = true;
   };
   starship = { 
     enable = true; 
     enableNushellIntegration = true;
   };
   zoxide = { 
     enable = true;
     enableNushellIntegration = true; 
   };
   eza = {
     enable = true;
     git = true;
     icons = "auto";
     colors = "auto";
     extraOptions = [
	  "--group-directories-first"
	  "--header"
     ];
     enableNushellIntegration = true;
   };
   atuin = {
     enable = true;
     enableNushellIntegration = true;
     flags = [
  "--disable-up-arrow"
];
   };
   nix-your-shell = {
     enable = true;
     enableNushellIntegration = true;
   };
  direnv = {
     enable = true;
     enableNushellIntegration = true;
     nix-direnv.enable = true;
     silent = true;
   };
};
}
