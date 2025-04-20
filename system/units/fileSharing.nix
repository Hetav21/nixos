{
  config,
  lib,
  pkgs,
  inputs,
  options,
  ...
}: let
  username = "hetav";
  homeDirectory = "/home/${username}";
in {
  environment.systemPackages = with pkgs; [
    rclone
    onedrive
    localsend
    megasync
    megacmd
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
