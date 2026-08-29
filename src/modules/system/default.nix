{...}: {
  # --- System Module Imports ---
  imports = [
    # Core System
    ./locale.nix
    ./nix-ld.nix
    ./secrets.nix
    ./settings.nix

    # Styling & Theming
    ./stylix.nix

    # Categorized System Modules
    ./browser
    ./communication
    ./desktop
    ./hardware
    ./llm
    ./media
    ./misc
    ./network
    ./productivity
    ./services
    ./storage
    ./virtualisation
  ];
}
