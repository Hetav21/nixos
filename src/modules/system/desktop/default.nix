{
  extraLib,
  ...
} @ args:
extraLib.modules.mkCategoryModule args {
  name = "system.desktop";
  imports = [
    ./appimage.nix
    ./display-manager.nix
    ./environment.nix
    ./power-management.nix
    ./printing.nix
    ./security.nix
    ./xdg-config.nix
  ];
  hasCli = true;
  cliDescription = "Enable all desktop environment components";
  cliChildren = [
    "appimage"
    "display-manager"
    "environment"
    "power-management"
    "printing"
    "security"
    "xdg-config"
  ];
}
