{...}: {
  imports = [
    ../_common/home-base.nix
  ];

  # Enable only CLI/TUI modules for WSL
  home.terminal.shell.enable = true;
  home.terminal.tmux.enable = true;
  # Note: ghostty is a GUI terminal emulator and won't work in WSL without X server
}
