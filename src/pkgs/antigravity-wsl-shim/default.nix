{
  lib,
  writeShellScriptBin,
  antigravity-ide ? null,
}: let
  fallbackExe =
    if antigravity-ide != null
    then lib.getExe antigravity-ide
    else "antigravity";
in
  writeShellScriptBin "antigravity" ''
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

    exec ${fallbackExe} "$@"
  ''
