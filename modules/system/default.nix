{...}: {
  imports = [
    # Core system (always enabled)
    ./nix-settings.nix
    ./nix-ld.nix
    ./locale.nix

    # Theming and fonts (can be enabled independently)
    ./stylix.nix

    # New categorized modules
    ./virtualisation
    ./network
    ./storage
    ./media
    ./productivity
    ./communication
    ./browser
    ./services
    ./llm
    ./desktop-environment.nix

    # Desktop sub-modules (managed by desktop-environment)
    ./desktop

    # Hardware and misc (unchanged)
    ./hardware
    ./misc
  ];
}
