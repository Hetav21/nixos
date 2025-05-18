{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.systemd.extra.localsend;
in {
  options.systemd.extra.localsend = {
    enable = mkEnableOption "Starts localsend app on startup";
  };

  config = mkIf cfg.enable {
    systemd.user.services = {
      localsend = {
        enable = true;
        description = "Starts localsend app on startup";
        wantedBy = ["default.target"];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.localsend}";
          Restart = "on-failure";
          RestartSec = "10s";
        };
      };
    };
  };
}
