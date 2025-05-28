{
  description = "Hetav's flake";

  # Flake Inputs
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix.url = "github:danth/stylix";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-nebula.url = "github:JustAdumbPrsn/Nebula-A-Minimal-Theme-for-Zen-Browser";
  };

  # Flake Outputs
  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    inherit (self) outputs;

    settings = {
      # User configuration
      username = "hetav";
      editor = "vim";
      visual = "zeditor";
      browser = "zen";
      terminal = "ghostty";
      wallpaper = "China.jpeg";

      # System configuration
      system = "x86_64-linux";
      videoDriver = "nvidia"; # CHOOSE YOUR GPU DRIVERS (nvidia, amdgpu or intel)
      hostname = "nixbook"; # CHOOSE A HOSTNAME HERE
      locale = "en_US.UTF-8"; # CHOOSE YOUR LOCALE
      extraLocale = "en_IN"; # CHOOSE YOUR LOCALE
      timeZone = "Asia/Kolkata"; # CHOOSE YOUR TIMEZONE
      keyboard = {
        layout = "us"; # CHOOSE YOUR KEYBOARD LAYOUT
        variant = ""; # CHOOSE YOUR KEYBOARD VARIANT (Can leave empty)
      };
      consoleKeymap = "us"; # CHOOSE YOUR CONSOLE KEYMAP (Affects the tty?)

      # Hardware configuration
      # TODO: Remove hardware configuration from here and add it to hosts/name
      nvidia = {
        enable = true;
        package = "stable"; # stable / beta
      };

      # Application specific configuration
      rofi_wallpaper_path = "/etc/nixos/wallpapers/China.jpeg"; # Should be an absolute path
      rclone = {
        local_dir = "Desktop/University";
        remote_dir = "Adani:University";
      };
      mount-partition = {
        enable = true;
        partition_id = "a96c2e2f-5a1a-4249-8a3c-283532bb14a9";
      };
    };
  in {
    templates = import ./templates;
    overlays = import ./overlays {inherit inputs settings;};
    nixosConfigurations = {
      nixbook = nixpkgs.lib.nixosSystem {
        system = settings.system;
        specialArgs = {inherit self inputs outputs settings;};
        modules = [
          ./hosts/nixbook/configuration.nix
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
                permittedInsecurePackages = [
                  "openssl-1.1.1w"
                ];
              };
            };
          }
        ];
      };
    };
  };
}
