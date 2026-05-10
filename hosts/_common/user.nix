{
  lib,
  pkgs,
  config,
  settings,
  ...
}: let
  isWslEnabled = config.profiles.system.wsl-minimal.enable or false;
  wslNushellCompat = pkgs.writeShellScriptBin "wsl-nushell-compat" ''
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
  '';
in {
  config = {
    users.users.${settings.username} = {
      isNormalUser = true;
      description = "Normal User";
      # WSL: keep Nushell for interactive sessions, but route non-interactive
      # shell invocations through Bash so WSL/IDE bootstrap scripts work.
      shell =
        if isWslEnabled
        then wslNushellCompat
        else pkgs.nushell;
      # Make sure shell's defined using home-manager
      ignoreShellProgramCheck = true;
      extraGroups = [
        "wheel"
      ];
    };
  };
}
