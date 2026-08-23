{
  extraLib,
  pkgs,
  settings,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "system.storage.rclone";
  hasCli = true;
  hasGui = false;
  cliConfig = {
    lib,
    config,
    ...
  }: let
    username = settings.username;
    homeDirectory = config.users.users.${username}.home;
    rcloneEnabled =
      (settings.rclone.enable or false)
      && (settings.rclone ? local_dir)
      && (settings.rclone ? remote_dir);
    folderPath =
      if rcloneEnabled
      then "${homeDirectory}/${settings.rclone.local_dir}"
      else "";
  in {
    # --- Packages ---
    environment.systemPackages = [pkgs.rclone];

    # --- Systemd Mount Service ---
    systemd.services.rclone-mount = lib.mkIf rcloneEnabled {
      enable = true;
      description = "Starts rclone mount";
      wantedBy = ["multi-user.target"];
      after = ["network-online.target"];
      requires = ["network-online.target"];
      serviceConfig = {
        Type = "simple";
        ExecStartPre = "${lib.getExe' pkgs.coreutils "mkdir"} -p ${folderPath}";
        ExecStart = "${lib.getExe pkgs.rclone} mount --vfs-cache-mode full ${settings.rclone.remote_dir} ${folderPath} --allow-non-empty --config ${homeDirectory}/.config/rclone/rclone.conf";
        ExecStop = "${lib.getExe' pkgs.fuse "fusermount"} -u ${folderPath}";
        Restart = "on-failure";
        RestartSec = "10s";
        User = username;
        Group = "users";
        Environment = ["PATH=/run/wrappers/bin/:$PATH"];
      };
    };
  };
}
