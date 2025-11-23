{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.system.time.local-clock;
in {
  options.system.time.local-clock = {
    enable = mkEnableOption "Change Hardware Clock To Local Time";
  };

  config = mkIf cfg.enable {time.hardwareClockInLocalTime = true;};
}
