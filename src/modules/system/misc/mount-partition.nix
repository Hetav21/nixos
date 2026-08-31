{
  extraLib,
  lib,
  settings,
  ...
} @ args: let
  inherit (settings.mountPartition) partitionId;
in
  extraLib.modules.mkModule args {
    name = "system.misc.mount-partition";
    hasGui = false;
    cliConfig = {
      # --- Storage Drivers ---
      boot.initrd.availableKernelModules = [
        "thunderbolt"
        "vmd"
        "nvme"
        "usb_storage"
        "sd_mod"
      ];

      # --- Filesystem Mounts ---
      fileSystems = lib.mkIf (partitionId != "") {
        "/virt" = {
          device = "/dev/disk/by-uuid/${partitionId}";
          fsType = "ext4";
        };
      };
    };
  }
