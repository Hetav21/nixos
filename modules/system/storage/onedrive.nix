{
  extraLib,
  pkgs,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "system.storage.onedrive";
  hasCli = false;
  hasGui = true;
  guiConfig = {
    # --- Packages ---
    environment.systemPackages = [pkgs.onedrive];
  };
}
