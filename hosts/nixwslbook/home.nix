{...}: {
  imports = [
    ../_common/home-base.nix
  ];

  # Enable only CLI/TUI modules for WSL (new categorized structure)
  home.development.enable = true;
  home.shell.enable = true;
  home.system.enable = true;
  home.downloads.enable = true;
}
