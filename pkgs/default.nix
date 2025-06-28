{pkgs, ...}: {
  # these will be overlayed in nixpkgs automatically.
  # for example: environment.systemPackages = with pkgs; [pokego];
  pokego = pkgs.callPackage ./pokego.nix {};
  zen-nebula = pkgs.callPackage ./zen-nebula/pkgs {};
}
