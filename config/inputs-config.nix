# Flake Input Configuration
#
# This file provides:
# - Nixpkgs configuration (allowUnfree, allowBroken, etc.)
# - Module lists for different host types (common, desktop, wsl)
#
# This is imported by lib/modules.nix and lib/nixpkgs.nix
{
  inputs,
  outputs,
}: {
  # Centralized nixpkgs configuration used across all channels
  nixpkgs = {
    allowUnfree = true;
    allowBroken = true;
    permittedInsecurePackages = [
      # Add any insecure packages you absolutely need here
    ];
  };

  # Common modules shared across all hosts
  modules.common = [
    inputs.sops-nix.nixosModules.sops
    inputs.nix-flatpak.nixosModules.nix-flatpak
    inputs.stylix.nixosModules.stylix
    inputs.home-manager.nixosModules.home-manager
    inputs.nix-index-database.nixosModules.nix-index
    {
      nixpkgs = {
        overlays = builtins.attrValues outputs.overlays;
        config = {
          allowUnfree = true;
          allowBroken = true;
          permittedInsecurePackages = [];
        };
      };
    }
  ];

  # Desktop-specific modules (for physical machines)
  modules.desktop = [inputs.lanzaboote.nixosModules.lanzaboote];

  # WSL-specific modules
  modules.wsl = [inputs.nixos-wsl.nixosModules.default];
}
