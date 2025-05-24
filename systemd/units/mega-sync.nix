{
  lib,
  pkgs,
  config,
  settings,
  ...
}:
with lib; let
  cfg = config.systemd.extra.mega-sync;
in {
  options.systemd.extra.mega-sync = {
    enable = mkEnableOption "Starts mega sync on boot";
  };

  config = mkIf cfg.enable {
    systemd.user.services = {
      mega-sync = {
        enable = true;
        description = "Starts mega sync on boot";
        wantedBy = ["multi-user.target"];
        #        after = ["network-online.target"];
        #        requires = ["network-online.target"];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.megasync}/bin/megasync";
          Restart = "on-failure";
          RestartSec = "10s";
          User = settings.username;
          Group = "users";
          Environment = ["PATH=/run/wrappers/bin/:$PATH"];
        };
      };
    };
  };
}
