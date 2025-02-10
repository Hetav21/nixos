{
  config,
  lib,
  pkgs,
  inputs,
  options,
  ...
}: let
in {
  programs.localsend = {
    enable = true;
    openFirewall = true;
  };

  imports = [
    ../../systemd/systemd-extra-imports.nix
  ];

  systemd.extra = {
    rclone.enable = true;
    mega-sync.enable = true;
  };

  environment.systemPackages = with pkgs; [
    rclone
    localsend
    megasync
    megacmd
  ];
}
