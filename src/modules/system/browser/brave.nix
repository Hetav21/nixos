{
  extraLib,
  pkgs,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "system.browser.brave";
  hasCli = false;
  hasGui = true;
  guiConfig = {
    # --- Brave Browser ---
    environment.systemPackages = [
      pkgs.unstable.brave
    ];
  };
}
