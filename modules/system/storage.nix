{
  extraLib,
  lib,
  pkgs,
  settings,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "system.storage";
  hasGui = true;
  cliConfig = {
    lib,
    pkgs,
    settings,
    ...
  }: let
    username = settings.username;
    homeDirectory = "/home/${username}";
    # Check if rclone settings exist before accessing them
    rcloneEnabled =
      (settings ? rclone)
      && (settings.rclone ? local_dir)
      && (settings.rclone ? remote_dir);
    folder_path =
      if rcloneEnabled
      then "/home/${settings.username}/${settings.rclone.local_dir}"
      else "";
  in {
    environment.systemPackages = with pkgs; [
      rclone
      ntfs3g
    ];

    services.syncthing = {
      enable = true;
      user = username;
      dataDir = homeDirectory;
      configDir = "${homeDirectory}/.config/syncthing";
    };

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
            ExecStartPre = "/run/current-system/sw/bin/mkdir -p ${folder_path}";
            ExecStart = "${lib.getExe pkgs.rclone} mount --vfs-cache-mode full ${settings.rclone.remote_dir} ${folder_path} --allow-non-empty --config /home/${settings.username}/.config/rclone/rclone.conf";
            ExecStop = "/run/current-system/sw/bin/fusermount -u ${folder_path}";
            Restart = "on-failure";
            RestartSec = "10s";
            User = settings.username;
            Group = "users";
            Environment = ["PATH=/run/wrappers/bin/:$PATH"];
          };
        };
      };
    };
  };
  guiConfig = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      localsend
      megasync
      megacmd
      onedrive
    ];

    programs.localsend = {
      enable = true;
      openFirewall = true;
    };
  };
})
args
