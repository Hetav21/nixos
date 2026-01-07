{
  extraLib,
  lib,
  pkgs,
  settings,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "system.desktop.environment";
  hasGui = false;
  cliConfig = _: {
    environment.sessionVariables = {
      TERMINAL = settings.terminal;
      BROWSER = settings.browser;
      SIGNAL_PASSWORD_STORE = "gnome-libsecret";

      NIXOS_OZONE_WL = "1";
      GDK_BACKEND = "wayland,x11";
      QT_QPA_PLATFORM = "wayland;xcb";
      JAVA_AWT_WM_NONREPARENTING = "1";
      WLR_NO_HARDWARE_CURSORS = "1";
      MOZ_ENABLE_WAYLAND = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    };

    systemd.user.services = {
      mute-on-boot = {
        enable = true;
        description = "Mutes microphone on boot";
        wantedBy = ["default.target"];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${lib.getExe' pkgs.pulseaudio "pactl"} set-source-mute @DEFAULT_SOURCE@ 1";
          Restart = "on-failure";
          RestartSec = "10s";
        };
      };
    };

    # Enable Stylix theming for desktop environments
    system.stylix.enable = true;
  };
})
args
