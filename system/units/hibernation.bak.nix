{...}: let
  ROOT_UUID = "luks-6f996364-18a9-457c-8914-3203ed6b7fb4";
  OFFSET = "6244352";
in {
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024;
    }
  ];

  boot.kernelParams = ["resume_offset=${OFFSET}"];

  boot.resumeDevice = "/dev/disk/by-uuid/${ROOT_UUID}";

  powerManagement.enable = true;
}
