{
  lib,
  pkgs,
  config,
  settings,
  ...
}:
with lib; let
  cfg = config.systemd.extra.onedrive;
in {
  options.systemd.extra.onedrive = {
    enable = mkEnableOption "Starts onedrive on boot";
  };

  config = mkIf cfg.enable {
    systemd.user.services = {
      onedrive = {
        enable = true;
        description = "Onedrive Sync Service";
        wantedBy = ["multi-user.target"];
        #        after = ["network-online.target"];
        #        requires = ["network-online.target"];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.onedrive}/bin/onedrive --monitor";
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
