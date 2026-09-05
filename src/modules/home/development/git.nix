{
  extraLib,
  lib,
  pkgs,
  settings,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "home.development.git";
  hasCli = true;
  hasGui = false;
  cliConfig = {
    # --- Packages & Aliases ---
    home.packages = [pkgs.custom.gitignore];

    home.shellAliases = {
      gs = "git status";
      gpush = "git push origin";
      gpull = "git pull origin";
      grestore = "git restore";
      lzg = "${lib.getExe pkgs.unstable.lazygit}";
      lzjj = "${lib.getExe pkgs.unstable.lazyjj}";
    };

    programs = {
      # --- Nushell Functions ---
      nushell.extraConfig = ''
        def "gac" [message: string] {
          git add .
          git commit -m $"($message)"
        }

        def "nu-complete gitignore-subcommands" [] {
          [
            { value: "copy", description: "Copy or append a gitignore template" }
            { value: "search", description: "Search available gitignore templates" }
            { value: "list", description: "List all available gitignore templates" }
            { value: "help", description: "Show help message" }
          ]
        }

        def "nu-complete gitignore-templates" [] {
          try {
            ^${lib.getExe pkgs.custom.gitignore} list | lines
          } catch {
            []
          }
        }

        # Search and copy .gitignore templates from github/gitignore
        def --env gi [
          subcommand?: string@"nu-complete gitignore-subcommands"
          template?: string@"nu-complete gitignore-templates"
        ] {
          let sub = ($subcommand | default "help")
          if $sub == "help" or $sub == "--help" or $sub == "-h" {
            ^${lib.getExe pkgs.custom.gitignore} help
          } else if ($template | is-empty) {
            ^${lib.getExe pkgs.custom.gitignore} $sub
          } else {
            ^${lib.getExe pkgs.custom.gitignore} $sub $template
          }
        }
      '';

      # --- Git & LFS ---
      git = {
        enable = true;
        package = pkgs.unstable.gitFull;
        settings = {
          user = {
            name = settings.git.personal.name;
            email = settings.git.personal.email;
          };
        };
        lfs.enable = true;
        lfs.package = pkgs.unstable.git-lfs;
        includes =
          [
            # Base config (always included)
            {path = "${extraLib.paths.dotfile ".config/git/config"}";}
            # Default: use personal SSH key for all repos
            {
              contents.core.sshCommand = "ssh -i ${settings.ssh.personal.identityFile} -o IdentitiesOnly=yes";
            }
          ]
          # Work directory: use work SSH key and identity (only if work mode is true)
          ++ lib.optionals (settings.mode == "work") [
            {
              condition = "gitdir:~/work/";
              contents =
                {
                  user.name = settings.git.work.name;
                  user.email = settings.git.work.email;
                }
                // lib.optionalAttrs (settings.ssh.work.identityFile != "") {
                  core.sshCommand = "ssh -i ${settings.ssh.work.identityFile} -o IdentitiesOnly=yes";
                };
            }
          ];
      };

      # --- Jujutsu VCS ---
      jujutsu = {
        enable = true;
        package = pkgs.unstable.jujutsu;
        settings = {
          user = {
            name = settings.git.personal.name;
            email = settings.git.personal.email;
          };
        };
      };

      # --- Delta ---
      delta = {
        enable = true;
        enableGitIntegration = true;
        enableJujutsuIntegration = true;
        package = pkgs.unstable.delta;
        options = {
          navigate = true;
          light = false;
          side-by-side = true;
        };
      };
    };
  };
}
