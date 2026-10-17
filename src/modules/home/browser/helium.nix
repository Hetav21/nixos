{
  extraLib,
  pkgs,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "home.browser.helium";
  hasCli = false;
  hasGui = true;

  guiConfig = {
    # --- Packages ---
    home.packages = [
      pkgs.helium
    ];
  };
}
