{
  description = "Hetav's flake";

  # Flake Inputs
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";

    stylix = {
      url = "github:danth/stylix/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    nixpkgs-kernel.url = "github:nixos/nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vicinae.url = "github:vicinaehq/vicinae";
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # Flake Outputs
  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    inherit (self) outputs;

    # Common settings shared across all hosts
    commonSettings = {
      # Upgrade configuration
      update-standard = "stylix home-manager lanzaboote sops-nix nix-flatpak zen-browser vicinae";
      update-latest = "nixpkgs-unstable nixpkgs-master chaotic nur stylix home-manager lanzaboote sops-nix nix-flatpak zen-browser vicinae";

      # User configuration
      username = "hetav";
      editor = "vim";
      visual = "zeditor";
      browser = "zen";
      terminal = "ghostty";

      # System configuration (common)
      setup_dir = "/etc/nixos/";
      system = "x86_64-linux";
      locale = "en_US.UTF-8";
      extraLocale = "en_IN";
      timeZone = "Asia/Kolkata";
      keyboard = {
        layout = "us";
        variant = "";
      };
      consoleKeymap = "us";

      # Application common configuration
      wallpaper_directory = "/etc/nixos/wallpapers";
    };

    # Per-host settings for nixbook (personal laptop)
    nixbookSettings =
      commonSettings
      // {
        hostname = "nixbook";
        wallpaper = "China.jpeg";
        rclone = {
          local_dir = "Desktop/University";
          remote_dir = "Adani:University";
        };
        mount-partition = {
          enable = true;
          partition_id = "a96c2e2f-5a1a-4249-8a3c-283532bb14a9";
        };
      };

    # Per-host settings for nixwslbook (work WSL)
    nixwslbookSettings =
      commonSettings
      // {
        hostname = "nixwslbook";
        # Add wallpaper for stylix TUI/CLI theming (color scheme generation)
        wallpaper = "China.jpeg";
        # Override update strings to exclude desktop-only inputs (lanzaboote, nix-flatpak, zen-browser, vicinae)
        update-standard = "stylix home-manager sops-nix";
        update-latest = "nixpkgs-unstable nixpkgs-master chaotic nur stylix home-manager sops-nix";
      };

    # Hardware configuration
    hardware_asus = {
      asus.enable = true;
      intel.enable = true;
      amdgpu.enable = false;
      nvidia = {
        enable = true;
        package = "stable"; # stable / beta
        prime = {
          sync.enable = false;
          offload.enable = true;
          intelBusId = "PCI:0:2:0";
          nvidiaBusId = "PCI:1:0:0";
        };
      };
    };
  in {
    templates = import ./templates;
    overlays = import ./overlays {
      inherit inputs;
      settings = commonSettings;
    };
    nixosConfigurations = {
      nixbook = nixpkgs.lib.nixosSystem {
        system = nixbookSettings.system;
        specialArgs = {
          inherit self inputs outputs;
          settings = nixbookSettings;
          hardware = hardware_asus;
        };
        modules = [
          ./hosts/nixbook/configuration.nix
          inputs.sops-nix.nixosModules.sops
          inputs.nix-flatpak.nixosModules.nix-flatpak
          inputs.stylix.nixosModules.stylix
          inputs.home-manager.nixosModules.home-manager
          inputs.lanzaboote.nixosModules.lanzaboote
          inputs.nix-index-database.nixosModules.nix-index
          inputs.chaotic.nixosModules.nyx-cache
          inputs.chaotic.nixosModules.nyx-overlay
          inputs.chaotic.nixosModules.nyx-registry
          {
            nixpkgs = {
              overlays = builtins.attrValues outputs.overlays;
              config = {
                allowUnfree = true;
                allowBroken = true;
              };
            };
          }
        ];
      };

      nixwslbook = nixpkgs.lib.nixosSystem {
        system = nixwslbookSettings.system;
        specialArgs = {
          inherit self inputs outputs;
          settings = nixwslbookSettings;
        };
        modules = [
          ./hosts/nixwslbook/configuration.nix
          inputs.nixos-wsl.nixosModules.default
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
              config = {
                allowUnfree = true;
                allowBroken = true;
              };
            };
          }
        ];
      };
    };
  };
}
