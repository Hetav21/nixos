{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  username = "hetav";
  cfg = config.systemd.extra.warp-cli;
in {
  options.systemd.extra.warp-cli = {
    enable = mkEnableOption "Starts warp cli on boot";
  };

  config = mkIf cfg.enable {
    systemd.user.services = {
      warp-cli = {
        enable = true;
        description = "Starts warp cli on boot";
        wantedBy = ["multi-user.target"];
        #        after = ["network-online.target"];
        #        requires = ["network-online.target"];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.cloudflare-warp}/bin/warp-cli connect";
          Restart = "on-failure";
          RestartSec = "10s";
          User = username;
          Group = "users";
          Environment = ["PATH=/run/wrappers/bin/:$PATH"];
        };
      };
    };
  };
}
