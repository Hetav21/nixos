{extraLib, ...} @ args:
extraLib.modules.mkModule args {
  name = "system.misc.cron";
  hasCli = true;
  hasGui = false;
  cliConfig = {
    # --- Cron Service ---
    services.cron.enable = true;
  };
}
