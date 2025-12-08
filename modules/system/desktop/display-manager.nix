{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
with lib; let
  cfg = config.system.desktop.display-manager;
  tuigreet = lib.getExe pkgs.tuigreet;
  hyprland = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
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
}
