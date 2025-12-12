{
  lib,
  pkgs,
  pkgs-unstable,
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
          package = pkgs-unstable.fish;
          shellInit = ''
            # Set SSH agent socket from systemd service
            set -gx SSH_AUTH_SOCK $XDG_RUNTIME_DIR/ssh-agent
          '';
        };

        nushell = {
          enable = true;
          package = pkgs.nushell;

          plugins = with pkgs.nushellPlugins; [
            query
            gstat
            semver
            formats
            highlight
          ];

          extraEnv = ''
            # Set SSH agent socket from systemd service
            $env.SSH_AUTH_SOCK = $"($env.XDG_RUNTIME_DIR)/ssh-agent"

            # NixOS configuration environment variables (used by config.nu)
            $env.NIXOS_SETUP_DIR = "${settings.setup_dir}"
            $env.NIXOS_UPDATE_STANDARD = "${settings.update-standard}"
            $env.NIXOS_UPDATE_LATEST = "${settings.update-latest}"

            if (('/run/secrets/openai_api_key' | path exists)) {
              $env.OPENAI_API_KEY = (open /run/secrets/openai_api_key | str trim)
            }
          '';

          # Load custom config from dotfiles (nx commands, aliases, etc.)
          # Package-dependent functions are kept inline due to Nix interpolation
          extraConfig =
            # Include the custom nushell config from dotfiles
            builtins.readFile ../../dotfiles/.config/nushell/config.nu
            + ''

              # File Manager Alias (requires package path interpolation)
              def --env yz [...args] {
                  let tmp = (mktemp -t "yazi-cwd.XXXXXX")
                  ${lib.getExe pkgs.yazi} ...$args --cwd-file $tmp
                  let cwd = (open $tmp)
                  if $cwd != "" and $cwd != $env.PWD {
                      cd $cwd
                  }
                  rm -fp $tmp
              }

              # Download Alias (requires package path interpolation)
              def "dl-yt" [url: string] {
                ${lib.getExe pkgs.yt-dlp} --external-downloader ${lib.getExe pkgs.aria2} --external-downloader-args "-x 16 -s 16 -k 1M" -o $"~/Downloads/%(title)s.%(ext)s" $url
              }

              clear
              if ('.git' | path exists) {
                ${lib.getExe pkgs.onefetch}
              } else {
                ${lib.getExe pkgs.microfetch}
              }
            '';
          shellAliases =
            {
              # Core Utils Aliases
              tree = "${lib.getExe pkgs.tree} -a -I .git";
              cat = "${lib.getExe config.programs.bat.package}";
              grep = "${lib.getExe pkgs.ripgrep} --color=auto";
              cls = "clear";
              e = "exit";

              # Git / Docker Aliases
              gs = "git status";
              gpush = "git push origin";
              gpull = "git pull origin";
              grestore = "git restore";
              lzg = "${lib.getExe pkgs.lazygit}";
              lzjj = "${lib.getExe pkgs.lazyjj}";
              lzd = "${lib.getExe pkgs.lazydocker}";

              # Download Aliases
              dl = "${lib.getExe pkgs.aria2} --continue --max-concurrent-downloads=5 --file-allocation=falloc --summary-interval=0";
              dl-list = "${lib.getExe pkgs.aria2} --continue --max-concurrent-downloads=5 --file-allocation=falloc --summary-interval=0 --input $'($in)'";
              dl-torrent = "${lib.getExe pkgs.aria2} --enable-dht=true --dht-listen-port=6881-6999 --dht-file-path=/tmp/aria2.dht --bt-enable-lpd=true --bt-max-peers=0 --bt-save-metadata=true --listen-port=6881-6999 --seed-time=0 --peer-id-prefix=ARIA2 --user-agent=' aria2/1.36.0 ' --continue --max-concurrent-downloads=5 --file-allocation=falloc --summary-interval=0";
              dl-magnet = "${lib.getExe pkgs.aria2} --enable-dht=true --dht-listen-port=6881-6999 --dht-file-path=/tmp/aria2.dht --bt-enable-lpd=true --bt-max-peers=0 --bt-save-metadata=true --listen-port=6881-6999 --seed-time=0 --peer-id-prefix=ARIA2 --user-agent='aria2/1.36.0' --continue --max-concurrent-downloads=5 --file-allocation=falloc --summary-interval=0";

              # Distrobox Aliases
              ubuntu = "distrobox enter ubuntu";

              # Other Aliases
              ff = "${lib.getExe pkgs.fastfetch}";
            }
            // lib.optionalAttrs (pkgs ? wl-clipboard) {
              # Wayland clipboard aliases (only available on systems with wayland/desktop)
              copy = "${lib.getExe' pkgs.wl-clipboard "wl-copy"}";
              paste = "${lib.getExe' pkgs.wl-clipboard "wl-paste"}";
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
          package = pkgs-unstable.yazi;
          enableFishIntegration = true;
          enableNushellIntegration = true;
        };

        carapace = {
          enable = true;
          package = pkgs-unstable.carapace;
          enableFishIntegration = true;
          enableNushellIntegration = true;
        };

        starship = {
          enable = true;
          package = pkgs-unstable.starship;
          enableFishIntegration = true;
          enableNushellIntegration = true;
        };

        zoxide = {
          enable = true;
          package = pkgs-unstable.zoxide;
          enableFishIntegration = true;
          enableNushellIntegration = true;
        };

        eza = {
          enable = true;
          package = pkgs-unstable.eza;
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
          package = pkgs-unstable.bat;
        };

        ripgrep = {
          enable = true;
          package = pkgs-unstable.ripgrep;
          arguments = [
            "--max-columns-preview"
            "--colors=line:style:bold"
          ];
        };

        fzf = {
          enable = true;
          package = pkgs-unstable.fzf;
        };

        fd = {
          enable = true;
          package = pkgs-unstable.fd;
        };

        atuin = {
          enable = true;
          package = pkgs-unstable.atuin;
          enableFishIntegration = true;
          enableNushellIntegration = true;
          flags = [
            "--disable-up-arrow"
          ];
        };

        nix-your-shell = {
          enable = true;
          package = pkgs-unstable.nix-your-shell;
          enableFishIntegration = true;
          enableNushellIntegration = true;
        };

        direnv = {
          enable = true;
          package = pkgs-unstable.direnv;
          # enableFishIntegration = true; # READ ONLY
          enableNushellIntegration = true;
          nix-direnv = {
            enable = true;
            package = pkgs-unstable.nix-direnv;
          };
          mise = {
            enable = true;
            package = pkgs-unstable.mise;
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
          package = pkgs-unstable.alacritty;
        };

        ghostty = {
          enable = true;
          package = pkgs-unstable.ghostty;
        };
      };
    })
  ];
}
