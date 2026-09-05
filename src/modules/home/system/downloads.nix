{
  extraLib,
  pkgs,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "home.system.downloads";
  hasCli = true;
  hasGui = false;

  cliConfig = {
    # --- Packages ---
    home.packages = [
      # pkgs.aria2 # Multi-protocol & multi-source command-line download accelerator
    ];
  };
}
