{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: let
  PARTITION_ID = "a96c2e2f-5a1a-4249-8a3c-283532bb14a9";
in {
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "thunderbolt"
    "vmd"
    "nvme"
    "usb_storage"
    "sd_mod"
  ];

  fileSystems."/virt" = {
    device = "/dev/disk/by-uuid/${PARTITION_ID}";
    fsType = "ext4";
  };
}
