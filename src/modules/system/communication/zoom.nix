{
  extraLib,
  pkgs,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "system.communication.zoom";
  hasCli = false;
  hasGui = true;
  guiConfig = {
    # --- Zoom Video Conferencing ---
    environment.systemPackages = [
      pkgs.zoom-us
    ];
  };
}
