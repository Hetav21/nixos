{
  extraLib,
  pkgs,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "system.browser.browseros";
  hasCli = false;
  hasGui = true;
  guiConfig = {
    # --- BrowserOS ---
    environment.systemPackages = [
      pkgs.custom.browseros
    ];
  };
}
