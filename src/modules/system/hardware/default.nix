{
  extraLib,
  ...
} @ args:
extraLib.modules.mkCategoryModule args {
  name = "system.hardware";
  imports = [
    ./base.nix
  ];
  hasCli = true;
  cliDescription = "Enable system hardware modules";
  cliChildren = [
    "base"
  ];
}
