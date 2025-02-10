{...}: let
in {
  imports = [
    ./units/_apps.nix
    ./units/_fonts.nix
    ./units/_flatpak.nix
    ./units/appImage.nix
    ./units/asus.nix
    ./units/desktop.nix
    ./units/fileManager.nix
    ./units/fileSharing.nix
    ./units/hardware.nix
    ./units/llm.nix
    ./units/misc.nix
    ./units/networking.nix
    ./units/powerManagement.nix
    ./units/printing.nix
    ./units/security.nix
    ./units/systemd.nix
    ./units/virtualisation.nix
  ];
}
