{
  extraLib,
  lib,
  pkgs,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "system.desktop.displayManager";
  hasGui = false;
  cliConfig = let
    tuigreet = lib.getExe pkgs.tuigreet;
    hyprland = pkgs.hyprland;
  in {
    # --- Login Management ---
    services.logind.settings.Login = {
      HandlePowerKey = "suspend";
      HandleLidSwitch = "hybrid-sleep";
    };

    # --- Greeter & Display Manager ---
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${tuigreet} --time --cmd ${lib.getExe' hyprland "start-hyprland"}  --remember --remember-session --sessions ${hyprland}/share/wayland-sessions";
          user = "greeter";
        };
      };
    };

    # --- PAM & Security ---
    security.pam.services.greetd = {
      enableGnomeKeyring = true;
      enableAppArmor = true;
    };

    # Configure greetd systemd service to prevent other processes from writing to its TTY
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
