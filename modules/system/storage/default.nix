{
  lib,
  config,
  ...
}: {
  imports = [
    ./ntfs.nix
    ./syncthing.nix
    ./rclone.nix
    ./localsend.nix
    ./megasync.nix
    ./onedrive.nix
  ];

  options = {
    system.storage = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable essential storage tools and sync services (CLI)";
      };
      enableGui = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable all GUI cloud/sync agents";
      };
    };
  };

  config = {
    system.storage.ntfs.enable = lib.mkDefault config.system.storage.enable;
    system.storage.syncthing.enable = lib.mkDefault config.system.storage.enable;
    system.storage.rclone.enable = lib.mkDefault config.system.storage.enable;

    system.storage.localsend.enableGui = lib.mkDefault config.system.storage.enableGui;
    system.storage.megasync.enableGui = lib.mkDefault config.system.storage.enableGui;
    system.storage.onedrive.enableGui = lib.mkDefault config.system.storage.enableGui;
  };
}
