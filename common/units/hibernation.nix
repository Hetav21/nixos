{
  config,
  lib,
  pkgs,
  inputs,
  options,
  ...
}: let
  ROOT_UUID = "93638b50-3fcf-43f6-8aa4-a26287b3ecfb";
  OFFSET = "25587712";
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
