{extraLib, ...} @ args:
(extraLib.modules.mkModule {
  name = "system.baseservices.cron";
  hasCli = true;
  hasGui = false;
  cliConfig = _: {
    services.cron = {
      enable = true;
    };
  };
})
args
