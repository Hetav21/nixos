{
  extraLib,
  ...
} @ args:
extraLib.modules.mkCategoryModule args {
  name = "system.network";
  imports = [
    ./applet.nix
    ./base.nix
    ./wireshark.nix
  ];
  hasCli = true;
  cliDescription = "Enable base networking services";
  cliChildren = ["base"];
  hasGui = true;
  guiDescription = "Enable GUI networking tools";
  guiChildren = [
    "applet"
    "wireshark"
  ];
}
