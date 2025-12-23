{
  extraLib,
  pkgs,
  ...
} @ args: let
  PRIMARYUSBID = "A31A-87EC";
  BACKUPUSBID = "A31A-87EC";
in
  (extraLib.modules.mkModule {
    name = "system.misc.diskDecryption";
    hasGui = false;
    cliConfig = _: {
      boot.initrd.kernelModules = [
        "uas"
        "usbcore"
        "usb_storage"
        "vfat"
        "nls_cp437"
        "nls_iso8859_1"
      ];

      # Mount USB key before trying to decrypt root filesystem
      boot.initrd.postDeviceCommands = pkgs.lib.mkBefore ''
        mkdir -m 0755 -p /key
        sleep 2 # To make sure the usb key has been loaded
        mount -n -t vfat -o ro `findfs UUID=${PRIMARYUSBID}` /key || mount -n -t vfat -o ro `findfs UUID=${BACKUPUSBID}` /key
      '';

      boot.initrd.luks.devices."luks-6f996364-18a9-457c-8914-3203ed6b7fb4" = {
        keyFile = "/key/keys";
        preLVM = false; # If this is true the decryption is attempted before the postDeviceCommands can run
      };

      boot.initrd.luks.devices."luks-92eff85b-8a75-4ead-a093-4c39c2a7f620" = {
        keyFile = "/key/keys";
        preLVM = false; # If this is true the decryption is attempted before the postDeviceCommands can run
      };
    };
  })
  args
