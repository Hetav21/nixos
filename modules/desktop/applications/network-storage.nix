{
  pkgs,
  settings,
  ...
}: let
  username = settings.username;
  homeDirectory = "/home/${username}";
  folder_path = "/home/${settings.username}/${settings.rclone.local_dir}";
in {
  environment.systemPackages = with pkgs; [
    rclone
    onedrive
    localsend
    megasync
    megacmd
  ];

  programs.localsend = {
    enable = true;
    openFirewall = true;
  };

  services.syncthing = {
    enable = true;
    user = username;
    dataDir = homeDirectory;
    configDir = "${homeDirectory}/.config/syncthing";
  };

  systemd = {
    services = {
      rclone-mount = {
        enable = true;
        description = "Starts rclone mount";
        wantedBy = ["multi-user.target"];
        after = ["network-online.target"];
        requires = ["network-online.target"];
        serviceConfig = {
          Type = "simple";
          ExecStartPre = "/run/current-system/sw/bin/mkdir -p ${folder_path}"; # Creates folder if didn't exist
          ExecStart = "${pkgs.rclone}/bin/rclone mount --vfs-cache-mode full ${settings.rclone.remote_dir} ${folder_path} --allow-non-empty --config /home/${settings.username}/.config/rclone/rclone.conf";
          ExecStop = "/run/current-system/sw/bin/fusermount -u ${folder_path}"; # Dismounts
          Restart = "on-failure";
          RestartSec = "10s";
          User = settings.username;
          Group = "users";
          Environment = ["PATH=/run/wrappers/bin/:$PATH"];
        };
      };
    };

    # user.services = {
    #   onedrive = {
    #     enable = true;
    #     description = "Onedrive Sync Service";
    #     wantedBy = ["multi-user.target"];
    #     #        after = ["network-online.target"];
    #     #        requires = ["network-online.target"];
    #     serviceConfig = {
    #       Type = "simple";
    #       ExecStart = "${pkgs.onedrive}/bin/onedrive --monitor";
    #       Restart = "on-failure";
    #       RestartSec = "10s";
    #       User = settings.username;
    #       Group = "users";
    #       Environment = ["PATH=/run/wrappers/bin/:$PATH"];
    #     };
    #   };
    # };
  };
}
