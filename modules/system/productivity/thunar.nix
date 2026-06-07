{
  extraLib,
  pkgs,
  ...
} @ args:
(extraLib.modules.mkModule {
  name = "system.productivity.thunar";
  hasCli = false;
  hasGui = true;
  guiConfig = _: {
    environment.systemPackages = with pkgs; [
      thunar
      file-roller
    ];

    programs.thunar = {
      enable = true;
      plugins = with pkgs; [thunar-archive-plugin thunar-volman];
    };
  };
})
args
