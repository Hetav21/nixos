{
  extraLib,
  pkgs,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "system.communication.thunderbird";
  hasCli = false;
  hasGui = true;
  guiConfig = {
    # --- Thunderbird Mail Client ---
    environment.systemPackages = [
      pkgs.thunderbird
    ];
  };
}
