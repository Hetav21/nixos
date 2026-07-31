{
  extraLib,
  lib,
  pkgs,
  pkgs-unstable,
  config,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "home.shell.tools";
  hasCli = true;
  hasGui = false;
  cliConfig = _: {
    home.shellAliases = {
      tree = "${lib.getExe pkgs.tree} -a -I .git";
      cat = "${lib.getExe config.programs.bat.package}";
      grep = "${lib.getExe pkgs-unstable.ripgrep} --color=auto";
      ff = "${lib.getExe pkgs.fastfetch}";
      lzd = "${lib.getExe pkgs.lazydocker}";
    };

    programs = {
      nushell.extraConfig = ''
        # File Manager Alias (requires package path interpolation)
        def --env yz [...args] {
            let tmp = (mktemp -t "yazi-cwd.XXXXXX")
            ${lib.getExe pkgs-unstable.yazi} ...$args --cwd-file $tmp
            let cwd = (open $tmp)
            if $cwd != "" and $cwd != $env.PWD {
                cd $cwd
            }
            rm -fp $tmp
        }
      '';

      yazi = {
        enable = true;
        package = pkgs-unstable.yazi;
        enableFishIntegration = true;
        enableNushellIntegration = true;
        shellWrapperName = "y";
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
  };
})
args
