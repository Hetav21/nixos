{
  config,
  lib,
  pkgs,
  inputs,
  options,
  ...
}: let
  # UUID_RESUME_DISK="";
  # OFFSET="";
in {
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024;
    }
  ];

  # boot.kernelParams = ["resume_offset=<offset>"];

  # boot.resumeDevice = "/dev/disk/by-uuid/<uuid-of-root-partition>";

  # powerManagement.enable = true;
}
