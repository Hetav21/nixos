{
  lib,
  config,
  ...
}: {
  # --- Submodules ---
  imports = [
    ./localsend.nix
    ./megasync.nix
    ./ntfs.nix
    ./onedrive.nix
    ./rclone.nix
    ./syncthing.nix
  ];

  # --- Options ---
  options.system.storage = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable essential storage tools and sync services (CLI)";
    };
    enableGui = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable GUI cloud and sync clients";
    };
  };

  # --- Configuration ---
  config = {
    system.storage.ntfs.enable = lib.mkDefault config.system.storage.enable;
    system.storage.rclone.enable = lib.mkDefault config.system.storage.enable;
    system.storage.syncthing.enable = lib.mkDefault config.system.storage.enable;

    system.storage.localsend.enableGui = lib.mkDefault config.system.storage.enableGui;
    system.storage.megasync.enableGui = lib.mkDefault config.system.storage.enableGui;
    system.storage.onedrive.enableGui = lib.mkDefault config.system.storage.enableGui;
  };
}
