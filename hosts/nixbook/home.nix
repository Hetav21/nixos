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
      ##  configFile.source = ../../dotfiles/.config/nushell/config.nu;
      extraConfig = ''
               let carapace_completer = {|spans|
               carapace $spans.0 nushell $spans | from json
               }
               $env.config = {
                show_banner: false,
                completions: {
                case_sensitive: false # case-sensitive completions
                quick: true    # set to false to prevent auto-selecting completions
                partial: true    # set to false to prevent partial filling of the prompt
                algorithm: "fuzzy"    # prefix or fuzzy
                external: {
                # set to false to prevent nushell looking into $env.PATH to find more suggestions
                    enable: true
                # set to lower can improve completion performance at the cost of omitting some options
                    max_results: 100
                    completer: $carapace_completer # check 'carapace_completer'
                  }
                }
               }
               $env.PATH = ($env.PATH |
               split row (char esep) |
               prepend /home/myuser/.apps |
               append /usr/bin/env
               )
        # Core Utils Aliases
        alias l = eza -lh  --icons=auto
        alias ls = eza -1   --icons=auto # short list
        alias ll = eza -lha --icons=auto --sort=name --group-directories-first # long list all
        alias ld = eza -lhD --icons=auto # long list dirs
        alias tree = tree -a -I .git
        alias cat = bat
        alias c = clear # clear terminal
        alias e = exit
        alias grep = rg --color=auto
        alias ssn = sudo shutdown now
        alias srn = sudo reboot now

        # Git Aliases
        alias gac = git add . and git commit -m
        alias gs = git status
        alias gpush = git push origin
        alias lg = lazygit

        # Downloads Aliases
        alias yd = yt-dlp -f "bestvideo+bestaudio" --embed-chapters --external-downloader aria2c --concurrent-fragments 8 --throttled-rate 100K
        alias td = yt-dlp --external-downloader aria2c -o "%(title)s."
        alias download = aria2c --split=16 --max-connection-per-server=16 --timeout=600 --max-download-limit=10M --file-allocation=none

        # VPN Aliases
        alias vu = sudo tailscale up --exit-node=raspberrypi --accept-routes
        alias vd = sudo tailscale down
        def warp [] {
            sudo systemctl "$1" warp-svc
        }

        # Other Aliases
        alias rebuild = sh /etc/nixos/rebuild.sh
        alias rebuild-log = tail -f /etc/nixos/nixos-switch.log
        alias ff = fastfetch
        alias files-space = sudo ncdu --exclude /.snapshots /
        alias ld = lazydocker
        alias docker-clean = docker container prune -f and docker image prune -f and docker network prune -f and docker volume prune -f
        alias crdown = mpv --yt-dlp-raw-options=cookies-from-browser=brave
        alias cr = cargo run
        alias battery = upower -i /org/freedesktop/UPower/devices/battery_BAT1
        alias y = yazi
        def lsfind [] {
            ll "$1" | grep "$2"
        }

        # X11 Clipboard Aliases `xsel`
        # alias pbcopy='xsel --input --clipboard'
        # alias pbpaste='xsel --output --clipboard'

        # Wayland Clipboard Aliases `wl-clipboard`
        alias pbcopy = wl-copy
        alias pbpaste = wl-paste

        # Shell Intgrations
        ## eval "$(fzf --zsh)"

        # Starship
        use ~/.cache/starship/init.nu

        # NPM global packages
        $env.PATH = ($env.PATH | append ~/.npm-global/bin)

        # Command Run
        date
        microfetch


      '';
    };
    fish.enable = true;
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
