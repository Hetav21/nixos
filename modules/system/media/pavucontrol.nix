{
  extraLib,
  pkgs,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "system.media.pavucontrol";
  hasCli = false;
  hasGui = true;
  guiConfig = {
    # --- Volume Control ---
    environment.systemPackages = [
      pkgs.pavucontrol
    ];
  };
}
