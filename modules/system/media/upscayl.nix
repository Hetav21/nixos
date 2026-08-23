{
  extraLib,
  pkgs,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "system.media.upscayl";
  hasCli = false;
  hasGui = true;
  guiConfig = {
    # --- Upscayl Image Upscaler ---
    environment.systemPackages = [
      pkgs.upscayl
    ];
  };
}
