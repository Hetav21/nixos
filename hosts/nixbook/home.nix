{
  config,
  pkgs,
  ...
}: let
  userName = "hetav";
  homeDirectory = "/home/${userName}";
  stateVersion = "24.11";
  wallpaper = "mountain-snow.jpeg";
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
      VISUAL = "vim";
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
      shellAliases = {
        # Core Utils Aliases
        l = "eza -lh  --icons=auto";
        ## ls = "eza -1   --icons=auto"; # short list
        ll = "eza -lha --icons=auto --sort=name --group-directories-first"; # long list all
        tree = "tree -a -I .git";
        cat = "bat";
        c = "clear"; # clear terminal
        e = "exit";
        grep = "rg --color=auto";
        ssn = "sudo shutdown now";
        srn = "sudo reboot now";

        # Git Aliases
        gac = "git add . and git commit -m";
        gs = "git status";
        gpush = "git push origin";
        lg = "lazygit";
        git-log = ''git log --pretty=%h»¦«%aN»¦«%s»¦«%aD | lines | split column "»¦«" sha1 committer desc merged_at | first 10'';
        git-histogram = ''git log --pretty=%h»¦«%aN»¦«%s»¦«%aD | lines | split column "»¦«" sha1 committer desc merged_at | histogram committer merger | sort-by merger | reverse'';

        # Downloads Aliases
        yd = ''yt-dlp -f "bestvideo+bestaudio" --embed-chapters --external-downloader aria2c --concurrent-fragments 8 --throttled-rate 100K'';
        td = ''yt-dlp --external-downloader aria2c -o "%(title)s."'';
        download = "aria2c --split=16 --max-connection-per-server=16 --timeout=600 --max-download-limit=10M --file-allocation=none";

        # VPN Aliases
        vu = "sudo tailscale up --exit-node=raspberrypi --accept-routes";
        vd = "sudo tailscale down";

        # Other Aliases
        nano = "vim";
        edit = "vim";
        rebuild = "sh /etc/nixos/rebuild.sh";
        rebuild-log = "tail -f /etc/nixos/nixos-switch.log";
        ff = "fastfetch";
        btop = "btop --utf-force";
        files-space = "sudo ncdu --exclude /.snapshots /";
        docker-clean = "docker container prune -f and docker image prune -f and docker network prune -f and docker volume prune -f";
        ld = "lazydocker";
        crdown = "mpv --yt-dlp-raw-options=cookies-from-browser=brave";
        cr = "cargo run";
        battery = "upower -i /org/freedesktop/UPower/devices/battery_BAT1";
        y = "yazi";

        # Wayland Clipboard Aliases `wl-clipboard`
        copy = "wl-copy";
        paste = "wl-paste";
      };
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
                                      algorithm: "prefix"    # prefix or fuzzy
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

        let fish_completer = {|spans|
            fish --command $'complete "--do-complete=($spans | str join " ")"'
            | from tsv --flexible --noheaders --no-infer
            | rename value description
        }

                let carapace_completer = {|spans: list<string>|
                    carapace $spans.0 nushell ...$spans
                    | from json
                    | if ($in | default [] | where value =~ '^-.*ERR$' | is-empty) { $in } else { null }
                }

                let zoxide_completer = {|spans|
                    $spans | skip 1 | zoxide query -l ...$in | lines | where {|x| $x != $env.PWD}
                }

                # This completer will use carapace by default
                let external_completer = {|spans|
                    let expanded_alias = scope aliases
                    | where name == $spans.0
                    | get -i 0.expansion

                    let spans = if $expanded_alias != null {
                        $spans
                        | skip 1
                        | prepend ($expanded_alias | split row ' ' | take 1)
                    } else {
                        $spans
                    }

                    match $spans.0 {
                        # carapace completions are incorrect for nu
                        nu => $fish_completer
                        # fish completes commits and branch names in a nicer way
                        git => $fish_completer
                        # carapace doesn't have completions for asdf
                        asdf => $fish_completer
                        # use zoxide completions for zoxide commands
                        __zoxide_z | __zoxide_zi => $zoxide_completer
                        _ => $carapace_completer
                    } | do $in $spans
                }

                $env.config = {
                    # ...
                    completions: {
                        external: {
                            enable: true
                            completer: $external_completer
                        }
                    }
                    # ...
                }

                        def lsfind [] {
                          		   ll "$1" | grep "$2"
                        }

                        def warp [] {
                        	   sudo systemctl "$1" warp-svc
                        }

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
