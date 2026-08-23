{
  extraLib,
  lib,
  ...
} @ args: let
  primaryUsbId = "A31A-87EC";
  backupUsbId = "A31A-87EC";
in
  extraLib.modules.mkModule args {
    name = "system.misc.diskDecryption";
    hasGui = false;
    cliConfig = {
      # --- Initrd Kernel Modules ---
      boot.initrd.kernelModules = [
        "uas"
        "usbcore"
        "usb_storage"
        "vfat"
        "nls_cp437"
        "nls_iso8859_1"
      ];

      # --- USB Key Mounting ---
      boot.initrd.postDeviceCommands = lib.mkBefore ''
        mkdir -m 0755 -p /key
        sleep 2
        mount -n -t vfat -o ro `findfs UUID=${primaryUsbId}` /key || mount -n -t vfat -o ro `findfs UUID=${backupUsbId}` /key
      '';

      # --- LUKS Keyfile Configuration ---
      boot.initrd.luks.devices = {
        "luks-6f996364-18a9-457c-8914-3203ed6b7fb4" = {
          keyFile = "/key/keys";
          preLVM = false;
        };
        "luks-92eff85b-8a75-4ead-a093-4c39c2a7f620" = {
          keyFile = "/key/keys";
          preLVM = false;
        };
      };
    };
  }
