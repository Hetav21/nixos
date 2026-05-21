{
  lib,
  config,
  pkgs,
  pkgs-unstable,
  ...
}: let
  antigravityWslShim = lib.hiPrio (pkgs.writeShellScriptBin "antigravity" ''
    set -euo pipefail

    app=""
    while IFS= read -r line; do
      launcher_win="''${line%$'\r'}"
      [ -n "$launcher_win" ] || continue

      launcher_unix="$(wslpath -u "$launcher_win")"
      candidate="$(dirname "$(dirname "$launcher_unix")")/Antigravity.exe"

      if [ -x "$candidate" ]; then
        app="$candidate"
        break
      fi
    done < <(where.exe antigravity 2>/dev/null)

    if [ -n "$app" ]; then
      if [ "$#" -eq 0 ]; then
        exec "$app"
      fi

      args=()
      for arg in "$@"; do
        case "$arg" in
          -*)
            args+=("$arg")
            ;;
          *)
            if [ "$arg" = "." ] || [ "$arg" = ".." ] || [ -e "$arg" ]; then
              args+=("$(wslpath -w "$(realpath -m "$arg")")")
            else
              args+=("$arg")
            fi
            ;;
        esac
      done

      exec "$app" "''${args[@]}"
    fi

    exec ${lib.getExe pkgs-unstable.antigravity} "$@"
  '');
in {
  options.profiles.home.wsl-common = {
    enable = lib.mkEnableOption "Common WSL home profile";
  };

  config = lib.mkIf config.profiles.home.wsl-common.enable {
    home.packages = [antigravityWslShim];
  };
}
