{
  extraLib,
  pkgs,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "system.virtualisation.virt-manager";
  hasCli = false;
  hasGui = true;
  guiConfig = {
    # --- Packages ---
    environment.systemPackages = [
      pkgs.virt-manager
      pkgs.quickemu
      pkgs.quickgui
    ];

    # --- Virtualisation & Tools ---
    virtualisation.spiceUSBRedirection.enable = true;

    programs = {
      virt-manager.enable = true;
      dconf.enable = true;
    };
  };
}
