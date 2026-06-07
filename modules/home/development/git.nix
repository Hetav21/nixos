{
  extraLib,
  lib,
  pkgs-unstable,
  settings,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "home.development.git";
  hasCli = true;
  hasGui = false;
  cliConfig = _: {
    programs = {
      git = {
        enable = true;
        package = pkgs-unstable.gitFull;
        settings = {
          user = {
            name = settings.git.personal.name;
            email = settings.git.personal.email;
          };
        };
        lfs.enable = true;
        lfs.package = pkgs-unstable.git-lfs;
        includes =
          [
            # Base config (always included)
            {path = "${../../../dotfiles/.config/git/config}";}
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

      jujutsu = {
        enable = true;
        package = pkgs-unstable.jujutsu;
        settings = {
          user = {
            name = settings.git.personal.name;
            email = settings.git.personal.email;
          };
        };
      };

      delta = {
        enable = true;
        enableGitIntegration = true;
        enableJujutsuIntegration = true;
        package = pkgs-unstable.delta;
        options = {
          navigate = true;
          light = false;
          side-by-side = true;
        };
      };
    };
  };
})
args
