{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: let
  PRIMARYUSBID = "2DFE-05A8";
  BACKUPUSBID = "2DFE-05A8";
in {
  boot.initrd.kernelModules = ["uas" "usbcore" "usb_storage" "vfat" "nls_cp437" "nls_iso8859_1"];

  # Mount USB key before trying to decrypt root filesystem
  boot.initrd.postDeviceCommands = pkgs.lib.mkBefore ''
    mkdir -m 0755 -p /key
    sleep 2 # To make sure the usb key has been loaded
    mount -n -t vfat -o ro `findfs UUID=${PRIMARYUSBID}` /key || mount -n -t vfat -o ro `findfs UUID=${BACKUPUSBID}` /key
  '';

  boot.initrd.luks.devices."luks-b6090c32-0847-4728-a618-502a6d686076" = {
    keyFile = "/key/keys";
    preLVM = false; # If this is true the decryption is attempted before the postDeviceCommands can run
  };

  boot.initrd.luks.devices."luks-33791fd5-4f48-4e78-a045-adcb9b30b2e6" = {
    keyFile = "/key/keys";
    preLVM = false; # If this is true the decryption is attempted before the postDeviceCommands can run
  };
}
