{...}: let
in {
  imports = [
    ./units/_apps.nix
    ./units/_fonts.nix
    ./units/_flatpak.nix
  ];
}
