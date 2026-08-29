{extraLib, ...} @ args:
extraLib.modules.mkModule args {
  name = "system.misc.local-hardware-clock";
  hasGui = false;
  cliConfig = {
    # --- Hardware Clock Configuration ---
    time.hardwareClockInLocalTime = true;
  };
}

