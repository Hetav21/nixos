{...}: let
in {
  imports = [
    ./units/nix-ld.nix
    ./units/virt-manager.nix
    ./units/electron-apps.nix
  ];
}
