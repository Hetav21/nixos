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
        c = "clear";
        e = "exit";
        y = "yazi";
        grep = "rg --color=auto";

        # Git Aliases
        gac = "git add . and git commit -m";
        gs = "git status";
        gpush = "git push origin";

        # Other Aliases
        pkg-find = "echo find '$(nix build nixpkgs#pkg --print-out-paths --no-link)'";
        rebuild-live = "sh /etc/nixos/rebuild-live.sh";
        rebuild-boot = "sh /etc/nixos/rebuild-boot.sh";
        rebuild-test = "sh /etc/nixos/rebuild-test.sh";
        log-rebuild = "tail -f /etc/nixos/nixos-switch.log";
        ff = "fastfetch";
        docker-clean = "docker container prune -f and docker image prune -f and docker network prune -f and docker volume prune -f";

        # Wayland Clipboard Aliases `wl-clipboard`
        copy = "wl-copy";
        paste = "wl-paste";
      };
      extraConfig = ''
        $env.config.show_banner = false
        microfetch
      '';
    };
    yazi = {
      enable = true;
      enableNushellIntegration = true;
      enableFishIntegration = true;
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
