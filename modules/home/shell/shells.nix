{
  extraLib,
  lib,
  pkgs,
  pkgs-unstable,
  settings,
  config,
  inputs,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "home.shell.shells";
  hasCli = true;
  hasGui = false;
  cliConfig = _: {
    home.shellAliases = {
      cls = "clear";
      e = "exit";
    };

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

        extraConfig =
          # Include the custom nushell config from dotfiles
          builtins.readFile ../../../dotfiles/.config/nushell/config.nu
          + ''
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
})
args
