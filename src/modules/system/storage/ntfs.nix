{
  extraLib,
  pkgs,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "system.storage.ntfs";
  hasCli = true;
  hasGui = false;
  cliConfig = {
    # --- Packages ---
    environment.systemPackages = [pkgs.ntfs3g];
  };
}
