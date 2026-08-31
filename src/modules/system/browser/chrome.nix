{
  extraLib,
  pkgs,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "system.browser.chrome";
  hasCli = false;
  hasGui = true;
  guiConfig = {
    # --- Google Chrome ---
    environment.systemPackages = [
      pkgs.unstable.google-chrome
    ];
  };
}
