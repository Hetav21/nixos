{pkgs, ...}: {
  # these will be overlayed in nixpkgs automatically.
  # for example: environment.systemPackages = with pkgs; [pokego];
  lact = pkgs.callPackage ./lact.nix {};
}
