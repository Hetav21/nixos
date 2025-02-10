{
  config,
  lib,
  pkgs,
  inputs,
  options,
  ...
}: let
in {
  services.printing = {
    enable = true;
    drivers = [pkgs.hplipWithPlugin]; # NIXPKGS_ALLOW_UNFREE=1 nix-shell -p hplipWithPlugin --run 'sudo -E hp-setup'
  };
  environment.systemPackages = with pkgs; [
    hplip
  ];
}
