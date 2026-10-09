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
      grep = "${lib.getExe pkgs.ripgrep} --color=auto";
      ff = "${lib.getExe pkgs.fastfetch}";
      lzd = "${lib.getExe pkgs.lazydocker}";
    };

    programs = {
      # --- Nushell Helper Functions ---
      nushell.extraConfig = ''
        def --env yz [...args] {
            let tmp = (mktemp -t "yazi-cwd.XXXXXX")
            ${lib.getExe pkgs.yazi} ...$args --cwd-file $tmp
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
        package = pkgs.yazi;
        enableFishIntegration = true;
        enableNushellIntegration = true;
        shellWrapperName = "y";
      };

      eza = {
        enable = true;
        package = pkgs.eza;
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
        package = pkgs.zoxide;
        enableFishIntegration = true;
        enableNushellIntegration = true;
      };

      fd = {
        enable = true;
        package = pkgs.fd;
      };

      # --- Search & Preview ---
      ripgrep = {
        enable = true;
        package = pkgs.ripgrep;
        arguments = [
          "--max-columns-preview"
          "--colors=line:style:bold"
        ];
      };

      fzf = {
        enable = true;
        package = pkgs.fzf;
      };

      bat = {
        enable = true;
        package = pkgs.bat;
      };

      # --- Shell Prompt & Autocomplete ---
      starship = {
        enable = true;
        package = pkgs.starship;
        enableFishIntegration = true;
        enableNushellIntegration = true;
      };

      carapace = {
        enable = true;
        package = pkgs.carapace;
        enableFishIntegration = true;
        enableNushellIntegration = true;
      };

      atuin = {
        enable = true;
        package = pkgs.atuin;
        enableFishIntegration = true;
        enableNushellIntegration = true;
        flags = [
          "--disable-up-arrow"
        ];
      };

      nix-your-shell = {
        enable = true;
        package = pkgs.nix-your-shell;
        enableFishIntegration = true;
        enableNushellIntegration = true;
      };

      # --- Environment Management ---
      direnv = {
        enable = true;
        package = pkgs.direnv;
        enableNushellIntegration = true;
        nix-direnv = {
          enable = true;
          package = pkgs.nix-direnv;
        };
        mise = {
          enable = true;
          package = pkgs.mise;
        };
        silent = true;
      };
    };
  };
}
