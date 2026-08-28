{...}: {
  # --- System Module Imports ---
  imports = [
    # Core System
    ./locale.nix
    ./nix-ld.nix
    ./settings.nix

    # Styling & Theming
    ./stylix.nix

    # Categorized System Modules
    ./browser
    ./communication
    ./desktop-environment.nix
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
