{
  extraLib,
  lib,
  pkgs,
  config,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "home.shell.tools";
  hasCli = true;
  hasGui = false;
  cliConfig = {
    # --- Shell Aliases ---
    home.shellAliases = {
      tree = "${lib.getExe pkgs.tree} -a -I .git";
      cat = "${lib.getExe config.programs.bat.package}";
      grep = "${lib.getExe pkgs.unstable.ripgrep} --color=auto";
      ff = "${lib.getExe pkgs.fastfetch}";
      lzd = "${lib.getExe pkgs.lazydocker}";
    };

    programs = {
      # --- Nushell Helper Functions ---
      nushell.extraConfig = ''
        def --env yz [...args] {
            let tmp = (mktemp -t "yazi-cwd.XXXXXX")
            ${lib.getExe pkgs.unstable.yazi} ...$args --cwd-file $tmp
            let cwd = (open $tmp)
            if $cwd != "" and $cwd != $env.PWD {
                cd $cwd
            }
            rm -fp $tmp
        }
      '';

      # --- File Management & Navigation ---
      yazi = {
        enable = true;
        package = pkgs.unstable.yazi;
        enableFishIntegration = true;
        enableNushellIntegration = true;
        shellWrapperName = "y";
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

      zoxide = {
        enable = true;
        package = pkgs.unstable.zoxide;
        enableFishIntegration = true;
        enableNushellIntegration = true;
      };

      fd = {
        enable = true;
        package = pkgs.unstable.fd;
      };

      # --- Search & Preview ---
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

      bat = {
        enable = true;
        package = pkgs.unstable.bat;
      };

      # --- Shell Prompt & Autocomplete ---
      starship = {
        enable = true;
        package = pkgs.unstable.starship;
        enableFishIntegration = true;
        enableNushellIntegration = true;
      };

      carapace = {
        enable = true;
        package = pkgs.unstable.carapace;
        enableFishIntegration = true;
        enableNushellIntegration = true;
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

      # --- Environment Management ---
      direnv = {
        enable = true;
        package = pkgs.unstable.direnv;
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
  };
}
