{...}: {
  imports = [
    # New categorized modules
    ./development.nix
    ./shell.nix
    ./system.nix
    ./downloads.nix

    # GUI-only modules
    ./desktop
    ./browser
  ];
}
