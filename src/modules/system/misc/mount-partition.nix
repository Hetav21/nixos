{
  settings,
  lib,
  ...
}: let
  mountPartitionEnabled = settings.mount-partition.enable or false;
in {
  # --- Storage Drivers ---
  boot.initrd.availableKernelModules = [
    "thunderbolt"
    "vmd"
    "nvme"
    "usb_storage"
    "sd_mod"
  ];

  # --- Filesystem Mounts ---
  fileSystems = lib.mkIf mountPartitionEnabled {
    "/virt" = {
      device = "/dev/disk/by-uuid/${settings.mount-partition.partition_id}";
      fsType = "ext4";
    };
  };
}
