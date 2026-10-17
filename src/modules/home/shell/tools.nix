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
      # --- Nushell Keybindings ---
      nushell.settings.keybindings = [
        {
          name = "fzf_files_nvim";
          modifier = "control";
          keycode = "char_t";
          mode = [
            "emacs"
            "vi_normal"
            "vi_insert"
          ];
          event = {
            send = "executehostcommand";
            cmd = "${lib.getExe pkgs.fd} --type f --strip-cwd-prefix --hidden --exclude .git | ${lib.getExe pkgs.fzf} --preview '${lib.getExe config.programs.bat.package} --style=numbers --color=always {}' --bind 'ctrl-/:toggle-preview' --bind 'enter:become(nvim {})' --bind 'double-click:become(nvim {})'";
          };
        }
        {
          name = "fzf_dirs_cd";
          modifier = "alt";
          keycode = "char_c";
          mode = [
            "emacs"
            "vi_normal"
            "vi_insert"
          ];
          event = {
            send = "executehostcommand";
            cmd = "let dir = (${lib.getExe pkgs.fd} --type d --strip-cwd-prefix --hidden --exclude .git | ${lib.getExe pkgs.fzf} --preview '${lib.getExe pkgs.eza} --tree --color=always {} | head -200' --bind 'ctrl-/:toggle-preview' | str trim); if ($dir | is-not-empty) { cd $dir }";
          };
        }
      ];

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
        enableFishIntegration = true;

        defaultCommand = "${lib.getExe pkgs.fd} --type f --strip-cwd-prefix --hidden --exclude .git";

        fileWidgetCommand = "${lib.getExe pkgs.fd} --type f --strip-cwd-prefix --hidden --exclude .git";
        fileWidgetOptions = [
          "--preview '${lib.getExe config.programs.bat.package} --style=numbers --color=always {}'"
          "--bind 'ctrl-/:toggle-preview'"
          "--bind 'enter:become(nvim {})'"
          "--bind 'double-click:become(nvim {})'"
          "--bind 'ctrl-y:accept'"
        ];

        changeDirWidgetCommand = "${lib.getExe pkgs.fd} --type d --strip-cwd-prefix --hidden --exclude .git";
        changeDirWidgetOptions = [
          "--preview '${lib.getExe pkgs.eza} --tree --color=always {} | head -200'"
          "--bind 'ctrl-/:toggle-preview'"
        ];
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
        silent = true;
      };
    };
  };
}
