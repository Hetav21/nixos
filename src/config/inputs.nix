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
  # --- Flake Input Update Groups ---
  groups = {
    stable = [
      "nixpkgs"
      "home-manager"
      "stylix"
    ];
    unstable = [
      "nixpkgs-unstable"
      "helium-flake"
      "vicinae-extensions"
    ];
    apps = [
      "nixvim"
      "llm-agents"
      "t3code"
    ];
    system = [
      "sops-nix"
      "lanzaboote"
      "nixos-wsl"
      "nix-flatpak"
      "nix-index-database"
    ];
    excluded = [
      "nur"
      "nix-skills"
    ];
  };

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
