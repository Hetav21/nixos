{...}: let
in {
  imports = [
    ./units/_apps.nix
    ./units/_fonts.nix
    ./units/_flatpak.nix
    ./units/appImage.nix
    ./units/asus.nix
    ./units/desktop.nix
    ./units/displayManager.nix
    ./units/fileManager.nix
    ./units/fileSharing.nix
    ./units/hardware.nix
    ## ./units/hibernation.nix
    ./units/llm.nix
    ./units/misc.nix
    ./units/networking.nix
    ./units/nix-ld.nix
    ./units/nix.nix
    ./units/powerManagement.nix
    ./units/printing.nix
    ./units/security.nix
    ./units/virtualisation.nix
  ];
}
