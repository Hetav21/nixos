{
  inputs,
  lib,
  pkgs,
  ...
}: let
in {
  programs.tmux = {
    enable = true;
    plugins = with pkgs; [
      tmuxPlugins.sensible
    ];
  };
}
