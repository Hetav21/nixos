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
      tmuxPlugins.rose-pine
      tmuxPlugins.vim-tmux-navigator
      {
        plugin = tmuxPlugins.yank;
        extraConfig = ''
          bind-key -T copy-mode-vi v send-keys -X begin-selection
          bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
          bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
        '';
      }
    ];
    sensibleOnTop = true;
    extraConfig = ''
      set-option -sa terminal-overrides ",xterm*:Tc"

      # Shift Alt vim keys to switch windows
      bind -n M-H previous-window
      bind -n M-L next-window
    '';
    newSession = true;
    baseIndex = 1;
    prefix = "C-Space";
    keyMode = "vi";
    mouse = true;
  };
}
