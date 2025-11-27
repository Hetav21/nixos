{...}: {
  imports = [
    # New categorized modules
    ./nix-settings.nix
    ./development.nix
    ./shell.nix
    ./system.nix
    ./downloads.nix

    # GUI-only modules
    ./desktop
    ./browser
  ];
}
