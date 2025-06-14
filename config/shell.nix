{pkgs, ...}: {
  programs = {
    fish.enable = true;

    nushell = {
      enable = true;
      extraEnv = ''
        if (('/run/secrets/openai_api_key' | path exists)) {
          $env.OPENAI_API_KEY = (open /run/secrets/openai_api_key | str trim)
        }
      '';
      extraConfig = ''
        def --env y [...args] {
            let tmp = (mktemp -t "yazi-cwd.XXXXXX")
            ${pkgs.yazi}/bin/yazi ...$args --cwd-file $tmp
            let cwd = (open $tmp)
            if $cwd != "" and $cwd != $env.PWD {
                cd $cwd
            }
            rm -fp $tmp
        }

        $env.config.show_banner = false
        ${pkgs.microfetch}/bin/microfetch
      '';
      shellAliases = {
        # Core Utils Aliases
        l = "${pkgs.eza}/bin/eza -lh  --icons=auto";
        ## ls = "${pkgs.eza}/bin/eza -1   --icons=auto"; # short list
        ll = "${pkgs.eza}/bin/eza -lha --icons=auto --sort=name --group-directories-first"; # long list all
        tree = "tree -a -I .git";
        cat = "${pkgs.bat}/bin/bat";
        grep = "${pkgs.ripgrep}/bin/rg --color=auto";
        cls = "clear";
        e = "exit";

        # Git / Docker Aliases
        gac = "git add . and git commit -m";
        gs = "git status";
        gpush = "git push origin";
        docker-clean = "docker container prune -f and docker image prune -f and docker network prune -f and docker volume prune -f";
        lzg = "${pkgs.lazygit}/bin/lazygit";
        lzd = "${pkgs.lazydocker}/bin/lazydocker";

        # System Specific Aliases
        rebuild-live = "sh /etc/nixos/rebuild-live.sh";
        rebuild-boot = "sh /etc/nixos/rebuild-boot.sh";
        rebuild-test = "sh /etc/nixos/rebuild-test.sh";
        log-rebuild = "tail -f /etc/nixos/nixos-switch.log";
        update-latest = "nix flake update zen-browser zen-nebula nixpkgs-latest";
        update-all = "nix flake update";

        # Other Aliases
        ff = "${pkgs.fastfetch}/bin/fastfetch";

        # Clipboard Aliases
        copy = "${pkgs.wl-clipboard}/bin/wl-copy";
        paste = "${pkgs.wl-clipboard}/bin/wl-paste";
      };
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
