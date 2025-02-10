{
  config,
  lib,
  pkgs,
  inputs,
  options,
  ...
}: let
in {
  programs = {
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
  };
}
