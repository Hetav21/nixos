{...}: {
  imports = [
    ./app-image.nix
    ./applications
    ./desktop.nix
    ./display-manager.nix
    ./misc.nix
    ./networking.nix
    ./power-management.nix
    ./printing.nix
    ./security.nix
    ./system.nix
    ./virtualisation.nix
  ];
}
