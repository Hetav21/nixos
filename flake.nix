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
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    zen-nebula.url = "github:JustAdumbPrsn/Nebula-A-Minimal-Theme-for-Zen-Browser";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # Flake Outputs
  outputs = {
    self,
    nixpkgs,
    home-manager,
    nix-flatpak,
    nix-index-database,
    ...
  } @ inputs: let
    system = "x86_64-linux";

    lib = nixpkgs.lib;

    pkgs = import inputs.stablePkgs {
      inherit system;
      config.allowUnfree = true;
    };

    disableGpuWrap = {appName}:
      pkgs.symlinkJoin {
        name = appName;
        paths = [pkgs.${appName}];
        buildInputs = [pkgs.makeWrapper];
        postBuild = lib.strings.concatStrings [
          "wrapProgram $out/bin/"
          appName
          " --add-flags \"--disable-gpu\""
        ];
      };

    overlay = final: prev: {
      megacmd = pkgs.megacmd;
      megasync = pkgs.megasync;
      ollama = pkgs.ollama;
      auto-cpufreq = pkgs.auto-cpufreq;
      bruno = disableGpuWrap {appName = "bruno";};
      obsidian = disableGpuWrap {appName = "obsidian";};
    };
  in {
    nixosConfigurations = {
      nixbook = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/nixbook/configuration.nix
          nix-flatpak.nixosModules.nix-flatpak
          inputs.stylix.nixosModules.stylix
          home-manager.nixosModules.home-manager
          inputs.home-manager.nixosModules.default
          nix-index-database.nixosModules.nix-index
          {
            home-manager.extraSpecialArgs = {
              inherit inputs;
            };
            nixpkgs = {
              overlays = [
                overlay
              ];
            };
          }
        ];
      };
    };
  };
}
