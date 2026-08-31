{
  extraLib,
  ...
} @ args:
extraLib.modules.mkCategoryModule args {
  name = "system.misc";
  imports = [
    ./cron.nix
    ./disk-decryption.nix
    ./gnupg.nix
    ./local-hardware-clock.nix
    ./locate.nix
    ./mount-partition.nix
  ];
  hasCli = true;
  cliDescription = "Enable all miscellaneous system utilities";
  cliChildren = [
    "cron"
    "disk-decryption"
    "gnupg"
    "local-hardware-clock"
    "locate"
    "mount-partition"
  ];
}
