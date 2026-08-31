{
  extraLib,
  ...
} @ args:
extraLib.modules.mkCategoryModule args {
  name = "home.browser";
  imports = [
    ./helium.nix
  ];
  hasGui = true;
  guiDescription = "Enable all user GUI web browsers";
  guiChildren = [
    "helium"
  ];
}
