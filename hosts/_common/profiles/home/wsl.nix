# Consolidated WSL home profile (CLI/TUI only + WSL shims)
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
  options.profiles.home.wsl = {
    enable = lib.mkEnableOption "Consolidated WSL home profile";
  };

  config = lib.mkIf config.profiles.home.wsl.enable {
    # System settings and utilities
    home.system = {
      packages.enable = true;
      downloads.enable = true;
      nix.enable = true;
    };

    # Development tools (CLI only)
    home.development = {
      git.enable = true;
      neovim.enable = true;
      ssh.enable = true;
      agents.enable = true;
      misc.enable = true;
      misc.enableGui = false;
    };

    # Shell and CLI tools
    home.shell = {
      shells.enable = true;
      tmux.enable = true;
      tools.enable = true;
      terminals.enableGui = false;
    };

    # Desktop components (disabled)
    home.desktop = {
      hyprland.enableGui = false;
      hypridle.enableGui = false;
      hyprlock.enableGui = false;
      hyprpaper.enableGui = false;
      hyprshot.enableGui = false;
      clipboard.enableGui = false;
      launcher.enableGui = false;
      notification.enableGui = false;
      rofi.enableGui = false;
      wallpaper.enableGui = false;
      panel.enableGui = false;
      waybar.enableGui = false;
      wlogout.enableGui = false;
      theme.enableGui = false;
    };

    # Browsers (disabled)
    home.browser = {
      zen.enableGui = false;
      helium.enableGui = false;
    };

    # WSL specific packages/shims
    home.packages = [antigravityWslShim];
  };
}
