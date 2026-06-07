{
  extraLib,
  pkgs,
  settings,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "system.storage.syncthing";
  hasCli = true;
  hasGui = false;
  cliConfig = {config, ...}: let
    username = settings.username;
    homeDirectory = config.users.users.${username}.home;
  in {
    services.syncthing = {
      enable = true;
      user = username;
      dataDir = homeDirectory;
      configDir = "${homeDirectory}/.config/syncthing";
    };
  };
})
args
