{
  pkgs,
  config,
  lib,
  ...
}: {
  programs = {
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
        open = "xdg-open";

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
        edit = "vim";
        rebuild-live = "sh /etc/nixos/rebuild-live.sh";
        rebuild-boot = "sh /etc/nixos/rebuild-boot.sh";
        log-rebuild = "tail -f /etc/nixos/nixos-switch.log";
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


           def lsfind [] {
                              ll "$1" | grep "$2"
           }

           def warp [] {
                      sudo systemctl "$1" warp-svc
           }

                  # Starship
                  use ~/.cache/starship/init.nu

                   # NPM global packages
         $env.PATH = ($env.PATH |
         split row (char esep) |
         prepend /home/hetav/.npm-global/bin |
         append /home/hetav/.npm-global/bin
         )

                   # Command Run
                   date
                   microfetch
      '';
    };
    fish.enable = true;
    carapace = {
      enable = true;
      ##      enableNushellIntegration = true;
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
