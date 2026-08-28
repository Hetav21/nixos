{
  extraLib,
  ...
} @ args:
extraLib.modules.mkCategoryModule args {
  name = "system.communication";
  imports = [
    ./zoom.nix
    ./thunderbird.nix
    ./discord.nix
  ];
  hasGui = true;
  guiDescription = "Enable all GUI communication applications";
  guiChildren = [
    "zoom"
    "thunderbird"
    "discord"
  ];
}
