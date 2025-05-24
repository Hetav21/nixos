{
  pkgs,
  config,
  inputs,
  settings,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./user.nix
    ../../system
    ../../modules
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_cachyos;
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

  users = {
    mutableUsers = true;
    users.${settings.username} = {
      isNormalUser = true;
      description = "Normal User";
      extraGroups = [
        "networkmanager"
        "mlocate"
        "wheel"
      ];
    };
  };

  drivers = {
    intel.enable = true;
    nvidia.enable = true;
    nvidia-prime.sync = {
      enable = false;
      intelBusID = "PCI:0:2:0";
      nvidiaBusID = "PCI:1:0:0";
    };
    nvidia-prime.offload = {
      enable = true;
      intelBusID = "PCI:0:2:0";
      nvidiaBusID = "PCI:1:0:0";
    };
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs settings;};
    users.${settings.username} = import ./home.nix;
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
  };

  system.stateVersion = "24.11";
}
