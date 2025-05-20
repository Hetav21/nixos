{...}: {
  programs = {
    fish.enable = true;

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

        # Dev
        de = "devenv";

        # Git Aliases
        gac = "git add . and git commit -m";
        gs = "git status";
        gpush = "git push origin";

        # Downloads Aliases
        yd = ''yt-dlp -f "bestvideo+bestaudio" --embed-chapters --external-downloader aria2c --concurrent-fragments 8 --throttled-rate 100K'';
        td = ''yt-dlp --external-downloader aria2c -o "%(title)s."'';
        download = "aria2c --split=16 --max-connection-per-server=16 --timeout=600 --max-download-limit=10M --file-allocation=none";

        # VPN Aliases
        vu = "sudo tailscale up --exit-node=raspberrypi --accept-routes";
        vd = "sudo tailscale down";

        # Other Aliases
        pkg-find = "echo find '$(nix build nixpkgs#pkg --print-out-paths --no-link)'";
        edit = "vim";
        rebuild-live = "sh /etc/nixos/rebuild-live.sh";
        rebuild-boot = "sh /etc/nixos/rebuild-boot.sh";
        rebuild-test = "sh /etc/nixos/rebuild-test.sh";
        recats = "sudo nix flake lock --update-input nixCats and sudo nixos-rebuild switch";
        log-rebuild = "tail -f /etc/nixos/nixos-switch.log";
        ff = "fastfetch";
        ## btop = "btop --force-utf";
        files-space = "sudo ncdu --exclude /.snapshots /";
        docker-clean = "docker container prune -f and docker image prune -f and docker network prune -f and docker volume prune -f";
        crdown = "mpv --yt-dlp-raw-options=cookies-from-browser=brave";
        cr = "cargo run";
        battery = "upower -i /org/freedesktop/UPower/devices/battery_BAT1";
        y = "yazi";

        # Wayland Clipboard Aliases `wl-clipboard`
        copy = "wl-copy";
        paste = "wl-paste";
      };
      extraConfig = ''
        $env.config.show_banner = false
        microfetch
      '';
    };
    carapace = {
      enable = true;
      enableNushellIntegration = true;
      enableFishIntegration = true;
    };
    starship = {
      enable = true;
      enableNushellIntegration = true;
      enableFishIntegration = true;
    };
    zoxide = {
      enable = true;
      enableNushellIntegration = true;
      enableFishIntegration = true;
    };
    eza = {
      enable = true;
      enableNushellIntegration = false;
      enableFishIntegration = true;
      git = true;
      icons = "auto";
      colors = "auto";
      extraOptions = [
        "--group-directories-first"
        "--header"
      ];
    };
    bat.enable = true;
    ripgrep = {
      enable = true;
      arguments = [
        "--max-columns-preview"
        "--colors=line:style:bold"
      ];
    };
    fzf.enable = true;
    atuin = {
      enable = true;
      enableNushellIntegration = true;
      enableFishIntegration = true;
      flags = [
        "--disable-up-arrow"
      ];
    };
    nix-your-shell = {
      enable = true;
      enableNushellIntegration = true;
      enableFishIntegration = true;
    };
    direnv = {
      enable = true;
      enableNushellIntegration = true;
      nix-direnv.enable = true;
      silent = true;
    };
  };
}
