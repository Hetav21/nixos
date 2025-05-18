{
  config,
  lib,
  pkgs,
  inputs,
  options,
  ...
}: let
in {
  environment.systemPackages = with pkgs; [
    appimage-run
  ];

  programs.fuse.userAllowOther = true;

  programs.appimage = {
    enable = true;
    binfmt = true;
  };
}
