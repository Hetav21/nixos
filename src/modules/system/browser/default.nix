{
  extraLib,
  ...
} @ args:
extraLib.modules.mkCategoryModule args {
  name = "system.browser";
  imports = [
    ./brave.nix
    ./chrome.nix
    ./edge.nix
  ];
  hasGui = true;
  guiDescription = "Enable all GUI web browsers";
  guiChildren = [
    "brave"
    "chrome"
    "edge"
  ];
}
