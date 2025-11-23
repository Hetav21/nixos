{...}: {
  imports = [
    ../_common/home-base.nix
  ];

  # Enable only CLI/TUI modules for WSL
  home.terminal.shell.enable = true;
  home.terminal.tmux.enable = true;
  home.terminal.ghostty.enable = true;
}
