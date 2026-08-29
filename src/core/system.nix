# Core NixOS System Base
#
# Baseline system configuration applied to all hosts. Configures hostname,
# primary user account, centralized Home Manager integration, and imports.
{
  lib,
  config,
  pkgs,
  inputs,
  settings,
  extraLib,
  pkgs-unstable,
  pkgs-master,
  ...
}: let
  # --- WSL Nushell Compatibility Wrapper ---
  isWslEnabled = (config.profiles.system.wsl.enable or false) || (config.wsl.enable or false);
  wslNushellCompat =
    (pkgs.writeShellScriptBin "wsl-nushell-compat" ''
      # WSL/IDE compatibility wrapper for nushell on NixOS-WSL
      # Interactive sessions → nushell, everything else → bash
      #
      # When WSL or an IDE runs: wsl.exe --distribution NixOS -- bash -c '...'
      # the user's login shell receives: bash -c '...'
      # This wrapper intercepts that and routes to real bash.

      if [ "$#" -eq 0 ]; then
        # No arguments: interactive login → launch nushell
        exec ${lib.getExe pkgs.nushell}
      fi

      case "$1" in
        bash)
          shift
          exec ${lib.getExe pkgs.bashInteractive} "$@"
          ;;
        sh)
          shift
          exec ${lib.getExe' pkgs.bashInteractive "sh"} "$@"
          ;;
        -*)
          # Flags like -c, -l, -i, --login, etc → bash
          exec ${lib.getExe pkgs.bashInteractive} "$@"
          ;;
        *)
          # Positional command like 'bash -c ...' or 'sh -c ...'
          # Pass everything through bash
          exec ${lib.getExe pkgs.bashInteractive} -lc "$*"
          ;;
      esac
    '').overrideAttrs (old: {
      passthru =
        (old.passthru or {})
        // {
          shellPath = "/bin/wsl-nushell-compat";
        };
    });
in {
  # --- Base System Imports ---
  imports = [
    ../modules
    ../profiles/system
  ];

  # --- Host Options ---
  options.local.homeConfig = lib.mkOption {
    type = lib.types.path;
    description = "Path to host-specific home.nix file";
  };

  # --- Core Configuration ---
  config = {
    # Hostname from settings
    networking.hostName = settings.hostname;

    # Primary User Account
    users.users.${settings.username} = {
      isNormalUser = true;
      description = "Normal User";
      shell =
        if isWslEnabled
        then wslNushellCompat
        else pkgs.nushell;
      ignoreShellProgramCheck = true;
      extraGroups = ["wheel"];
    };

    # Centralized Home Manager Integration
    home-manager = {
      extraSpecialArgs = {inherit inputs settings extraLib pkgs-unstable pkgs-master;};
      users.${settings.username} = {
        imports = [
          ./home.nix
          (import config.local.homeConfig)
        ];
      };
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "backup";
    };

    # Base System State Version
    system.stateVersion = "25.11";
  };
}
