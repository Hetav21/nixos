{
  lib,
  config,
  modulesPath,
  ...
}: {
  # --- Scanner Modules ---
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # --- Kernel & Hardware Modules ---
  boot.initrd.availableKernelModules = ["xhci_pci" "thunderbolt" "vmd" "nvme" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  # --- File Systems & Storage ---
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/4bad9613-0a0b-4f97-9ca9-24a3c414b584";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/08F0-03E3";
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077"];
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/d461659e-fe4a-4457-a459-e1514a64e86b";}
  ];

  # --- Platform & Microcode ---
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
