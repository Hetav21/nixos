{
  extraLib,
  pkgs,
  settings,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "system.baseservices.locate";
  hasCli = true;
  hasGui = false;
  cliConfig = _: {
    services.locate = {
      enable = true;
      package = pkgs.mlocate;
    };
    users.users.${settings.username}.extraGroups = ["mlocate"];
  };
})
args
