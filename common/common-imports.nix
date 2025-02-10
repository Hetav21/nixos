{...}: let
in {
  imports = [
    ./units/_apps.nix
    ./units/_fonts.nix
    ./units/_flatpak.nix
    ./units/asus.nix
    ./units/desktop.nix
    ./units/fileSharing.nix
    ./units/powerManagement.nix
    ./units/printing.nix
    ./units/systemd.nix
    ./units/virtualisation.nix
  ];
}
