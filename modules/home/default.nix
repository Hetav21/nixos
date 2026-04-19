{inputs, ...}: {
  imports = [
    # New categorized modules
    ./nix-settings.nix
    ./development.nix
    inputs.nix-skills.homeManagerModules.default
    ./shell.nix
    ./system.nix
    ./downloads.nix

    # GUI-only modules
    ./desktop
    ./browser
  ];
}
