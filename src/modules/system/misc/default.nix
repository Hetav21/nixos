{
  extraLib,
  ...
} @ args:
extraLib.modules.mkCategoryModule args {
  name = "system.misc";
  imports = [
    ./disk-decryption.nix
    ./local-hardware-clock.nix
    ./mount-partition.nix
  ];
  hasCli = true;
  cliDescription = "Enable all miscellaneous system utilities";
  cliChildren = [
    "disk-decryption"
    "local-hardware-clock"
    "mount-partition"
  ];
}
