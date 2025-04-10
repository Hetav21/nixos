{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.systemd.extra.muteMicrophone;
in {
  options.systemd.extra.muteMicrophone = {
    enable = mkEnableOption "Mutes microphone on boot";
  };

  config = mkIf cfg.enable {
    systemd.user.services = {
      mute-on-boot = {
        enable = true;
        description = "Mutes microphone on boot";
        wantedBy = ["default.target"];
        serviceConfig = {
          Type = "simple";
          ExecStart = "/run/current-system/sw/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle";
          Restart = "on-failure";
          RestartSec = "10s";
        };
      };
    };
  };
}
