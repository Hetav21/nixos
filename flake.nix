{
  description = "Hetav's flake";

  # Flake Inputs
  inputs = {
    stablePkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    stylix.url = "github:danth/stylix";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    sddm-sugar-candy-nix = {
      url = "gitlab:Zhaith-Izaliel/sddm-sugar-candy-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # Flake Outputs
  outputs = {
    self,
    nixpkgs,
    chaotic,
    nix-flatpak,
    sddm-sugar-candy-nix,
    nix-index-database,
    ...
  } @ inputs: let
    system = "x86_64-linux";

    pkgs = import inputs.stablePkgs {
      inherit system;
      config.allowUnfree = true;
    };

    overlay = final: prev: {
      megacmd = pkgs.megacmd;
      megasync = pkgs.megasync;
      open-webui = pkgs.open-webui;
    };
  in {
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
          nix-index-database.nixosModules.nix-index
          # optional to also wrap and install comma
          {programs.nix-index-database.comma.enable = true;}
          {programs.nix-index.enable = true;}
          ({pkgs, ...}: {
            ## Add specific packages that you need
          })
          {
            nixpkgs = {
              overlays = [
                overlay
              ];
            };
          }
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
