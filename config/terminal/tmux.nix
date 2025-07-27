{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    plugins = with pkgs; [
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
    mouse = true;
    prefix = "M-a";
    extraConfig = ''
      set-option -sa terminal-overrides ",xterm*:Tc"
      ## set -g mouse on

      # Change the prefix key
      unbind C-b
      set -g prefix M-a
      bind M-a send-prefix

      # Shift Alt vim keys to switch windows
      bind -n M-H previous-window
      bind -n M-L next-window

      # Change the base index to 1
      set -g base-index 1
      set -g pane-base-index 1
      set-window-option -g pane-base-index 1
      set-option -g renumber-windows on
    '';
  };
}
