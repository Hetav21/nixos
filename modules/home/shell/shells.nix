{
  extraLib,
  lib,
  pkgs,
  pkgs-unstable,
  settings,
  config,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "home.shell.shells";
  hasCli = true;
  hasGui = false;
  cliConfig = _: {
    programs = {
      fish = {
        enable = true;
        package = pkgs.fish;
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
        ];

        extraEnv = ''
          # Set SSH agent socket from systemd service
          $env.SSH_AUTH_SOCK = $"($env.XDG_RUNTIME_DIR)/ssh-agent"

          # NixOS configuration environment variables (used by config.nu)
          $env.NIXOS_SETUP_DIR = "${settings.setup_dir}"
          $env.NIXOS_UPDATE_STANDARD = "${settings.update-standard}"
          $env.NIXOS_UPDATE_LATEST = "${settings.update-latest}"

          try {
            $env.OPENAI_API_KEY = (cat /run/secrets/openai_api_key | str trim)
          }

          try {
            $env.CONTEXT7_API_KEY = (cat /run/secrets/context7_api_key | str trim)
          }
        '';

        # Load custom config from dotfiles (nx commands, aliases, etc.)
        # Package-dependent functions are kept inline due to Nix interpolation
        extraConfig =
          # Include the custom nushell config from dotfiles
          builtins.readFile ../../../dotfiles/.config/nushell/config.nu
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
            oc = "${lib.getExe config.programs.opencode.package}";
            nv = "${lib.getExe config.nixCats.out.packages.nixCats}";
          }
          // lib.optionalAttrs (pkgs ? wl-clipboard) {
            # Wayland clipboard aliases (only available on systems with wayland/desktop)
            copy = "${lib.getExe' pkgs.wl-clipboard "wl-copy"}";
            paste = "${lib.getExe' pkgs.wl-clipboard "wl-paste"}";
          };
      };
    };
  };
})
args
