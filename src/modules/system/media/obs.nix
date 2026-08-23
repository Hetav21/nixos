{
  extraLib,
  pkgs,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "system.media.obs";
  hasCli = false;
  hasGui = true;
  guiConfig = {
    # --- OBS Studio ---
    environment.systemPackages = [
      pkgs.obs-studio
    ];
  };
}
