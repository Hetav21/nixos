{
  config,
  lib,
  pkgs,
  inputs,
  options,
  ...
}: let
  username = "hetav";
  userDescription = "Hetav Shah";
  homeDirectory = "/home/${username}";
  hostName = "nixbook";
  timeZone = "Asia/Kolkata";
in {
  nixpkgs.config.allowUnfree = true;

  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1w"
  ];

  imports = [
    ./hardware-configuration.nix
    ./user.nix
    ../../system
    ../../modules
    inputs.home-manager.nixosModules.default
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    kernelModules = ["v4l2loopback"];
    extraModulePackages = [config.boot.kernelPackages.v4l2loopback];
    kernel.sysctl = {
      "vm.max_map_count" = 2147483642;
    };
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
      };
    };
    tmp = {
      useTmpfs = true;
      tmpfsSize = "30%";
    };
  };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024;
    }
  ];

  time.timeZone = timeZone;

  i18n = {
    defaultLocale = "en_IN";
    extraLocaleSettings = {
      LC_ADDRESS = "en_IN";
      LC_IDENTIFICATION = "en_IN";
      LC_MEASUREMENT = "en_IN";
      LC_MONETARY = "en_IN";
      LC_NAME = "en_IN";
      LC_NUMERIC = "en_IN";
      LC_PAPER = "en_IN";
      LC_TELEPHONE = "en_IN";
      LC_TIME = "en_IN";
    };
  };

  users = {
    mutableUsers = true;
    users.${username} = {
      isNormalUser = true;
      description = userDescription;
      extraGroups = ["networkmanager" "mlocate" "wheel"];
    };
  };

  drivers = {
    intel.enable = true;
    nvidia.enable = true;
    nvidia-prime.sync.enable = true;
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users.${username} = import ./home.nix;
    useUserPackages = true;
    backupFileExtension = "backup";
  };

  system.stateVersion = "24.11";
}
