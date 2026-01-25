{...}: {
  imports = [
    # New categorized modules
    ./nix-settings.nix
    ./development.nix
    ./claude-resources.nix
    ./shell.nix
    ./system.nix
    ./downloads.nix

    # GUI-only modules
    ./desktop
    ./browser
  ];
}
