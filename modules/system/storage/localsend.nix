{
  extraLib,
  pkgs,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "system.storage.localsend";
  hasCli = false;
  hasGui = true;
  guiConfig = _: {
    environment.systemPackages = with pkgs; [
      localsend
    ];

    programs.localsend = {
      enable = true;
      openFirewall = true;
    };
  };
})
args
