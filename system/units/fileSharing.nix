{
  pkgs,
  settings,
  ...
}: let
  username = settings.username;
  homeDirectory = "/home/${username}";
in {
  environment.systemPackages = with pkgs; [
    rclone
    onedrive
    localsend
    stable.megasync
    stable.megacmd
  ];

  programs.droidcam.enable = true;

  programs.localsend = {
    enable = true;
    openFirewall = true;
  };

  services = {
    syncthing = {
      enable = true;
      user = username;
      dataDir = homeDirectory;
      configDir = "${homeDirectory}/.config/syncthing";
    };
  };

  imports = [
    ../../systemd/systemd-extra-imports.nix
  ];

  systemd.extra = {
    rclone.enable = true;
    mega-sync.enable = true;
  };
}
