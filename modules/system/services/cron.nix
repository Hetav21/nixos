{extraLib, ...} @ args:
extraLib.modules.mkModule args {
  name = "system.baseservices.cron";
  hasCli = true;
  hasGui = false;
  cliConfig = {
    # --- Cron Service ---
    services.cron.enable = true;
  };
}
