{
  lib,
  pkgs,
  config,
  settings,
  ...
}:
with lib; let
  cfg = config.home.shell;
in {
  options.home.shell = {
    enable = mkEnableOption "Enable CLI/TUI shell tools";
    enableGui = mkEnableOption "Enable GUI terminal emulators";
  };

  config = mkMerge [
    # CLI/TUI shell tools
    (mkIf cfg.enable {
      programs = {
        fish = {
          enable = true;
          package = pkgs.unstable.fish;
          shellInit = ''
            # Set SSH agent socket from systemd service
            set -gx SSH_AUTH_SOCK $XDG_RUNTIME_DIR/ssh-agent
          '';
        };

        nushell = {
          enable = true;
          package = pkgs.unstable.nushell;
          extraEnv = ''
            # Set SSH agent socket from systemd service
            $env.SSH_AUTH_SOCK = $"($env.XDG_RUNTIME_DIR)/ssh-agent"

            if (('/run/secrets/openai_api_key' | path exists)) {
              $env.OPENAI_API_KEY = (open /run/secrets/openai_api_key | str trim)
            }
          '';
          extraConfig = ''
            # File Manager Alias
            def --env yz [...args] {
                let tmp = (mktemp -t "yazi-cwd.XXXXXX")
                ${pkgs.yazi}/bin/yazi ...$args --cwd-file $tmp
                let cwd = (open $tmp)
                if $cwd != "" and $cwd != $env.PWD {
                    cd $cwd
                }
                rm -fp $tmp
            }

            # Git / Docker Aliases
            def "gac" [message: string] {
              git add .
              git commit -m $"($message)"
            }
            def "docker-clean" [] {
              print "Cleaning Docker..."
              docker container prune -f
              docker image prune -f
              docker network prune -f
              docker volume prune -f
              print "Docker clean complete."
            }
            def "docker-rmi-all" [] {
              print "Removing all Docker images (this may take a while)..."
              let image_ids = (docker images -q)
              if ($image_ids | is-empty) {
                print "No Docker images to remove."
              } else {
                docker rmi $image_ids
              }
              print "All Docker images removed."
            }

            # Download Alias
            def "dl-yt" [url: string] {
              ${pkgs.yt-dlp}/bin/yt-dlp --external-downloader ${pkgs.aria2}/bin/aria2c --external-downloader-args "-x 16 -s 16 -k 1M" -o $"~/Downloads/%(title)s.%(ext)s" $url
            }

            $env.config.show_banner = false

            clear
            if ('.git' | path exists) {
              ${pkgs.onefetch}/bin/onefetch
            } else {
              ${pkgs.microfetch}/bin/microfetch
            }
          '';
          shellAliases =
            {
              # Core Utils Aliases
              tree = "${pkgs.tree}/bin/tree -a -I .git";
              cat = "${config.programs.bat.package}/bin/bat";
              grep = "${pkgs.ripgrep}/bin/rg --color=auto";
              cls = "clear";
              e = "exit";

              # Git / Docker Aliases
              gs = "git status";
              gpush = "git push origin";
              gpull = "git pull origin";
              grestore = "git restore";
              lzg = "${pkgs.lazygit}/bin/lazygit";
              lzd = "${pkgs.lazydocker}/bin/lazydocker";

              # System Specific Aliases
              rebuild-live = "sh ${settings.setup_dir}scripts/rebuild/live.sh '${settings.setup_dir}'";
              rebuild-boot = "sh ${settings.setup_dir}scripts/rebuild/boot.sh '${settings.setup_dir}'";
              rebuild-test = "sh ${settings.setup_dir}scripts/rebuild/test.sh '${settings.setup_dir}'";
              log-rebuild = "tail -f ${settings.setup_dir}nixos-switch.log";
              update-latest = "sh ${settings.setup_dir}scripts/update/latest.sh '${settings.update-latest}' '${settings.setup_dir}'";
              update-standard = "sh ${settings.setup_dir}scripts/update/standard.sh '${settings.update-standard}' '${settings.setup_dir}'";
              update-all = "sh ${settings.setup_dir}scripts/update/all.sh '${settings.update-latest}' '${settings.update-standard}' '${settings.setup_dir}'";
              update-packages = "sh ${settings.setup_dir}scripts/update/packages.sh '${settings.setup_dir}'";

              # Download Aliases
              dl = "${pkgs.aria2}/bin/aria2c --continue --max-concurrent-downloads=5 --file-allocation=falloc --summary-interval=0";
              dl-list = "${pkgs.aria2}/bin/aria2c --continue --max-concurrent-downloads=5 --file-allocation=falloc --summary-interval=0 --input $'($in)'";
              dl-torrent = "${pkgs.aria2}/bin/aria2c --enable-dht=true --dht-listen-port=6881-6999 --dht-file-path=/tmp/aria2.dht --bt-enable-lpd=true --bt-max-peers=0 --bt-save-metadata=true --listen-port=6881-6999 --seed-time=0 --peer-id-prefix=ARIA2 --user-agent=' aria2/1.36.0 ' --continue --max-concurrent-downloads=5 --file-allocation=falloc --summary-interval=0";
              dl-magnet = "${pkgs.aria2}/bin/aria2c --enable-dht=true --dht-listen-port=6881-6999 --dht-file-path=/tmp/aria2.dht --bt-enable-lpd=true --bt-max-peers=0 --bt-save-metadata=true --listen-port=6881-6999 --seed-time=0 --peer-id-prefix=ARIA2 --user-agent='aria2/1.36.0' --continue --max-concurrent-downloads=5 --file-allocation=falloc --summary-interval=0";

              # Distrobox Aliases
              ubuntu = "distrobox enter ubuntu";

              # Other Aliases
              ff = "${pkgs.fastfetch}/bin/fastfetch";
            }
            // lib.optionalAttrs (pkgs ? wl-clipboard) {
              # Wayland clipboard aliases (only available on systems with wayland/desktop)
              copy = "${pkgs.wl-clipboard}/bin/wl-copy";
              paste = "${pkgs.wl-clipboard}/bin/wl-paste";
            };
        };

        # Terminal multiplexer
        tmux = {
          enable = true;
          plugins = with pkgs; [
            tmuxPlugins.rose-pine
            tmuxPlugins.vim-tmux-navigator
            {
              plugin = tmuxPlugins.yank;
              extraConfig = ''
                bind-key -T copy-mode-vi v send-keys -X begin-selection
                bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
                bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
              '';
            }
          ];
          sensibleOnTop = true;
          mouse = true;
          prefix = "M-a";
          extraConfig = ''
            set-option -sa terminal-overrides ",xterm*:Tc"

            # Change the prefix key
            unbind C-b
            set -g prefix M-a
            bind M-a send-prefix

            # Shift Alt vim keys to switch windows
            bind -n M-H previous-window
            bind -n M-L next-window

            # Change the base index to 1
            set -g base-index 1
            set -g pane-base-index 1
            set-window-option -g pane-base-index 1
            set-option -g renumber-windows on
          '';
        };

        yazi = {
          enable = true;
          package = pkgs.unstable.yazi;
          enableFishIntegration = true;
          enableNushellIntegration = true;
        };

        carapace = {
          enable = true;
          package = pkgs.unstable.carapace;
          enableFishIntegration = true;
          enableNushellIntegration = true;
        };

        starship = {
          enable = true;
          package = pkgs.unstable.starship;
          enableFishIntegration = true;
          enableNushellIntegration = true;
        };

        zoxide = {
          enable = true;
          package = pkgs.unstable.zoxide;
          enableFishIntegration = true;
          enableNushellIntegration = true;
        };

        eza = {
          enable = true;
          package = pkgs.unstable.eza;
          enableFishIntegration = true;
          enableNushellIntegration = false;
          git = true;
          icons = "auto";
          colors = "auto";
          extraOptions = [
            "--group-directories-first"
            "--header"
          ];
        };

        bat = {
          enable = true;
          package = pkgs.unstable.bat;
        };

        ripgrep = {
          enable = true;
          package = pkgs.unstable.ripgrep;
          arguments = [
            "--max-columns-preview"
            "--colors=line:style:bold"
          ];
        };

        fzf = {
          enable = true;
          package = pkgs.unstable.fzf;
        };

        fd = {
          enable = true;
          package = pkgs.unstable.fd;
        };

        atuin = {
          enable = true;
          package = pkgs.unstable.atuin;
          enableFishIntegration = true;
          enableNushellIntegration = true;
          flags = [
            "--disable-up-arrow"
          ];
        };

        nix-your-shell = {
          enable = true;
          package = pkgs.unstable.nix-your-shell;
          enableFishIntegration = true;
          enableNushellIntegration = true;
        };

        direnv = {
          enable = true;
          package = pkgs.unstable.direnv;
          enableFishIntegration = true;
          enableNushellIntegration = true;
          nix-direnv = {
            enable = true;
            package = pkgs.unstable.nix-direnv;
          };
          mise = {
            enable = true;
            package = pkgs.unstable.mise;
          };
          silent = true;
        };
      };

      # Auto-enable CLI tools when GUI is enabled
      home.shell = {
        enableShellIntegration = true;

        # Override individual shell integration
        # enableFishIntegration = false;
        # enableNushellIntegration = false;
      };
    })

    # GUI terminal emulators
    (mkIf cfg.enableGui {
      programs = {
        alacritty = {
          enable = true;
          package = pkgs.unstable.alacritty;
        };

        ghostty = {
          enable = true;
          package = pkgs.unstable.ghostty;
        };
      };
    })
  ];
}
