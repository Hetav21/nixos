{
  lib,
  pkgs,
  config,
  settings,
  ...
}:
with lib; let
  cfg = config.home.terminal.shell;
in {
  options.home.terminal.shell = {
    enable = mkEnableOption "Enable shell configuration";
  };

  config = mkIf cfg.enable {
    programs = {
      fish = {
        enable = true;
        package = pkgs.unstable.fish;
      };

      nushell = {
        enable = true;
        package = pkgs.unstable.nushell;
        extraEnv = ''
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
            git commit -m "$message"
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
          alias dl-yt = |url| {
            ${pkgs.yt-dlp}/bin/yt-dlp -o '~/Downloads/%(title)s.%(ext)s' "$url" | ${pkgs.aria2}/bin/aria2c --input-file=- --dir '~/Downloads'
          }

          $env.config.show_banner = false

          if ('.git' | path exists) {
            ${pkgs.onefetch}/bin/onefetch
          } else {
            ${pkgs.microfetch}/bin/microfetch
          }
        '';
        shellAliases = {
          # Core Utils Aliases
          ## l = "${pkgs.eza}/bin/eza -lh  --icons=auto";
          ## ls = "${pkgs.eza}/bin/eza -1   --icons=auto"; # short list
          ## ll = "${pkgs.eza}/bin/eza -lha --icons=auto --sort=name --group-directories-first"; # long list all
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
          # rebuild = "sh ${settings.setup_dir}scripts/rebuild/rebuild";
          log-rebuild = "tail -f ${settings.setup_dir}nixos-switch.log";
          update-latest = "sh ${settings.setup_dir}scripts/update/latest.sh '${settings.update-latest}' '${settings.setup_dir}'";
          update-standard = "sh ${settings.setup_dir}scripts/update/standard.sh '${settings.update-standard}' '${settings.setup_dir}'";
          update-all = "sh ${settings.setup_dir}scripts/update/all.sh '${settings.update-latest}' '${settings.update-standard}' '${settings.setup_dir}'";
          update-packages = "sh ${settings.setup_dir}scripts/update/packages.sh '${settings.setup_dir}'";
          # update = "sh ${settings.setup_dir}scripts/update/update";

          # Downlaod Aliases
          dl = "${pkgs.aria2}/bin/aria2c --continue --max-concurrent-downloads=5 --file-allocation=falloc --summary-interval=0";
          dl-list = "${pkgs.aria2}/bin/aria2c --continue --max-concurrent-downloads=5 --file-allocation=falloc --summary-interval=0 --input $'($in)'";
          dl-torrent = "${pkgs.aria2}/bin/aria2c --enable-dht=true --dht-listen-port=6881-6999 --dht-file-path=/tmp/aria2.dht --bt-enable-lpd=true --bt-max-peers=0 --bt-save-metadata=true --listen-port=6881-6999 --seed-time=0 --peer-id-prefix=ARIA2 --user-agent=' aria2/1.36.0 ' --continue --max-concurrent-downloads=5 --file-allocation=falloc --summary-interval=0";
          dl-magnet = "${pkgs.aria2}/bin/aria2c --enable-dht=true --dht-listen-port=6881-6999 --dht-file-path=/tmp/aria2.dht --bt-enable-lpd=true --bt-max-peers=0 --bt-save-metadata=true --listen-port=6881-6999 --seed-time=0 --peer-id-prefix=ARIA2 --user-agent='aria2/1.36.0' --continue --max-concurrent-downloads=5 --file-allocation=falloc --summary-interval=0";

          # Distrobox Aliases
          ubuntu = "distrobox enter ubuntu";

          # Other Aliases
          ff = "${pkgs.fastfetch}/bin/fastfetch";

          # Clipboard Aliases
          copy = "${pkgs.wl-clipboard}/bin/wl-copy";
          paste = "${pkgs.wl-clipboard}/bin/wl-paste";
        };
      };
      yazi = {
        enable = true;
        package = pkgs.unstable.yazi;
        enableNushellIntegration = true;
        enableFishIntegration = true;
      };
      carapace = {
        enable = true;
        package = pkgs.unstable.carapace;
        enableNushellIntegration = true;
        enableFishIntegration = true;
      };
      starship = {
        enable = true;
        package = pkgs.unstable.starship;
        enableNushellIntegration = true;
        enableFishIntegration = true;
      };
      zoxide = {
        enable = true;
        package = pkgs.unstable.zoxide;
        enableNushellIntegration = true;
        enableFishIntegration = true;
      };
      eza = {
        enable = true;
        package = pkgs.unstable.eza;
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
        enableNushellIntegration = true;
        enableFishIntegration = true;
        flags = [
          "--disable-up-arrow"
        ];
      };
      nix-your-shell = {
        enable = true;
        package = pkgs.unstable.nix-your-shell;
        enableNushellIntegration = true;
        enableFishIntegration = true;
      };
      direnv = {
        enable = true;
        package = pkgs.unstable.direnv;
        enableNushellIntegration = true;
        nix-direnv.enable = true;
        silent = true;
      };
    };
  };
}

