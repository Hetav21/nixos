{
  mkModule,
  lib,
  pkgs,
  ...
} @ args:
(mkModule {
  name = "system.desktop.security";
  hasGui = false;
  cliConfig = _: {
    environment.systemPackages = with pkgs; [hyprpolkitagent];

    services.gnome.gnome-keyring.enable = true;

    security = {
      rtkit.enable = true;
      polkit = {
        enable = true;
        extraConfig = ''
          polkit.addRule(function(action, subject) {
            if (
              subject.isInGroup("users")
                && (
                  action.id == "org.freedesktop.login1.reboot" ||
                  action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
                  action.id == "org.freedesktop.login1.power-off" ||
                  action.id == "org.freedesktop.login1.power-off-multiple-sessions"
                )
              )
            {
              return polkit.Result.YES;
            }
          })
        '';
      };
    };
  };
})
args
