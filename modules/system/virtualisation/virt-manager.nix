{
  extraLib,
  pkgs,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "system.virtualisation.virt-manager";
  hasCli = false;
  hasGui = true;
  guiConfig = {
    environment.systemPackages = with pkgs; [
      virt-manager
      quickemu
      quickgui
    ];

    virtualisation.spiceUSBRedirection.enable = true;

    programs = {
      virt-manager.enable = true;
      dconf.enable = true;
    };

    services = {
      # SPICE USB redirection requires no extra daemon config here
    };
  };
})
args
