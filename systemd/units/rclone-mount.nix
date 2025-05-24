{
  lib,
  pkgs,
  config,
  settings,
  ...
}:
with lib; let
  cfg = config.systemd.extra.rclone;
  folder_path = "/home/${settings.username}/${settings.rclone.local_dir}";
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
          ExecStart = "${pkgs.rclone}/bin/rclone mount --vfs-cache-mode writes ${settings.rclone.remote_dir} ${folder_path} --allow-non-empty"; # Mounts
          ExecStop = "/run/current-system/sw/bin/fusermount -u ${folder_path}"; # Dismounts
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
