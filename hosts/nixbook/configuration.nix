{
  lib,
  pkgs,
  config,
  inputs,
  settings,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../_common
  ];

  # Point to host-specific home.nix (centralized home-manager is in _common)
  local.homeConfig = ./home.nix;

  # Host-specific boot configuration (secure boot with lanzaboote)
  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    kernelModules = ["v4l2loopback"];
    extraModulePackages = with config.boot.kernelPackages; [v4l2loopback];
    kernel.sysctl = {
      "vm.max_map_count" = 2147483642;
    };
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      systemd-boot.enable = lib.mkForce false;
      grub.enable = lib.mkForce false;
    };
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
    tmp = {
      useTmpfs = true;
      tmpfsSize = "30%";
    };
  };

  # Swap configuration for memory management
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024;
    }
  ];

  # Enable drivers
  hardware.graphics = {
    enable = true;
    package = pkgs.mesa;
    enable32Bit = true;
    package32 = pkgs.driversi686Linux.mesa;
  };

  # Complete desktop environment with all features (system-level profile)
  profiles.system.desktop-full.enable = true;
}
