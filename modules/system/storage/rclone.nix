{
  extraLib,
  pkgs,
  settings,
  ...
} @ args:
(extraLib.modules.mkModule {
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
      (settings ? rclone)
      && (settings.rclone ? enable)
      && settings.rclone.enable
      && (settings.rclone ? local_dir)
      && (settings.rclone ? remote_dir);
    folder_path =
      if rcloneEnabled
      then "${homeDirectory}/${settings.rclone.local_dir}"
      else "";
  in {
    environment.systemPackages = with pkgs; [
      rclone
    ];

    systemd = lib.mkIf rcloneEnabled {
      services = {
        rclone-mount = {
          enable = true;
          description = "Starts rclone mount";
          wantedBy = ["multi-user.target"];
          after = ["network-online.target"];
          requires = ["network-online.target"];
          serviceConfig = {
            Type = "simple";
            ExecStartPre = "${lib.getExe' pkgs.coreutils "mkdir"} -p ${folder_path}";
            ExecStart = "${lib.getExe pkgs.rclone} mount --vfs-cache-mode full ${settings.rclone.remote_dir} ${folder_path} --allow-non-empty --config ${homeDirectory}/.config/rclone/rclone.conf";
            ExecStop = "${lib.getExe' pkgs.fuse "fusermount"} -u ${folder_path}";
            Restart = "on-failure";
            RestartSec = "10s";
            User = username;
            Group = "users";
            Environment = ["PATH=/run/wrappers/bin/:$PATH"];
          };
        };
      };
    };
  };
})
args
