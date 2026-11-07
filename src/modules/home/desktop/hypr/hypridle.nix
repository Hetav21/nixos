{
  extraLib,
  lib,
  pkgs,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "home.desktop.hypridle";
  hasCli = false;
  hasGui = true;

  guiConfig = let
    hyprctl = lib.getExe' pkgs.hyprland "hyprctl";
    jq = lib.getExe pkgs.jq;
    loginctl = lib.getExe' pkgs.systemd "loginctl";
    systemctl = lib.getExe' pkgs.systemd "systemctl";
    hyprlock = lib.getExe pkgs.hyprlock;

    # Check if any window is currently in true fullscreen (mode 2) across any workspace
    isAnyWindowFullscreen = pkgs.writeShellScript "check-hypr-fullscreen" ''
      clients="$(${hyprctl} clients -j 2>/dev/null)" || exit 1
      [ -n "$clients" ] || exit 1
      echo "$clients" | ${jq} -e '.[] | select((((.fullscreen // 0) % 4) >= 2) or (((.fullscreenClient // 0) % 4) >= 2))' >/dev/null 2>&1
    '';
  in {
    # --- Hypridle Daemon Configuration ---
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || ${hyprlock}";
          before_sleep_cmd = "${loginctl} lock-session";
          after_sleep_cmd = "${hyprctl} dispatch dpms on";
          ignore_dbus_inhibit = false;
          ignore_wayland_inhibit = false;
        };

        listener = [
          {
            timeout = 600;
            on-timeout = "if ! ${isAnyWindowFullscreen}; then ${loginctl} lock-session; fi";
          }
          {
            timeout = 660;
            on-timeout = "if ! ${isAnyWindowFullscreen}; then ${loginctl} lock-session; ${hyprctl} dispatch dpms off; fi";
            on-resume = "${hyprctl} dispatch dpms on";
          }
          {
            timeout = 1800;
            on-timeout = "if ! ${isAnyWindowFullscreen}; then ${systemctl} suspend; fi";
          }
        ];
      };
    };
  };
}
