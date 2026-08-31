{
  extraLib,
  ...
} @ args:
extraLib.modules.mkCategoryModule args {
  name = "system.productivity";
  imports = [
    ./latex.nix
    ./obsidian.nix
    ./office.nix
    ./teams.nix
    ./thunar.nix
  ];
  hasGui = true;
  guiDescription = "Enable GUI productivity applications";
  guiChildren = [
    "latex"
    "obsidian"
    "office"
    "teams"
    "thunar"
  ];
}
