{extraLib, ...} @ args:
(extraLib.modules.mkModule {
  name = "system.time.localClock";
  hasGui = false;
  cliConfig = _: {
    time.hardwareClockInLocalTime = true;
  };
})
args
