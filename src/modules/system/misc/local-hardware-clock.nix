{extraLib, ...} @ args:
extraLib.modules.mkModule args {
  name = "system.time.localClock";
  hasGui = false;
  cliConfig = {
    time.hardwareClockInLocalTime = true;
  };
}
