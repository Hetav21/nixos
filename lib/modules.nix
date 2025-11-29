inputs: outputs: {
  # Common modules shared across all hosts
  common = [
    inputs.sops-nix.nixosModules.sops
    inputs.nix-flatpak.nixosModules.nix-flatpak
    inputs.stylix.nixosModules.stylix
    inputs.home-manager.nixosModules.home-manager
    inputs.nix-index-database.nixosModules.nix-index
    inputs.chaotic.nixosModules.nyx-cache
    inputs.chaotic.nixosModules.nyx-overlay
    inputs.chaotic.nixosModules.nyx-registry
    {
      nixpkgs = {
        overlays = builtins.attrValues outputs.overlays;
        config = import ../settings/nixpkgs-config.nix;
      };
    }
  ];

  # Desktop-specific modules (for physical machines)
  desktop = [inputs.lanzaboote.nixosModules.lanzaboote];

  # WSL-specific modules
  wsl = [inputs.nixos-wsl.nixosModules.default];
}
