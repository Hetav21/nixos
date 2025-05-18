{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.systemd.extra.rclone;
  username = "hetav";
  folder_path = "/home/hetav/Desktop/University";
  rclone_path = "Adani:University";
in {
  options.systemd.extra.rclone = {
    enable = mkEnableOption "Mounting netfs using rclone";
  };

  config = mkIf cfg.enable {
    systemd.services = {
      rclone-mount = {
        enable = true;
        description = "Starts rclone mount";
        wantedBy = ["multi-user.target"];
        after = ["network-online.target"];
        requires = ["network-online.target"];
        serviceConfig = {
          Type = "simple";
          ExecStartPre = "/run/current-system/sw/bin/mkdir -p ${folder_path}"; # Creates folder if didn't exist
          ExecStart = "${pkgs.rclone}/bin/rclone mount --vfs-cache-mode writes ${rclone_path} ${folder_path} --allow-non-empty"; # Mounts
          ExecStop = "/run/current-system/sw/bin/fusermount -u ${folder_path}"; # Dismounts
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
