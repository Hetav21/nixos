{
  lib,
  pkgs,
  config,
  ...
}: {
  # --- Host Imports & Path Setup ---
  imports = [
    ./hardware-configuration.nix
    ../_common
  ];

  local.homeConfig = ./home.nix;

  # --- Boot & Kernel Configuration ---
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

  # --- Swap & Memory Management ---
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024;
    }
  ];

  # --- Hardware & Graphics Drivers ---
  hardware.graphics = {
    enable = true;
    package = pkgs.mesa;
    enable32Bit = true;
    package32 = pkgs.driversi686Linux.mesa;
  };

  # --- Profiles & State Version ---
  profiles.system.desktop.enable = true;
  system.stateVersion = lib.mkForce "25.11";
}
