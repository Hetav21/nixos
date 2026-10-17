{
  extraLib,
  lib,
  pkgs,
  settings,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "home.shell.shells";
  hasCli = true;
  hasGui = false;
  cliConfig = {osConfig ? null, ...}: let
    # Map environment variable names to their corresponding sops secret names
    secretEnvVars = {
      OPENAI_API_KEY = "openai_api_key";
      CONTEXT7_API_KEY = "context7_api_key";
    };

    getSecretPath = secretName:
      osConfig.sops.secrets.${secretName}.path or "/run/secrets/${secretName}";

    fishSecretEnv = lib.concatStringsSep "\n" (
      lib.mapAttrsToList (envVar: secretName: let
        path = getSecretPath secretName;
      in ''
        test -f "${path}"; and set -gx ${envVar} (string trim < "${path}")
      '')
      secretEnvVars
    );

    nushellSecretEnv = lib.concatStringsSep "\n" (
      lib.mapAttrsToList (envVar: secretName: let
        path = getSecretPath secretName;
      in ''
        if ('${path}' | path exists) {
          $env.${envVar} = (open '${path}' | str trim)
        }
      '')
      secretEnvVars
    );
  in {
    # --- Aliases ---
    home.shellAliases = {
      cls = "clear";
      e = "exit";
    };

    programs = {
      # --- Fish Shell ---
      fish = {
        enable = true;
        package = pkgs.fish;
        shellInit = ''
          # Set SSH agent socket from systemd service
          set -gx SSH_AUTH_SOCK $XDG_RUNTIME_DIR/ssh-agent

          # Decrypted SOPS secrets environment variables
          ${fishSecretEnv}
        '';
      };

      # --- Nushell ---
      nushell = {
        enable = true;
        package = pkgs.nushell;

        settings = {
          edit_mode = "vi";
          cursor_shape = {
            vi_insert = "block";
            vi_normal = "underscore";
          };
        };

        plugins = with pkgs.nushellPlugins; [
          query
          gstat
          semver
          formats
        ];

        extraEnv = ''
          # Set SSH agent socket from systemd service
          $env.SSH_AUTH_SOCK = $"($env.XDG_RUNTIME_DIR)/ssh-agent"

          # Let pinentry-curses prompt on this terminal
          try { $env.GPG_TTY = (^tty | str trim) }

          # Flake configuration environment variables for nh
          $env.FLAKE = "${settings.setup_dir}"
          $env.NH_FLAKE = "${settings.setup_dir}"
          $env.NH_OS_FLAKE = "${settings.setup_dir}"

          # Decrypted SOPS secrets environment variables
          ${nushellSecretEnv}
        '';

        extraConfig = ''
          ${builtins.readFile (extraLib.paths.dotfile ".config/nushell/config.nu")}

          clear
          if ('.git' | path exists) {
            ${lib.getExe pkgs.onefetch}
          } else {
            ${lib.getExe pkgs.microfetch}
          }
        '';
      };
    };
  };
}
