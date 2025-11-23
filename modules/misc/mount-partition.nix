{
  settings,
  lib,
  ...
}: let
  mountPartitionEnabled =
    (settings ? mount-partition && settings.mount-partition ? enable)
    && settings.mount-partition.enable;
in {
  boot.initrd.availableKernelModules = [
    # "xhci_pci"
    "thunderbolt"
    "vmd"
    "nvme"
    "usb_storage"
    "sd_mod"
  ];

  fileSystems = lib.mkIf mountPartitionEnabled {
    "/virt" = {
      device = "/dev/disk/by-uuid/${settings.mount-partition.partition_id}";
      fsType = "ext4";
    };
  };
}
