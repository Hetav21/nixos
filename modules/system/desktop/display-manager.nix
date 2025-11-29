{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.system.desktop.display-manager;
  tuigreet = "${pkgs.tuigreet}/bin/tuigreet";
  hyprland-session = "${pkgs.hyprland}/share/wayland-sessions";
in {
  options.system.desktop.display-manager = {
    enable = mkEnableOption "Enable display manager configuration";
  };

  config = mkIf cfg.enable {
    services = {
      logind.settings.Login = {
        HandlePowerKey = "suspend";
        HandleLidSwitch = "hybrid-sleep";
      };

      greetd = {
        enable = true;
        settings = {
          default_session = {
            command = "${tuigreet} --time --remember --remember-session --sessions ${hyprland-session}";
            user = "greeter";
          };
        };
      };
    };

    security.pam.services.greetd = {
      enableGnomeKeyring = true;
      enableAppArmor = true;
    };

    systemd.services.greetd.serviceConfig = {
      Type = "idle";
      StandardInput = "tty";
      StandardOutput = "tty";
      StandardError = "journal";
      TTYReset = true;
      TTYVHangup = true;
      TTYVTDisallocate = true;
    };
  };
}
