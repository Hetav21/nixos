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
      tmuxPlugins.vim-tmux-navigator
    ];
    sensibleOnTop = true;
    extraConfig = ''
      set-option -sa terminal-overrides ",xterm*:Tc"

      # Shift Alt vim keys to switch windows
      bind -n M-H previous-window
      bind -n M-L next-window
    '';
    newSession = true;
    prefix = "C-Shift";
    keyMode = "vi";
  };
}
