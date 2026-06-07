{
  extraLib,
  pkgs-unstable,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "home.shell.tools";
  hasCli = true;
  hasGui = false;
  cliConfig = _: {
    programs = {
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
