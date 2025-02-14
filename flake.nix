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
    nix-flatpak,
    sddm-sugar-candy-nix,
    nix-index-database,
    ...
  } @ inputs: let
    system = "x86_64-linux";

    lib = nixpkgs.lib;

    pkgs = import inputs.stablePkgs {
      inherit system;
      config.allowUnfree = true;
    };

    electronWrap = {appName}:
      pkgs.symlinkJoin {
        name = appName;
        paths = [pkgs.${appName}];
        buildInputs = [pkgs.makeWrapper];
        postBuild = lib.strings.concatStrings [
          "wrapProgram $out/bin/"
          appName
          " --add-flags \"--enable-features=UseOzonePlatform\""
          " --add-flags \"--ozone-platform-hint=wayland\""
          " --add-flags \"--enable-webrtc-pipewire-capturer\""
          " --add-flags \"--enable-features=WaylandWindowDecorations\""
          " --add-flags \"--enable-wayland-ime\""
        ];
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
      open-webui = pkgs.open-webui;
      bruno = disableGpuWrap {appName = "bruno";};
      obsidian = disableGpuWrap {appName = "obsidian";};
      chromium = disableGpuWrap {appName = "chromium";};
    };
  in {
    nixosConfigurations = {
      nixbook = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/nixbook/configuration.nix
          sddm-sugar-candy-nix.nixosModules.default
          nix-flatpak.nixosModules.nix-flatpak
          inputs.stylix.nixosModules.stylix
          inputs.home-manager.nixosModules.default
          nix-index-database.nixosModules.nix-index
          {
            nixpkgs = {
              overlays = [
                overlay
                sddm-sugar-candy-nix.overlays.default
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
