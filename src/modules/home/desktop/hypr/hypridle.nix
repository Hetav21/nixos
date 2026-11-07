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
    loginctl = lib.getExe' pkgs.systemd "loginctl";
    systemctl = lib.getExe' pkgs.systemd "systemctl";
    hyprlock = lib.getExe pkgs.hyprlock;
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
            on-timeout = "${loginctl} lock-session";
          }
          {
            timeout = 660;
            on-timeout = "${hyprctl} dispatch dpms off";
            on-resume = "${hyprctl} dispatch dpms on";
          }
          {
            timeout = 1800;
            on-timeout = "${systemctl} suspend";
          }
        ];
      };
    };
  };
}
