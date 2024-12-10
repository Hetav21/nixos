{
  description = "Hetav's flake";

  # Flake Inputs
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    stylix.url = "github:danth/stylix";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    sddm-sugar-candy-nix.url = "gitlab:Zhaith-Izaliel/sddm-sugar-candy-nix";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.5.0"; # Pinning ref because main 'default' branch is unstable
  };

  # Flake Outputs
  outputs = {
    self,
    nixpkgs,
    chaotic,
    nix-flatpak,
    sddm-sugar-candy-nix,
    ...
  } @ inputs: {
    # Define multiple NixOS configurations
    nixosConfigurations = {
      nixbook = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/nixbook/configuration.nix # Path to your host specific config
          chaotic.nixosModules.default
          sddm-sugar-candy-nix.nixosModules.default
          {
            nixpkgs = {
              overlays = [
                sddm-sugar-candy-nix.overlays.default
              ];
            };
          }
          nix-flatpak.nixosModules.nix-flatpak
          inputs.stylix.nixosModules.stylix
          inputs.home-manager.nixosModules.default
          ({pkgs, ...}: {
            ## Add specific packages that you need
          })
        ];
      };

      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/nixos/configuration.nix # Path to your host specific config
        ];
      };
    };
  };
}
