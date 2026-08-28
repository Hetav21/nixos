{
  extraLib,
  ...
} @ args:
extraLib.modules.mkCategoryModule args {
  name = "system.storage";
  imports = [
    ./localsend.nix
    ./megasync.nix
    ./ntfs.nix
    ./onedrive.nix
    ./rclone.nix
    ./syncthing.nix
  ];
  hasCli = true;
  cliDescription = "Enable essential storage tools and sync services (CLI)";
  cliChildren = [
    "ntfs"
    "rclone"
    "syncthing"
  ];
  hasGui = true;
  guiDescription = "Enable GUI cloud and sync clients";
  guiChildren = [
    "localsend"
    "megasync"
    "onedrive"
  ];
}
