{
  extraLib,
  lib,
  pkgs,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "system.desktop.display-manager";
  hasGui = false;
  cliConfig = _: let
    tuigreet = lib.getExe pkgs.tuigreet;
    hyprland = pkgs.hyprland;
  in {
    services = {
      logind.settings.Login = {
        HandlePowerKey = "suspend";
        HandleLidSwitch = "hybrid-sleep";
      };

      greetd = {
        enable = true;
        settings = {
          default_session = {
            command = "${tuigreet} --time --cmd ${lib.getExe' hyprland "start-hyprland"}  --remember --remember-session --sessions ${hyprland}/share/wayland-sessions";
            user = "greeter";
          };
        };
      };
    };

    security.pam.services.greetd = {
      enableGnomeKeyring = true;
      enableAppArmor = true;
    };

    # Configure greetd systemd service to prevent other processes from writing to its TTY
    systemd.services.greetd = {
      serviceConfig = {
        Type = "idle";
        StandardInput = "tty";
        StandardOutput = "tty";
        StandardError = "journal";
        TTYReset = true;
        TTYVHangup = true;
        TTYVTDisallocate = true;
      };
    };
  };
})
args
