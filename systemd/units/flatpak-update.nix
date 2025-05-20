{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.systemd.extra.flatpak;
in {
  options.systemd.extra.flatpak = {
    enable = mkEnableOption "Auto Update Flatpak";
  };

  config = mkIf cfg.enable {
    systemd.services = {
      update-flatpak = {
        description = "Update system Flatpaks";
        after = ["network-online.target"];
        wantedBy = ["multi-user.target"];

        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.flatpak}/bin/flatpak update --assumeyes --noninteractive --system";
        };
      };
    };
    systemd.timers = {
      update-flatpak = {
        enable = true;
        description = "Update system Flatpaks daily";
        wantedBy = ["timers.target"];
        timerConfig = {
          OnCalendar = "daily";
          Persistent = true;
        };
      };
    };
  };
}
