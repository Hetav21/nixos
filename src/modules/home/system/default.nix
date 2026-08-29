{
  extraLib,
  ...
} @ args:
extraLib.modules.mkCategoryModule args {
  name = "home.system";
  imports = [
    ./packages.nix
    ./downloads.nix
    ./settings.nix
  ];
  hasCli = true;
  cliDescription = "Enable all system utilities and packages";
  cliChildren = [
    "packages"
    "downloads"
    "settings"
  ];
}
