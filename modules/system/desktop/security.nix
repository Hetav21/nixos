{
  extraLib,
  pkgs,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "system.desktop.security";
  hasGui = false;
  cliConfig = {
    # --- Authentication & Polkit Agent ---
    environment.systemPackages = [pkgs.hyprpolkitagent];
    services.gnome.gnome-keyring.enable = true;

    # --- Realtime & Polkit Rules ---
    security.rtkit.enable = true;
    security.polkit = {
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
}
