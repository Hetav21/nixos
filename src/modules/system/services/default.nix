{
  extraLib,
  ...
} @ args:
extraLib.modules.mkCategoryModule args {
  name = "system.baseservices";
  imports = [
    ./cron.nix
    ./flatpak.nix
    ./gnupg.nix
    ./locate.nix
  ];
  hasCli = true;
  cliDescription = "Enable essential base services (locate, cron, gnupg)";
  cliChildren = [
    "cron"
    "gnupg"
    "locate"
  ];
  hasGui = true;
  guiDescription = "Enable base GUI services (flatpak)";
  guiChildren = [
    "flatpak"
  ];
}
