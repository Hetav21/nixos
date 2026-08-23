# Flake Inputs & Shared Configuration
{
  inputs,
  outputs,
}: let
  nixpkgsConfig = {
    allowUnfree = true;
    allowBroken = false;
    permittedInsecurePackages = [];
  };
in {
  # --- Nixpkgs Config ---
  nixpkgs = nixpkgsConfig;

  # --- Host Module Sets ---
  modules = {
    common = [
      inputs.sops-nix.nixosModules.sops
      inputs.nix-flatpak.nixosModules.nix-flatpak
      inputs.stylix.nixosModules.stylix
      inputs.home-manager.nixosModules.home-manager
      inputs.nix-index-database.nixosModules.nix-index
      {
        nixpkgs = {
          overlays = builtins.attrValues outputs.overlays;
          config = nixpkgsConfig;
        };
      }
    ];

    desktop = [
      inputs.lanzaboote.nixosModules.lanzaboote
    ];

    wsl = [
      inputs.nixos-wsl.nixosModules.default
    ];
  };
}
