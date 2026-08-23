{
  extraLib,
  pkgs,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "system.storage.localsend";
  hasCli = false;
  hasGui = true;
  guiConfig = {
    # --- Packages ---
    environment.systemPackages = [pkgs.localsend];

    # --- Programs ---
    programs.localsend = {
      enable = true;
      openFirewall = true;
    };
  };
}
