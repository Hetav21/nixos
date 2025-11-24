{...}: {
  imports = [
    # Core system (always enabled)
    ./nix-settings.nix
    ./nix-ld.nix

    # Theming and fonts (can be enabled independently)
    ./stylix.nix

    # New categorized modules
    ./virtualisation.nix
    ./network.nix
    ./storage.nix
    ./media.nix
    ./productivity.nix
    ./communication.nix
    ./services.nix
    ./llm.nix
    ./desktop-environment.nix

    # Desktop sub-modules (managed by desktop-environment)
    ./desktop

    # Hardware and misc (unchanged)
    ./hardware
    ./misc
  ];
}
